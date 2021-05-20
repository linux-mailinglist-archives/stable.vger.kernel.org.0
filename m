Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F38938A155
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhETJaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:30:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231912AbhETJ2U (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:28:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAEBB6101E;
        Thu, 20 May 2021 09:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502806;
        bh=OnVCr+m0wmDeu1RhxUiLx+50TxRwvDXIHStP5MLTU7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OwDZL+c+QMPbuNBeuIyA8j1QthziSDQByM72Mi8saYRyBX/xC65z0wdEu+fd0WJ4y
         iKUFe0OJr6WiaOgiiQcNTt8L9EKZ5VpJeC3D2N/IJjOocnqOhZ6HwlOK9P3eWUt2S3
         Gd1zXE29OwwORDZ4W3RHD40BMqiU28KEMMbu+E5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 14/47] PCI: tegra: Fix runtime PM imbalance in pex_ep_event_pex_rst_deassert()
Date:   Thu, 20 May 2021 11:22:12 +0200
Message-Id: <20210520092054.013591562@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.559923764@linuxfoundation.org>
References: <20210520092053.559923764@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



