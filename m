Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641FE29BD6B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802395AbgJ0Qg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:36:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799944AbgJ0Pn1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:43:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79C6322409;
        Tue, 27 Oct 2020 15:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813405;
        bh=mcHk6piw7br4qc/6ajvRIGsdzwYRhDh1bfnKcN2vjPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DekM1coz5mOZEq0X08NmxeVvTfm0I7DQYIcqj4tR0ldh71BZenzoJWj4bP+VEuXE8
         pk6Ltk9oD0RsnBOHyp7P+ZB4XDtpEjo+KUK/GqC/hiAQ0XeFfaZGWmpgu6av5fB/Jn
         oDCQLJ3vENs7hrMxsV7uxsSuURrnpPsVAA3B2hjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elaine Zhang <zhangqing@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 539/757] clk: rockchip: Initialize hw to error to avoid undefined behavior
Date:   Tue, 27 Oct 2020 14:53:09 +0100
Message-Id: <20201027135515.768201818@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <sboyd@kernel.org>

[ Upstream commit b608f11d49ec671739604cc763248d8e8fadbbeb ]

We can get down to this return value from ERR_CAST() without
initializing hw. Set it to -ENOMEM so that we always return something
sane.

Fixes the following smatch warning:

drivers/clk/rockchip/clk-half-divider.c:228 rockchip_clk_register_halfdiv() error: uninitialized symbol 'hw'.
drivers/clk/rockchip/clk-half-divider.c:228 rockchip_clk_register_halfdiv() warn: passing zero to 'ERR_CAST'

Cc: Elaine Zhang <zhangqing@rock-chips.com>
Cc: Heiko Stuebner <heiko@sntech.de>
Fixes: 956060a52795 ("clk: rockchip: add support for half divider")
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-half-divider.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-half-divider.c b/drivers/clk/rockchip/clk-half-divider.c
index b333fc28c94b6..37c858d689e0d 100644
--- a/drivers/clk/rockchip/clk-half-divider.c
+++ b/drivers/clk/rockchip/clk-half-divider.c
@@ -166,7 +166,7 @@ struct clk *rockchip_clk_register_halfdiv(const char *name,
 					  unsigned long flags,
 					  spinlock_t *lock)
 {
-	struct clk *clk;
+	struct clk *clk = ERR_PTR(-ENOMEM);
 	struct clk_mux *mux = NULL;
 	struct clk_gate *gate = NULL;
 	struct clk_divider *div = NULL;
-- 
2.25.1



