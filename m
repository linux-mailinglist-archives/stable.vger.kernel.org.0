Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB6E2E3967
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388468AbgL1NXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:23:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:51666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388463AbgL1NXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:23:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C587822B3A;
        Mon, 28 Dec 2020 13:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161755;
        bh=8eqCS1fATQKmxKzkQpZAO4+h0NCwVw0ZGv2G/2XWjkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJKBcxHe65QYxwV/nrrbIwT40fQfC4g3PzxQPh8X05vHFXGEKezxBr/Scd5stZZrP
         0pUYd5EmrjicUYVqD8y1ukwtiCHgz/Kc3FJeMS983aMQziWQlF1ZVV5Po7sEJFhicB
         jL9Mgd/+HFH+k6VzU7J2FoIyVHWUTLIFX45/NNZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qinglang Miao <miaoqinglang@huawei.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 071/346] drm/tegra: sor: Disable clocks on error in tegra_sor_init()
Date:   Mon, 28 Dec 2020 13:46:30 +0100
Message-Id: <20201228124923.227970399@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit bf3a3cdcad40e5928a22ea0fd200d17fd6d6308d ]

Fix the missing clk_disable_unprepare() before return from
tegra_sor_init() in the error handling case.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/sor.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index 89cb70da2bfe6..83108e2430501 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -2668,17 +2668,23 @@ static int tegra_sor_init(struct host1x_client *client)
 		if (err < 0) {
 			dev_err(sor->dev, "failed to deassert SOR reset: %d\n",
 				err);
+			clk_disable_unprepare(sor->clk);
 			return err;
 		}
 	}
 
 	err = clk_prepare_enable(sor->clk_safe);
-	if (err < 0)
+	if (err < 0) {
+		clk_disable_unprepare(sor->clk);
 		return err;
+	}
 
 	err = clk_prepare_enable(sor->clk_dp);
-	if (err < 0)
+	if (err < 0) {
+		clk_disable_unprepare(sor->clk_safe);
+		clk_disable_unprepare(sor->clk);
 		return err;
+	}
 
 	return 0;
 }
-- 
2.27.0



