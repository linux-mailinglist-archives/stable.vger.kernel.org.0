Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D976041D9
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiJSKty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbiJSKrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:47:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD651187A5;
        Wed, 19 Oct 2022 03:21:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36879B8243F;
        Wed, 19 Oct 2022 08:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EEA3C433C1;
        Wed, 19 Oct 2022 08:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169953;
        bh=OIJs8jEJDlE4X49d2dwxy8tysOIHP5M9KVrpH9pEbiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wVvvzOBNQSnweW58/cFx7Ld1eHYn7++Sjjtg1rVrT1fONVjfaftoYXEUOP4iGqOfC
         cDBGMhzADzShvmAQ/kkuQ/OXva0wQLDjhu8Ez2GJ6GHQbPQR/rVneXRCU2fLpAeu7p
         Y8Korr/5I4dkaY/ce4lyNeOmk62hd8/bX/D+kgGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 471/862] clk: qoriq: Hold reference returned by of_get_parent()
Date:   Wed, 19 Oct 2022 10:29:18 +0200
Message-Id: <20221019083310.780397939@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



