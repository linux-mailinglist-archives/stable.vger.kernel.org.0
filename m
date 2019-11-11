Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2D84F7D44
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbfKKSzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:55:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:51590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729864AbfKKSzB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:55:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FD8720818;
        Mon, 11 Nov 2019 18:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498500;
        bh=oa7+ObusdG651tsz+lRNsmIw5Rwdto7V/xiHEg4SlIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yEXypkrDngJUknxQghkYciV3VofDAlfQa7HcKd7oGBSNA0IOZMuu+SNMm1tlSVlYi
         fngP8+DheGYNJPevcUOs9LkCtsd5suSmdzblerQzQC6oLukciM6q8lpi9Aw2czno1b
         PChPIujWMqAh+FUaralnd5E2IpMvIvDBc7KfvF2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 137/193] usb: dwc3: select CONFIG_REGMAP_MMIO
Date:   Mon, 11 Nov 2019 19:28:39 +0100
Message-Id: <20191111181511.282245835@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit a51bab592fbbef10f0e42a8aed86adfbf6a68fa7 ]

After many randconfig builds, one configuration caused a link
error with dwc3-meson-g12a lacking the regmap-mmio code:

drivers/usb/dwc3/dwc3-meson-g12a.o: In function `dwc3_meson_g12a_probe':
dwc3-meson-g12a.c:(.text+0x9f): undefined reference to `__devm_regmap_init_mmio_clk'

Add the select statement that we have for all other users
of that dependency.

Fixes: c99993376f72 ("usb: dwc3: Add Amlogic G12A DWC3 glue")
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
index 89abc6078703f..556a876c78962 100644
--- a/drivers/usb/dwc3/Kconfig
+++ b/drivers/usb/dwc3/Kconfig
@@ -102,6 +102,7 @@ config USB_DWC3_MESON_G12A
        depends on ARCH_MESON || COMPILE_TEST
        default USB_DWC3
        select USB_ROLE_SWITCH
+	select REGMAP_MMIO
        help
          Support USB2/3 functionality in Amlogic G12A platforms.
 	 Say 'Y' or 'M' if you have one such device.
-- 
2.20.1



