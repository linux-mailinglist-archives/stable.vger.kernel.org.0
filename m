Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22273BCF06
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234540AbhGFL1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:27:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234959AbhGFLZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:25:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9175C61D3F;
        Tue,  6 Jul 2021 11:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570359;
        bh=dU+sE3O5fFtWgS0WL4SVp5dHsvS6LMM2bVi73Rk4nhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sIHi3NvtdnOW1hPQduvESRzgP/QmjDqdDCW9oigltlDwu4AUIcnob/AdlDbLwzjeK
         VFKidD4dImDYznrRC6o20T6iTI9dyGdBCLAywHwmQ9aStOIvLJhhywZs4nq4qb0x/F
         ES3JcWaglWkcXJKYjdCRFxB/FoiGfd34x8ME4dYM/ntB5i1u8pVkyEtcY/St0E3Fu+
         wS2nMvGSYou5uW5dLqVvxu5+fygglEd0hlmsTbrjPk2mfCU5D9+gmA3GMjyjcPM8Fh
         f4DnlD48hzgS9/nQOAEkLNU1F0hS44sXeCcvJfs48uyhxjOeUSMliFSEgaFdXG5c7J
         3s51T4g8/KCGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 039/160] drm/bridge: cdns: Fix PM reference leak in cdns_dsi_transfer()
Date:   Tue,  6 Jul 2021 07:16:25 -0400
Message-Id: <20210706111827.2060499-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 33f90f27e1c5ccd648d3e78a1c28be9ee8791cf1 ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/1621840862-106024-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/cdns-dsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/cdns-dsi.c b/drivers/gpu/drm/bridge/cdns-dsi.c
index 76373e31df92..b31281f76117 100644
--- a/drivers/gpu/drm/bridge/cdns-dsi.c
+++ b/drivers/gpu/drm/bridge/cdns-dsi.c
@@ -1028,7 +1028,7 @@ static ssize_t cdns_dsi_transfer(struct mipi_dsi_host *host,
 	struct mipi_dsi_packet packet;
 	int ret, i, tx_len, rx_len;
 
-	ret = pm_runtime_get_sync(host->dev);
+	ret = pm_runtime_resume_and_get(host->dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2

