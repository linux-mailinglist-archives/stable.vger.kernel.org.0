Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC044371D4A
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 19:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbhECQ6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:58:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235370AbhECQ4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:56:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92F4F613C6;
        Mon,  3 May 2021 16:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060220;
        bh=zkpyHWDMow+yanN2rf0LhKYSxQoSglRoOdF3EPPw7a0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E87OrCx4exdjzQsbR8wV6r8rb18dNVleO2Qb5kglkAzNgge8MrNR02RwSJgsdEmZt
         KWXY4RVhRhKZAQohYgGN0MA6q0Mafyy9jFGHqi0yMbyLeLHt7h7OtNfA8+OsE+KSgj
         Sp2qfYnSH+LZs1685UI/CZoAuLVz4CbAfWtd5IQWEX6zVtoWLfEz/slp4zrHqAu7fB
         dMQSDY/+ckdBahA2SJG1lAWXWG0EtdasIX+zBGWU2koYylPB7ailuwt+R1VCRQ0YxZ
         U9rFdSSfT8mpFlkF9X/sWXcibLVyZ8WmcwqDriFoziBXMmyCSm15m72c7WSqfeQsJs
         jrAbIBXrtQO0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 07/16] clk: socfpga: arria10: Fix memory leak of socfpga_clk on error return
Date:   Mon,  3 May 2021 12:43:20 -0400
Message-Id: <20210503164329.2854739-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164329.2854739-1-sashal@kernel.org>
References: <20210503164329.2854739-1-sashal@kernel.org>
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
index 1cebf253e8fd..48e371035a63 100644
--- a/drivers/clk/socfpga/clk-gate-a10.c
+++ b/drivers/clk/socfpga/clk-gate-a10.c
@@ -158,6 +158,7 @@ static void __init __socfpga_gate_init(struct device_node *node,
 		if (IS_ERR(socfpga_clk->sys_mgr_base_addr)) {
 			pr_err("%s: failed to find altr,sys-mgr regmap!\n",
 					__func__);
+			kfree(socfpga_clk);
 			return;
 		}
 	}
-- 
2.30.2

