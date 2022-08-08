Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 266E258C030
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243188AbiHHBst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243141AbiHHBsU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:48:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04BB167EC;
        Sun,  7 Aug 2022 18:37:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 905F560EB5;
        Mon,  8 Aug 2022 01:37:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16925C433D6;
        Mon,  8 Aug 2022 01:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922627;
        bh=uY13mo9qtASTnrLurEscpXAMDs4UVUh1xoWThPdMtxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQrj/6IZANINTSp2BJzqmESCr9Hc1B5UnnRfF1EGZpZaOPRVdGBJXJnsfuQpqyAtF
         c8teL0yG/7tid7392uoL462baxs0w5XTnDB6ud7WcC0YZH46MO5XoeX4iz7WR2j/dK
         0OV5aGTWXGb8iWlVn+2PT1Z2M/naQrpjTOy72lseabkETimap2fS9gALGd5jPFBl+H
         Z8f+xthYqzGP9jyicRlqlRdM07XKtV9MxTrx66+mHbEAlOyvGjaUo3Y8KQNzRa5POe
         0wFFilt28vNLCZMIHnbDaikI2TYjh1S1ONsghqszbWUbpvptmz+wtcETzvd0A24LyA
         j4FGml9zfcneg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 28/45] ARM: OMAP2+: display: Fix refcount leak bug
Date:   Sun,  7 Aug 2022 21:35:32 -0400
Message-Id: <20220808013551.315446-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013551.315446-1-sashal@kernel.org>
References: <20220808013551.315446-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 50b87a32a79bca6e275918a711fb8cc55e16d739 ]

In omapdss_init_fbdev(), of_find_node_by_name() will return a node
pointer with refcount incremented. We should use of_node_put() when
it is not used anymore.

Signed-off-by: Liang He <windhl@126.com>
Message-Id: <20220617145803.4050918-1-windhl@126.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/display.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap2/display.c b/arch/arm/mach-omap2/display.c
index 21413a9b7b6c..eb09a25e3b45 100644
--- a/arch/arm/mach-omap2/display.c
+++ b/arch/arm/mach-omap2/display.c
@@ -211,6 +211,7 @@ static int __init omapdss_init_fbdev(void)
 	node = of_find_node_by_name(NULL, "omap4_padconf_global");
 	if (node)
 		omap4_dsi_mux_syscon = syscon_node_to_regmap(node);
+	of_node_put(node);
 
 	return 0;
 }
-- 
2.35.1

