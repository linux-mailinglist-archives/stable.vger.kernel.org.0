Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51BA60ABD6
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236854AbiJXN6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236869AbiJXN5o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:57:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D18696ED;
        Mon, 24 Oct 2022 05:45:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94C2A612A1;
        Mon, 24 Oct 2022 12:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89CEC433C1;
        Mon, 24 Oct 2022 12:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615502;
        bh=OIJs8jEJDlE4X49d2dwxy8tysOIHP5M9KVrpH9pEbiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l43SvPKAZKYicyHLly6rQxb4HRlNMvhbKEz2Vv5lkMxVg1Y1Y+fRu7swqP1S0typO
         Gb6ufAY54UZQQQyR9uzmRLCf9oom8tL9utLWhNE1jKDRx0c0dTchSCSlO/yR3Pb3Ax
         a1K1EVC+CCmPzOGPDwkoCXIZy0bcGvmt9KjOMSbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 276/530] clk: qoriq: Hold reference returned by of_get_parent()
Date:   Mon, 24 Oct 2022 13:30:20 +0200
Message-Id: <20221024113057.576048453@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit a8ea4273bc26256ce3cce83164f0f51c5bf6e127 ]

In legacy_init_clockgen(), we need to hold the reference returned
by of_get_parent() and use it to call of_node_put() for refcount
balance.

Beside, in create_sysclk(), we need to call of_node_put() on 'sysclk'
also for refcount balance.

Fixes: 0dfc86b3173f ("clk: qoriq: Move chip-specific knowledge into driver")
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220628143851.171299-1-windhl@126.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-qoriq.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-qoriq.c b/drivers/clk/clk-qoriq.c
index 88898b97a443..5eddb9f0d6bd 100644
--- a/drivers/clk/clk-qoriq.c
+++ b/drivers/clk/clk-qoriq.c
@@ -1063,8 +1063,13 @@ static void __init _clockgen_init(struct device_node *np, bool legacy);
  */
 static void __init legacy_init_clockgen(struct device_node *np)
 {
-	if (!clockgen.node)
-		_clockgen_init(of_get_parent(np), true);
+	if (!clockgen.node) {
+		struct device_node *parent_np;
+
+		parent_np = of_get_parent(np);
+		_clockgen_init(parent_np, true);
+		of_node_put(parent_np);
+	}
 }
 
 /* Legacy node */
@@ -1159,6 +1164,7 @@ static struct clk * __init create_sysclk(const char *name)
 	sysclk = of_get_child_by_name(clockgen.node, "sysclk");
 	if (sysclk) {
 		clk = sysclk_from_fixed(sysclk, name);
+		of_node_put(sysclk);
 		if (!IS_ERR(clk))
 			return clk;
 	}
-- 
2.35.1



