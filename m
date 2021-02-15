Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E34331BEEC
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 17:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbhBOQVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 11:21:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:53258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231702AbhBOPq6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:46:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B100264E37;
        Mon, 15 Feb 2021 15:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403313;
        bh=bhDqEH9zOJRCMqDkygcw2XwdvM5ZzSlCwdfVnG58tRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQ1gS++5TM8FGLVh1mt6XStM6VccK1T33SXHiYaZ1YyjmagT8sp/XKxTeQB8EZI2F
         M7Jn4i1UJIQ4dRBB8iZm56rgxQXsroY3guEwxJEWyJDvWOHoQ7VK/1lsh4hVlld8eH
         RAWiepd//lPSSqGSVA2Y+L+mno6U0PWOeRaqZmOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Andre Heider <a.heider@gmail.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <mripard@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/104] clk: sunxi-ng: mp: fix parent rate change flag check
Date:   Mon, 15 Feb 2021 16:27:34 +0100
Message-Id: <20210215152722.065814250@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
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



