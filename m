Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C00611346D
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbfLDSC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:02:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729850AbfLDSC3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:02:29 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 304C820659;
        Wed,  4 Dec 2019 18:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482548;
        bh=SX2sF24SxxN0DTRfvAZ+p3qN/yPB1GS57zgjqYDAA+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ubDzYrcUQA7QkIK54w8DQBdL+mRUozPb0tNFADiPvNZu2VWkW55BSuZNdDtV6kdl7
         Dsy3UDY6WlD0zBzILIpr8pZadvkkItcPRUvYX4U7+X+TwRKFW8aC2XkWVfSL/epoEJ
         zJyt+aB/WPQsiBPv1LGarlMOTkOg9JfD181FnXsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 039/209] ARM: OMAP1: fix USB configuration for device-only setups
Date:   Wed,  4 Dec 2019 18:54:11 +0100
Message-Id: <20191204175324.112362776@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@iki.fi>

[ Upstream commit c7b7b5cbd0c859b1546a5a3455d457708bdadf4c ]

Currently we do USB configuration only if the host mode (CONFIG_USB)
is enabled. But it should be done also in the case of device-only setups,
so change the condition to CONFIG_USB_SUPPORT. This allows to use
omap_udc on Palm Tungsten E.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap1/Makefile           | 2 +-
 arch/arm/mach-omap1/include/mach/usb.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap1/Makefile b/arch/arm/mach-omap1/Makefile
index e8ccf51c6f292..ec0235899de20 100644
--- a/arch/arm/mach-omap1/Makefile
+++ b/arch/arm/mach-omap1/Makefile
@@ -25,7 +25,7 @@ obj-y					+= $(i2c-omap-m) $(i2c-omap-y)
 
 led-y := leds.o
 
-usb-fs-$(CONFIG_USB)			:= usb.o
+usb-fs-$(CONFIG_USB_SUPPORT)		:= usb.o
 obj-y					+= $(usb-fs-m) $(usb-fs-y)
 
 # Specific board support
diff --git a/arch/arm/mach-omap1/include/mach/usb.h b/arch/arm/mach-omap1/include/mach/usb.h
index 77867778d4ec7..5429d86c7190d 100644
--- a/arch/arm/mach-omap1/include/mach/usb.h
+++ b/arch/arm/mach-omap1/include/mach/usb.h
@@ -11,7 +11,7 @@
 
 #include <linux/platform_data/usb-omap1.h>
 
-#if IS_ENABLED(CONFIG_USB)
+#if IS_ENABLED(CONFIG_USB_SUPPORT)
 void omap1_usb_init(struct omap_usb_config *pdata);
 #else
 static inline void omap1_usb_init(struct omap_usb_config *pdata)
-- 
2.20.1



