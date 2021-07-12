Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6663C5121
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344257AbhGLHiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:38:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243317AbhGLHf3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:35:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21153613DB;
        Mon, 12 Jul 2021 07:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075136;
        bh=H7iqm+NQ4y2X2+Gx7MVopqODNNQ0ttsLJOZX2Qcms0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rR0IvJl5a2iEWAYST0Xb20eu7Lp7eRFwN6vxJdNhSFJtvSq5wHje9xuoJ6xux3di0
         FjNfGMAWz8qQBoj683xOBhZxjIEeE4h+rxH19cSGAkdnE1if03q0A8eQpzq50KHahn
         AlpCrrrqef8c9jzZwCYURaK+zn/dNc1fe9tuJ1Sw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.13 085/800] clk: k210: Fix k210_clk_set_parent()
Date:   Mon, 12 Jul 2021 08:01:48 +0200
Message-Id: <20210712060925.032524822@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit faa0e307948594b4379a86fff7fb2409067aed6f upstream.

In k210_clk_set_parent(), add missing writel() call to update the mux
register of a clock to change its parent. This also fixes a compilation
warning with clang when compiling with W=1.

Fixes: c6ca7616f7d5 ("clk: Add RISC-V Canaan Kendryte K210 clock driver")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Link: https://lore.kernel.org/r/20210622064502.14841-1-damien.lemoal@wdc.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/clk-k210.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/clk/clk-k210.c
+++ b/drivers/clk/clk-k210.c
@@ -722,6 +722,7 @@ static int k210_clk_set_parent(struct cl
 		reg |= BIT(cfg->mux_bit);
 	else
 		reg &= ~BIT(cfg->mux_bit);
+	writel(reg, ksc->regs + cfg->mux_reg);
 	spin_unlock_irqrestore(&ksc->clk_lock, flags);
 
 	return 0;


