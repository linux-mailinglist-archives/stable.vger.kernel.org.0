Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90AE03CE3A7
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346455AbhGSPit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:38:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348883AbhGSPfe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76F38611EF;
        Mon, 19 Jul 2021 16:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711306;
        bh=YhXSwoh8bMN8/Mbo0txirRqP3/npuOXCLagUFhi2wV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eKjfAIUwxHSRRLY+vOmGO7w7O0JbYVBkHqkJIPWRYVJTCAL9ky6+IfWEGym/8cGE8
         MjWFJu9rkNxWkEASnjNo4vQcqMDlAXHEOd8znfCYGpMBGheiJsDY6I7T5izaP/6e+I
         GogPPzszfKacSbjepi1J95npWzur/AvDOLKSCZWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 303/351] firmware: tegra: Fix error return code in tegra210_bpmp_init()
Date:   Mon, 19 Jul 2021 16:54:09 +0200
Message-Id: <20210719144955.077091721@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 7fea67710e9f6a111a2c9440576f2396ccd92d57 ]

When call irq_get_irq_data() to get the IRQ's irq_data failed, an
appropriate error code -ENOENT should be returned. However, we directly
return 'err', which records the IRQ number instead of the error code.

Fixes: 139251fc2208 ("firmware: tegra: add bpmp driver for Tegra210")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/tegra/bpmp-tegra210.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/tegra/bpmp-tegra210.c b/drivers/firmware/tegra/bpmp-tegra210.c
index ae15940a078e..c32754055c60 100644
--- a/drivers/firmware/tegra/bpmp-tegra210.c
+++ b/drivers/firmware/tegra/bpmp-tegra210.c
@@ -210,7 +210,7 @@ static int tegra210_bpmp_init(struct tegra_bpmp *bpmp)
 	priv->tx_irq_data = irq_get_irq_data(err);
 	if (!priv->tx_irq_data) {
 		dev_err(&pdev->dev, "failed to get IRQ data for TX IRQ\n");
-		return err;
+		return -ENOENT;
 	}
 
 	err = platform_get_irq_byname(pdev, "rx");
-- 
2.30.2



