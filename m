Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2595A4125CE
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384663AbhITSsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:48:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1384093AbhITSqc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:46:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12C9C61AFF;
        Mon, 20 Sep 2021 17:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159211;
        bh=ZCZentaYvttHyVpUHqXCyKjD3G7Jr3hrZo83sk2KXrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yuBw+nfAyfOzb5R7albdsV25zJMbznfqv+i5s73HgQE3lKFI3Zfk7BP+L1oBOOD08
         YQU/NR9aufbOauqGFNlst6ZOZo1cFgSPNPmrSb5hbx8OBvEWBpWPJjvJLawI859UH+
         Ot/8Gq+GKWvdK8P31E1kyJe992urumyAZTg9sorA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com
Subject: [PATCH 5.14 126/168] netfilter: nft_ct: protect nft_ct_pcpu_template_refcnt with mutex
Date:   Mon, 20 Sep 2021 18:44:24 +0200
Message-Id: <20210920163925.807638253@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit e3245a7b7b34bd2e97f744fd79463add6e9d41f4 ]

Syzbot hit use-after-free in nf_tables_dump_sets. The problem was in
missing lock protection for nft_ct_pcpu_template_refcnt.

Before commit f102d66b335a ("netfilter: nf_tables: use dedicated
mutex to guard transactions") all transactions were serialized by global
mutex, but then global mutex was changed to local per netnamespace
commit_mutex.

This change causes use-after-free bug, when 2 netnamespaces concurently
changing nft_ct_pcpu_template_refcnt without proper locking. Fix it by
adding nft_ct_pcpu_mutex and protect all nft_ct_pcpu_template_refcnt
changes with it.

Fixes: f102d66b335a ("netfilter: nf_tables: use dedicated mutex to guard transactions")
Reported-and-tested-by: syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_ct.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 337e22d8b40b..99b1de14ff7e 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -41,6 +41,7 @@ struct nft_ct_helper_obj  {
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 static DEFINE_PER_CPU(struct nf_conn *, nft_ct_pcpu_template);
 static unsigned int nft_ct_pcpu_template_refcnt __read_mostly;
+static DEFINE_MUTEX(nft_ct_pcpu_mutex);
 #endif
 
 static u64 nft_ct_get_eval_counter(const struct nf_conn_counter *c,
@@ -525,8 +526,10 @@ static void __nft_ct_set_destroy(const struct nft_ctx *ctx, struct nft_ct *priv)
 #endif
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	case NFT_CT_ZONE:
+		mutex_lock(&nft_ct_pcpu_mutex);
 		if (--nft_ct_pcpu_template_refcnt == 0)
 			nft_ct_tmpl_put_pcpu();
+		mutex_unlock(&nft_ct_pcpu_mutex);
 		break;
 #endif
 	default:
@@ -564,9 +567,13 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 #endif
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	case NFT_CT_ZONE:
-		if (!nft_ct_tmpl_alloc_pcpu())
+		mutex_lock(&nft_ct_pcpu_mutex);
+		if (!nft_ct_tmpl_alloc_pcpu()) {
+			mutex_unlock(&nft_ct_pcpu_mutex);
 			return -ENOMEM;
+		}
 		nft_ct_pcpu_template_refcnt++;
+		mutex_unlock(&nft_ct_pcpu_mutex);
 		len = sizeof(u16);
 		break;
 #endif
-- 
2.30.2



