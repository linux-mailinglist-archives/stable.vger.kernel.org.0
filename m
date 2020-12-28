Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9719B2E37C7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbgL1NAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:00:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:56604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729449AbgL1NAU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:00:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DF0622B4B;
        Mon, 28 Dec 2020 12:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160379;
        bh=UYlMdK4kn5Xt4WnTn7c/gjPUrqb+gsMFX9v8nahJ37I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pPy5pcCgikCRzRYgFGuwOYKKXRDIBEvQ9QiRS8FEII5NRLkEsqpSijILxKuI8fIUz
         WkFHrRanCQHexi0xsAixrYxFsogDH2V+iOfVFNhfNgkNfrzSmwwxRSvLSaKhHNGxlA
         dp8XNYfU5n2tXZtVOxT2lUvqhgI3VsHQkUB7NWyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qinglang Miao <miaoqinglang@huawei.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 032/175] drm/tegra: sor: Disable clocks on error in tegra_sor_init()
Date:   Mon, 28 Dec 2020 13:48:05 +0100
Message-Id: <20201228124854.812080893@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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
index 74d0540b8d4c7..76717d2f51e74 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -2375,17 +2375,23 @@ static int tegra_sor_init(struct host1x_client *client)
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



