Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BA52C08DF
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388272AbgKWNCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:02:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:36276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732708AbgKWMwi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:52:38 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACA3820657;
        Mon, 23 Nov 2020 12:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135935;
        bh=d/cqruKDZrsKivw8M0FhCRFYLoXUnSQZecbugpXjBcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BoANENvpRuhWgc0lWq7uXeCUlI17/WVCdpF62AEMSSdG1GJsvS4Zqv3BxB0eRvaCC
         6yLNqr1Rgdb/zNZsr71jhYYzZPFtT6mh0iaVc0ionWVkFdrxeI9x1YDRU1yBwjItQp
         F5OTDLeaNC8vHV+oWqHqMqDEoi5QQ8hP7XsLQubM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>,
        Manish Narani <manish.narani@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.9 242/252] mmc: sdhci-of-arasan: Use Mask writes for Tap delays
Date:   Mon, 23 Nov 2020 13:23:12 +0100
Message-Id: <20201123121847.260370365@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manish Narani <manish.narani@xilinx.com>

commit d338c6d01dc614cad253d6c042501fa0eb242d5c upstream.

Mask the ITAP and OTAP delay bits before updating with the new
tap value for Versal platform.

Fixes: 1a470721c8f5 ("sdhci: arasan: Add support for Versal Tap Delays")
Signed-off-by: Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>
Signed-off-by: Manish Narani <manish.narani@xilinx.com>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1605515565-117562-3-git-send-email-manish.narani@xilinx.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-of-arasan.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -30,7 +30,10 @@
 #define SDHCI_ARASAN_VENDOR_REGISTER	0x78
 
 #define SDHCI_ARASAN_ITAPDLY_REGISTER	0xF0F8
+#define SDHCI_ARASAN_ITAPDLY_SEL_MASK	0xFF
+
 #define SDHCI_ARASAN_OTAPDLY_REGISTER	0xF0FC
+#define SDHCI_ARASAN_OTAPDLY_SEL_MASK	0x3F
 
 #define SDHCI_ARASAN_CQE_BASE_ADDR	0x200
 #define VENDOR_ENHANCED_STROBE		BIT(0)
@@ -755,6 +758,7 @@ static int sdhci_versal_sdcardclk_set_ph
 		regval = sdhci_readl(host, SDHCI_ARASAN_OTAPDLY_REGISTER);
 		regval |= SDHCI_OTAPDLY_ENABLE;
 		sdhci_writel(host, regval, SDHCI_ARASAN_OTAPDLY_REGISTER);
+		regval &= ~SDHCI_ARASAN_OTAPDLY_SEL_MASK;
 		regval |= tap_delay;
 		sdhci_writel(host, regval, SDHCI_ARASAN_OTAPDLY_REGISTER);
 	}
@@ -822,6 +826,7 @@ static int sdhci_versal_sampleclk_set_ph
 		sdhci_writel(host, regval, SDHCI_ARASAN_ITAPDLY_REGISTER);
 		regval |= SDHCI_ITAPDLY_ENABLE;
 		sdhci_writel(host, regval, SDHCI_ARASAN_ITAPDLY_REGISTER);
+		regval &= ~SDHCI_ARASAN_ITAPDLY_SEL_MASK;
 		regval |= tap_delay;
 		sdhci_writel(host, regval, SDHCI_ARASAN_ITAPDLY_REGISTER);
 		regval &= ~SDHCI_ITAPDLY_CHGWIN;


