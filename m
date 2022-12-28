Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B047657E3D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbiL1PwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:52:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234172AbiL1Pvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:51:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A7E18B0D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:51:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24E5E61563
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:51:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330E1C433EF;
        Wed, 28 Dec 2022 15:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242694;
        bh=tKrsNASXm356EdJnY/G+089reObObzamFt1AZTTZjzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2XxOUGw2+yjb37NWrys+qwZHEtz12uAJh87z19wUjdRUpyhtO7vmiD0OJlLWH5iN
         dKepjyV5Xbad0KmDpkJdbWG7p9iLw+u4sieLaqfQVES5DJIIFB5wajnlWyXxN0Rwpe
         VY6UWRKrLG2nnUZ2QK4erRyPs8VCZdPuxNd+IOQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0403/1146] media: dvb-core: Fix ignored return value in dvb_register_frontend()
Date:   Wed, 28 Dec 2022 15:32:22 +0100
Message-Id: <20221228144341.111430984@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit a574359e2e71ce16be212df3a082ed60a4bd2c5f ]

In dvb_register_frontend(), dvb_register_device() is possible to fail
but its return value is ignored.

It will cause use-after-free when module is removed, because in
dvb_unregister_frontend() it tries to unregister a not registered
device.

BUG: KASAN: use-after-free in dvb_remove_device+0x18b/0x1f0 [dvb_core]
Read of size 4 at addr ffff88800dff4824 by task rmmod/428
CPU: 3 PID: 428 Comm: rmmod
Call Trace:
 <TASK>
 ...
 dvb_remove_device+0x18b/0x1f0 [dvb_core]
 dvb_unregister_frontend+0x7b/0x130 [dvb_core]
 vidtv_bridge_remove+0x6e/0x160 [dvb_vidtv_bridge]
 ...

Fix this by catching return value of dvb_register_device().
However the fe->refcount can't be put to zero immediately, because
there are still modules calling dvb_frontend_detach() when
dvb_register_frontend() fails.

Link: https://lore.kernel.org/linux-media/20221108033005.169095-1-chenzhongjin@huawei.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 48e735cdbe6b..a7792ef4baf8 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2986,6 +2986,7 @@ int dvb_register_frontend(struct dvb_adapter *dvb,
 		.name = fe->ops.info.name,
 #endif
 	};
+	int ret;
 
 	dev_dbg(dvb->device, "%s:\n", __func__);
 
@@ -3019,8 +3020,13 @@ int dvb_register_frontend(struct dvb_adapter *dvb,
 		 "DVB: registering adapter %i frontend %i (%s)...\n",
 		 fe->dvb->num, fe->id, fe->ops.info.name);
 
-	dvb_register_device(fe->dvb, &fepriv->dvbdev, &dvbdev_template,
+	ret = dvb_register_device(fe->dvb, &fepriv->dvbdev, &dvbdev_template,
 			    fe, DVB_DEVICE_FRONTEND, 0);
+	if (ret) {
+		dvb_frontend_put(fe);
+		mutex_unlock(&frontend_mutex);
+		return ret;
+	}
 
 	/*
 	 * Initialize the cache to the proper values according with the
-- 
2.35.1



