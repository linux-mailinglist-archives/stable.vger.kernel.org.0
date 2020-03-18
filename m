Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E911D189F8C
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 16:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgCRPXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 11:23:43 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36864 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbgCRPXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Mar 2020 11:23:43 -0400
Received: by mail-wr1-f66.google.com with SMTP id w10so2099434wrm.4
        for <stable@vger.kernel.org>; Wed, 18 Mar 2020 08:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=vcuQ9gcytyRyDY8O+hV2btKMyad21nj7al+XoxPWHJE=;
        b=nGzIz3b8BS+V35Arf30oggbsc/tPZjP11gUMYxid52jBa2s9rJgwlGXTg6QiOfyHXw
         J3XMSRISYs58xGGakGzW4VeeieqMi0KkQ0AYDynXCN7QJWOGjRmwh3E2E0vTxTsX1YOC
         5UfgdjXRHcMwEWG6RS1JZsl5y+/Y72SNan1fQs4uWeNbck8sXBffJVA+/QyirERP848B
         5DdA6sZn3TwGRsgmVtwhiP6uSZVx7f6y1VO8J9SJUASeVqcYkPvXPkWoAOExjY7l+YS2
         OyhAXthKt0wKqpSzWCj9BzeVQjSJumvScqcO77UZO1eXQas46QyaJTBCDKD/LHwyKejA
         NZ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vcuQ9gcytyRyDY8O+hV2btKMyad21nj7al+XoxPWHJE=;
        b=VxEaRlHs1twQen4pps71vqgnAbVnXGtQUA2+dXPgvYo5wk6/3Mn6QuFDSzzBAM+rt+
         o5jUrmafiIbkb8yq8/pONjihJP3QGmaGuGT+tKx2Kpv27Rwteos38W8Ihzx5ovZvBqXH
         nCEAXNxG/IWbwK53oeDjGw6bUrszOtdjI4bESjyH39a/dLmZe8ETtdd1W462VQi5+zsa
         CX7TKMx6P911gGmZGwja/dBlVokmwtHK2/tKpyBAXzpDdeAH3Mw8lLHoac0GoSYZUdk+
         uLu23268QBLOkyZGgv26SxxLpqcwxrsgO4E6prcG4ka3nTLT//Aw1w/NAnmxPhdsTCYj
         NKJw==
X-Gm-Message-State: ANhLgQ27LTKaHRvgOxnGNpiLx5QFcwXrRKEoaTonEB1xD8SFZlt4KEQ1
        Dni53zzz0caFjkPlqwLONm6vdQ==
X-Google-Smtp-Source: ADFU+vvGk6xRRdtafKwG/IAn8PrMglCVvUmZVoJhe+n4XquEkaUXMZhe+dh6g8+sA8wedIJ2nB2gFw==
X-Received: by 2002:a5d:440a:: with SMTP id z10mr6208528wrq.177.1584545021409;
        Wed, 18 Mar 2020 08:23:41 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id v10sm4015464wml.44.2020.03.18.08.23.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 18 Mar 2020 08:23:40 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     jonathanh@nvidia.com, kishon@ti.com, nkristam@nvidia.com,
        thierry.reding@gmail.com, treding@nvidia.com
Cc:     linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] phy: tegra: should select USB_PHY
Date:   Wed, 18 Mar 2020 15:23:33 +0000
Message-Id: <1584545013-19859-1-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I have hit the following build error:
armv7a-hardfloat-linux-gnueabi-ld: drivers/phy/tegra/xusb.o: in function `tegra_xusb_port_unregister':
xusb.c:(.text+0x2ac): undefined reference to `usb_remove_phy'
armv7a-hardfloat-linux-gnueabi-ld: drivers/phy/tegra/xusb.o: in function `tegra_xusb_setup_ports':
xusb.c:(.text+0xf30): undefined reference to `usb_add_phy_dev'

PHY_TEGRA_XUSB should select USB_PHY

Fixes: 23babe30fb45d ("phy: tegra: xusb: Add usb-phy support")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/phy/tegra/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/tegra/Kconfig b/drivers/phy/tegra/Kconfig
index df07c4dea059..a208aca4ba7b 100644
--- a/drivers/phy/tegra/Kconfig
+++ b/drivers/phy/tegra/Kconfig
@@ -3,6 +3,7 @@ config PHY_TEGRA_XUSB
 	tristate "NVIDIA Tegra XUSB pad controller driver"
 	depends on ARCH_TEGRA
 	select USB_CONN_GPIO
+	select USB_PHY
 	help
 	  Choose this option if you have an NVIDIA Tegra SoC.
 
-- 
2.24.1

