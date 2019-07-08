Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4E4A622B0
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389217AbfGHP2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:28:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389210AbfGHP2D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:28:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B7142173C;
        Mon,  8 Jul 2019 15:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599683;
        bh=D5ayUhAsF0VdP8RdtN5yXJViL+YPdWibDMqRp+evdtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kK2HztgxOapYYvRfXtHl9laEsiYMGOHI8j5R69TsdOxJ2ZN5ZswfSvgtEngnyI/7t
         AMe2ZAKuH2yb3S947Ld2Iaqgcc2HTg++5b4dbq4N3k1rt7xkTQb+CWeXMRwFDlGBdc
         wXO0Blr4CM79Qt2dMtREakZ3i9WLPSBazWUHDtIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 06/90] netfilter: nft_flow_offload: dont offload when sequence numbers need adjustment
Date:   Mon,  8 Jul 2019 17:12:33 +0200
Message-Id: <20190708150522.724082827@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 91a9048f238063dde7feea752b9dd386f7e3808b upstream.

We can't deal with tcp sequence number rewrite in flow_offload.
While at it, simplify helper check, we only need to know if the extension
is present, we don't need the helper data.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nft_flow_offload.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -12,7 +12,6 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <net/netfilter/nf_flow_table.h>
-#include <net/netfilter/nf_conntrack_helper.h>
 
 struct nft_flow_offload {
 	struct nft_flowtable	*flowtable;
@@ -67,7 +66,6 @@ static void nft_flow_offload_eval(const
 {
 	struct nft_flow_offload *priv = nft_expr_priv(expr);
 	struct nf_flowtable *flowtable = &priv->flowtable->data;
-	const struct nf_conn_help *help;
 	enum ip_conntrack_info ctinfo;
 	struct nf_flow_route route;
 	struct flow_offload *flow;
@@ -93,8 +91,8 @@ static void nft_flow_offload_eval(const
 		goto out;
 	}
 
-	help = nfct_help(ct);
-	if (help)
+	if (nf_ct_ext_exist(ct, NF_CT_EXT_HELPER) ||
+	    ct->status & IPS_SEQ_ADJUST)
 		goto out;
 
 	if (ctinfo == IP_CT_NEW ||


