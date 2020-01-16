Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF97113E2FB
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733299AbgAPQ7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:59:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:44542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387485AbgAPQ5Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:57:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DBE12192A;
        Thu, 16 Jan 2020 16:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193843;
        bh=i5owRwERAnOiCFmbkU+ANJ+g3C6UCYGaMA8Usv0k760=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WhPnKMYCvJYHQ93Jb3fCRZ1tsh7Mru960wyY+RfC5Oqe6skGM6im1WhnMC8ctgmNo
         bmU+9OP1tc03tQSSnbWl/xe27l3C2tl0EEaFyYXKVJrbJdt/vUJ1YDoZMtiRnDYHNT
         gQHS9K+QaNuN2ON9AdGRj8ppvBUYwtxFJ5bdam8Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yangtao Li <tiny.windzz@gmail.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 097/671] clk: dove: fix refcount leak in dove_clk_init()
Date:   Thu, 16 Jan 2020 11:45:28 -0500
Message-Id: <20200116165502.8838-97-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <tiny.windzz@gmail.com>

[ Upstream commit 8d726c5128298386b907963033be93407b0c4275 ]

The of_find_compatible_node() returns a node pointer with refcount
incremented, but there is the lack of use of the of_node_put() when
done. Add the missing of_node_put() to release the refcount.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Reviewed-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Fixes: 8f7fc5450b64 ("clk: mvebu: dove: maintain clock init order")
Fixes: 63b8d92c793f ("clk: add Dove PLL divider support for GPU, VMeta and AXI clocks")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mvebu/dove.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/mvebu/dove.c b/drivers/clk/mvebu/dove.c
index 59fad9546c84..5f258c9bb68b 100644
--- a/drivers/clk/mvebu/dove.c
+++ b/drivers/clk/mvebu/dove.c
@@ -190,10 +190,14 @@ static void __init dove_clk_init(struct device_node *np)
 
 	mvebu_coreclk_setup(np, &dove_coreclks);
 
-	if (ddnp)
+	if (ddnp) {
 		dove_divider_clk_init(ddnp);
+		of_node_put(ddnp);
+	}
 
-	if (cgnp)
+	if (cgnp) {
 		mvebu_clk_gating_setup(cgnp, dove_gating_desc);
+		of_node_put(cgnp);
+	}
 }
 CLK_OF_DECLARE(dove_clk, "marvell,dove-core-clock", dove_clk_init);
-- 
2.20.1

