Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263612E640C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404995AbgL1Pqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:46:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391995AbgL1Nod (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:44:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8B802064B;
        Mon, 28 Dec 2020 13:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163032;
        bh=jIIYkHliLspoegH2ahI27zAHrjfaMFVrripQCiepCTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xrFDaRv80huun5s8RISfTeeMILkQPhJ8HubfcrQq/k/KzfUVONmoylIFWXsPAFwPP
         hhqZ90aTAn+535jZjavFL3fkTpgsGkbEyIbSZhJkpoCt2GDSaX3qdd0eHxPrW+fha1
         z/+zcLpWo822+AySUHjtC/FudplwC7l7gVOeghAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 146/453] spi: mxs: fix reference leak in mxs_spi_probe
Date:   Mon, 28 Dec 2020 13:46:22 +0100
Message-Id: <20201228124944.227823071@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 03fc41afaa6549baa2dab7a84e1afaf5cadb5b18 ]

pm_runtime_get_sync will increment pm usage counter even it
failed. Forgetting to pm_runtime_put_noidle will result in
reference leak in mxs_spi_probe, so we should fix it.

Fixes: b7969caf41a1d ("spi: mxs: implement runtime pm")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201106012421.95420-1-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mxs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-mxs.c b/drivers/spi/spi-mxs.c
index 996c1c8a9c719..34856c9ad931a 100644
--- a/drivers/spi/spi-mxs.c
+++ b/drivers/spi/spi-mxs.c
@@ -608,6 +608,7 @@ static int mxs_spi_probe(struct platform_device *pdev)
 
 	ret = pm_runtime_get_sync(ssp->dev);
 	if (ret < 0) {
+		pm_runtime_put_noidle(ssp->dev);
 		dev_err(ssp->dev, "runtime_get_sync failed\n");
 		goto out_pm_runtime_disable;
 	}
-- 
2.27.0



