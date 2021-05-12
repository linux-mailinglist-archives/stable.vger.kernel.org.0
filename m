Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCA637CD61
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239990AbhELQys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:54:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243839AbhELQmJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52AF361C45;
        Wed, 12 May 2021 16:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835649;
        bh=D05Ms35Fa3zBhWVOkhp6js7LRYTCD4eitDpF6CmpE+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENZcywPfEH9mxe2wKrPvMYDjtc8pBA8E2bx4alOuxITCWJbKu6jMhyhHe/8Gs2IiJ
         +BeD/NQP+RE7CaUXv+uiIBf6EqWFW6pgYc6fDJjBBW1bjHSpdGlEM1ofU2FuvTXfzu
         8jdy0s/z4zkBWAIr9QkbrrcWKnynRWsqw+kRwtsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 412/677] clk: uniphier: Fix potential infinite loop
Date:   Wed, 12 May 2021 16:47:38 +0200
Message-Id: <20210512144851.034892475@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit f6b1340dc751a6caa2a0567b667d0f4f4172cd58 ]

The for-loop iterates with a u8 loop counter i and compares this
with the loop upper limit of num_parents that is an int type.
There is a potential infinite loop if num_parents is larger than
the u8 loop counter. Fix this by making the loop counter the same
type as num_parents.  Also make num_parents an unsigned int to
match the return type of the call to clk_hw_get_num_parents.

Addresses-Coverity: ("Infinite loop")
Fixes: 734d82f4a678 ("clk: uniphier: add core support code for UniPhier clock driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20210409090104.629722-1-colin.king@canonical.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/uniphier/clk-uniphier-mux.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/uniphier/clk-uniphier-mux.c b/drivers/clk/uniphier/clk-uniphier-mux.c
index 462c84321b2d..1998e9d4cfc0 100644
--- a/drivers/clk/uniphier/clk-uniphier-mux.c
+++ b/drivers/clk/uniphier/clk-uniphier-mux.c
@@ -31,10 +31,10 @@ static int uniphier_clk_mux_set_parent(struct clk_hw *hw, u8 index)
 static u8 uniphier_clk_mux_get_parent(struct clk_hw *hw)
 {
 	struct uniphier_clk_mux *mux = to_uniphier_clk_mux(hw);
-	int num_parents = clk_hw_get_num_parents(hw);
+	unsigned int num_parents = clk_hw_get_num_parents(hw);
 	int ret;
 	unsigned int val;
-	u8 i;
+	unsigned int i;
 
 	ret = regmap_read(mux->regmap, mux->reg, &val);
 	if (ret)
-- 
2.30.2



