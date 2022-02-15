Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A37E4B70BB
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbiBOPdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:33:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240375AbiBOPcI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:32:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551CEBF52F;
        Tue, 15 Feb 2022 07:30:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18312B8185B;
        Tue, 15 Feb 2022 15:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1798C340ED;
        Tue, 15 Feb 2022 15:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644939001;
        bh=C9+r6K9CKqbLGqkt3mB9J/OJvtR9LupLVAs5w8dtfXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hl0qLasJXZ/1DAqE9qMFWVb1sUyaxK1Zq27nFnHY4Hixeuzj2yCc/1qQ4BQSe4HFn
         KBkyBhShQrALpIzP8LZByHGeTZzPSjXPzEFbrBDIbPRbyWtC+19nebGlEybZRjOomu
         RV5gvsz6Ls0y4S+KZOr/lGbm2LhIekQDYOtn7CnAlYer7CKhA2f9UruPU5Z4dzhwd7
         uPLDLU49C1h/iisI9cOUiHTY6tG03RNsr/1yBC/CpMwPXxiHFp+NjYlUqswuiE0qvV
         uaUwLkaMuj6vVPjCh2l2OL4z/KLLPPsjWvMLXibnFQeJWkZE2I5Kk6u9O1xbqhYPZ0
         r9/mst7QHVx7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Guojin <ye.guojin@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 02/23] ARM: OMAP2+: adjust the location of put_device() call in omapdss_init_of
Date:   Tue, 15 Feb 2022 10:29:36 -0500
Message-Id: <20220215152957.581303-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215152957.581303-1-sashal@kernel.org>
References: <20220215152957.581303-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Guojin <ye.guojin@zte.com.cn>

[ Upstream commit 34596ba380b03d181e24efd50e2f21045bde3696 ]

This was found by coccicheck:
./arch/arm/mach-omap2/display.c, 272, 1-7, ERROR missing put_device;
call of_find_device_by_node on line 258, but without a corresponding
object release within this function.

Move the put_device() call before the if judgment.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Ye Guojin <ye.guojin@zte.com.cn>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/display.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/display.c b/arch/arm/mach-omap2/display.c
index 2000fca6bd4e6..6098666e928d0 100644
--- a/arch/arm/mach-omap2/display.c
+++ b/arch/arm/mach-omap2/display.c
@@ -263,9 +263,9 @@ static int __init omapdss_init_of(void)
 	}
 
 	r = of_platform_populate(node, NULL, NULL, &pdev->dev);
+	put_device(&pdev->dev);
 	if (r) {
 		pr_err("Unable to populate DSS submodule devices\n");
-		put_device(&pdev->dev);
 		return r;
 	}
 
-- 
2.34.1

