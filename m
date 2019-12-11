Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC7F11B30E
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388397AbfLKPiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:38:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:48818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388354AbfLKPiY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:38:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF39F222C4;
        Wed, 11 Dec 2019 15:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078704;
        bh=Tx5MCI3Qql+KbrRHjeZLJvrry2OrUVUoaWFEF2fGWfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=btcPxN1CD6764T50K7YNilo1CebHuzT0DqXH6pi8QfezJ4Fqwuy0sVFgK/bj96H34
         a7WD2qe8n+QUaopsxkG/22AnIRGCfRDy+XShGnnTie+gmEX6dGygQgHUSG6uv7eRJk
         qLwWuAfHJqrzDoI+TNLtD2o3CKcNQ+fMW26EmGGc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 10/37] clocksource/drivers/asm9260: Add a check for of_clk_get
Date:   Wed, 11 Dec 2019 10:37:46 -0500
Message-Id: <20191211153813.24126-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211153813.24126-1-sashal@kernel.org>
References: <20191211153813.24126-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 6e001f6a4cc73cd06fc7b8c633bc4906c33dd8ad ]

asm9260_timer_init misses a check for of_clk_get.
Add a check for it and print errors like other clocksource drivers.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20191016124330.22211-1-hslester96@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/asm9260_timer.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clocksource/asm9260_timer.c b/drivers/clocksource/asm9260_timer.c
index 217438d39eb36..38a28240f84fa 100644
--- a/drivers/clocksource/asm9260_timer.c
+++ b/drivers/clocksource/asm9260_timer.c
@@ -196,6 +196,10 @@ static void __init asm9260_timer_init(struct device_node *np)
 		panic("%s: unable to map resource", np->name);
 
 	clk = of_clk_get(np, 0);
+	if (IS_ERR(clk)) {
+		pr_err("Failed to get clk!\n");
+		return PTR_ERR(clk);
+	}
 
 	ret = clk_prepare_enable(clk);
 	if (ret)
-- 
2.20.1

