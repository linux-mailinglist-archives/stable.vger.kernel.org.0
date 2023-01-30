Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC39681025
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236836AbjA3OBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236865AbjA3OBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:01:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E353A87C
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:00:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BD8161034
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD10C433D2;
        Mon, 30 Jan 2023 13:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087193;
        bh=JoD7Hk55e3EapjnEioEQz18oUXJZ0vPnj8YOIlLeibU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=htC92K2+IDZNZRuuambFYA10PUzZZVnpLU5qy0/2o8cGZuXyd0KCSBDZai8geeJQr
         6in9+h6a+Cb/yROxbEf+tE6YRF/eZ3v0xn20041g48TkQAIH7wu4f2xQLSfsxs/kZU
         CROfLs2ahwGQmK/lsPLMbK1bojaoQIQml2WZsJvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 127/313] usb: dwc3: fix extcon dependency
Date:   Mon, 30 Jan 2023 14:49:22 +0100
Message-Id: <20230130134342.566370552@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 7d80dbd708c18c683dd34f79b600a05307707ce8 ]

The dwc3 core support now links against the extcon subsystem,
so it cannot be built-in when extcon is a loadable module:

arm-linux-gnueabi-ld: drivers/usb/dwc3/core.o: in function `dwc3_get_extcon':
core.c:(.text+0x572): undefined reference to `extcon_get_edev_by_phandle'
arm-linux-gnueabi-ld: core.c:(.text+0x596): undefined reference to `extcon_get_extcon_dev'
arm-linux-gnueabi-ld: core.c:(.text+0x5ea): undefined reference to `extcon_find_edev_by_node'

There was already a Kconfig dependency in the dual-role support,
but this is now needed for the entire dwc3 driver.

It is still possible to build dwc3 without extcon, but this
prevents it from being set to built-in when extcon is a loadable
module.

Fixes: d182c2e1bc92 ("usb: dwc3: Don't switch OTG -> peripheral if extcon is present")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20230118090147.2126563-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
index 03ededa86da1..864fef540a39 100644
--- a/drivers/usb/dwc3/Kconfig
+++ b/drivers/usb/dwc3/Kconfig
@@ -3,6 +3,7 @@
 config USB_DWC3
 	tristate "DesignWare USB3 DRD Core Support"
 	depends on (USB || USB_GADGET) && HAS_DMA
+	depends on (EXTCON || EXTCON=n)
 	select USB_XHCI_PLATFORM if USB_XHCI_HCD
 	select USB_ROLE_SWITCH if USB_DWC3_DUAL_ROLE
 	help
@@ -44,7 +45,6 @@ config USB_DWC3_GADGET
 config USB_DWC3_DUAL_ROLE
 	bool "Dual Role mode"
 	depends on ((USB=y || USB=USB_DWC3) && (USB_GADGET=y || USB_GADGET=USB_DWC3))
-	depends on (EXTCON=y || EXTCON=USB_DWC3)
 	help
 	  This is the default mode of working of DWC3 controller where
 	  both host and gadget features are enabled.
-- 
2.39.0



