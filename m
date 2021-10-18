Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F63431E41
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbhJRN7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:59:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234098AbhJRN5W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:57:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D9EB61452;
        Mon, 18 Oct 2021 13:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564457;
        bh=exjujlaf+hgjlrlzagkNQVvgh741fEx2KVV2ikdGtvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGeo0uiTWr5Mke7CvgzgliEvbqKHD3EZYhpbeV6CqCR/DS7a0XC98vIT0zE4tiLya
         0ToTD5VbR7DuyhSsjfoWR2trK6GF1Exf/1dgQYJcpyJi9ecbIGMfYOqebyjPnSw3Rj
         9fA/W0iyB2YUTW9jOTLbInQ+WMTE1ojcRjjqraso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5.14 096/151] clk: renesas: rzg2l: Fix clk status function
Date:   Mon, 18 Oct 2021 15:24:35 +0200
Message-Id: <20211018132343.796105871@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

commit fa2a30f8e0aa9304919750b116a9e9e322465299 upstream.

As per RZ/G2L HW(Rev.0.50) manual, clock monitor register value
0 means clock is not supplied and 1 means clock is supplied.
This patch fixes the issue by removing the inverted logic.

Fixing the above, triggered following 2 issues

1) GIC interrupts don't work if we disable IA55_CLK and DMAC_ACLK.
   Fixed this issue by adding these clocks as critical clocks.

2) DMA is not working, since the DMA driver is not turning on DMAC_PCLK.
   So will provide a fix in the DMA driver to turn on DMA_PCLK.

Fixes: ef3c613ccd68 ("clk: renesas: Add CPG core wrapper for RZ/G2L SoC")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20210922112405.26413-2-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/renesas/renesas-rzg2l-cpg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/renesas/renesas-rzg2l-cpg.c
+++ b/drivers/clk/renesas/renesas-rzg2l-cpg.c
@@ -398,7 +398,7 @@ static int rzg2l_mod_clock_is_enabled(st
 
 	value = readl(priv->base + CLK_MON_R(clock->off));
 
-	return !(value & bitmask);
+	return value & bitmask;
 }
 
 static const struct clk_ops rzg2l_mod_clock_ops = {


