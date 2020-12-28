Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01EBF2E3BB8
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407367AbgL1Nxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:53:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:55658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407361AbgL1Nxu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:53:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F371E206D4;
        Mon, 28 Dec 2020 13:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163589;
        bh=SGoB8j5yDF3J909SAHZihhflgFYzkjcmdLEJAdoZbjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EiDMUKYgoI8uum7lN4/+xDSEPKEGRyUZ9YX+KQ9S8dISaHenxzXBYEtlaIO0JA+iq
         2rztZqNF4ff6oceNFKvz3Nmcz4a3ZyxNsHpqv1dyCLIrdb6H5f6eNmn+q6o63x2nM/
         uNGddxgf7ciVVqpxNXwiBzO6DNhX2+92YRv/1kQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <mripard@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 308/453] clk: sunxi-ng: Make sure divider tables have sentinel
Date:   Mon, 28 Dec 2020 13:49:04 +0100
Message-Id: <20201228124952.034517149@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit 48f68de00c1405351fa0e7bc44bca067c49cd0a3 ]

Two clock divider tables are missing sentinel at the end. Effect of that
is that clock framework reads past the last entry. Fix that with adding
sentinel at the end.

Issue was discovered with KASan.

Fixes: 0577e4853bfb ("clk: sunxi-ng: Add H3 clocks")
Fixes: c6a0637460c2 ("clk: sunxi-ng: Add A64 clocks")
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Link: https://lore.kernel.org/r/20201202203817.438713-1-jernej.skrabec@siol.net
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun50i-a64.c | 1 +
 drivers/clk/sunxi-ng/ccu-sun8i-h3.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/clk/sunxi-ng/ccu-sun50i-a64.c b/drivers/clk/sunxi-ng/ccu-sun50i-a64.c
index 5f66bf8797723..149cfde817cba 100644
--- a/drivers/clk/sunxi-ng/ccu-sun50i-a64.c
+++ b/drivers/clk/sunxi-ng/ccu-sun50i-a64.c
@@ -389,6 +389,7 @@ static struct clk_div_table ths_div_table[] = {
 	{ .val = 1, .div = 2 },
 	{ .val = 2, .div = 4 },
 	{ .val = 3, .div = 6 },
+	{ /* Sentinel */ },
 };
 static const char * const ths_parents[] = { "osc24M" };
 static struct ccu_div ths_clk = {
diff --git a/drivers/clk/sunxi-ng/ccu-sun8i-h3.c b/drivers/clk/sunxi-ng/ccu-sun8i-h3.c
index 6b636362379ee..7e629a4493afd 100644
--- a/drivers/clk/sunxi-ng/ccu-sun8i-h3.c
+++ b/drivers/clk/sunxi-ng/ccu-sun8i-h3.c
@@ -322,6 +322,7 @@ static struct clk_div_table ths_div_table[] = {
 	{ .val = 1, .div = 2 },
 	{ .val = 2, .div = 4 },
 	{ .val = 3, .div = 6 },
+	{ /* Sentinel */ },
 };
 static SUNXI_CCU_DIV_TABLE_WITH_GATE(ths_clk, "ths", "osc24M",
 				     0x074, 0, 2, ths_div_table, BIT(31), 0);
-- 
2.27.0



