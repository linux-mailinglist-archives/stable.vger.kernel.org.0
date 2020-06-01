Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235FD1EAAB4
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730297AbgFASKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:10:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729773AbgFASKg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:10:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00E6220825;
        Mon,  1 Jun 2020 18:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035035;
        bh=4UhJldZD0Eevpz5WBeIfMgikOVwXHoQKBYBYJ8uQUZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kw3qSAV56Q74Oa69+OQTHH0S/2+EuKIMRct52ymwYc36OyrbkcfVKahSH8dA5tRI4
         +CJMQIrfvPibApRSzpLZNXfqK40ImbI15imthcHDtU498S16i70Kjh944WiK/WWs61
         cHwPeyGs++uFisNv+ck98z3ATJ79r3Ncsx47ufyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 123/142] netfilter: conntrack: make conntrack userspace helpers work again
Date:   Mon,  1 Jun 2020 19:54:41 +0200
Message-Id: <20200601174050.546749690@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit ee04805ff54a63ffd90bc6749ebfe73473734ddb upstream.

Florian Westphal says:

"Problem is that after the helper hook was merged back into the confirm
one, the queueing itself occurs from the confirm hook, i.e. we queue
from the last netfilter callback in the hook-list.

Therefore, on return, the packet bypasses the confirm action and the
connection is never committed to the main conntrack table.

To fix this there are several ways:
1. revert the 'Fixes' commit and have a extra helper hook again.
   Works, but has the drawback of adding another indirect call for
   everyone.

2. Special case this: split the hooks only when userspace helper
   gets added, so queueing occurs at a lower priority again,
   and normal enqueue reinject would eventually call the last hook.

3. Extend the existing nf_queue ct update hook to allow a forced
   confirmation (plus run the seqadj code).

This goes for 3)."

Fixes: 827318feb69cb ("netfilter: conntrack: remove helper hook again")
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_conntrack_core.c |   78 +++++++++++++++++++++++++++++++++++---
 1 file changed, 72 insertions(+), 6 deletions(-)

--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1879,22 +1879,18 @@ static void nf_conntrack_attach(struct s
 	nf_conntrack_get(skb_nfct(nskb));
 }
 
-static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
+static int __nf_conntrack_update(struct net *net, struct sk_buff *skb,
+				 struct nf_conn *ct)
 {
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_tuple tuple;
 	enum ip_conntrack_info ctinfo;
 	struct nf_nat_hook *nat_hook;
 	unsigned int status;
-	struct nf_conn *ct;
 	int dataoff;
 	u16 l3num;
 	u8 l4num;
 
-	ct = nf_ct_get(skb, &ctinfo);
-	if (!ct || nf_ct_is_confirmed(ct))
-		return 0;
-
 	l3num = nf_ct_l3num(ct);
 
 	dataoff = get_l4proto(skb, skb_network_offset(skb), l3num, &l4num);
@@ -1951,6 +1947,76 @@ static int nf_conntrack_update(struct ne
 	return 0;
 }
 
+/* This packet is coming from userspace via nf_queue, complete the packet
+ * processing after the helper invocation in nf_confirm().
+ */
+static int nf_confirm_cthelper(struct sk_buff *skb, struct nf_conn *ct,
+			       enum ip_conntrack_info ctinfo)
+{
+	const struct nf_conntrack_helper *helper;
+	const struct nf_conn_help *help;
+	unsigned int protoff;
+
+	help = nfct_help(ct);
+	if (!help)
+		return 0;
+
+	helper = rcu_dereference(help->helper);
+	if (!(helper->flags & NF_CT_HELPER_F_USERSPACE))
+		return 0;
+
+	switch (nf_ct_l3num(ct)) {
+	case NFPROTO_IPV4:
+		protoff = skb_network_offset(skb) + ip_hdrlen(skb);
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case NFPROTO_IPV6: {
+		__be16 frag_off;
+		u8 pnum;
+
+		pnum = ipv6_hdr(skb)->nexthdr;
+		protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum,
+					   &frag_off);
+		if (protoff < 0 || (frag_off & htons(~0x7)) != 0)
+			return 0;
+		break;
+	}
+#endif
+	default:
+		return 0;
+	}
+
+	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
+	    !nf_is_loopback_packet(skb)) {
+		if (!nf_ct_seq_adjust(skb, ct, ctinfo, protoff)) {
+			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
+			return -1;
+		}
+	}
+
+	/* We've seen it coming out the other side: confirm it */
+	return nf_conntrack_confirm(skb) == NF_DROP ? - 1 : 0;
+}
+
+static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
+{
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+	int err;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct)
+		return 0;
+
+	if (!nf_ct_is_confirmed(ct)) {
+		err = __nf_conntrack_update(net, skb, ct);
+		if (err < 0)
+			return err;
+	}
+
+	return nf_confirm_cthelper(skb, ct, ctinfo);
+}
+
 static bool nf_conntrack_get_tuple_skb(struct nf_conntrack_tuple *dst_tuple,
 				       const struct sk_buff *skb)
 {


