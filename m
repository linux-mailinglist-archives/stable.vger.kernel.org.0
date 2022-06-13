Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE0054870E
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355293AbiFMLqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356917AbiFMLpM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:45:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D7D48E4A;
        Mon, 13 Jun 2022 03:51:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 254D0B80EA3;
        Mon, 13 Jun 2022 10:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE10C34114;
        Mon, 13 Jun 2022 10:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117485;
        bh=Z9DYUngYcON6a47cxhpviZQO2HQH4IU+z97whtMmzU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/3O41yXR+G3u4JYXQTUQhYa/MuzxCcrDgJRHlgcn+YqXtiNvESs/zJ2VIMNG60CC
         bKTwl/A3/cfmVVraDFhP3RAidcbUCeCdWEDCRSGdL0cUdxrplYERNRTeh20rdJKSsx
         laC7TBYyTB973eMKQLJsPA+N4hDdFdPheWZtgB3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 376/411] usb: dwc2: gadget: dont reset gadgets driver->bus
Date:   Mon, 13 Jun 2022 12:10:49 +0200
Message-Id: <20220613094939.949707008@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 3120aac6d0ecd9accf56894aeac0e265f74d3d5a ]

UDC driver should not touch gadget's driver internals, especially it
should not reset driver->bus. This wasn't harmful so far, but since
commit fc274c1e9973 ("USB: gadget: Add a new bus for gadgets") gadget
subsystem got it's own bus and messing with ->bus triggers the
following NULL pointer dereference:

dwc2 12480000.hsotg: bound driver g_ether
8<--- cut here ---
Unable to handle kernel NULL pointer dereference at virtual address 00000000
[00000000] *pgd=00000000
Internal error: Oops: 5 [#1] SMP ARM
Modules linked in: ...
CPU: 0 PID: 620 Comm: modprobe Not tainted 5.18.0-rc5-next-20220504 #11862
Hardware name: Samsung Exynos (Flattened Device Tree)
PC is at module_add_driver+0x44/0xe8
LR is at sysfs_do_create_link_sd+0x84/0xe0
...
Process modprobe (pid: 620, stack limit = 0x(ptrval))
...
 module_add_driver from bus_add_driver+0xf4/0x1e4
 bus_add_driver from driver_register+0x78/0x10c
 driver_register from usb_gadget_register_driver_owner+0x40/0xb4
 usb_gadget_register_driver_owner from do_one_initcall+0x44/0x1e0
 do_one_initcall from do_init_module+0x44/0x1c8
 do_init_module from load_module+0x19b8/0x1b9c
 load_module from sys_finit_module+0xdc/0xfc
 sys_finit_module from ret_fast_syscall+0x0/0x54
Exception stack(0xf1771fa8 to 0xf1771ff0)
...
dwc2 12480000.hsotg: new device is high-speed
---[ end trace 0000000000000000 ]---

Fix this by removing driver->bus entry reset.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20220505104618.22729-1-m.szyprowski@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/gadget.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 379bbf27c7ce..8fd6eefc671c 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -4486,7 +4486,6 @@ static int dwc2_hsotg_udc_start(struct usb_gadget *gadget,
 
 	WARN_ON(hsotg->driver);
 
-	driver->driver.bus = NULL;
 	hsotg->driver = driver;
 	hsotg->gadget.dev.of_node = hsotg->dev->of_node;
 	hsotg->gadget.speed = USB_SPEED_UNKNOWN;
-- 
2.35.1



