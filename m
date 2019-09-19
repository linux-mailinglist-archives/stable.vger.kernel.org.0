Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 731BDB84B1
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406026AbfISWNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:13:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393731AbfISWNN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:13:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D99D21924;
        Thu, 19 Sep 2019 22:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931192;
        bh=f37VyrfJ+6B8a1BBEwyKuj1RitCm1kFr2ZZwpsJCCW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ll/URLjw4blxByFShrC4qYkdsrq92B0NJvcZKgKtE87YGBrUoxBCsufHjwmnHKlqX
         XHa4ZbKRGYrpIHq/0zet0Ks5khfOP1r4EwerRadUmNHCGOHuGKYMW8rQBIL65h2LUA
         O+W7WuQTzCL6sAnHggbnleHtVw8cXsIK0vkk91tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 35/79] netfilter: xt_nfacct: Fix alignment mismatch in xt_nfacct_match_info
Date:   Fri, 20 Sep 2019 00:03:20 +0200
Message-Id: <20190919214810.818333331@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214807.612593061@linuxfoundation.org>
References: <20190919214807.612593061@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>

[ Upstream commit 89a26cd4b501e9511d3cd3d22327fc76a75a38b3 ]

When running a 64-bit kernel with a 32-bit iptables binary, the size of
the xt_nfacct_match_info struct diverges.

    kernel: sizeof(struct xt_nfacct_match_info) : 40
    iptables: sizeof(struct xt_nfacct_match_info)) : 36

Trying to append nfacct related rules results in an unhelpful message.
Although it is suggested to look for more information in dmesg, nothing
can be found there.

    # iptables -A <chain> -m nfacct --nfacct-name <acct-object>
    iptables: Invalid argument. Run `dmesg' for more information.

This patch fixes the memory misalignment by enforcing 8-byte alignment
within the struct's first revision. This solution is often used in many
other uapi netfilter headers.

Signed-off-by: Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/netfilter/xt_nfacct.h |  5 ++++
 net/netfilter/xt_nfacct.c                | 36 ++++++++++++++++--------
 2 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_nfacct.h b/include/uapi/linux/netfilter/xt_nfacct.h
index 5c8a4d760ee34..b5123ab8d54a8 100644
--- a/include/uapi/linux/netfilter/xt_nfacct.h
+++ b/include/uapi/linux/netfilter/xt_nfacct.h
@@ -11,4 +11,9 @@ struct xt_nfacct_match_info {
 	struct nf_acct	*nfacct;
 };
 
+struct xt_nfacct_match_info_v1 {
+	char		name[NFACCT_NAME_MAX];
+	struct nf_acct	*nfacct __attribute__((aligned(8)));
+};
+
 #endif /* _XT_NFACCT_MATCH_H */
diff --git a/net/netfilter/xt_nfacct.c b/net/netfilter/xt_nfacct.c
index 6b56f4170860c..3241fee9f2a19 100644
--- a/net/netfilter/xt_nfacct.c
+++ b/net/netfilter/xt_nfacct.c
@@ -57,25 +57,39 @@ nfacct_mt_destroy(const struct xt_mtdtor_param *par)
 	nfnl_acct_put(info->nfacct);
 }
 
-static struct xt_match nfacct_mt_reg __read_mostly = {
-	.name       = "nfacct",
-	.family     = NFPROTO_UNSPEC,
-	.checkentry = nfacct_mt_checkentry,
-	.match      = nfacct_mt,
-	.destroy    = nfacct_mt_destroy,
-	.matchsize  = sizeof(struct xt_nfacct_match_info),
-	.usersize   = offsetof(struct xt_nfacct_match_info, nfacct),
-	.me         = THIS_MODULE,
+static struct xt_match nfacct_mt_reg[] __read_mostly = {
+	{
+		.name       = "nfacct",
+		.revision   = 0,
+		.family     = NFPROTO_UNSPEC,
+		.checkentry = nfacct_mt_checkentry,
+		.match      = nfacct_mt,
+		.destroy    = nfacct_mt_destroy,
+		.matchsize  = sizeof(struct xt_nfacct_match_info),
+		.usersize   = offsetof(struct xt_nfacct_match_info, nfacct),
+		.me         = THIS_MODULE,
+	},
+	{
+		.name       = "nfacct",
+		.revision   = 1,
+		.family     = NFPROTO_UNSPEC,
+		.checkentry = nfacct_mt_checkentry,
+		.match      = nfacct_mt,
+		.destroy    = nfacct_mt_destroy,
+		.matchsize  = sizeof(struct xt_nfacct_match_info_v1),
+		.usersize   = offsetof(struct xt_nfacct_match_info_v1, nfacct),
+		.me         = THIS_MODULE,
+	},
 };
 
 static int __init nfacct_mt_init(void)
 {
-	return xt_register_match(&nfacct_mt_reg);
+	return xt_register_matches(nfacct_mt_reg, ARRAY_SIZE(nfacct_mt_reg));
 }
 
 static void __exit nfacct_mt_exit(void)
 {
-	xt_unregister_match(&nfacct_mt_reg);
+	xt_unregister_matches(nfacct_mt_reg, ARRAY_SIZE(nfacct_mt_reg));
 }
 
 module_init(nfacct_mt_init);
-- 
2.20.1



