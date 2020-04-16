Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E6B1AC7D0
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406503AbgDPO7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:59:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898829AbgDPNyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:54:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E429920786;
        Thu, 16 Apr 2020 13:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045283;
        bh=46mEjSm/G6IxHNb/fSSMev4MKJ0GpsninI8lztdBv/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DV6yEeXYrAkuA03o35PL9EdtAsF6Di+V0v95NlrtTnB5oyYnQ307tkD575Jj/jJj8
         vdeap4B4ywMMBpxfm2BE4U1FoRNGbO99SgJwRbtvsQzcyotyqLNKR7GqPg+Te9O3xX
         UqOHTG8bqgj3k7I8tRgmWEZnyQWwjh7yuJYXWSJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongjin Kim <tobetter@gmail.com>,
        Jianxin Pan <jianxin.pan@amlogic.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Jun Li <lijun.kernel@gmail.com>, Tim <elatllat@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 054/254] usb: dwc3: core: add support for disabling SS instances in park mode
Date:   Thu, 16 Apr 2020 15:22:23 +0200
Message-Id: <20200416131332.663789377@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit 7ba6b09fda5e0cb741ee56f3264665e0edc64822 ]

In certain circumstances, the XHCI SuperSpeed instance in park mode
can fail to recover, thus on Amlogic G12A/G12B/SM1 SoCs when there is high
load on the single XHCI SuperSpeed instance, the controller can crash like:
 xhci-hcd xhci-hcd.0.auto: xHCI host not responding to stop endpoint command.
 xhci-hcd xhci-hcd.0.auto: Host halt failed, -110
 xhci-hcd xhci-hcd.0.auto: xHCI host controller not responding, assume dead
 xhci-hcd xhci-hcd.0.auto: xHCI host not responding to stop endpoint command.
 hub 2-1.1:1.0: hub_ext_port_status failed (err = -22)
 xhci-hcd xhci-hcd.0.auto: HC died; cleaning up
 usb 2-1.1-port1: cannot reset (err = -22)

Setting the PARKMODE_DISABLE_SS bit in the DWC3_USB3_GUCTL1 mitigates
the issue. The bit is described as :
"When this bit is set to '1' all SS bus instances in park mode are disabled"

Synopsys explains:
The GUCTL1.PARKMODE_DISABLE_SS is only available in
dwc_usb3 controller running in host mode.
This should not be set for other IPs.
This can be disabled by default based on IP, but I recommend to have a
property to enable this feature for devices that need this.

CC: Dongjin Kim <tobetter@gmail.com>
Cc: Jianxin Pan <jianxin.pan@amlogic.com>
Cc: Thinh Nguyen <thinhn@synopsys.com>
Cc: Jun Li <lijun.kernel@gmail.com>
Reported-by: Tim <elatllat@gmail.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c | 5 +++++
 drivers/usb/dwc3/core.h | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 1d85c42b9c674..43bd5b1ea9e2c 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1029,6 +1029,9 @@ static int dwc3_core_init(struct dwc3 *dwc)
 		if (dwc->dis_tx_ipgap_linecheck_quirk)
 			reg |= DWC3_GUCTL1_TX_IPGAP_LINECHECK_DIS;
 
+		if (dwc->parkmode_disable_ss_quirk)
+			reg |= DWC3_GUCTL1_PARKMODE_DISABLE_SS;
+
 		dwc3_writel(dwc->regs, DWC3_GUCTL1, reg);
 	}
 
@@ -1342,6 +1345,8 @@ static void dwc3_get_properties(struct dwc3 *dwc)
 				"snps,dis-del-phy-power-chg-quirk");
 	dwc->dis_tx_ipgap_linecheck_quirk = device_property_read_bool(dev,
 				"snps,dis-tx-ipgap-linecheck-quirk");
+	dwc->parkmode_disable_ss_quirk = device_property_read_bool(dev,
+				"snps,parkmode-disable-ss-quirk");
 
 	dwc->tx_de_emphasis_quirk = device_property_read_bool(dev,
 				"snps,tx_de_emphasis_quirk");
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 77c4a9abe3652..3ecc69c5b150f 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -249,6 +249,7 @@
 #define DWC3_GUCTL_HSTINAUTORETRY	BIT(14)
 
 /* Global User Control 1 Register */
+#define DWC3_GUCTL1_PARKMODE_DISABLE_SS	BIT(17)
 #define DWC3_GUCTL1_TX_IPGAP_LINECHECK_DIS	BIT(28)
 #define DWC3_GUCTL1_DEV_L1_EXIT_BY_HW	BIT(24)
 
@@ -1024,6 +1025,8 @@ struct dwc3_scratchpad_array {
  *			change quirk.
  * @dis_tx_ipgap_linecheck_quirk: set if we disable u2mac linestate
  *			check during HS transmit.
+ * @parkmode_disable_ss_quirk: set if we need to disable all SuperSpeed
+ *			instances in park mode.
  * @tx_de_emphasis_quirk: set if we enable Tx de-emphasis quirk
  * @tx_de_emphasis: Tx de-emphasis value
  * 	0	- -6dB de-emphasis
@@ -1215,6 +1218,7 @@ struct dwc3 {
 	unsigned		dis_u2_freeclk_exists_quirk:1;
 	unsigned		dis_del_phy_power_chg_quirk:1;
 	unsigned		dis_tx_ipgap_linecheck_quirk:1;
+	unsigned		parkmode_disable_ss_quirk:1;
 
 	unsigned		tx_de_emphasis_quirk:1;
 	unsigned		tx_de_emphasis:2;
-- 
2.20.1



