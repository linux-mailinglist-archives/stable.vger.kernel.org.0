Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D611B67E7
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgDWXKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:10:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50278 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728584AbgDWXGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:52 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkve-0004lg-21; Fri, 24 Apr 2020 00:06:46 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvV-00E6wE-Vo; Fri, 24 Apr 2020 00:06:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        syzbot+91bdd8eece0f6629ec8b@syzkaller.appspotmail.com,
        "Florian Westphal" <fw@strlen.de>
Date:   Fri, 24 Apr 2020 00:06:46 +0100
Message-ID: <lsq.1587683028.298975339@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 179/245] netfilter: arp_tables: init netns pointer in
 xt_tgdtor_param struct
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

commit 212e7f56605ef9688d0846db60c6c6ec06544095 upstream.

An earlier commit (1b789577f655060d98d20e,
"netfilter: arp_tables: init netns pointer in xt_tgchk_param struct")
fixed missing net initialization for arptables, but turns out it was
incomplete.  We can get a very similar struct net NULL deref during
error unwinding:

general protection fault: 0000 [#1] PREEMPT SMP KASAN
RIP: 0010:xt_rateest_put+0xa1/0x440 net/netfilter/xt_RATEEST.c:77
 xt_rateest_tg_destroy+0x72/0xa0 net/netfilter/xt_RATEEST.c:175
 cleanup_entry net/ipv4/netfilter/arp_tables.c:509 [inline]
 translate_table+0x11f4/0x1d80 net/ipv4/netfilter/arp_tables.c:587
 do_replace net/ipv4/netfilter/arp_tables.c:981 [inline]
 do_arpt_set_ctl+0x317/0x650 net/ipv4/netfilter/arp_tables.c:1461

Also init the netns pointer in xt_tgdtor_param struct.

Fixes: add67461240c1d ("netfilter: add struct net * to target parameters")
Reported-by: syzbot+91bdd8eece0f6629ec8b@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[bwh: Backported to 3.16:
 - __arpt_unregister_table() has not been split out of
   arpt_unregister_table()
 - Add "net" parameter to arpt_unregister_table() and update its only
   caller in arptable_filter.c]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -51,7 +51,7 @@ extern void *arpt_alloc_initial_table(co
 extern struct xt_table *arpt_register_table(struct net *net,
 					    const struct xt_table *table,
 					    const struct arpt_replace *repl);
-extern void arpt_unregister_table(struct xt_table *table);
+extern void arpt_unregister_table(struct net *, struct xt_table *table);
 extern unsigned int arpt_do_table(struct sk_buff *skb,
 				  unsigned int hook,
 				  const struct net_device *in,
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -602,12 +602,13 @@ static inline int check_entry_size_and_h
 	return 0;
 }
 
-static inline void cleanup_entry(struct arpt_entry *e)
+static void cleanup_entry(struct arpt_entry *e, struct net *net)
 {
 	struct xt_tgdtor_param par;
 	struct xt_entry_target *t;
 
 	t = arpt_get_target(e);
+	par.net      = net;
 	par.target   = t->u.kernel.target;
 	par.targinfo = t->data;
 	par.family   = NFPROTO_ARP;
@@ -706,7 +707,7 @@ static int translate_table(struct net *n
 		xt_entry_foreach(iter, entry0, newinfo->size) {
 			if (i-- == 0)
 				break;
-			cleanup_entry(iter);
+			cleanup_entry(iter, net);
 		}
 		return ret;
 	}
@@ -1051,7 +1052,7 @@ static int __do_replace(struct net *net,
 	/* Decrease module usage counts and free resource */
 	loc_cpu_old_entry = oldinfo->entries[raw_smp_processor_id()];
 	xt_entry_foreach(iter, loc_cpu_old_entry, oldinfo->size)
-		cleanup_entry(iter);
+		cleanup_entry(iter, net);
 
 	xt_free_table_info(oldinfo);
 	if (copy_to_user(counters_ptr, counters,
@@ -1118,7 +1119,7 @@ static int do_replace(struct net *net, c
 
  free_newinfo_untrans:
 	xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
-		cleanup_entry(iter);
+		cleanup_entry(iter, net);
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
@@ -1431,7 +1432,7 @@ static int compat_do_replace(struct net
 
  free_newinfo_untrans:
 	xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
-		cleanup_entry(iter);
+		cleanup_entry(iter, net);
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
@@ -1708,7 +1709,7 @@ out:
 	return ERR_PTR(ret);
 }
 
-void arpt_unregister_table(struct xt_table *table)
+void arpt_unregister_table(struct net *net, struct xt_table *table)
 {
 	struct xt_table_info *private;
 	void *loc_cpu_entry;
@@ -1720,7 +1721,7 @@ void arpt_unregister_table(struct xt_tab
 	/* Decrease module usage counts and free resources */
 	loc_cpu_entry = private->entries[raw_smp_processor_id()];
 	xt_entry_foreach(iter, loc_cpu_entry, private->size)
-		cleanup_entry(iter);
+		cleanup_entry(iter, net);
 	if (private->number > private->initial_entries)
 		module_put(table_owner);
 	xt_free_table_info(private);
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -54,7 +54,7 @@ static int __net_init arptable_filter_ne
 
 static void __net_exit arptable_filter_net_exit(struct net *net)
 {
-	arpt_unregister_table(net->ipv4.arptable_filter);
+	arpt_unregister_table(net, net->ipv4.arptable_filter);
 }
 
 static struct pernet_operations arptable_filter_net_ops = {

