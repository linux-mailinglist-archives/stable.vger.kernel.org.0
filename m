Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 618E2147BB2
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387499AbgAXJps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:45:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:44830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387494AbgAXJps (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:45:48 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 570A2206D5;
        Fri, 24 Jan 2020 09:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859147;
        bh=HSev9NpQU1x6v9EGBt+tR8wzvFG0L/tTisqwtR0alCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jHwOxotdmZ+USCtA2psmDqgMxqEBZXsK8tekcCeEg863bLT7yA+JHm972r0F7QlWA
         IgLWhc0J4hYahpWQsZ164vlGk8Eeu+8+ZbabTyh+MxL/IjHA9wKAsxw76U+29j5/E1
         o7ipO016iVW0YUykHi+mg5Tg2S+3pFjq4fmT1RaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 053/343] clk: armada-xp: fix refcount leak in axp_clk_init()
Date:   Fri, 24 Jan 2020 10:27:51 +0100
Message-Id: <20200124092926.681538961@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <tiny.windzz@gmail.com>

[ Upstream commit db20a90a4b6745dad62753f8bd2f66afdd5abc84 ]

The of_find_compatible_node() returns a node pointer with refcount
incremented, but there is the lack of use of the of_node_put() when
done. Add the missing of_node_put() to release the refcount.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Reviewed-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Fixes: 0a11a6ae9437 ("clk: mvebu: armada-xp: maintain clock init order")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mvebu/armada-xp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/mvebu/armada-xp.c b/drivers/clk/mvebu/armada-xp.c
index 0ec44ae9a2a26..df529982adc97 100644
--- a/drivers/clk/mvebu/armada-xp.c
+++ b/drivers/clk/mvebu/armada-xp.c
@@ -228,7 +228,9 @@ static void __init axp_clk_init(struct device_node *np)
 
 	mvebu_coreclk_setup(np, &axp_coreclks);
 
-	if (cgnp)
+	if (cgnp) {
 		mvebu_clk_gating_setup(cgnp, axp_gating_desc);
+		of_node_put(cgnp);
+	}
 }
 CLK_OF_DECLARE(axp_clk, "marvell,armada-xp-core-clock", axp_clk_init);
-- 
2.20.1



