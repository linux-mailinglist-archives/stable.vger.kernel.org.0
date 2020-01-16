Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCC713FFF4
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392037AbgAPXqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:46:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729624AbgAPXVs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:21:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D078A2077C;
        Thu, 16 Jan 2020 23:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216908;
        bh=4QuQBs/y2wtwL6SKyn0ignYxYeQE9C0+uY2gTmS+OEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q66Qc8a/TKR8xnb1geFdOgRfdZnhD6EpmBZZjD3mbQzVGJ6ZpBvWU2GTKp9nOClNd
         Mbz62iVC5LiBEmJAUy8Krd7KcTX7AzKFnTKuVFHlTldaCPm03r1HhuTicrsEtxJbkx
         f+ZnuVksLxMWzNpxH+BZkJ7WvusklB+cktpxeO7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 053/203] netfilter: nf_tables_offload: release flow_rule on error from commit path
Date:   Fri, 17 Jan 2020 00:16:10 +0100
Message-Id: <20200116231748.608901770@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 23403cd8898dbc9808d3eb2f63bc1db8a340b751 upstream.

If hardware offload commit path fails, release all flow_rule objects.

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_tables_offload.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -358,14 +358,14 @@ int nft_flow_rule_offload_commit(struct
 				continue;
 
 			if (trans->ctx.flags & NLM_F_REPLACE ||
-			    !(trans->ctx.flags & NLM_F_APPEND))
-				return -EOPNOTSUPP;
-
+			    !(trans->ctx.flags & NLM_F_APPEND)) {
+				err = -EOPNOTSUPP;
+				break;
+			}
 			err = nft_flow_offload_rule(trans->ctx.chain,
 						    nft_trans_rule(trans),
 						    nft_trans_flow_rule(trans),
 						    FLOW_CLS_REPLACE);
-			nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 			break;
 		case NFT_MSG_DELRULE:
 			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
@@ -379,7 +379,23 @@ int nft_flow_rule_offload_commit(struct
 		}
 
 		if (err)
-			return err;
+			break;
+	}
+
+	list_for_each_entry(trans, &net->nft.commit_list, list) {
+		if (trans->ctx.family != NFPROTO_NETDEV)
+			continue;
+
+		switch (trans->msg_type) {
+		case NFT_MSG_NEWRULE:
+			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
+				continue;
+
+			nft_flow_rule_destroy(nft_trans_flow_rule(trans));
+			break;
+		default:
+			break;
+		}
 	}
 
 	return err;


