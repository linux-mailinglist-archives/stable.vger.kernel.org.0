Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D70EF13E6CC
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390784AbgAPRNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:13:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:59038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390779AbgAPRNh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:13:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91741246AB;
        Thu, 16 Jan 2020 17:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194816;
        bh=pWEElET2TJj1Rs3U7xsrYRFMhcDQkuh7Oq+mAcenkEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gml7VjfNl3j+VGixfyVzgC9jeEUJtBJjncFoIJYGhkTcUdnWQCbeYWlAv0nIypTTk
         PHfvCzSM72O+VnE/1NBz3gjv5imhF/XlpfIabVbpA8YNEIm0rkxInE0DyEL/oHrGgF
         1hW3G6KSCv6wD5w45Iod851fcQoRLpe/Ax9QlZ5c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niklas Cassel <niklas.cassel@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Gustavo Pimentel <gustavo.pimentel@synopsys.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 622/671] PCI: dwc: Fix find_next_bit() usage
Date:   Thu, 16 Jan 2020 12:04:20 -0500
Message-Id: <20200116170509.12787-359-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@linaro.org>

[ Upstream commit 1137e61dcb99f7f8b54e77ed83f68b5b485a3e34 ]

find_next_bit() takes a parameter of size long, and performs arithmetic
that assumes that the argument is of size long.

Therefore we cannot pass a u32, since this will cause find_next_bit()
to read outside the stack buffer and will produce the following print:
BUG: KASAN: stack-out-of-bounds in find_next_bit+0x38/0xb0

Fixes: 1b497e6493c4 ("PCI: dwc: Fix uninitialized variable in dw_handle_msi_irq()")
Tested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Andrew Murray <andrew.murray@arm.com>
Acked-by: Gustavo Pimentel <gustavo.pimentel@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-host.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index b57ee79f6d69..6d4ef0101ef6 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -78,7 +78,8 @@ static struct msi_domain_info dw_pcie_msi_domain_info = {
 irqreturn_t dw_handle_msi_irq(struct pcie_port *pp)
 {
 	int i, pos, irq;
-	u32 val, num_ctrls;
+	unsigned long val;
+	u32 status, num_ctrls;
 	irqreturn_t ret = IRQ_NONE;
 
 	num_ctrls = pp->num_vectors / MAX_MSI_IRQS_PER_CTRL;
@@ -86,14 +87,14 @@ irqreturn_t dw_handle_msi_irq(struct pcie_port *pp)
 	for (i = 0; i < num_ctrls; i++) {
 		dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_STATUS +
 					(i * MSI_REG_CTRL_BLOCK_SIZE),
-				    4, &val);
-		if (!val)
+				    4, &status);
+		if (!status)
 			continue;
 
 		ret = IRQ_HANDLED;
+		val = status;
 		pos = 0;
-		while ((pos = find_next_bit((unsigned long *) &val,
-					    MAX_MSI_IRQS_PER_CTRL,
+		while ((pos = find_next_bit(&val, MAX_MSI_IRQS_PER_CTRL,
 					    pos)) != MAX_MSI_IRQS_PER_CTRL) {
 			irq = irq_find_mapping(pp->irq_domain,
 					       (i * MAX_MSI_IRQS_PER_CTRL) +
-- 
2.20.1

