Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1682440E2B6
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242412AbhIPQlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:41:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244347AbhIPQiz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:38:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B729613A8;
        Thu, 16 Sep 2021 16:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809363;
        bh=3YFunZ3hlc2GCNPhew0LSVgKaXkLPk5AYp8WX289ifY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pv2gr7ZbuECK9lp3rYHKw9hTkZHFhPGDE64a1b57ukGTvoofXkVF/3FcDbGaGk999
         r36kZCsjvq381o1/g15+3o7RqECCRWdNJDCRFsk2dL0kRnEPps+vpWshgDD1y/H4kv
         itDIbXHEXFpheQrTNHK7PaQeOC5zU6cIpAtpzUic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 127/380] clk: ralink: avoid to set CLK_IS_CRITICAL flag for gates
Date:   Thu, 16 Sep 2021 17:58:04 +0200
Message-Id: <20210916155808.356347762@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

[ Upstream commit c16edf5ff8ece9c4135175da4103cee1bec360be ]

'clk_init_data' for gates is setting up 'CLK_IS_CRITICAL'
flag for all of them. This was being doing because some
drivers of this SoC might not be ready to use the clock
and we don't wanted the kernel to disable them since default
behaviour without clock driver was to set all gate bits to
enabled state. After a bit more testing and checking driver
code it is safe to remove this flag and just let the kernel
to disable those gates that are not in use. No regressions
seems to appear.

Fixes: 48df7a26f470 ("clk: ralink: add clock driver for mt7621 SoC")
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://lore.kernel.org/r/20210727055537.11785-1-sergio.paracuellos@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ralink/clk-mt7621.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/clk/ralink/clk-mt7621.c b/drivers/clk/ralink/clk-mt7621.c
index 857da1e274be..a2c045390f00 100644
--- a/drivers/clk/ralink/clk-mt7621.c
+++ b/drivers/clk/ralink/clk-mt7621.c
@@ -131,14 +131,7 @@ static int mt7621_gate_ops_init(struct device *dev,
 				struct mt7621_gate *sclk)
 {
 	struct clk_init_data init = {
-		/*
-		 * Until now no clock driver existed so
-		 * these SoC drivers are not prepared
-		 * yet for the clock. We don't want kernel to
-		 * disable anything so we add CLK_IS_CRITICAL
-		 * flag here.
-		 */
-		.flags = CLK_SET_RATE_PARENT | CLK_IS_CRITICAL,
+		.flags = CLK_SET_RATE_PARENT,
 		.num_parents = 1,
 		.parent_names = &sclk->parent_name,
 		.ops = &mt7621_gate_ops,
-- 
2.30.2



