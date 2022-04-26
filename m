Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFD6550F6A5
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiDZI55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345876AbiDZI4r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:56:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FEA8165C;
        Tue, 26 Apr 2022 01:41:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A1268CE1BD5;
        Tue, 26 Apr 2022 08:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814F8C385A4;
        Tue, 26 Apr 2022 08:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962486;
        bh=DYSNSp8iRym2lE5Nit1dl1dGlcB1989Le7U+aRqnevo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BT9D6odXqQ5GVAEjr4LsFXSGYYIsPy8COehUGh8JN45JCIksRCdMaK9He63U9L0xv
         GhbC6vgtLu19Uacqnwm2q20FatqaCN3cBs/PH+6mbmDUz9cQNeHmSn5Jhm8/kbl2sl
         H5rNsmqDGNiRiJR0zmC4FTHPiFu9xJkmtSQf0jtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 112/124] netfilter: conntrack: avoid useless indirection during conntrack destruction
Date:   Tue, 26 Apr 2022 10:21:53 +0200
Message-Id: <20220426081750.477069275@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 6ae7989c9af0d98ab64196f4f4c6f6499454bd23 upstream.

nf_ct_put() results in a usesless indirection:

nf_ct_put -> nf_conntrack_put -> nf_conntrack_destroy -> rcu readlock +
indirect call of ct_hooks->destroy().

There are two _put helpers:
nf_ct_put and nf_conntrack_put.  The latter is what should be used in
code that MUST NOT cause a linker dependency on the conntrack module
(e.g. calls from core network stack).

Everyone else should call nf_ct_put() instead.

A followup patch will convert a few nf_conntrack_put() calls to
nf_ct_put(), in particular from modules that already have a conntrack
dependency such as act_ct or even nf_conntrack itself.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netfilter/nf_conntrack_common.h |    2 ++
 include/net/netfilter/nf_conntrack.h          |    8 ++++++--
 net/netfilter/nf_conntrack_core.c             |   12 ++++++------
 3 files changed, 14 insertions(+), 8 deletions(-)

--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -29,6 +29,8 @@ struct nf_conntrack {
 };
 
 void nf_conntrack_destroy(struct nf_conntrack *nfct);
+
+/* like nf_ct_put, but without module dependency on nf_conntrack */
 static inline void nf_conntrack_put(struct nf_conntrack *nfct)
 {
 	if (nfct && refcount_dec_and_test(&nfct->use))
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -76,6 +76,8 @@ struct nf_conn {
 	 * Hint, SKB address this struct and refcnt via skb->_nfct and
 	 * helpers nf_conntrack_get() and nf_conntrack_put().
 	 * Helper nf_ct_put() equals nf_conntrack_put() by dec refcnt,
+	 * except that the latter uses internal indirection and does not
+	 * result in a conntrack module dependency.
 	 * beware nf_ct_get() is different and don't inc refcnt.
 	 */
 	struct nf_conntrack ct_general;
@@ -169,11 +171,13 @@ nf_ct_get(const struct sk_buff *skb, enu
 	return (struct nf_conn *)(nfct & NFCT_PTRMASK);
 }
 
+void nf_ct_destroy(struct nf_conntrack *nfct);
+
 /* decrement reference count on a conntrack */
 static inline void nf_ct_put(struct nf_conn *ct)
 {
-	WARN_ON(!ct);
-	nf_conntrack_put(&ct->ct_general);
+	if (ct && refcount_dec_and_test(&ct->ct_general.use))
+		nf_ct_destroy(&ct->ct_general);
 }
 
 /* Protocol module loading */
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -571,7 +571,7 @@ static void nf_ct_del_from_dying_or_unco
 
 #define NFCT_ALIGN(len)	(((len) + NFCT_INFOMASK) & ~NFCT_INFOMASK)
 
-/* Released via destroy_conntrack() */
+/* Released via nf_ct_destroy() */
 struct nf_conn *nf_ct_tmpl_alloc(struct net *net,
 				 const struct nf_conntrack_zone *zone,
 				 gfp_t flags)
@@ -625,12 +625,11 @@ static void destroy_gre_conntrack(struct
 #endif
 }
 
-static void
-destroy_conntrack(struct nf_conntrack *nfct)
+void nf_ct_destroy(struct nf_conntrack *nfct)
 {
 	struct nf_conn *ct = (struct nf_conn *)nfct;
 
-	pr_debug("destroy_conntrack(%p)\n", ct);
+	pr_debug("%s(%p)\n", __func__, ct);
 	WARN_ON(refcount_read(&nfct->use) != 0);
 
 	if (unlikely(nf_ct_is_template(ct))) {
@@ -656,9 +655,10 @@ destroy_conntrack(struct nf_conntrack *n
 	if (ct->master)
 		nf_ct_put(ct->master);
 
-	pr_debug("destroy_conntrack: returning ct=%p to slab\n", ct);
+	pr_debug("%s: returning ct=%p to slab\n", __func__, ct);
 	nf_conntrack_free(ct);
 }
+EXPORT_SYMBOL(nf_ct_destroy);
 
 static void nf_ct_delete_from_lists(struct nf_conn *ct)
 {
@@ -2825,7 +2825,7 @@ err_cachep:
 
 static struct nf_ct_hook nf_conntrack_hook = {
 	.update		= nf_conntrack_update,
-	.destroy	= destroy_conntrack,
+	.destroy	= nf_ct_destroy,
 	.get_tuple_skb  = nf_conntrack_get_tuple_skb,
 };
 


