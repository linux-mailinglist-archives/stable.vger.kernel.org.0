Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC1D404FAA
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349442AbhIIMWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:22:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350791AbhIIMSK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:18:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B73C861A85;
        Thu,  9 Sep 2021 11:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188202;
        bh=EFk7taVLDDEyryR2UN+6vNU2VWI9oVuX3ynm0n8vEZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TVCM6mWZYYpe3FENrK9aNtTqIUH+OPB3wq1ODpBGaUgl0DufbdDtzCDZPWBt9g+xq
         mEmSF2OU17ZoCKgceVl6tQqC4JKoA9ZWoQGzIECyE1wVWJo0lxFu5eBlWlRg1KG6gM
         6XDVmJlf40wwjULnNY6DN4OOv44uQhG4CZoF03HnptKMSQcEl2dHCxsjPhJOLIc2D1
         IFHaE/o62ascCzV7UAnocyW5X3vIqKfYD3DA+rmn1ftk1zsO1TTPufrowFnO0lhfVF
         /qELvXpY/dhUykANO9K7xWu0rccddNXtgQdMsumVeYbfz7ZAFuYAYFbZSB8ePYTmng
         m2yj2ZBED0oyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Jun <jun.li@nxp.com>, Zhipeng Wang <zhipeng.wang_1@nxp.com>,
        Peter Chen <peter.chen@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 160/219] usb: chipidea: host: fix port index underflow and UBSAN complains
Date:   Thu,  9 Sep 2021 07:45:36 -0400
Message-Id: <20210909114635.143983-160-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Jun <jun.li@nxp.com>

[ Upstream commit e5d6a7c6cfae9e714a0e8ff64facd1ac68a784c6 ]

If wIndex is 0 (and it often is), these calculations underflow and
UBSAN complains, here resolve this by not decrementing the index when
it is equal to 0, this copies the solution from commit 85e3990bea49
("USB: EHCI: avoid undefined pointer arithmetic and placate UBSAN")

Reported-by: Zhipeng Wang <zhipeng.wang_1@nxp.com>
Signed-off-by: Li Jun <jun.li@nxp.com>
Link: https://lore.kernel.org/r/1624004938-2399-1-git-send-email-jun.li@nxp.com
Signed-off-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/host.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
index e86d13c04bdb..bdc3885c0d49 100644
--- a/drivers/usb/chipidea/host.c
+++ b/drivers/usb/chipidea/host.c
@@ -240,15 +240,18 @@ static int ci_ehci_hub_control(
 )
 {
 	struct ehci_hcd	*ehci = hcd_to_ehci(hcd);
+	unsigned int	ports = HCS_N_PORTS(ehci->hcs_params);
 	u32 __iomem	*status_reg;
-	u32		temp;
+	u32		temp, port_index;
 	unsigned long	flags;
 	int		retval = 0;
 	bool		done = false;
 	struct device *dev = hcd->self.controller;
 	struct ci_hdrc *ci = dev_get_drvdata(dev);
 
-	status_reg = &ehci->regs->port_status[(wIndex & 0xff) - 1];
+	port_index = wIndex & 0xff;
+	port_index -= (port_index > 0);
+	status_reg = &ehci->regs->port_status[port_index];
 
 	spin_lock_irqsave(&ehci->lock, flags);
 
@@ -260,6 +263,11 @@ static int ci_ehci_hub_control(
 	}
 
 	if (typeReq == SetPortFeature && wValue == USB_PORT_FEAT_SUSPEND) {
+		if (!wIndex || wIndex > ports) {
+			retval = -EPIPE;
+			goto done;
+		}
+
 		temp = ehci_readl(ehci, status_reg);
 		if ((temp & PORT_PE) == 0 || (temp & PORT_RESET) != 0) {
 			retval = -EPIPE;
@@ -288,7 +296,7 @@ static int ci_ehci_hub_control(
 			ehci_writel(ehci, temp, status_reg);
 		}
 
-		set_bit((wIndex & 0xff) - 1, &ehci->suspended_ports);
+		set_bit(port_index, &ehci->suspended_ports);
 		goto done;
 	}
 
-- 
2.30.2

