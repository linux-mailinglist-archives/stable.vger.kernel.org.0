Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFAEAA8A5
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 18:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbfIEQT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 12:19:56 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35592 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731806AbfIEQSH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 12:18:07 -0400
Received: by mail-pf1-f195.google.com with SMTP id 205so2082051pfw.2
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 09:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oxweDnammrNyIt2aaQLCe6r9vThCpXKTK19Q9yGm1E4=;
        b=B+cZWsZuXFEQB01N9qcY/nKk7nFveM0bQSkHouQZ+2v8KRCDItQu12g91o55OqiDIl
         SQnnn5r6vvZTn3KSmZR9+5rl9wxcTUw4H96aAEmGDnjJxx3uKAFfio+dNp5I+wQr3Vwe
         gbXWR4hTOwsV+tXvAEB+6kyHio5Z54rthgV5q6RE89zhMs4lr/LJm01282eHycMXzU0z
         U9a2VMJKcYvCVPouURNHnaM7gNG9pAlCnZKkh1Y0vrCEBkYcoJQ5dlKEJOS6mj8Rfcf/
         3BOqGGxylR2E7voPViPNnWEY2QFJ0exUKtekqdkZckIcT8g6oOqpENw3lQbrUEfCQSqK
         d4Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oxweDnammrNyIt2aaQLCe6r9vThCpXKTK19Q9yGm1E4=;
        b=C4+BAWMtY8Z4O/DFEGwUOkx2eNaVn6slSwkymy7sbCukNrU7SueGR/spRx9iJU3LuJ
         jYsyDbjoJ/LJ01YmO+cQKtl+7/zOe96QErkmm3GMzjcde749D+4jP8/oYXS1AiCjXU9J
         XQa6CVBfHfNWpJeKPQLS6Kqs4Q9rJs/Ss2OfivXvb/Lozy+WvujHyrMixMwWuV9npcLb
         CXdgSwCNlBmqxJq5+4sRDvao7uQga9i3OHgXkYHct7jvpkodMejjLeWVtKtq/fBzREZ8
         fdYpyeGUhPY4d1ibhxSPhOBPYfC22KcZAEXgXxIzA8azp9LpgDNQRR8VGg+DT15Uz9p6
         XhPQ==
X-Gm-Message-State: APjAAAVDPK3vVs3pD4WPQ72DTmhrh0CQezz6GVH7pK1MN0nhWIC/aJuv
        Bw8Pdr8v8jggOeJKuDIBXOhscbR7/yw=
X-Google-Smtp-Source: APXvYqztrUm14X1kqPalVQhtzDPhMyl9ZuipQZ2gB9IH4meo0O8XJPRIpaw1CUbOHUi6IeHE59j1dQ==
X-Received: by 2002:a17:90a:303:: with SMTP id 3mr4750663pje.124.1567700285921;
        Thu, 05 Sep 2019 09:18:05 -0700 (PDT)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m129sm6324005pga.39.2019.09.05.09.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 09:18:05 -0700 (PDT)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [BACKPORT 4.14.y 04/18] usb: dwc3: Allow disabling of metastability workaround
Date:   Thu,  5 Sep 2019 10:17:45 -0600
Message-Id: <20190905161759.28036-5-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905161759.28036-1-mathieu.poirier@linaro.org>
References: <20190905161759.28036-1-mathieu.poirier@linaro.org>
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
---
 Documentation/devicetree/bindings/usb/dwc3.txt | 2 ++
 drivers/usb/dwc3/core.c                        | 3 +++
 drivers/usb/dwc3/core.h                        | 3 +++
 drivers/usb/dwc3/gadget.c                      | 6 ++++--
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentation/devicetree/bindings/usb/dwc3.txt
index 52fb41046b34..44e8bab159ad 100644
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
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 945330ea8d5c..9b093978bd24 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1115,6 +1115,9 @@ static void dwc3_get_properties(struct dwc3 *dwc)
 	device_property_read_u32(dev, "snps,quirk-frame-length-adjustment",
 				 &dwc->fladj);
 
+	dwc->dis_metastability_quirk = device_property_read_bool(dev,
+				"snps,dis_metastability_quirk");
+
 	dwc->lpm_nyet_threshold = lpm_nyet_threshold;
 	dwc->tx_de_emphasis = tx_de_emphasis;
 
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index abd1142c9e4d..40bf0e0768d9 100644
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
 
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 1b99d44e52b9..5916340c4162 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2034,7 +2034,8 @@ static void dwc3_gadget_set_speed(struct usb_gadget *g,
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
 
-- 
2.17.1

