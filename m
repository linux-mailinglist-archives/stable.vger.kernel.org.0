Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83657643348
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbiLETfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbiLETe6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:34:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4EE6456
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:30:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AECF5B811EC
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0E4C433D6;
        Mon,  5 Dec 2022 19:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268655;
        bh=SdJQWARgQaB28Ti5xKgTmEcBs+Mz6G6T2u42RJZ1dsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R/vWPO+S2f09LbLz2RlqM6VX1JbcmBx1gwAXJbA1uvO9jdItiefvL2o3PeBhfQ5kO
         T4FAOgs9L3rDPGYaJHTxeJJSdfXO8tvW/xAL/XL5J+wfaPBdo86kRnKg0paxswdI1c
         yV0HB6Zx40ppHQ4+lIZxBp4RoDdsMcR9/s6ntxxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 39/92] net: phy: fix null-ptr-deref while probe() failed
Date:   Mon,  5 Dec 2022 20:09:52 +0100
Message-Id: <20221205190804.757159978@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 369eb2c9f1f72adbe91e0ea8efb130f0a2ba11a6 ]

I got a null-ptr-deref report as following when doing fault injection test:

BUG: kernel NULL pointer dereference, address: 0000000000000058
Oops: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 PID: 253 Comm: 507-spi-dm9051 Tainted: G    B            N 6.1.0-rc3+
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:klist_put+0x2d/0xd0
Call Trace:
 <TASK>
 klist_remove+0xf1/0x1c0
 device_release_driver_internal+0x23e/0x2d0
 bus_remove_device+0x1bd/0x240
 device_del+0x357/0x770
 phy_device_remove+0x11/0x30
 mdiobus_unregister+0xa5/0x140
 release_nodes+0x6a/0xa0
 devres_release_all+0xf8/0x150
 device_unbind_cleanup+0x19/0xd0

//probe path:
phy_device_register()
  device_add()

phy_connect
  phy_attach_direct() //set device driver
    probe() //it's failed, driver is not bound
    device_bind_driver() // probe failed, it's not called

//remove path:
phy_device_remove()
  device_del()
    device_release_driver_internal()
      __device_release_driver() //dev->drv is not NULL
        klist_remove() <- knode_driver is not added yet, cause null-ptr-deref

In phy_attach_direct(), after setting the 'dev->driver', probe() fails,
device_bind_driver() is not called, so the knode_driver->n_klist is not
set, then it causes null-ptr-deref in __device_release_driver() while
deleting device. Fix this by setting dev->driver to NULL in the error
path in phy_attach_direct().

Fixes: e13934563db0 ("[PATCH] PHY Layer fixup")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index d2f6d8107595..3ef5aa6b72a7 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1423,6 +1423,7 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 
 error_module_put:
 	module_put(d->driver->owner);
+	d->driver = NULL;
 error_put_device:
 	put_device(d);
 	if (ndev_owner != bus->owner)
-- 
2.35.1



