Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CECF945C229
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347807AbhKXNZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:25:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:47200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350020AbhKXNXe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:23:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D0DE61B2D;
        Wed, 24 Nov 2021 12:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758107;
        bh=deIH0YXRzyXmDnM7tiGr+SnSPusFaQvf7yI468ANOEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i1coVOv6WtO9k+ul4w3kFiIv+XihrPw0eO2n/DgW4oxCETS4kQ9X6czwhes8+hnKk
         6mF91gnqypyT+61FBRO/oZMtxn4FGO5k603KBAvB/Owan0jaEi9OSTrJ88U4IiOqUn
         zwIFDeWGhcDFO35GgQpoaz9jw67bHY50xdnw9dB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Artur Rojek <contact@artur-rojek.eu>,
        Paul Cercueil <paul@crapouillou.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/100] clk: ingenic: Fix bugs with divided dividers
Date:   Wed, 24 Nov 2021 12:57:52 +0100
Message-Id: <20211124115656.041283669@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit ed84ef1cd7eddf933d4ffce2caa8161d6f947245 ]

Two fixes in one:

- In the "impose hardware constraints" block, the "logical" divider
  value (aka. not translated to the hardware) was clamped to fit in the
  register area, but this totally ignored the fact that the divider
  value can itself have a fixed divider.

- The code that made sure that the divider value returned by the
  function was a multiple of its own fixed divider could result in a
  wrong value being calculated, because it was rounded down instead of
  rounded up.

Fixes: 4afe2d1a6ed5 ("clk: ingenic: Allow divider value to be divided")
Co-developed-by: Artur Rojek <contact@artur-rojek.eu>
Signed-off-by: Artur Rojek <contact@artur-rojek.eu>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Link: https://lore.kernel.org/r/20211001172033.122329-1-paul@crapouillou.net
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ingenic/cgu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/ingenic/cgu.c b/drivers/clk/ingenic/cgu.c
index 7490d4f4d9366..dff759c0f6193 100644
--- a/drivers/clk/ingenic/cgu.c
+++ b/drivers/clk/ingenic/cgu.c
@@ -426,15 +426,15 @@ ingenic_clk_calc_div(const struct ingenic_cgu_clk_info *clk_info,
 	}
 
 	/* Impose hardware constraints */
-	div = min_t(unsigned, div, 1 << clk_info->div.bits);
-	div = max_t(unsigned, div, 1);
+	div = clamp_t(unsigned int, div, clk_info->div.div,
+		      clk_info->div.div << clk_info->div.bits);
 
 	/*
 	 * If the divider value itself must be divided before being written to
 	 * the divider register, we must ensure we don't have any bits set that
 	 * would be lost as a result of doing so.
 	 */
-	div /= clk_info->div.div;
+	div = DIV_ROUND_UP(div, clk_info->div.div);
 	div *= clk_info->div.div;
 
 	return div;
-- 
2.33.0



