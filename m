Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42231657D07
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbiL1Pik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233498AbiL1Pij (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:38:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9CF1659E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:38:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10968B8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794EAC433D2;
        Wed, 28 Dec 2022 15:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241915;
        bh=kl9t3VKFk9KL5Sokgh4hA/Dvd50iPx2j8/AN9euXYsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gTO0Ft9vztGlcgpTRZHW14gWXChXAvfT0Us/7sTFtn1v+/9AbKqEuy1ppi9Uf5UK1
         sacXqq+oF9Pu/XjVZMULYciyJQfjouRMieL9cRBsGe4VCDM+3PPxp8dg1bIP2yQ8Hd
         5jakoKXRXsPJqFb38sUUrOUr7649Y/Woe6XsWHHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0343/1073] media: vidtv: Fix use-after-free in vidtv_bridge_dvb_init()
Date:   Wed, 28 Dec 2022 15:32:11 +0100
Message-Id: <20221228144337.323006142@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 82620613d56b..dff7265a42ca 100644
--- a/drivers/media/test-drivers/vidtv/vidtv_bridge.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_bridge.c
@@ -459,26 +459,20 @@ static int vidtv_bridge_dvb_init(struct vidtv_dvb *dvb)
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



