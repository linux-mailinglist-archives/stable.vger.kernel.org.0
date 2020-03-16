Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45A051862DF
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbgCPCdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:33:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729620AbgCPCdq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:33:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA9E4206EB;
        Mon, 16 Mar 2020 02:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326025;
        bh=OOHQbU1RbTHQ1Ma7XU0Q9tWR+VuZggUaN4Rhmo7+W4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gHbwThH2r23n96AgZck5OzJ9LJ4haCPtKkGYeILbmn2e1R2tbHE9HS4F5GWd5ZFXD
         chpZCSy0DuYaHbB8CKv32WiCJTlRJ4uO5iXrTd1NUNJ0F2XV7S8tsZgqMMo65da4LO
         MciwvF9Dwm4R7VnrbbfOH8GFUCbmt2fktevkRAos=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 21/41] drivers/perf: fsl_imx8_ddr: Correct the CLEAR bit definition
Date:   Sun, 15 Mar 2020 22:32:59 -0400
Message-Id: <20200316023319.749-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316023319.749-1-sashal@kernel.org>
References: <20200316023319.749-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

[ Upstream commit 049d919168458ac54e7fad27cd156a958b042d2f ]

When disabling a counter from ddr_perf_event_stop(), the counter value
is reset to 0 at the same time.

Preserve the counter value by performing a read-modify-write of the
PMU register and clearing only the enable bit.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/fsl_imx8_ddr_perf.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/perf/fsl_imx8_ddr_perf.c b/drivers/perf/fsl_imx8_ddr_perf.c
index 95dca2cb52650..90884d14f95fa 100644
--- a/drivers/perf/fsl_imx8_ddr_perf.c
+++ b/drivers/perf/fsl_imx8_ddr_perf.c
@@ -388,9 +388,10 @@ static void ddr_perf_counter_enable(struct ddr_pmu *pmu, int config,
 
 	if (enable) {
 		/*
-		 * must disable first, then enable again
-		 * otherwise, cycle counter will not work
-		 * if previous state is enabled.
+		 * cycle counter is special which should firstly write 0 then
+		 * write 1 into CLEAR bit to clear it. Other counters only
+		 * need write 0 into CLEAR bit and it turns out to be 1 by
+		 * hardware. Below enable flow is harmless for all counters.
 		 */
 		writel(0, pmu->base + reg);
 		val = CNTL_EN | CNTL_CLEAR;
@@ -398,7 +399,8 @@ static void ddr_perf_counter_enable(struct ddr_pmu *pmu, int config,
 		writel(val, pmu->base + reg);
 	} else {
 		/* Disable counter */
-		writel(0, pmu->base + reg);
+		val = readl_relaxed(pmu->base + reg) & CNTL_EN_MASK;
+		writel(val, pmu->base + reg);
 	}
 }
 
-- 
2.20.1

