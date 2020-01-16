Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 651BD13F730
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405029AbgAPTJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:09:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:50512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387856AbgAPRAi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:00:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F079422525;
        Thu, 16 Jan 2020 17:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194037;
        bh=XX4X6EpJrToEwjK3Fv9nagxPTDojAtDKIFRZMSV0bSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WKgeloLCSxgn+DI+51VViBc9wBhLw7GPE+4j2BdzoxYDS0MaiekupReMtdOhBa6Eb
         IHXG+E3b0LINKbZDNKz+MXhlvpEY8TsXozET87dapblK4+7LyA3K8tsWQuOInmiKBm
         d8KFoZkx7vtPZ9Qbbfr9dPx+hYuFaLGfm94gRlnc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Artur Rojek <contact@artur-rojek.eu>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 155/671] clk: ingenic: jz4740: Fix gating of UDC clock
Date:   Thu, 16 Jan 2020 11:51:04 -0500
Message-Id: <20200116165940.10720-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit b7e29924a1a628aec60d18651b493fa1601bf944 ]

The UDC clock is gated when the bit is cleared, not when it is set.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Tested-by: Artur Rojek <contact@artur-rojek.eu>
Fixes: 2b555a4b9cae ("clk: ingenic: Add missing flag for UDC clock")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ingenic/jz4740-cgu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/ingenic/jz4740-cgu.c b/drivers/clk/ingenic/jz4740-cgu.c
index 4479c102e899..b86edd328249 100644
--- a/drivers/clk/ingenic/jz4740-cgu.c
+++ b/drivers/clk/ingenic/jz4740-cgu.c
@@ -165,7 +165,7 @@ static const struct ingenic_cgu_clk_info jz4740_cgu_clocks[] = {
 		.parents = { JZ4740_CLK_EXT, JZ4740_CLK_PLL_HALF, -1, -1 },
 		.mux = { CGU_REG_CPCCR, 29, 1 },
 		.div = { CGU_REG_CPCCR, 23, 1, 6, -1, -1, -1 },
-		.gate = { CGU_REG_SCR, 6 },
+		.gate = { CGU_REG_SCR, 6, true },
 	},
 
 	/* Gate-only clocks */
-- 
2.20.1

