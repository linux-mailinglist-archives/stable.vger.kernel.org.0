Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2384B6B4589
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbjCJOei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbjCJOeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:34:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79364B83E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:34:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42EA261745
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5114CC433EF;
        Fri, 10 Mar 2023 14:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458861;
        bh=12OrUunPROg9fNe41Yixt3FKTnnM7aTpNHMCgzEojmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KtvQx7/Ezi0FP10hu4nblfkBTFuWlJ1vAZK/hABuYr3sTRq4Qxf8gW0NKIIV93/aL
         uclXEQv/aqRZkzx8RE5WoGFBOn4cNtVs5sD+n6kNmt5b7PrB944Kn2OLAQ1owtH92x
         ppLPcDoOzC1HBqCnKhTC5a3pglj/2EJSrlWSjfbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 151/357] clk: renesas: cpg-mssr: Fix use after free if cpg_mssr_common_init() failed
Date:   Fri, 10 Mar 2023 14:37:20 +0100
Message-Id: <20230310133741.372886580@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

[ Upstream commit fbfd614aeaa2853c2c575299dfe2458db8eff67e ]

If cpg_mssr_common_init() fails after assigning priv to global variable
cpg_mssr_priv, it deallocates priv, but cpg_mssr_priv keeps dangling
pointer that potentially can be used later.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 1f7db7bbf031 ("clk: renesas: cpg-mssr: Add early clock support")
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/1671806417-32623-1-git-send-email-khoroshilov@ispras.ru
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/renesas-cpg-mssr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/renesas/renesas-cpg-mssr.c b/drivers/clk/renesas/renesas-cpg-mssr.c
index 6f9612c169afe..9ffd1bf80b6a3 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -907,7 +907,6 @@ static int __init cpg_mssr_common_init(struct device *dev,
 		goto out_err;
 	}
 
-	cpg_mssr_priv = priv;
 	priv->num_core_clks = info->num_total_core_clks;
 	priv->num_mod_clks = info->num_hw_mod_clks;
 	priv->last_dt_core_clk = info->last_dt_core_clk;
@@ -921,6 +920,8 @@ static int __init cpg_mssr_common_init(struct device *dev,
 	if (error)
 		goto out_err;
 
+	cpg_mssr_priv = priv;
+
 	return 0;
 
 out_err:
-- 
2.39.2



