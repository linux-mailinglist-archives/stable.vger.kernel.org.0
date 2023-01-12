Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3619C6674E8
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235489AbjALOPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235510AbjALOPE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:15:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C8B5AC49
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:07:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55471B81E6D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8798BC433EF;
        Thu, 12 Jan 2023 14:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532427;
        bh=b0/Xhh3zxswWVrUclMM/HSwyBlfKCqTB2RmFy31SKXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=boTQ9e3S3lW9M/K941t3/t4c4ipn36Y7FaFBCucFLFvp531sD7aSyJpqCnLZexCeX
         XnLY5QRSPMw9TCvrZwJdQsVHgCQIkSjjEmMX4QGQsrN7BKe3up53Cyomiuz2udXMgx
         t0JOYGAUzxnlHxte/L/FjYi70JKH+NguOB0Yjve0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 158/783] media: vidtv: Fix use-after-free in vidtv_bridge_dvb_init()
Date:   Thu, 12 Jan 2023 14:47:54 +0100
Message-Id: <20230112135531.663777552@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit ba8d9405935097e296bcf7a942c3a01df0edb865 ]

KASAN reports a use-after-free:
BUG: KASAN: use-after-free in dvb_dmxdev_release+0x4d5/0x5d0 [dvb_core]
Call Trace:
 ...
 dvb_dmxdev_release+0x4d5/0x5d0 [dvb_core]
 vidtv_bridge_probe+0x7bf/0xa40 [dvb_vidtv_bridge]
 platform_probe+0xb6/0x170
 ...
Allocated by task 1238:
 ...
 dvb_register_device+0x1a7/0xa70 [dvb_core]
 dvb_dmxdev_init+0x2af/0x4a0 [dvb_core]
 vidtv_bridge_probe+0x766/0xa40 [dvb_vidtv_bridge]
 ...
Freed by task 1238:
 dvb_register_device+0x6d2/0xa70 [dvb_core]
 dvb_dmxdev_init+0x2af/0x4a0 [dvb_core]
 vidtv_bridge_probe+0x766/0xa40 [dvb_vidtv_bridge]
 ...

It is because the error handling in vidtv_bridge_dvb_init() is wrong.

First, vidtv_bridge_dmx(dev)_init() will clean themselves when fail, but
goto fail_dmx(_dev): calls release functions again, which causes
use-after-free.

Also, in fail_fe, fail_tuner_probe and fail_demod_probe, j = i will cause
out-of-bound when i finished its loop (i == NUM_FE). And the loop
releasing is wrong, although now NUM_FE is 1 so it won't cause problem.

Fix this by correctly releasing everything.

Fixes: f90cf6079bf6 ("media: vidtv: add a bridge driver")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/test-drivers/vidtv/vidtv_bridge.c   | 22 +++++++------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/media/test-drivers/vidtv/vidtv_bridge.c b/drivers/media/test-drivers/vidtv/vidtv_bridge.c
index fc64d0c8492a..3c281265a9ec 100644
--- a/drivers/media/test-drivers/vidtv/vidtv_bridge.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_bridge.c
@@ -456,26 +456,20 @@ static int vidtv_bridge_dvb_init(struct vidtv_dvb *dvb)
 	for (j = j - 1; j >= 0; --j)
 		dvb->demux.dmx.remove_frontend(&dvb->demux.dmx,
 					       &dvb->dmx_fe[j]);
-fail_dmx_dev:
 	dvb_dmxdev_release(&dvb->dmx_dev);
-fail_dmx:
+fail_dmx_dev:
 	dvb_dmx_release(&dvb->demux);
+fail_dmx:
+fail_demod_probe:
+	for (i = i - 1; i >= 0; --i) {
+		dvb_unregister_frontend(dvb->fe[i]);
 fail_fe:
-	for (j = i; j >= 0; --j)
-		dvb_unregister_frontend(dvb->fe[j]);
+		dvb_module_release(dvb->i2c_client_tuner[i]);
 fail_tuner_probe:
-	for (j = i; j >= 0; --j)
-		if (dvb->i2c_client_tuner[j])
-			dvb_module_release(dvb->i2c_client_tuner[j]);
-
-fail_demod_probe:
-	for (j = i; j >= 0; --j)
-		if (dvb->i2c_client_demod[j])
-			dvb_module_release(dvb->i2c_client_demod[j]);
-
+		dvb_module_release(dvb->i2c_client_demod[i]);
+	}
 fail_adapter:
 	dvb_unregister_adapter(&dvb->adapter);
-
 fail_i2c:
 	i2c_del_adapter(&dvb->i2c_adapter);
 
-- 
2.35.1



