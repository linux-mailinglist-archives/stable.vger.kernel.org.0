Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702FB37D2BD
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350905AbhELSKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352892AbhELSE1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:04:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F3256142D;
        Wed, 12 May 2021 18:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842598;
        bh=OnVCr+m0wmDeu1RhxUiLx+50TxRwvDXIHStP5MLTU7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFfZKn4cjF8ooegTnJKvsszq/nzLXkh6yqBPmAuzor+BtxjOSiugxYvN8rREu297h
         mx22gYa2ftjTnybHuzC9RrWBfogMXdfXn0k6/6JMj/uclgz3PYRJt8dgZOMudSmEFf
         wJn5SLM0n7TyMhcEOK9NK1sZp10puZ+UpRuTmFtAsi46kG2M+e9NYjw2qZOrq5PgVj
         jmUSAxu3jOaLKIDULbrQwBlyt86g0FCnuD8nNTlVzBegIZ8xd3fW0t2oEFwNt8cTF3
         KD/FCxpdmF3HAf4MPITVhmumxbU1+4T1eN1IYprHdmNoXQUJcehcZRypB1jb6cPp0I
         cEghwGHtPG2TQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/34] PCI: tegra: Fix runtime PM imbalance in pex_ep_event_pex_rst_deassert()
Date:   Wed, 12 May 2021 14:02:38 -0400
Message-Id: <20210512180306.664925-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180306.664925-1-sashal@kernel.org>
References: <20210512180306.664925-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 5859c926d1f052ee61b5815b14658875c14f6243 ]

pm_runtime_get_sync() will increase the runtime PM counter
even it returns an error. Thus a pairing decrement is needed
to prevent refcount leak. Fix this by replacing this API with
pm_runtime_resume_and_get(), which will not change the runtime
PM counter on error.

Link: https://lore.kernel.org/r/20210408072700.15791-1-dinghao.liu@zju.edu.cn
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index f920e7efe118..d788f4d7f9aa 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1660,7 +1660,7 @@ static void pex_ep_event_pex_rst_deassert(struct tegra_pcie_dw *pcie)
 	if (pcie->ep_state == EP_STATE_ENABLED)
 		return;
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0) {
 		dev_err(dev, "Failed to get runtime sync for PCIe dev: %d\n",
 			ret);
-- 
2.30.2

