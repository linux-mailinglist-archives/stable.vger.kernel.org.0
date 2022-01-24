Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42000499B04
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574332AbiAXVsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:48:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457499AbiAXVlo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:41:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C719EC07E328;
        Mon, 24 Jan 2022 12:28:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66A9061232;
        Mon, 24 Jan 2022 20:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41956C340E5;
        Mon, 24 Jan 2022 20:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056134;
        bh=dZCh+rQmXNsTbp25IWcKPBSby7DdQprMmtkeo9Wg3yM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMyIGA3utIaJhEXuIporzSrpyFs3apnc0N5YgbR57qf/gToIu2aAbNWmhrbC/CPsF
         3d0IyT/D6R5VakEYDMX5+iQYG3aLyBEYOm3EieHbYOrNuoLHS2G/TGjVQq5YaHukX9
         4mk9kF4enI+IcVLmVy+FKEk6bB6lXm3zAwNqaOIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 382/846] clk: renesas: rzg2l: propagate return value of_genpd_add_provider_simple()
Date:   Mon, 24 Jan 2022 19:38:19 +0100
Message-Id: <20220124184114.118767436@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 33748744f15a110a233b6ae0380f476006e770f0 ]

of_genpd_add_provider_simple() might fail, this patch makes sure we check
the return value of of_genpd_add_provider_simple() by propagating the
return value to the caller of rzg2l_cpg_add_clk_domain().

Fixes: ef3c613ccd68a ("clk: renesas: Add CPG core wrapper for RZ/G2L SoC")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/r/20211117115101.28281-3-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rzg2l-cpg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/clk/renesas/rzg2l-cpg.c b/drivers/clk/renesas/rzg2l-cpg.c
index 61e7c0c4f3794..1c92e73cd2b8c 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -666,8 +666,7 @@ static int __init rzg2l_cpg_add_clk_domain(struct device *dev)
 	if (ret)
 		return ret;
 
-	of_genpd_add_provider_simple(np, genpd);
-	return 0;
+	return of_genpd_add_provider_simple(np, genpd);
 }
 
 static int __init rzg2l_cpg_probe(struct platform_device *pdev)
-- 
2.34.1



