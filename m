Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C1F1B6882
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgDWXPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:15:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49652 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728403AbgDWXGr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:47 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvT-0004he-Rm; Fri, 24 Apr 2020 00:06:35 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvS-00E6qX-1i; Fri, 24 Apr 2020 00:06:34 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        syzbot+d7358a458d8a81aee898@syzkaller.appspotmail.com,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        "Florian Westphal" <fw@strlen.de>,
        "Cong Wang" <xiyou.wangcong@gmail.com>
Date:   Fri, 24 Apr 2020 00:06:10 +0100
Message-ID: <lsq.1587683028.973228933@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 143/245] netfilter: arp_tables: init netns pointer in
 xt_tgchk_param struct
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
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/netfilter/arp_tables.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -480,11 +480,12 @@ static int mark_source_chains(const stru
 	return 1;
 }
 
-static inline int check_target(struct arpt_entry *e, const char *name)
+static int check_target(struct arpt_entry *e, struct net *net, const char *name)
 {
 	struct xt_entry_target *t = arpt_get_target(e);
 	int ret;
 	struct xt_tgchk_param par = {
+		.net       = net,
 		.table     = name,
 		.entryinfo = e,
 		.target    = t->u.kernel.target,
@@ -502,8 +503,9 @@ static inline int check_target(struct ar
 	return 0;
 }
 
-static inline int
-find_check_entry(struct arpt_entry *e, const char *name, unsigned int size)
+static int
+find_check_entry(struct arpt_entry *e, struct net *net, const char *name,
+		 unsigned int size)
 {
 	struct xt_entry_target *t;
 	struct xt_target *target;
@@ -519,7 +521,7 @@ find_check_entry(struct arpt_entry *e, c
 	}
 	t->u.kernel.target = target;
 
-	ret = check_target(e, name);
+	ret = check_target(e, net, name);
 	if (ret)
 		goto err;
 	return 0;
@@ -617,7 +619,9 @@ static inline void cleanup_entry(struct
 /* Checks and translates the user-supplied table segment (held in
  * newinfo).
  */
-static int translate_table(struct xt_table_info *newinfo, void *entry0,
+static int translate_table(struct net *net,
+			   struct xt_table_info *newinfo,
+			   void *entry0,
                            const struct arpt_replace *repl)
 {
 	struct arpt_entry *iter;
@@ -692,7 +696,7 @@ static int translate_table(struct xt_tab
 	/* Finally, each sanity check must pass */
 	i = 0;
 	xt_entry_foreach(iter, entry0, newinfo->size) {
-		ret = find_check_entry(iter, repl->name, repl->size);
+		ret = find_check_entry(iter, net, repl->name, repl->size);
 		if (ret != 0)
 			break;
 		++i;
@@ -1100,7 +1104,7 @@ static int do_replace(struct net *net, c
 		goto free_newinfo;
 	}
 
-	ret = translate_table(newinfo, loc_cpu_entry, &tmp);
+	ret = translate_table(net, newinfo, loc_cpu_entry, &tmp);
 	if (ret != 0)
 		goto free_newinfo;
 
@@ -1287,7 +1291,8 @@ compat_copy_entry_from_user(struct compa
 	}
 }
 
-static int translate_compat_table(struct xt_table_info **pinfo,
+static int translate_compat_table(struct net *net,
+				  struct xt_table_info **pinfo,
 				  void **pentry0,
 				  const struct compat_arpt_replace *compatr)
 {
@@ -1356,7 +1361,7 @@ static int translate_compat_table(struct
 	repl.num_counters = 0;
 	repl.counters = NULL;
 	repl.size = newinfo->size;
-	ret = translate_table(newinfo, entry1, &repl);
+	ret = translate_table(net, newinfo, entry1, &repl);
 	if (ret)
 		goto free_newinfo;
 
@@ -1412,7 +1417,7 @@ static int compat_do_replace(struct net
 		goto free_newinfo;
 	}
 
-	ret = translate_compat_table(&newinfo, &loc_cpu_entry, &tmp);
+	ret = translate_compat_table(net, &newinfo, &loc_cpu_entry, &tmp);
 	if (ret != 0)
 		goto free_newinfo;
 
@@ -1685,7 +1690,7 @@ struct xt_table *arpt_register_table(str
 	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
 	memcpy(loc_cpu_entry, repl->entries, repl->size);
 
-	ret = translate_table(newinfo, loc_cpu_entry, repl);
+	ret = translate_table(net, newinfo, loc_cpu_entry, repl);
 	duprintf("arpt_register_table: translate table gives %d\n", ret);
 	if (ret != 0)
 		goto out_free;

