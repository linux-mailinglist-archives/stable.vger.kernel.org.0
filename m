Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3CA40625C
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241683AbhIJApZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232135AbhIJAVL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:21:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74F256023D;
        Fri, 10 Sep 2021 00:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233201;
        bh=DAsXn2Zx4m38ogIFJGUmBAwJ438dX4Jn+iPAr8I2QxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kTHMK/lsgkFQ93kf1KrNtsLDzV4iuvgpscCa6MHB5JeTc/J3ZRqlAzxXetWhAI4cq
         BQIjMrfDh4P14f/z96Q6e8duZxV7AW5sXAvU7Ze7tlGMDmizrmQby72iVQz3YIwWin
         9ute2akwgDX1tmiUhfzfO26h4OFuUxfdpeHmmO+1XcubYeHMA7J4m6o8yOT4n8yTGl
         F43JCnVglfJlRm6154fLiVSjP0Oj6aM/kRAs+Uvecj4tLnVsho/DVc6O7bo+b7gIuO
         mOo2hhMraNN+HykkVAlyCP3MA/kAm30qmElTUHLol2R0pchK2cxkIp4v1z0IYGGQeY
         HTQi6nxQeOYWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 71/88] clk: zynqmp: Fix a memory leak
Date:   Thu,  9 Sep 2021 20:18:03 -0400
Message-Id: <20210910001820.174272-71-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
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
index d576c900dee0..be5149fac970 100644
--- a/drivers/clk/zynqmp/clk-mux-zynqmp.c
+++ b/drivers/clk/zynqmp/clk-mux-zynqmp.c
@@ -136,7 +136,7 @@ struct clk_hw *zynqmp_clk_register_mux(const char *name, u32 clk_id,
 	hw = &mux->hw;
 	ret = clk_hw_register(NULL, hw);
 	if (ret) {
-		kfree(hw);
+		kfree(mux);
 		hw = ERR_PTR(ret);
 	}
 
-- 
2.30.2

