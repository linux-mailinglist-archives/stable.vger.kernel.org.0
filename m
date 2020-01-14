Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2E4913A695
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732971AbgANKMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:12:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:48616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732970AbgANKMV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:12:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80B5320678;
        Tue, 14 Jan 2020 10:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996741;
        bh=yv6Xm0dPM6fPLiIkYnk+bsptA0BWa59tQ/ddJJ+oGp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xaZmofToBUrJhMIj6um1yYw/8qmRyAO0c3f/Fp/dKaqVkB3wUJNQAj2bF89/6vLHp
         VqgqRTwh1euyIl6ySlP/RJbbSxir/wHm/BINsW5gBFWVsMBBurg0RboXOtUhN+6Tl8
         wfVidpRS5DXkVb9P/T5PshtPSFNLkCSWkhYINrQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d7358a458d8a81aee898@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.9 30/31] netfilter: arp_tables: init netns pointer in xt_tgchk_param struct
Date:   Tue, 14 Jan 2020 11:02:22 +0100
Message-Id: <20200114094345.638189497@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094334.725604663@linuxfoundation.org>
References: <20200114094334.725604663@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 1b789577f655060d98d20ed0c6f9fbd469d6ba63 upstream.

We get crash when the targets checkentry function tries to make
use of the network namespace pointer for arptables.

When the net pointer got added back in 2010, only ip/ip6/ebtables were
changed to initialize it, so arptables has this set to NULL.

This isn't a problem for normal arptables because no existing
arptables target has a checkentry function that makes use of par->net.

However, direct users of the setsockopt interface can provide any
target they want as long as its registered for ARP or UNPSEC protocols.

syzkaller managed to send a semi-valid arptables rule for RATEEST target
which is enough to trigger NULL deref:

kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
RIP: xt_rateest_tg_checkentry+0x11d/0xb40 net/netfilter/xt_RATEEST.c:109
[..]
 xt_check_target+0x283/0x690 net/netfilter/x_tables.c:1019
 check_target net/ipv4/netfilter/arp_tables.c:399 [inline]
 find_check_entry net/ipv4/netfilter/arp_tables.c:422 [inline]
 translate_table+0x1005/0x1d70 net/ipv4/netfilter/arp_tables.c:572
 do_replace net/ipv4/netfilter/arp_tables.c:977 [inline]
 do_arpt_set_ctl+0x310/0x640 net/ipv4/netfilter/arp_tables.c:1456

Fixes: add67461240c1d ("netfilter: add struct net * to target parameters")
Reported-by: syzbot+d7358a458d8a81aee898@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/netfilter/arp_tables.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -403,10 +403,11 @@ next:		;
 	return 1;
 }
 
-static inline int check_target(struct arpt_entry *e, const char *name)
+static int check_target(struct arpt_entry *e, struct net *net, const char *name)
 {
 	struct xt_entry_target *t = arpt_get_target(e);
 	struct xt_tgchk_param par = {
+		.net       = net,
 		.table     = name,
 		.entryinfo = e,
 		.target    = t->u.kernel.target,
@@ -418,8 +419,9 @@ static inline int check_target(struct ar
 	return xt_check_target(&par, t->u.target_size - sizeof(*t), 0, false);
 }
 
-static inline int
-find_check_entry(struct arpt_entry *e, const char *name, unsigned int size,
+static int
+find_check_entry(struct arpt_entry *e, struct net *net, const char *name,
+		 unsigned int size,
 		 struct xt_percpu_counter_alloc_state *alloc_state)
 {
 	struct xt_entry_target *t;
@@ -438,7 +440,7 @@ find_check_entry(struct arpt_entry *e, c
 	}
 	t->u.kernel.target = target;
 
-	ret = check_target(e, name);
+	ret = check_target(e, net, name);
 	if (ret)
 		goto err;
 	return 0;
@@ -531,7 +533,9 @@ static inline void cleanup_entry(struct
 /* Checks and translates the user-supplied table segment (held in
  * newinfo).
  */
-static int translate_table(struct xt_table_info *newinfo, void *entry0,
+static int translate_table(struct net *net,
+			   struct xt_table_info *newinfo,
+			   void *entry0,
 			   const struct arpt_replace *repl)
 {
 	struct xt_percpu_counter_alloc_state alloc_state = { 0 };
@@ -597,7 +601,7 @@ static int translate_table(struct xt_tab
 	/* Finally, each sanity check must pass */
 	i = 0;
 	xt_entry_foreach(iter, entry0, newinfo->size) {
-		ret = find_check_entry(iter, repl->name, repl->size,
+		ret = find_check_entry(iter, net, repl->name, repl->size,
 				       &alloc_state);
 		if (ret != 0)
 			break;
@@ -987,7 +991,7 @@ static int do_replace(struct net *net, c
 		goto free_newinfo;
 	}
 
-	ret = translate_table(newinfo, loc_cpu_entry, &tmp);
+	ret = translate_table(net, newinfo, loc_cpu_entry, &tmp);
 	if (ret != 0)
 		goto free_newinfo;
 
@@ -1164,7 +1168,8 @@ compat_copy_entry_from_user(struct compa
 	}
 }
 
-static int translate_compat_table(struct xt_table_info **pinfo,
+static int translate_compat_table(struct net *net,
+				  struct xt_table_info **pinfo,
 				  void **pentry0,
 				  const struct compat_arpt_replace *compatr)
 {
@@ -1230,7 +1235,7 @@ static int translate_compat_table(struct
 	repl.num_counters = 0;
 	repl.counters = NULL;
 	repl.size = newinfo->size;
-	ret = translate_table(newinfo, entry1, &repl);
+	ret = translate_table(net, newinfo, entry1, &repl);
 	if (ret)
 		goto free_newinfo;
 
@@ -1283,7 +1288,7 @@ static int compat_do_replace(struct net
 		goto free_newinfo;
 	}
 
-	ret = translate_compat_table(&newinfo, &loc_cpu_entry, &tmp);
+	ret = translate_compat_table(net, &newinfo, &loc_cpu_entry, &tmp);
 	if (ret != 0)
 		goto free_newinfo;
 
@@ -1559,7 +1564,7 @@ int arpt_register_table(struct net *net,
 	loc_cpu_entry = newinfo->entries;
 	memcpy(loc_cpu_entry, repl->entries, repl->size);
 
-	ret = translate_table(newinfo, loc_cpu_entry, repl);
+	ret = translate_table(net, newinfo, loc_cpu_entry, repl);
 	if (ret != 0)
 		goto out_free;
 


