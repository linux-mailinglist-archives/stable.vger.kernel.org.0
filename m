Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1998D4061AD
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240968AbhIJAnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:43:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232657AbhIJATD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:19:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD15861186;
        Fri, 10 Sep 2021 00:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233068;
        bh=7Wc3Q4Vf/QiCCyd/0l4lfoGgAJzafC/sVQpLEuQlXTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xi/jn7GZ5PY92um7CkL66g29+mdDp8wIBzcwlsjoG993pMwTW1sgjMQdLfXIGkjmP
         97QTOuIFVNPhLEBtI2M3OzNNw7l6y+WrRinVaz/RAd2s9JX2ce66PhZX32ctaYTLOJ
         0uncBXglWVGEZAu2DbhQeR8pJ5IWjOZSKxVCN78lm5//isu/PLzLJ3Lw2XZvIew+//
         pcA49ubzVyCRed+zjvC1wVbUbX7LxUcaiSgGI2yTgC/gCgklbMbBFJrlNkHg7aqjCs
         6dnq76/3LW3WRBYsKoVgRJ4ulO60lFBTG+y25wLRzpcv/CxK6IyoekAigdyC1HbCwA
         9f5zQ9TnE3H/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 79/99] clk: zynqmp: Fix a memory leak
Date:   Thu,  9 Sep 2021 20:15:38 -0400
Message-Id: <20210910001558.173296-79-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>

[ Upstream commit e7296d16ef7be11a6001be9bd89906ef55ab2405 ]

Fix a memory leak of mux.

Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Link: https://lore.kernel.org/r/20210818065929.12835-3-shubhrajyoti.datta@xilinx.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/zynqmp/clk-mux-zynqmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/zynqmp/clk-mux-zynqmp.c b/drivers/clk/zynqmp/clk-mux-zynqmp.c
index 157d4a960bf4..17afce594f28 100644
--- a/drivers/clk/zynqmp/clk-mux-zynqmp.c
+++ b/drivers/clk/zynqmp/clk-mux-zynqmp.c
@@ -159,7 +159,7 @@ struct clk_hw *zynqmp_clk_register_mux(const char *name, u32 clk_id,
 	hw = &mux->hw;
 	ret = clk_hw_register(NULL, hw);
 	if (ret) {
-		kfree(hw);
+		kfree(mux);
 		hw = ERR_PTR(ret);
 	}
 
-- 
2.30.2

