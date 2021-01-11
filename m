Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920C12F1672
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731078AbhAKNwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:52:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:56216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731090AbhAKNIy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:08:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79A8E2250F;
        Mon, 11 Jan 2021 13:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370493;
        bh=AOcWVqRsTQBPZZ3TihIRdXpFjpy8Z1a82lKrEooybQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CTuKIBcC31L1svHh4ZJCNZJfBFpPyMTiNIZVaz4NcSdFvvaVA0k8X+2bTKFLBOtty
         N+iQEBu92UM6obSFPMSJbggAB9SfPl0x4fOppXPWrhaVp1HP5E+4IFso8SqkbzC1sP
         OLazswe6sUVD2EKmz8A9YPAfMT8BCwF3C+QPV1cQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>
Subject: [PATCH 4.19 46/77] usb: dwc3: ulpi: Use VStsDone to detect PHY regs access completion
Date:   Mon, 11 Jan 2021 14:01:55 +0100
Message-Id: <20210111130038.621197514@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
References: <20210111130036.414620026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

commit ce722da66d3e9384aa2de9d33d584ee154e5e157 upstream.

In accordance with [1] the DWC_usb3 core sets the GUSB2PHYACCn.VStsDone
bit when the PHY vendor control access is done and clears it when the
application initiates a new transaction. The doc doesn't say anything
about the GUSB2PHYACCn.VStsBsy flag serving for the same purpose. Moreover
we've discovered that the VStsBsy flag can be cleared before the VStsDone
bit. So using the former as a signal of the PHY control registers
completion might be dangerous. Let's have the VStsDone flag utilized
instead then.

[1] Synopsys DesignWare Cores SuperSpeed USB 3.0 xHCI Host Controller
    Databook, 2.70a, December 2013, p.388

Fixes: 88bc9d194ff6 ("usb: dwc3: add ULPI interface support")
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Link: https://lore.kernel.org/r/20201210085008.13264-2-Sergey.Semin@baikalelectronics.ru
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/core.h |    1 +
 drivers/usb/dwc3/ulpi.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -272,6 +272,7 @@
 
 /* Global USB2 PHY Vendor Control Register */
 #define DWC3_GUSB2PHYACC_NEWREGREQ	BIT(25)
+#define DWC3_GUSB2PHYACC_DONE		BIT(24)
 #define DWC3_GUSB2PHYACC_BUSY		BIT(23)
 #define DWC3_GUSB2PHYACC_WRITE		BIT(22)
 #define DWC3_GUSB2PHYACC_ADDR(n)	(n << 16)
--- a/drivers/usb/dwc3/ulpi.c
+++ b/drivers/usb/dwc3/ulpi.c
@@ -24,7 +24,7 @@ static int dwc3_ulpi_busyloop(struct dwc
 
 	while (count--) {
 		reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYACC(0));
-		if (!(reg & DWC3_GUSB2PHYACC_BUSY))
+		if (reg & DWC3_GUSB2PHYACC_DONE)
 			return 0;
 		cpu_relax();
 	}


