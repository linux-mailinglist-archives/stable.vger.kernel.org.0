Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5249C4062F7
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbhIJAqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:46:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234081AbhIJAWk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:22:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3B9B610E9;
        Fri, 10 Sep 2021 00:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233290;
        bh=GqfxCRn+EqCHU/WfjFhL1kK8yG6xvyHgBKiAiq6smuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aB4TMjcAZJycmWMV8r64F5Pev7AKruAYNq2DwwckSKsqTGyhkYLEDPpbyG3ue6fZi
         TLc7ZML8kCRV8UJiv4UOBgUiospf2uQ8+XePFJxgiQT1GyMmIH5PvVfsSHS+06NJCn
         rzEtKsq1K/PKGAy48ifbVUZQZxGXnZqyZjcYkRVD1SmDXwj4i3aJOhW0AS3s5nkpPG
         UTb/et/ITk0Psyy7C8j8DsSaQSmwT3/6/2MPAKg+4J6BMVTXiL3PBINuvoU7oaSSUA
         vzsVxPz0VAysJOsIhC9vP3mBwKAufGKtaWNDsYNw/ZgfcoodJMad06GoCGlQ7SUDED
         aKDvKWEMyVBQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 45/53] clk: zynqmp: Fix a memory leak
Date:   Thu,  9 Sep 2021 20:20:20 -0400
Message-Id: <20210910002028.175174-45-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002028.175174-1-sashal@kernel.org>
References: <20210910002028.175174-1-sashal@kernel.org>
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
index 06194149be83..d3b88384b2ff 100644
--- a/drivers/clk/zynqmp/clk-mux-zynqmp.c
+++ b/drivers/clk/zynqmp/clk-mux-zynqmp.c
@@ -130,7 +130,7 @@ struct clk_hw *zynqmp_clk_register_mux(const char *name, u32 clk_id,
 	hw = &mux->hw;
 	ret = clk_hw_register(NULL, hw);
 	if (ret) {
-		kfree(hw);
+		kfree(mux);
 		hw = ERR_PTR(ret);
 	}
 
-- 
2.30.2

