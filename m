Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE0759506B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbiHPEmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbiHPEkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:40:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D052A61EB;
        Mon, 15 Aug 2022 13:32:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CACB9B8113E;
        Mon, 15 Aug 2022 20:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ACA2C433D6;
        Mon, 15 Aug 2022 20:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595574;
        bh=TAuUMR7MhN059r8wH39ZJ2WwqdyBclsgrNGwmEPdtag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mAL9W0jV+/8gMBTQSOs+hPIH0h39Oc7YLwHl5SUUUwdZbobaftsA6Num183b8R/1V
         ZG5AtDBH+FXjoS23dSZf1FjZ7T+A1455FimSmkIsFQRZBRC9tKApQKusUz6g09aAw5
         euJbPionPTwa8toS4a1InQBdwQ7SEyn8/NvrRCDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Raviteja Garimella <raviteja.garimella@broadcom.com>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0808/1157] usb: gadget: udc: amd5536 depends on HAS_DMA
Date:   Mon, 15 Aug 2022 20:02:44 +0200
Message-Id: <20220815180511.816097398@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 69394dc1cdfb..2cdd37be165a 100644
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



