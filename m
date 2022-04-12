Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9554FD225
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 09:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344439AbiDLHJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235739AbiDLHAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:00:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A7F4348F;
        Mon, 11 Apr 2022 23:46:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06DDC6109E;
        Tue, 12 Apr 2022 06:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18843C385A1;
        Tue, 12 Apr 2022 06:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746005;
        bh=Rsjvxg+k8r2vza09ZjsYYA3qoPxRWtfGsNYwNg5EE+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KUwMALSouWxC+uhPDvQaJUMvETsSulSMKiINPPz8jZWtwFhOSUSBetSa6cegq1uJ4
         ZjRHVKR+kHV+dLAnVozwDJrHusWu22KJXMkGRniA4T4eL57qbq55EyLJgzEx/jJ3y1
         Q0GjQXoN9SvTXRy+/h3som7RVg1eU8wewgSion5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/277] clk: ti: Preserve node in ti_dt_clocks_register()
Date:   Tue, 12 Apr 2022 08:28:48 +0200
Message-Id: <20220412062945.657969492@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 80864594ff2ad002e2755daf97d46ff0c86faf1f ]

In preparation for making use of the clock-output-names, we want to
keep node around in ti_dt_clocks_register().

This change should not needed as a fix currently.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20220204071449.16762-3-tony@atomide.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/clk.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/ti/clk.c b/drivers/clk/ti/clk.c
index 3da33c786d77..29eafab4353e 100644
--- a/drivers/clk/ti/clk.c
+++ b/drivers/clk/ti/clk.c
@@ -131,7 +131,7 @@ int ti_clk_setup_ll_ops(struct ti_clk_ll_ops *ops)
 void __init ti_dt_clocks_register(struct ti_dt_clk oclks[])
 {
 	struct ti_dt_clk *c;
-	struct device_node *node, *parent;
+	struct device_node *node, *parent, *child;
 	struct clk *clk;
 	struct of_phandle_args clkspec;
 	char buf[64];
@@ -171,10 +171,13 @@ void __init ti_dt_clocks_register(struct ti_dt_clk oclks[])
 		node = of_find_node_by_name(NULL, buf);
 		if (num_args && compat_mode) {
 			parent = node;
-			node = of_get_child_by_name(parent, "clock");
-			if (!node)
-				node = of_get_child_by_name(parent, "clk");
-			of_node_put(parent);
+			child = of_get_child_by_name(parent, "clock");
+			if (!child)
+				child = of_get_child_by_name(parent, "clk");
+			if (child) {
+				of_node_put(parent);
+				node = child;
+			}
 		}
 
 		clkspec.np = node;
-- 
2.35.1



