Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D823F6542
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239640AbhHXRLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:11:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239995AbhHXRJw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:09:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57B2961A53;
        Tue, 24 Aug 2021 17:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824426;
        bh=Tjq5f9hG31kCz0NjLuq0v1QYChjHR8EwaoWS3BdxKAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBNaWU5wG/GDzHldQKLv7e5hr8u3KYfeMJKxEKEWckn6hvtIzrNwheQptU9iVk3BA
         uT5KpwQiIULrVJu1nOigMElFZvM25fmAFL8iH7panS9L4qI5hWuiwkkI55/AOXXL79
         2hdVxbp+PINeoEc1dAyJsngDS0GykXbt0SmLSx2qERT/QohTG3xbXJ+wtxr6eb0Jl5
         bw3sPOvSP7nMwe5yoZU/jqSNpcNEw8/pGKdPBraiykcR2YsRvRfIOPCouVFG2BUYIo
         y9VPFLGq/pcgYJZC+bHcFrEwjxike48QckehlduJY9o61jhsBQxHnMuKtqsUaqI53Q
         XGpm9njuE2UVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dong Aisheng <aisheng.dong@nxp.com>, Abel Vesa <abel.vesa@nxp.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 76/98] clk: imx6q: fix uart earlycon unwork
Date:   Tue, 24 Aug 2021 12:58:46 -0400
Message-Id: <20210824165908.709932-77-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dong Aisheng <aisheng.dong@nxp.com>

[ Upstream commit 283f1b9a0401859c53fdd6483ab66f1c4fadaea5 ]

The earlycon depends on the bootloader setup UART clocks being retained.
There're actually two uart clocks (ipg, per) on MX6QDL,
but the 'Fixes' commit change to register only one which means
another clock may be disabled during booting phase
and result in the earlycon unwork.

Cc: stable@vger.kernel.org # v5.10+
Fixes: 379c9a24cc23 ("clk: imx: Fix reparenting of UARTs not associated with stdout")
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
Link: https://lore.kernel.org/r/20210702085438.1988087-1-aisheng.dong@nxp.com
Reviewed-by: Abel Vesa <abel.vesa@nxp.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx6q.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx6q.c b/drivers/clk/imx/clk-imx6q.c
index f444bbe8244c..7d07dd92a7b4 100644
--- a/drivers/clk/imx/clk-imx6q.c
+++ b/drivers/clk/imx/clk-imx6q.c
@@ -974,6 +974,6 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 			       hws[IMX6QDL_CLK_PLL3_USB_OTG]->clk);
 	}
 
-	imx_register_uart_clocks(1);
+	imx_register_uart_clocks(2);
 }
 CLK_OF_DECLARE(imx6q, "fsl,imx6q-ccm", imx6q_clocks_init);
-- 
2.30.2

