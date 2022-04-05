Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02484F3591
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236561AbiDEI2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239543AbiDEIUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B37110E;
        Tue,  5 Apr 2022 01:15:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB0CDB81B92;
        Tue,  5 Apr 2022 08:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A557C385A1;
        Tue,  5 Apr 2022 08:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146547;
        bh=ua5vIw0517RX36TBBiaySxjD3XAV6nk60MX+XrVugGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O6MbDsqbzkqFiSbjHL53Ojz6/TgyACGs4y/3zw++oVZW5tgrqh/JNHeWZ+TEEU6Z2
         osCSlrZAHCDoejpyf71/jgQPmW1snLSTkqsnpOBERno/Mq+FjKYIQOp+inEC8QiMR0
         8J2wU7bKpfOu6RDPHbW2HHAKECZ90CUD4/pTlcWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0804/1126] clk: Initialize orphan req_rate
Date:   Tue,  5 Apr 2022 09:25:51 +0200
Message-Id: <20220405070431.168654604@linuxfoundation.org>
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

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 5f7e2af00807f2117650e711a58b7f0e986ce1df ]

When registering a clock that doesn't have a recalc_rate implementation,
and doesn't have its parent registered yet, we initialize the clk_core
rate and 'req_rate' fields to 0.

The rate field is later updated when the parent is registered in
clk_core_reparent_orphans_nolock() using __clk_recalc_rates(), but the
'req_rate' field is never updated.

This leads to an issue in clk_set_rate_range() and clk_put(), since
those functions will call clk_set_rate() with the content of 'req_rate'
to provide drivers with the opportunity to change the rate based on the
new boundaries. In this case, we would call clk_set_rate() with a rate
of 0, effectively enforcing the minimum allowed for this clock whenever
we would call one of those two functions, even though the actual rate
might be within range.

Let's fix this by setting 'req_rate' in
clk_core_reparent_orphans_nolock() with the rate field content just
updated by the call to __clk_recalc_rates().

Fixes: 1c8e600440c7 ("clk: Add rate constraints to clocks")
Reported-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Tested-by: Dmitry Osipenko <dmitry.osipenko@collabora.com> # T30 Nexus7
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20220325161144.1901695-2-maxime@cerno.tech
[sboyd@kernel.org: Reword comment]
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index fff5edb89d6d..01b64b962e76 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3456,6 +3456,19 @@ static void clk_core_reparent_orphans_nolock(void)
 			__clk_set_parent_after(orphan, parent, NULL);
 			__clk_recalc_accuracies(orphan);
 			__clk_recalc_rates(orphan, 0);
+
+			/*
+			 * __clk_init_parent() will set the initial req_rate to
+			 * 0 if the clock doesn't have clk_ops::recalc_rate and
+			 * is an orphan when it's registered.
+			 *
+			 * 'req_rate' is used by clk_set_rate_range() and
+			 * clk_put() to trigger a clk_set_rate() call whenever
+			 * the boundaries are modified. Let's make sure
+			 * 'req_rate' is set to something non-zero so that
+			 * clk_set_rate_range() doesn't drop the frequency.
+			 */
+			orphan->req_rate = orphan->rate;
 		}
 	}
 }
-- 
2.34.1



