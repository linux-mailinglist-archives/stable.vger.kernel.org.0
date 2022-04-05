Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B104F250D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbiDEHop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbiDEHnd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:43:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB83939A9;
        Tue,  5 Apr 2022 00:40:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8EE48CE1BDB;
        Tue,  5 Apr 2022 07:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A548CC340EE;
        Tue,  5 Apr 2022 07:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144426;
        bh=hiepfgHCUoOr2gSHKgyDZg8utOmO3xMK1AQWFOpqwto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GkJr9qC2KCZP+nlnqKrC9pedg74fEqzMJoWoIjYhtYx6ezqePD4DklPcHENSQr+3h
         IEUVDU7DDq3gFlKwZwaDNchdZAd0615j7tccuVr3XOUBBYbM8Yh0VwOw9y7b2SJ1UX
         1THFIiwBFTWbPnzUg6PZ/5tCK9+WKC6+agTFJCxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Schulz <foss+kernel@0leil.net>,
        Quentin Schulz <quentin.schulz@theobroma-systems.com>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.17 0040/1126] clk: rockchip: re-add rational best approximation algorithm to the fractional divider
Date:   Tue,  5 Apr 2022 09:13:07 +0200
Message-Id: <20220405070408.735525184@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Quentin Schulz <quentin.schulz@theobroma-systems.com>

commit 10b74af310735860510a533433b1d3ab2e05a138 upstream.

In commit 4e7cf74fa3b2 ("clk: fractional-divider: Export approximation
algorithm to the CCF users"), the code handling the rational best
approximation algorithm was replaced by a call to the core
clk_fractional_divider_general_approximation function which did the same
thing back then.

However, in commit 82f53f9ee577 ("clk: fractional-divider: Introduce
POWER_OF_TWO_PS flag"), this common code was made conditional on
CLK_FRAC_DIVIDER_POWER_OF_TWO_PS flag which was not added back to the
rockchip clock driver.

This broke the ltk050h3146w-a2 MIPI DSI display present on a PX30-based
downstream board.

Let's add the flag to the fractional divider flags so that the original
and intended behavior is brought back to the rockchip clock drivers.

Fixes: 82f53f9ee577 ("clk: fractional-divider: Introduce POWER_OF_TWO_PS flag")
Cc: stable@vger.kernel.org
Cc: Quentin Schulz <foss+kernel@0leil.net>
Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Link: https://lore.kernel.org/r/20220131163224.708002-1-quentin.schulz@theobroma-systems.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/rockchip/clk.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/clk/rockchip/clk.c
+++ b/drivers/clk/rockchip/clk.c
@@ -180,6 +180,7 @@ static void rockchip_fractional_approxim
 		unsigned long rate, unsigned long *parent_rate,
 		unsigned long *m, unsigned long *n)
 {
+	struct clk_fractional_divider *fd = to_clk_fd(hw);
 	unsigned long p_rate, p_parent_rate;
 	struct clk_hw *p_parent;
 
@@ -190,6 +191,8 @@ static void rockchip_fractional_approxim
 		*parent_rate = p_parent_rate;
 	}
 
+	fd->flags |= CLK_FRAC_DIVIDER_POWER_OF_TWO_PS;
+
 	clk_fractional_divider_general_approximation(hw, rate, parent_rate, m, n);
 }
 


