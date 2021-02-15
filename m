Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8372631BCAD
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhBOPd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:33:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231243AbhBOPbs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:31:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FE4C64E9E;
        Mon, 15 Feb 2021 15:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613402988;
        bh=bhDqEH9zOJRCMqDkygcw2XwdvM5ZzSlCwdfVnG58tRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MWQHZZDOLDAZAc7T1ieF8awFAl4j1BVsY+LTVBq8h9435oWTAfPOj3/mA20m0XHSk
         ZE3txc0va1ATRfdyrAi4gKEIazjPqFbglUUUORtqgPJt3NDyUxzHhu9t4jMDBwLdkU
         nyKzsUTD1AgVicQIHrW4uAm+Jkhy0xv0i9jJNufY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Andre Heider <a.heider@gmail.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <mripard@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 44/60] clk: sunxi-ng: mp: fix parent rate change flag check
Date:   Mon, 15 Feb 2021 16:27:32 +0100
Message-Id: <20210215152716.779645484@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
References: <20210215152715.401453874@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit 245090ab2636c0869527ce563afbfb8aff29e825 ]

CLK_SET_RATE_PARENT flag is checked on parent clock instead of current
one. Fix that.

Fixes: 3f790433c3cb ("clk: sunxi-ng: Adjust MP clock parent rate when allowed")
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Tested-by: Andre Heider <a.heider@gmail.com>
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Link: https://lore.kernel.org/r/20210209175900.7092-2-jernej.skrabec@siol.net
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu_mp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi-ng/ccu_mp.c b/drivers/clk/sunxi-ng/ccu_mp.c
index fa4ecb9155909..9d3a76604d94c 100644
--- a/drivers/clk/sunxi-ng/ccu_mp.c
+++ b/drivers/clk/sunxi-ng/ccu_mp.c
@@ -108,7 +108,7 @@ static unsigned long ccu_mp_round_rate(struct ccu_mux_internal *mux,
 	max_m = cmp->m.max ?: 1 << cmp->m.width;
 	max_p = cmp->p.max ?: 1 << ((1 << cmp->p.width) - 1);
 
-	if (!(clk_hw_get_flags(hw) & CLK_SET_RATE_PARENT)) {
+	if (!clk_hw_can_set_rate_parent(&cmp->common.hw)) {
 		ccu_mp_find_best(*parent_rate, rate, max_m, max_p, &m, &p);
 		rate = *parent_rate / p / m;
 	} else {
-- 
2.27.0



