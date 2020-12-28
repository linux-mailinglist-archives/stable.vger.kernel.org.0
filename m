Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5752E3CEC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438731AbgL1OIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:08:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438717AbgL1OIv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:08:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C85D0206D4;
        Mon, 28 Dec 2020 14:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164490;
        bh=jAOjQE2Thmvh0+P9hIbZqSU8IQfXLj4L9XRYNK+rX0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ljJAKO9+FOWKbt+IO7Hyat+HgCHXH9E7nHPDPO4TH6TgPxvTJleDf320WlxC0vbLG
         KWl3yGeMbosIFQD8yrcztg3lIh63p7K2duvnLxv+vQxs9BtDn5ygovPvPI0CYN2ThI
         3P53uKDOY3/YfRcKS84l6mfMnxfIckVK72dfw0kI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 198/717] qtnfmac: fix error return code in qtnf_pcie_probe()
Date:   Mon, 28 Dec 2020 13:43:16 +0100
Message-Id: <20201228125030.460189932@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 31e07aa33fa7cdc93fa91c3f78f031e8d38862c2 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: b7da53cd6cd1 ("qtnfmac_pcie: use single PCIe driver for all platforms")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201114123347.29632-1-wanghai38@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
index 5337e67092ca6..0f328ce47fee3 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
@@ -299,19 +299,19 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	sysctl_bar = qtnf_map_bar(pdev, QTN_SYSCTL_BAR);
 	if (IS_ERR(sysctl_bar)) {
 		pr_err("failed to map BAR%u\n", QTN_SYSCTL_BAR);
-		return ret;
+		return PTR_ERR(sysctl_bar);
 	}
 
 	dmareg_bar = qtnf_map_bar(pdev, QTN_DMA_BAR);
 	if (IS_ERR(dmareg_bar)) {
 		pr_err("failed to map BAR%u\n", QTN_DMA_BAR);
-		return ret;
+		return PTR_ERR(dmareg_bar);
 	}
 
 	epmem_bar = qtnf_map_bar(pdev, QTN_SHMEM_BAR);
 	if (IS_ERR(epmem_bar)) {
 		pr_err("failed to map BAR%u\n", QTN_SHMEM_BAR);
-		return ret;
+		return PTR_ERR(epmem_bar);
 	}
 
 	chipid = qtnf_chip_id_get(sysctl_bar);
-- 
2.27.0



