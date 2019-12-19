Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5983E12693B
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbfLSSfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:35:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:52374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726836AbfLSSfm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:35:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2C9624679;
        Thu, 19 Dec 2019 18:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780542;
        bh=qGW1AnRfHulQuoxOcJ1quQ3TEjBJS6JUQMxrNU41tGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OcxQ0ZO4zYH7gE3YUn36QYBJbZXLmMtdbtam8IZ5DHFTakWFWdF7dPOJH+uq3IdKw
         XwE2jgBThriX/5jU26+wxNF4N7j3HOSPV1g94Ke1VZc7AecJQX0IRIwAfc4r9vH3We
         HOFlCwLr7AOWpjRs784fgviV1SFZhoHT4iUn/wGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Finley Xiao <finley.xiao@rock-chips.com>,
        Johan Jonker <jbx9999@hotmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 017/162] clk: rockchip: fix rk3188 sclk_smc gate data
Date:   Thu, 19 Dec 2019 19:32:05 +0100
Message-Id: <20191219183207.397022772@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finley Xiao <finley.xiao@rock-chips.com>

[ Upstream commit a9f0c0e563717b9f63b3bb1c4a7c2df436a206d9 ]

Fix sclk_smc gate data.
Change variable order, flags come before the register address.

Signed-off-by: Finley Xiao <finley.xiao@rock-chips.com>
Signed-off-by: Johan Jonker <jbx9999@hotmail.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-rk3188.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/rockchip/clk-rk3188.c b/drivers/clk/rockchip/clk-rk3188.c
index fe728f8dcbe43..986a558c361d6 100644
--- a/drivers/clk/rockchip/clk-rk3188.c
+++ b/drivers/clk/rockchip/clk-rk3188.c
@@ -360,8 +360,8 @@ static struct rockchip_clk_branch common_clk_branches[] __initdata = {
 	 * Clock-Architecture Diagram 4
 	 */
 
-	GATE(SCLK_SMC, "sclk_smc", "hclk_peri",
-			RK2928_CLKGATE_CON(2), 4, 0, GFLAGS),
+	GATE(SCLK_SMC, "sclk_smc", "hclk_peri", 0,
+			RK2928_CLKGATE_CON(2), 4, GFLAGS),
 
 	COMPOSITE_NOMUX(SCLK_SPI0, "sclk_spi0", "pclk_peri", 0,
 			RK2928_CLKSEL_CON(25), 0, 7, DFLAGS,
-- 
2.20.1



