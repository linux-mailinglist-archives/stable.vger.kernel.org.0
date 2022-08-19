Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B881759A0A4
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352340AbiHSQWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352434AbiHSQUz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:20:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABF24A101;
        Fri, 19 Aug 2022 09:01:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88E1161698;
        Fri, 19 Aug 2022 16:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9673C433C1;
        Fri, 19 Aug 2022 16:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924916;
        bh=W02nud47FAwyYJH8y0n+a0JMGBj+6bFQPEtMBhqJBfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QW0dGWxe1YQouNYOCz9Yp4NUtkf4nB0vWWdg0TJc9ANt/tDf7XwsbQD0tGISwlXX0
         ldMGy5PzCFpA6HAAOXgaa/Sb3nBr9c67LsHEwb6H+wP0si2q5+zT3Ps617EutVjfM2
         y6XHtr0Lg+zWy58vgHy3jauLkoYF2Be2CkVfb2kY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Raviteja Garimella <raviteja.garimella@broadcom.com>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 324/545] usb: gadget: udc: amd5536 depends on HAS_DMA
Date:   Fri, 19 Aug 2022 17:41:34 +0200
Message-Id: <20220819153843.859521384@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index 933e80d5053a..f28e1bbd5724 100644
--- a/drivers/usb/gadget/udc/Kconfig
+++ b/drivers/usb/gadget/udc/Kconfig
@@ -311,7 +311,7 @@ source "drivers/usb/gadget/udc/bdc/Kconfig"
 
 config USB_AMD5536UDC
 	tristate "AMD5536 UDC"
-	depends on USB_PCI
+	depends on USB_PCI && HAS_DMA
 	select USB_SNP_CORE
 	help
 	   The AMD5536 UDC is part of the AMD Geode CS5536, an x86 southbridge.
-- 
2.35.1



