Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D094E7623
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240859AbiCYPLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359787AbiCYPKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:10:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE8C6273;
        Fri, 25 Mar 2022 08:08:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C390E61C1A;
        Fri, 25 Mar 2022 15:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47BDC340E9;
        Fri, 25 Mar 2022 15:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648220885;
        bh=KFdJg0u0Ss3Tzkf16u9n79i+nKiZd4QsLL/5VaEmHS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RVg0PrlnkAUGtyOTEKDYRs9pdtyq5fmxcEw5GBN6XJJDgT8a3AuxJnW7ckH+ejGHA
         K7ZNo1q8Vou4FuV6R8WXz8Jn0W3UP6LLy+P7RRpQN+mTPCpCMUsAqHhtCSJQDghJGA
         aEocbyAyatVZsoILjihyq8D3VN7caok8cCKDkQQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 21/29] netfilter: nf_tables: initialize registers in nft_do_chain()
Date:   Fri, 25 Mar 2022 16:05:01 +0100
Message-Id: <20220325150419.196662736@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150418.585286754@linuxfoundation.org>
References: <20220325150418.585286754@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 4c905f6740a365464e91467aa50916555b28213d upstream.

Initialize registers to avoid stack leak into userspace.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -153,7 +153,7 @@ nft_do_chain(struct nft_pktinfo *pkt, vo
 	struct nft_rule *const *rules;
 	const struct nft_rule *rule;
 	const struct nft_expr *expr, *last;
-	struct nft_regs regs;
+	struct nft_regs regs = {};
 	unsigned int stackptr = 0;
 	struct nft_jumpstack jumpstack[NFT_JUMP_STACK_SIZE];
 	bool genbit = READ_ONCE(net->nft.gencursor);


