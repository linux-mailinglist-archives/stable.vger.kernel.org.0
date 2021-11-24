Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4EE045C2F0
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350051AbhKXNeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:34:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:47486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348474AbhKXNcp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:32:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADD5A61BD4;
        Wed, 24 Nov 2021 12:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758400;
        bh=qqlYTQSW+aaMSokLxOA6YaEkCvQhesPwPXCzLWKVlhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MMp+3220Un5FSVUHUieTZJqIrBOsR6LPYUJKV95WS9CAhfuRGfRPwDuNr8hVIK/U6
         1RavrydEcqEF+m8MvMR/Ol/oRKVuhsfdvs5egekYm8Pqgv7HI/qk6mKDZkMtjFUDvU
         FQ12Pt4ZF3uBBMEquPLLe9LjNHJNhq+BlrUy4Seg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Artur Rojek <contact@artur-rojek.eu>,
        Paul Cercueil <paul@crapouillou.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/154] clk: ingenic: Fix bugs with divided dividers
Date:   Wed, 24 Nov 2021 12:57:33 +0100
Message-Id: <20211124115704.172460432@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
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
index c8e9cb6c8e39c..2b9bb7d55efc8 100644
--- a/drivers/clk/ingenic/cgu.c
+++ b/drivers/clk/ingenic/cgu.c
@@ -425,15 +425,15 @@ ingenic_clk_calc_div(const struct ingenic_cgu_clk_info *clk_info,
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



