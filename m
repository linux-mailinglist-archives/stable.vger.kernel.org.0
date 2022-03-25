Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBA4F4E7196
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 11:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237842AbiCYKv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 06:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350064AbiCYKvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 06:51:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CE523BFF
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 03:49:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82C79B827FA
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 10:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F56C340E9;
        Fri, 25 Mar 2022 10:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648205376;
        bh=jruBhoo+1hlqluEuStAroa+gjrJLPhmNP02ZLfjFOsI=;
        h=Subject:To:Cc:From:Date:From;
        b=Ppvtv5NemiVsnQKm7i3LnXCoM8KxFtCUPlINR9jsYMfvk+z07slUyEL9abPL1ielL
         TrGv4/JOzsfjKxiQMeLp5RceqfXXwNG8yB5jYm7dAtw3e84Vikvji8zHCrbMPaHIEW
         1gRxQZk2iYc3okDZai9KXE86W3JsGesg4I+gLq4g=
Subject: FAILED: patch "[PATCH] netfilter: nf_tables: validate registers coming from" failed to apply to 5.10-stable tree
To:     pablo@netfilter.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Mar 2022 11:49:33 +0100
Message-ID: <1648205373120221@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6e1acfa387b9ff82cfc7db8cc3b6959221a95851 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 17 Mar 2022 11:59:26 +0100
Subject: [PATCH] netfilter: nf_tables: validate registers coming from
 userspace.

Bail out in case userspace uses unsupported registers.

Fixes: 49499c3e6e18 ("netfilter: nf_tables: switch registers to 32 bit addressing")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d71a33ae39b3..1f5a0eece0d1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9275,17 +9275,23 @@ int nft_parse_u32_check(const struct nlattr *attr, int max, u32 *dest)
 }
 EXPORT_SYMBOL_GPL(nft_parse_u32_check);
 
-static unsigned int nft_parse_register(const struct nlattr *attr)
+static unsigned int nft_parse_register(const struct nlattr *attr, u32 *preg)
 {
 	unsigned int reg;
 
 	reg = ntohl(nla_get_be32(attr));
 	switch (reg) {
 	case NFT_REG_VERDICT...NFT_REG_4:
-		return reg * NFT_REG_SIZE / NFT_REG32_SIZE;
+		*preg = reg * NFT_REG_SIZE / NFT_REG32_SIZE;
+		break;
+	case NFT_REG32_00...NFT_REG32_15:
+		*preg = reg + NFT_REG_SIZE / NFT_REG32_SIZE - NFT_REG32_00;
+		break;
 	default:
-		return reg + NFT_REG_SIZE / NFT_REG32_SIZE - NFT_REG32_00;
+		return -ERANGE;
 	}
+
+	return 0;
 }
 
 /**
@@ -9327,7 +9333,10 @@ int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len)
 	u32 reg;
 	int err;
 
-	reg = nft_parse_register(attr);
+	err = nft_parse_register(attr, &reg);
+	if (err < 0)
+		return err;
+
 	err = nft_validate_register_load(reg, len);
 	if (err < 0)
 		return err;
@@ -9382,7 +9391,10 @@ int nft_parse_register_store(const struct nft_ctx *ctx,
 	int err;
 	u32 reg;
 
-	reg = nft_parse_register(attr);
+	err = nft_parse_register(attr, &reg);
+	if (err < 0)
+		return err;
+
 	err = nft_validate_register_store(ctx, reg, data, type, len);
 	if (err < 0)
 		return err;

