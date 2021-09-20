Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A9C412220
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345689AbhITSNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:13:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345178AbhITSKr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:10:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E10063273;
        Mon, 20 Sep 2021 17:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158412;
        bh=K/PGg6kLoihHZ8O6+cHlmGT+jLvgPdnTCFTMk7Bxex0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y2ZYwmgsOJO/y7nfZqft4BQSRelVBhuMy4EshTqqhoKLGjZzdQkilw1LQ5x9nvRHX
         Qf+lA3sAsV8xrdjxbNk+kWPk7Je7S9UDBiinjGLB7naAK/bRSPetl7YiEtmqsPdF6M
         mu1Ix7GCwd34R2w9p+NEvOiiKAm4PuJjilFfQY4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhipeng Wang <zhipeng.wang_1@nxp.com>,
        Li Jun <jun.li@nxp.com>, Peter Chen <peter.chen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 144/260] usb: chipidea: host: fix port index underflow and UBSAN complains
Date:   Mon, 20 Sep 2021 18:42:42 +0200
Message-Id: <20210920163936.011358747@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 48e4a5ca1835..f5f56ee07729 100644
--- a/drivers/usb/chipidea/host.c
+++ b/drivers/usb/chipidea/host.c
@@ -233,18 +233,26 @@ static int ci_ehci_hub_control(
 )
 {
 	struct ehci_hcd	*ehci = hcd_to_ehci(hcd);
+	unsigned int	ports = HCS_N_PORTS(ehci->hcs_params);
 	u32 __iomem	*status_reg;
-	u32		temp;
+	u32		temp, port_index;
 	unsigned long	flags;
 	int		retval = 0;
 	struct device *dev = hcd->self.controller;
 	struct ci_hdrc *ci = dev_get_drvdata(dev);
 
-	status_reg = &ehci->regs->port_status[(wIndex & 0xff) - 1];
+	port_index = wIndex & 0xff;
+	port_index -= (port_index > 0);
+	status_reg = &ehci->regs->port_status[port_index];
 
 	spin_lock_irqsave(&ehci->lock, flags);
 
 	if (typeReq == SetPortFeature && wValue == USB_PORT_FEAT_SUSPEND) {
+		if (!wIndex || wIndex > ports) {
+			retval = -EPIPE;
+			goto done;
+		}
+
 		temp = ehci_readl(ehci, status_reg);
 		if ((temp & PORT_PE) == 0 || (temp & PORT_RESET) != 0) {
 			retval = -EPIPE;
@@ -273,7 +281,7 @@ static int ci_ehci_hub_control(
 			ehci_writel(ehci, temp, status_reg);
 		}
 
-		set_bit((wIndex & 0xff) - 1, &ehci->suspended_ports);
+		set_bit(port_index, &ehci->suspended_ports);
 		goto done;
 	}
 
-- 
2.30.2



