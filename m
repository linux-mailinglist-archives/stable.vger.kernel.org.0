Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6D229AFD4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756403AbgJ0ONC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:13:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756394AbgJ0ONC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:13:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B97302076A;
        Tue, 27 Oct 2020 14:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807981;
        bh=044yO2KzVY6Dp++J6DBnKQi8nbBZOUn+IFx2Q5OAxR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MBFHp1hvBRM1jVDhHaSYWqDLYsqB3FXj0gxGFdJ2Huuzb1by7Rfze/UpYpAS6uxiu
         6CyTPbskA/jgZwkwOjDT0RfzRTM3x4mvw/OEiZ5g4Oa1giGo5sWyXhkDolRm99Bj33
         9oN14SLX9QALVSAnFE8KwMDxdqWozpgP53oQHQ3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ray Jui <ray.jui@broadcom.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 113/191] PCI: iproc: Set affinity mask on MSI interrupts
Date:   Tue, 27 Oct 2020 14:49:28 +0100
Message-Id: <20201027134915.146089700@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

[ Upstream commit eb7eacaa5b9e4f665bd08d416c8f88e63d2f123c ]

The core interrupt code expects the irq_set_affinity call to update the
effective affinity for the interrupt. This was not being done, so update
iproc_msi_irq_set_affinity() to do so.

Link: https://lore.kernel.org/r/20200803035241.7737-1-mark.tomlinson@alliedtelesis.co.nz
Fixes: 3bc2b2348835 ("PCI: iproc: Add iProc PCIe MSI support")
Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Ray Jui <ray.jui@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/host/pcie-iproc-msi.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/host/pcie-iproc-msi.c b/drivers/pci/host/pcie-iproc-msi.c
index 2d0f535a2f69a..7e6f7b8504d2f 100644
--- a/drivers/pci/host/pcie-iproc-msi.c
+++ b/drivers/pci/host/pcie-iproc-msi.c
@@ -217,15 +217,20 @@ static int iproc_msi_irq_set_affinity(struct irq_data *data,
 	struct iproc_msi *msi = irq_data_get_irq_chip_data(data);
 	int target_cpu = cpumask_first(mask);
 	int curr_cpu;
+	int ret;
 
 	curr_cpu = hwirq_to_cpu(msi, data->hwirq);
 	if (curr_cpu == target_cpu)
-		return IRQ_SET_MASK_OK_DONE;
+		ret = IRQ_SET_MASK_OK_DONE;
+	else {
+		/* steer MSI to the target CPU */
+		data->hwirq = hwirq_to_canonical_hwirq(msi, data->hwirq) + target_cpu;
+		ret = IRQ_SET_MASK_OK;
+	}
 
-	/* steer MSI to the target CPU */
-	data->hwirq = hwirq_to_canonical_hwirq(msi, data->hwirq) + target_cpu;
+	irq_data_update_effective_affinity(data, cpumask_of(target_cpu));
 
-	return IRQ_SET_MASK_OK;
+	return ret;
 }
 
 static void iproc_msi_irq_compose_msi_msg(struct irq_data *data,
-- 
2.25.1



