Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28BB4F2A81
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244709AbiDEKjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238903AbiDEJdC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:33:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A013DB;
        Tue,  5 Apr 2022 02:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F041B81B75;
        Tue,  5 Apr 2022 09:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5E8C385A3;
        Tue,  5 Apr 2022 09:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150420;
        bh=hiepfgHCUoOr2gSHKgyDZg8utOmO3xMK1AQWFOpqwto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cxGp3D6HN6wXyYpj8xegz+HJikfjf4v5a4G1h50RgsGke9vykPLgUYa1FKl8PMHaM
         nRb4dzySLrMOS/6sCsqtICCq3pQsf5uwDpdz0N2oKbjp/JcgysYowlFpPXQyWrT0hd
         5da+IYY9ofhCuJPMmrkJN4XftOA5DHDfk+oVnrug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Schulz <foss+kernel@0leil.net>,
        Quentin Schulz <quentin.schulz@theobroma-systems.com>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.15 050/913] clk: rockchip: re-add rational best approximation algorithm to the fractional divider
Date:   Tue,  5 Apr 2022 09:18:32 +0200
Message-Id: <20220405070341.320272822@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
 


