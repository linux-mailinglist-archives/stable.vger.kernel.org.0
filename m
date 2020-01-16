Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96AC713E916
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404357AbgAPRfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:35:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:49766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405082AbgAPRf2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:35:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCA9B24727;
        Thu, 16 Jan 2020 17:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196127;
        bh=Vphdej1Ityuadwcb/J0YSdp3PfSRndhx5e/AjZg4CQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DYm3/oJ58lNOGcrZreQbXuTKCyoz+0W9ZwHa9Q4it0n+0j8HEVSlW5F8IPlARJejJ
         YausPzd9aPFENqnNPnyewgpI4RXK/3GF3BTYZltng4PC0V6QTVi1iAlEPB0838W0xg
         bUIAg/YFAjjoVNp1FoM+PVPzsZFzXnm1RttkWoCw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yangtao Li <tiny.windzz@gmail.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 032/251] clk: armada-370: fix refcount leak in a370_clk_init()
Date:   Thu, 16 Jan 2020 12:31:06 -0500
Message-Id: <20200116173445.21385-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173445.21385-1-sashal@kernel.org>
References: <20200116173445.21385-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <tiny.windzz@gmail.com>

[ Upstream commit a3c24050bdf70c958a8d98c2823b66ea761e6a31 ]

The of_find_compatible_node() returns a node pointer with refcount
incremented, but there is the lack of use of the of_node_put() when
done. Add the missing of_node_put() to release the refcount.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Reviewed-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Fixes: 07ad6836fa21 ("clk: mvebu: armada-370: maintain clock init order")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mvebu/armada-370.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/mvebu/armada-370.c b/drivers/clk/mvebu/armada-370.c
index 2c7c1085f883..8fdfa97900cd 100644
--- a/drivers/clk/mvebu/armada-370.c
+++ b/drivers/clk/mvebu/armada-370.c
@@ -177,8 +177,10 @@ static void __init a370_clk_init(struct device_node *np)
 
 	mvebu_coreclk_setup(np, &a370_coreclks);
 
-	if (cgnp)
+	if (cgnp) {
 		mvebu_clk_gating_setup(cgnp, a370_gating_desc);
+		of_node_put(cgnp);
+	}
 }
 CLK_OF_DECLARE(a370_clk, "marvell,armada-370-core-clock", a370_clk_init);
 
-- 
2.20.1

