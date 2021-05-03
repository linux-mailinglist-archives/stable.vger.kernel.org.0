Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E627371CF4
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbhECQ5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:57:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234838AbhECQzD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:55:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43B1661428;
        Mon,  3 May 2021 16:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060153;
        bh=ORvfsTPWidhMijguO6X2vUt3yYaF9/7ZZj8+OK9Lx3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FFKGRWrpdCO7FcfVPp1eIp8EQI8SdHbtsNx+oOVpFPBAn1dMQdZ1fEKU14uqJqnnA
         JtuwvLqrHiOlaxEsmPX2tOQqVYi7pabTqrNhxCCV8EYNRcJg68mOOw9PCA4A1QCENc
         r/pCkoEnuO6IHI6Bfkpy6TGTzKCyU3NmVEfuWDLHJ90qJlyfCexqtVei35nobuq2PS
         73aN675tTqb/lzssQd6N0CxZ32lAweBaSusitg+SCLHMQ9omg21Q87sVJs0qLjeuXU
         8d1kgeQQN7k7K5QunYHJROJiQ8GleIdLoomk5s5cHfz5+owAz9YrI1x1Kemk7d73oG
         QjvMI6+nyKt3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 19/31] clk: socfpga: arria10: Fix memory leak of socfpga_clk on error return
Date:   Mon,  3 May 2021 12:41:52 -0400
Message-Id: <20210503164204.2854178-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164204.2854178-1-sashal@kernel.org>
References: <20210503164204.2854178-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 657d4d1934f75a2d978c3cf2086495eaa542e7a9 ]

There is an error return path that is not kfree'ing socfpga_clk leading
to a memory leak. Fix this by adding in the missing kfree call.

Addresses-Coverity: ("Resource leak")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20210406170115.430990-1-colin.king@canonical.com
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/socfpga/clk-gate-a10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/socfpga/clk-gate-a10.c b/drivers/clk/socfpga/clk-gate-a10.c
index 36376c542055..637e26babf89 100644
--- a/drivers/clk/socfpga/clk-gate-a10.c
+++ b/drivers/clk/socfpga/clk-gate-a10.c
@@ -157,6 +157,7 @@ static void __init __socfpga_gate_init(struct device_node *node,
 		if (IS_ERR(socfpga_clk->sys_mgr_base_addr)) {
 			pr_err("%s: failed to find altr,sys-mgr regmap!\n",
 					__func__);
+			kfree(socfpga_clk);
 			return;
 		}
 	}
-- 
2.30.2

