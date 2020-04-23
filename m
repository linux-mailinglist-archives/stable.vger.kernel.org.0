Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81AD1B6921
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbgDWXU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:20:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48644 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728224AbgDWXGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:33 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvL-0004bC-Sk; Fri, 24 Apr 2020 00:06:28 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvL-00E6jo-0i; Fri, 24 Apr 2020 00:06:27 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>
Date:   Fri, 24 Apr 2020 00:04:58 +0100
Message-ID: <lsq.1587683028.38144236@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 071/245] netfilter: nf_tables: missing sanitization
 in data from userspace
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 71df14b0ce094be46d105b5a3ededd83b8e779a0 upstream.

Do not assume userspace always sends us NFT_DATA_VALUE for bitwise and
cmp expressions. Although NFT_DATA_VERDICT does not make any sense, it
is still possible to handcraft a netlink message using this incorrect
data type.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/netfilter/nft_bitwise.c | 19 ++++++++++++++-----
 net/netfilter/nft_cmp.c     | 12 ++++++++++--
 2 files changed, 24 insertions(+), 7 deletions(-)

--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -86,16 +86,25 @@ static int nft_bitwise_init(const struct
 	err = nft_data_init(NULL, &priv->mask, &d1, tb[NFTA_BITWISE_MASK]);
 	if (err < 0)
 		return err;
-	if (d1.len != priv->len)
-		return -EINVAL;
+	if (d1.len != priv->len) {
+		err = -EINVAL;
+		goto err1;
+	}
 
 	err = nft_data_init(NULL, &priv->xor, &d2, tb[NFTA_BITWISE_XOR]);
 	if (err < 0)
-		return err;
-	if (d2.len != priv->len)
-		return -EINVAL;
+		goto err1;
+	if (d2.len != priv->len) {
+		err = -EINVAL;
+		goto err2;
+	}
 
 	return 0;
+err2:
+	nft_data_uninit(&priv->xor, d2.type);
+err1:
+	nft_data_uninit(&priv->mask, d1.type);
+	return err;
 }
 
 static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -201,10 +201,18 @@ nft_cmp_select_ops(const struct nft_ctx
 	if (err < 0)
 		return ERR_PTR(err);
 
+	if (desc.type != NFT_DATA_VALUE) {
+		err = -EINVAL;
+		goto err1;
+	}
+
 	if (desc.len <= sizeof(u32) && op == NFT_CMP_EQ)
 		return &nft_cmp_fast_ops;
-	else
-		return &nft_cmp_ops;
+
+	return &nft_cmp_ops;
+err1:
+	nft_data_uninit(&data, desc.type);
+	return ERR_PTR(-EINVAL);
 }
 
 static struct nft_expr_type nft_cmp_type __read_mostly = {

