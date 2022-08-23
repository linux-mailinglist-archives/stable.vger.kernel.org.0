Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F13E59D920
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242349AbiHWJsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238966AbiHWJrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:47:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899DA9C8CE;
        Tue, 23 Aug 2022 01:44:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B12AB81C4A;
        Tue, 23 Aug 2022 08:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9733BC433B5;
        Tue, 23 Aug 2022 08:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244239;
        bh=azrkHgPOnQs884ZEUGFFFLQT6q0lJFF7yhUhaKnD080=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RWExlh+fyrRuwMbIxKr/2863jpg53DDS8GIMBy9wXUfwpcEfm5lEdzncqx4HV/QIo
         GFBOPINW6aH4pFTiOpn3xO2LHWozElYjn+OK+n3cOFWu7ez00L8yU+0ggTBIkJUtR7
         EyJFUNkXLA7b8cC7QT1I/ALs35hStapQ42VD9cYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Raviteja Garimella <raviteja.garimella@broadcom.com>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 107/229] usb: gadget: udc: amd5536 depends on HAS_DMA
Date:   Tue, 23 Aug 2022 10:24:28 +0200
Message-Id: <20220823080057.502281644@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 8097cf2fb3b2205257f1c76f4808e3398d66b6d9 ]

USB_AMD5536UDC should depend on HAS_DMA since it selects USB_SNP_CORE,
which depends on HAS_DMA and since 'select' does not follow any
dependency chains.

Fixes this kconfig warning:

WARNING: unmet direct dependencies detected for USB_SNP_CORE
  Depends on [n]: USB_SUPPORT [=y] && USB_GADGET [=y] && (USB_AMD5536UDC [=y] || USB_SNP_UDC_PLAT [=n]) && HAS_DMA [=n]
  Selected by [y]:
  - USB_AMD5536UDC [=y] && USB_SUPPORT [=y] && USB_GADGET [=y] && USB_PCI [=y]

Fixes: 97b3ffa233b9 ("usb: gadget: udc: amd5536: split core and PCI layer")
Cc: Raviteja Garimella <raviteja.garimella@broadcom.com>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: linux-usb@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20220709013601.7536-1-rdunlap@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/Kconfig b/drivers/usb/gadget/udc/Kconfig
index 3291ea22853c..4c6eaf2a3b73 100644
--- a/drivers/usb/gadget/udc/Kconfig
+++ b/drivers/usb/gadget/udc/Kconfig
@@ -309,7 +309,7 @@ source "drivers/usb/gadget/udc/bdc/Kconfig"
 
 config USB_AMD5536UDC
 	tristate "AMD5536 UDC"
-	depends on USB_PCI
+	depends on USB_PCI && HAS_DMA
 	select USB_SNP_CORE
 	help
 	   The AMD5536 UDC is part of the AMD Geode CS5536, an x86 southbridge.
-- 
2.35.1



