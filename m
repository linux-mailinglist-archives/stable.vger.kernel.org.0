Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3D94997FC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376652AbiAXVR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:17:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35796 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449526AbiAXVPp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:15:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88CAEB80FA1;
        Mon, 24 Jan 2022 21:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA95C340E4;
        Mon, 24 Jan 2022 21:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058942;
        bh=zBpNwWKSqsso1OByKSC4HcnXg0qiDGwuZ+0URWSstR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qvOMz2ni0JUC9fmp9eTnnhM3yWbO2iSo8UnaP2EEsHG/jE3H5a8X00k7VeRPev02z
         Akh9D8MZSGCEClY/sPXOSAlxS0/q5rYmJpzGXXBi5ZE33CugKmo7nbHjgFOexu/Zfo
         mtkVZCmFavhAtBtsrm8Gg7B1VPXgR0ZCmr9B4/Vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0453/1039] clk: renesas: rzg2l: propagate return value of_genpd_add_provider_simple()
Date:   Mon, 24 Jan 2022 19:37:22 +0100
Message-Id: <20220124184140.528054004@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 4f04ff57d468a..aafd1879ff562 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -878,8 +878,7 @@ static int __init rzg2l_cpg_add_clk_domain(struct device *dev)
 	if (ret)
 		return ret;
 
-	of_genpd_add_provider_simple(np, genpd);
-	return 0;
+	return of_genpd_add_provider_simple(np, genpd);
 }
 
 static int __init rzg2l_cpg_probe(struct platform_device *pdev)
-- 
2.34.1



