Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9116F5EA20B
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237234AbiIZLBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237432AbiIZK7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:59:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1AF5C9E1;
        Mon, 26 Sep 2022 03:31:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43E34B80835;
        Mon, 26 Sep 2022 10:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932A8C433C1;
        Mon, 26 Sep 2022 10:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188190;
        bh=ER3mexkbJMYny8HTxGhK3/B5gxon5l23I0zwMGyFQzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7NSrhANiRY7MTit5z4pUccUTqL66hUqdIPYaW0TV4uHCGhS+Ds+EVeyjNH74O5Wm
         gz6AwPFtyw0SOtaazAIkpm+WFl1gt0JXU+AqgymOMUNCIsKUx7bV66siPKFAIwwys2
         +489m+PPqW8Do/QTzg0MjtjHj3F2J0nKYbuaQn+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/141] netfilter: nfnetlink_osf: fix possible bogus match in nf_osf_find()
Date:   Mon, 26 Sep 2022 12:11:36 +0200
Message-Id: <20220926100756.970645849@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 559c36c5a8d730c49ef805a72b213d3bba155cc8 ]

nf_osf_find() incorrectly returns true on mismatch, this leads to
copying uninitialized memory area in nft_osf which can be used to leak
stale kernel stack data to userspace.

Fixes: 22c7652cdaa8 ("netfilter: nft_osf: Add version option support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_osf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 79fbf37291f3..51e3953b414c 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -269,6 +269,7 @@ bool nf_osf_find(const struct sk_buff *skb,
 	struct nf_osf_hdr_ctx ctx;
 	const struct tcphdr *tcp;
 	struct tcphdr _tcph;
+	bool found = false;
 
 	memset(&ctx, 0, sizeof(ctx));
 
@@ -283,10 +284,11 @@ bool nf_osf_find(const struct sk_buff *skb,
 
 		data->genre = f->genre;
 		data->version = f->version;
+		found = true;
 		break;
 	}
 
-	return true;
+	return found;
 }
 EXPORT_SYMBOL_GPL(nf_osf_find);
 
-- 
2.35.1



