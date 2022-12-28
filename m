Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0547B65816A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbiL1Q23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:28:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbiL1Q1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:27:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804A5E0A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:23:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24370B816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907B4C433EF;
        Wed, 28 Dec 2022 16:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244630;
        bh=ZDPtHCi+qzo0de6C5Ur2Nat4s2JnI3zoml3f1C3ca+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fy6MgZ5No9vrAETKWJbOWjvW3mPn07vFF04g3/6pOHz/udEohx0D0JaUr9pUjduCT
         wG+e9SA80qgCdPucmdD0Fsir9BdLdoIO7+2qjpAi/sBj28aqPvM/W22vCrQcmpAiOs
         Hs4TSjIz70eHiM14ux51UwEx0kluAQqk9IhCZ4ck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Jiantao Zhang <water.zhangjiantao@huawei.com>,
        TaoXue <xuetao09@huawei.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0706/1146] USB: gadget: Fix use-after-free during usb config switch
Date:   Wed, 28 Dec 2022 15:37:25 +0100
Message-Id: <20221228144349.323554674@linuxfoundation.org>
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

From: Jiantao Zhang <water.zhangjiantao@huawei.com>

[ Upstream commit afdc12887f2b2ecf20d065a7d81ad29824155083 ]

In the process of switching USB config from rndis to other config,
if the hardware does not support the ->pullup callback, or the
hardware encounters a low probability fault, both of them may cause
the ->pullup callback to fail, which will then cause a system panic
(use after free).

The gadget drivers sometimes need to be unloaded regardless of the
hardware's behavior.

Analysis as follows:
=======================================================================
(1) write /config/usb_gadget/g1/UDC "none"

gether_disconnect+0x2c/0x1f8
rndis_disable+0x4c/0x74
composite_disconnect+0x74/0xb0
configfs_composite_disconnect+0x60/0x7c
usb_gadget_disconnect+0x70/0x124
usb_gadget_unregister_driver+0xc8/0x1d8
gadget_dev_desc_UDC_store+0xec/0x1e4

(2) rm /config/usb_gadget/g1/configs/b.1/f1

rndis_deregister+0x28/0x54
rndis_free+0x44/0x7c
usb_put_function+0x14/0x1c
config_usb_cfg_unlink+0xc4/0xe0
configfs_unlink+0x124/0x1c8
vfs_unlink+0x114/0x1dc

(3) rmdir /config/usb_gadget/g1/functions/rndis.gs4

panic+0x1fc/0x3d0
do_page_fault+0xa8/0x46c
do_mem_abort+0x3c/0xac
el1_sync_handler+0x40/0x78
0xffffff801138f880
rndis_close+0x28/0x34
eth_stop+0x74/0x110
dev_close_many+0x48/0x194
rollback_registered_many+0x118/0x814
unregister_netdev+0x20/0x30
gether_cleanup+0x1c/0x38
rndis_attr_release+0xc/0x14
kref_put+0x74/0xb8
configfs_rmdir+0x314/0x374

If gadget->ops->pullup() return an error, function rndis_close() will be
called, then it will causes a use-after-free problem.
=======================================================================

Fixes: 0a55187a1ec8 ("USB: gadget core: Issue ->disconnect() callback from usb_gadget_disconnect()")
Signed-off-by: Jiantao Zhang <water.zhangjiantao@huawei.com>
Signed-off-by: TaoXue <xuetao09@huawei.com>
Link: https://lore.kernel.org/r/20221121130805.10735-1-water.zhangjiantao@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index c63c0c2cf649..bf9878e1a72a 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -734,13 +734,13 @@ int usb_gadget_disconnect(struct usb_gadget *gadget)
 	}
 
 	ret = gadget->ops->pullup(gadget, 0);
-	if (!ret) {
+	if (!ret)
 		gadget->connected = 0;
-		mutex_lock(&udc_lock);
-		if (gadget->udc->driver)
-			gadget->udc->driver->disconnect(gadget);
-		mutex_unlock(&udc_lock);
-	}
+
+	mutex_lock(&udc_lock);
+	if (gadget->udc->driver)
+		gadget->udc->driver->disconnect(gadget);
+	mutex_unlock(&udc_lock);
 
 out:
 	trace_usb_gadget_disconnect(gadget, ret);
-- 
2.35.1



