Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF21224773A
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbgHQPUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729238AbgHQPTx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:19:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4751420786;
        Mon, 17 Aug 2020 15:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677592;
        bh=K1Ma8cAdRm4cq5FiYwAP+gpk459mF5A3ggKalD13s7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i+/pWSf33n4AVvmZYS/pOcAM2bRfOQBLDb36gM5Z7F4hv2vbpL2FNL/Hfcsyal0Hm
         4XwKAGvHIy7+aJfYI4WGD2t6UFX/DldgviQ8hozxe8idAy/LtBfBCzQPz56AwSwOAE
         7zeM7khfhJ6eNrIuahBIoe18tHHUVvwc5p1G7Awk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 020/464] memory: tegra: Fix an error handling path in tegra186_emc_probe()
Date:   Mon, 17 Aug 2020 17:09:33 +0200
Message-Id: <20200817143834.725434432@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit c3d4eb3bf6ad32466555b31094f33a299444f795 ]

The call to tegra_bpmp_get() must be balanced by a call to
tegra_bpmp_put() in case of error, as already done in the remove
function.

Add an error handling path and corresponding goto.

Fixes: 52d15dd23f0b ("memory: tegra: Support DVFS on Tegra186 and later")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/tegra/tegra186-emc.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/memory/tegra/tegra186-emc.c b/drivers/memory/tegra/tegra186-emc.c
index 97f26bc77ad41..c900948881d5b 100644
--- a/drivers/memory/tegra/tegra186-emc.c
+++ b/drivers/memory/tegra/tegra186-emc.c
@@ -185,7 +185,7 @@ static int tegra186_emc_probe(struct platform_device *pdev)
 	if (IS_ERR(emc->clk)) {
 		err = PTR_ERR(emc->clk);
 		dev_err(&pdev->dev, "failed to get EMC clock: %d\n", err);
-		return err;
+		goto put_bpmp;
 	}
 
 	platform_set_drvdata(pdev, emc);
@@ -201,7 +201,7 @@ static int tegra186_emc_probe(struct platform_device *pdev)
 	err = tegra_bpmp_transfer(emc->bpmp, &msg);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to EMC DVFS pairs: %d\n", err);
-		return err;
+		goto put_bpmp;
 	}
 
 	emc->debugfs.min_rate = ULONG_MAX;
@@ -211,8 +211,10 @@ static int tegra186_emc_probe(struct platform_device *pdev)
 
 	emc->dvfs = devm_kmalloc_array(&pdev->dev, emc->num_dvfs,
 				       sizeof(*emc->dvfs), GFP_KERNEL);
-	if (!emc->dvfs)
-		return -ENOMEM;
+	if (!emc->dvfs) {
+		err = -ENOMEM;
+		goto put_bpmp;
+	}
 
 	dev_dbg(&pdev->dev, "%u DVFS pairs:\n", emc->num_dvfs);
 
@@ -237,7 +239,7 @@ static int tegra186_emc_probe(struct platform_device *pdev)
 			"failed to set rate range [%lu-%lu] for %pC\n",
 			emc->debugfs.min_rate, emc->debugfs.max_rate,
 			emc->clk);
-		return err;
+		goto put_bpmp;
 	}
 
 	emc->debugfs.root = debugfs_create_dir("emc", NULL);
@@ -254,6 +256,10 @@ static int tegra186_emc_probe(struct platform_device *pdev)
 			    emc, &tegra186_emc_debug_max_rate_fops);
 
 	return 0;
+
+put_bpmp:
+	tegra_bpmp_put(emc->bpmp);
+	return err;
 }
 
 static int tegra186_emc_remove(struct platform_device *pdev)
-- 
2.25.1



