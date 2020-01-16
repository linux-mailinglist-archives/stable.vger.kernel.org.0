Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04DCD13F440
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389733AbgAPRJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:09:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389727AbgAPRJm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:09:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D1AC2467A;
        Thu, 16 Jan 2020 17:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194581;
        bh=3qKvzdVHJtKqiD1XDd9gYxY9M0XMt+MlxqxmSCoyTpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHqt7rdtE7dT0wv7cZjb1PbIQ4Z2p7gs/94lIugZSFOkuzMj8Zw7LFlgUZLE7Hc1b
         DPX4v2KPjCm0liOyVot9DC90N5QicHFj090zXiZn53PbC7urfHXhk8j8dccsJ+f88R
         qVDNJubWC4xkJ8Tdc4eGZrja9XTRyIW2Z/UaH56A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Minghuan Lian <Minghuan.Lian@nxp.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 455/671] PCI: mobiveil: Fix devfn check in mobiveil_pcie_valid_device()
Date:   Thu, 16 Jan 2020 12:01:33 -0500
Message-Id: <20200116170509.12787-192-sashal@kernel.org>
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

From: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>

[ Upstream commit cbd50b3ca3964c79dac65fda277637577e029e8c ]

Current check for devfn number in mobiveil_pci_valid_device() is
wrong in that it flags as invalid functions present in PCI device 0
in the root bus while it is perfectly valid to access all functions
in PCI device 0 in the root bus.

Update the check in mobiveil_pci_valid_device() to fix the issue.

Fixes: 9af6bcb11e12 ("PCI: mobiveil: Add Mobiveil PCIe Host Bridge IP driver")
Signed-off-by: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Minghuan Lian <Minghuan.Lian@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mobiveil.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-mobiveil.c b/drivers/pci/controller/pcie-mobiveil.c
index dc228eb500ed..476be4f3c7f6 100644
--- a/drivers/pci/controller/pcie-mobiveil.c
+++ b/drivers/pci/controller/pcie-mobiveil.c
@@ -174,7 +174,7 @@ static bool mobiveil_pcie_valid_device(struct pci_bus *bus, unsigned int devfn)
 	 * Do not read more than one device on the bus directly
 	 * attached to RC
 	 */
-	if ((bus->primary == pcie->root_bus_nr) && (devfn > 0))
+	if ((bus->primary == pcie->root_bus_nr) && (PCI_SLOT(devfn) > 0))
 		return false;
 
 	return true;
-- 
2.20.1

