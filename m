Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48899F7ECE
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbfKKTG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 14:06:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728028AbfKKSiv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:38:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 927592196E;
        Mon, 11 Nov 2019 18:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497530;
        bh=mK+Elh+tbvp7chd+lajcYCegHw9TYGBbrnx4TCYxMNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ascod6o9QoLFL3UkvfiA0vwBLnDjznDZA6tFsKU0Ro/jYIM1k57P67ofYS/RWQowK
         Af8nNfa4C3oj6sICBPKtR89nOjdDe09RHnKCv07iiJIPGUzz9FUmCzGQ4Tf1CZddVo
         +0NU0gEjtwYI3sEwwckvdce7L1Thw3APkurkDW0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Roger Quadros <rogerq@ti.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 4.14 046/105] usb: dwc3: Allow disabling of metastability workaround
Date:   Mon, 11 Nov 2019 19:28:16 +0100
Message-Id: <20191111181441.392248271@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

commit 42bf02ec6e420e541af9a47437d0bdf961ca2972 upstream

Some platforms (e.g. TI's DRA7 USB2 instance) have more trouble
with the metastability workaround as it supports only
a High-Speed PHY and the PHY can enter into an Erratic state [1]
when the controller is set in SuperSpeed mode as part of
the metastability workaround.

This causes upto 2 seconds delay in enumeration on DRA7's USB2
instance in gadget mode.

If these platforms can be better off without the workaround,
provide a device tree property to suggest that so the workaround
is avoided.

[1] Device mode enumeration trace showing PHY Erratic Error.
     irq/90-dwc3-969   [000] d...    52.323145: dwc3_event: event (00000901): Erratic Error [U0]
     irq/90-dwc3-969   [000] d...    52.560646: dwc3_event: event (00000901): Erratic Error [U0]
     irq/90-dwc3-969   [000] d...    52.798144: dwc3_event: event (00000901): Erratic Error [U0]

Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/usb/dwc3.txt |    2 ++
 drivers/usb/dwc3/core.c                        |    3 +++
 drivers/usb/dwc3/core.h                        |    3 +++
 drivers/usb/dwc3/gadget.c                      |    6 ++++--
 4 files changed, 12 insertions(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/usb/dwc3.txt
+++ b/Documentation/devicetree/bindings/usb/dwc3.txt
@@ -47,6 +47,8 @@ Optional properties:
 			from P0 to P1/P2/P3 without delay.
  - snps,dis-tx-ipgap-linecheck-quirk: when set, disable u2mac linestate check
 			during HS transmit.
+ - snps,dis_metastability_quirk: when set, disable metastability workaround.
+			CAUTION: use only if you are absolutely sure of it.
  - snps,is-utmi-l1-suspend: true when DWC3 asserts output signal
 			utmi_l1_suspend_n, false when asserts utmi_sleep_n
  - snps,hird-threshold: HIRD threshold
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1115,6 +1115,9 @@ static void dwc3_get_properties(struct d
 	device_property_read_u32(dev, "snps,quirk-frame-length-adjustment",
 				 &dwc->fladj);
 
+	dwc->dis_metastability_quirk = device_property_read_bool(dev,
+				"snps,dis_metastability_quirk");
+
 	dwc->lpm_nyet_threshold = lpm_nyet_threshold;
 	dwc->tx_de_emphasis = tx_de_emphasis;
 
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -869,6 +869,7 @@ struct dwc3_scratchpad_array {
  * 	1	- -3.5dB de-emphasis
  * 	2	- No de-emphasis
  * 	3	- Reserved
+ * @dis_metastability_quirk: set to disable metastability quirk.
  * @imod_interval: set the interrupt moderation interval in 250ns
  *                 increments or 0 to disable.
  */
@@ -1025,6 +1026,8 @@ struct dwc3 {
 	unsigned		tx_de_emphasis_quirk:1;
 	unsigned		tx_de_emphasis:2;
 
+	unsigned		dis_metastability_quirk:1;
+
 	u16			imod_interval;
 };
 
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2034,7 +2034,8 @@ static void dwc3_gadget_set_speed(struct
 	 * STAR#9000525659: Clock Domain Crossing on DCTL in
 	 * USB 2.0 Mode
 	 */
-	if (dwc->revision < DWC3_REVISION_220A) {
+	if (dwc->revision < DWC3_REVISION_220A &&
+	    !dwc->dis_metastability_quirk) {
 		reg |= DWC3_DCFG_SUPERSPEED;
 	} else {
 		switch (speed) {
@@ -3265,7 +3266,8 @@ int dwc3_gadget_init(struct dwc3 *dwc)
 	 * is less than super speed because we don't have means, yet, to tell
 	 * composite.c that we are USB 2.0 + LPM ECN.
 	 */
-	if (dwc->revision < DWC3_REVISION_220A)
+	if (dwc->revision < DWC3_REVISION_220A &&
+	    !dwc->dis_metastability_quirk)
 		dev_info(dwc->dev, "changing max_speed on rev %08x\n",
 				dwc->revision);
 


