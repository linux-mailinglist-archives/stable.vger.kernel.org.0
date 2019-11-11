Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFB83F8805
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 06:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbfKLFeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 00:34:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:60760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfKLFeA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 00:34:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 879C12084F;
        Tue, 12 Nov 2019 05:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573536840;
        bh=sbnFXAjpbcwJnf2+mH5IsFebJvwzJN37XivvkMyt/50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rrw9OoBoJJsfH217xuK/dIynZd/Lg3JslxJZPFFOu+cHhG9k+6kIM0nBggDw4x4G0
         cRUqK3qLEBrT44fRfisxQOXG8+2cSiGBD+8JHqN6tT7EhpPwCfqnia3993/K2k8qKR
         Nw05FMp4nIvID6V0U5M+CJ/5OXz/Z+jJcBv5Xg44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roger Quadros <rogerq@ti.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4.14 061/105] ARM: dts: dra7: Disable USB metastability workaround for USB2
Date:   Mon, 11 Nov 2019 19:28:31 +0100
Message-Id: <20191111181444.963730015@linuxfoundation.org>
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

commit b8c9c6fa2002b8fd4a9710f76f80f99c6046d48c upstream.

The metastability workaround causes Erratic errors [1]
on the HighSpeed USB PHY which can cause upto 2 seconds
delay in enumerating to a USB host while in Gadget mode.

Disable the Run/Stop metastability workaround to avoid this
ill effect. We are aware that this opens up the opportunity
for Run/Stop metastability, however this issue has never been
observed in TI releases so we think that Run/Stop metastability
is a lesser evil than the PHY Erratic errors. So disable it.

[1] USB controller trace during gadget enumeration
    irq/90-dwc3-969   [000] d...    52.323145: dwc3_event: event
    (00000901): Erratic Error [U0]
    irq/90-dwc3-969   [000] d...    52.560646: dwc3_event: event
    (00000901): Erratic Error [U0]
    irq/90-dwc3-969   [000] d...    52.798144: dwc3_event: event
    (00000901): Erratic Error [U0]

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Felipe Balbi <felipe.balbi@linux/intel.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/dra7.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -1540,6 +1540,7 @@
 				dr_mode = "otg";
 				snps,dis_u3_susphy_quirk;
 				snps,dis_u2_susphy_quirk;
+				snps,dis_metastability_quirk;
 			};
 		};
 


