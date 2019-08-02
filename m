Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8C087F396
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406789AbfHBJ6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406871AbfHBJ5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:57:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2296B20B7C;
        Fri,  2 Aug 2019 09:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739842;
        bh=lpySsXp3nInyhS+g20TznSRkPQDULGp/A/Gs1UqHMSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QhU6t3AlpXL7tDy6W69FRvc+ec7eYpveA+Sv18u2c/h5mFeEhddjLmI5atUUix8Hq
         GYcTEIuTckrCaUqc6dPnwJxH+IL39ZHsXA/ReX4gjtQt/7wrIcmBRluBG2bGGNrV4n
         s2rwu0ySjwJ73ALFmyroZbkfPHjAqjJR1AGczHz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+0165480d4ef07360eeda@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.2 11/20] xfrm: policy: fix bydst hlist corruption on hash rebuild
Date:   Fri,  2 Aug 2019 11:40:05 +0200
Message-Id: <20190802092100.481389776@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092055.131876977@linuxfoundation.org>
References: <20190802092055.131876977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit fd709721352dd5239056eacaded00f2244e6ef58 upstream.

syzbot reported following spat:

BUG: KASAN: use-after-free in __write_once_size include/linux/compiler.h:221
BUG: KASAN: use-after-free in hlist_del_rcu include/linux/rculist.h:455
BUG: KASAN: use-after-free in xfrm_hash_rebuild+0xa0d/0x1000 net/xfrm/xfrm_policy.c:1318
Write of size 8 at addr ffff888095e79c00 by task kworker/1:3/8066
Workqueue: events xfrm_hash_rebuild
Call Trace:
 __write_once_size include/linux/compiler.h:221 [inline]
 hlist_del_rcu include/linux/rculist.h:455 [inline]
 xfrm_hash_rebuild+0xa0d/0x1000 net/xfrm/xfrm_policy.c:1318
 process_one_work+0x814/0x1130 kernel/workqueue.c:2269
Allocated by task 8064:
 __kmalloc+0x23c/0x310 mm/slab.c:3669
 kzalloc include/linux/slab.h:742 [inline]
 xfrm_hash_alloc+0x38/0xe0 net/xfrm/xfrm_hash.c:21
 xfrm_policy_init net/xfrm/xfrm_policy.c:4036 [inline]
 xfrm_net_init+0x269/0xd60 net/xfrm/xfrm_policy.c:4120
 ops_init+0x336/0x420 net/core/net_namespace.c:130
 setup_net+0x212/0x690 net/core/net_namespace.c:316

The faulting address is the address of the old chain head,
free'd by xfrm_hash_resize().

In xfrm_hash_rehash(), chain heads get re-initialized without
any hlist_del_rcu:

 for (i = hmask; i >= 0; i--)
    INIT_HLIST_HEAD(odst + i);

Then, hlist_del_rcu() gets called on the about to-be-reinserted policy
when iterating the per-net list of policies.

hlist_del_rcu() will then make chain->first be nonzero again:

static inline void __hlist_del(struct hlist_node *n)
{
   struct hlist_node *next = n->next;   // address of next element in list
   struct hlist_node **pprev = n->pprev;// location of previous elem, this
                                        // can point at chain->first
        WRITE_ONCE(*pprev, next);       // chain->first points to next elem
        if (next)
                next->pprev = pprev;

Then, when we walk chainlist to find insertion point, we may find a
non-empty list even though we're supposedly reinserting the first
policy to an empty chain.

To fix this first unlink all exact and inexact policies instead of
zeroing the list heads.

Add the commands equivalent to the syzbot reproducer to xfrm_policy.sh,
without fix KASAN catches the corruption as it happens, SLUB poisoning
detects it a bit later.

Reported-by: syzbot+0165480d4ef07360eeda@syzkaller.appspotmail.com
Fixes: 1548bc4e0512 ("xfrm: policy: delete inexact policies from inexact list on hash rebuild")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/xfrm/xfrm_policy.c                     |   12 +++++++-----
 tools/testing/selftests/net/xfrm_policy.sh |   27 ++++++++++++++++++++++++++-
 2 files changed, 33 insertions(+), 6 deletions(-)

--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1280,13 +1280,17 @@ static void xfrm_hash_rebuild(struct wor
 
 		hlist_for_each_entry_safe(policy, n,
 					  &net->xfrm.policy_inexact[dir],
-					  bydst_inexact_list)
+					  bydst_inexact_list) {
+			hlist_del_rcu(&policy->bydst);
 			hlist_del_init(&policy->bydst_inexact_list);
+		}
 
 		hmask = net->xfrm.policy_bydst[dir].hmask;
 		odst = net->xfrm.policy_bydst[dir].table;
-		for (i = hmask; i >= 0; i--)
-			INIT_HLIST_HEAD(odst + i);
+		for (i = hmask; i >= 0; i--) {
+			hlist_for_each_entry_safe(policy, n, odst + i, bydst)
+				hlist_del_rcu(&policy->bydst);
+		}
 		if ((dir & XFRM_POLICY_MASK) == XFRM_POLICY_OUT) {
 			/* dir out => dst = remote, src = local */
 			net->xfrm.policy_bydst[dir].dbits4 = rbits4;
@@ -1315,8 +1319,6 @@ static void xfrm_hash_rebuild(struct wor
 		chain = policy_hash_bysel(net, &policy->selector,
 					  policy->family, dir);
 
-		hlist_del_rcu(&policy->bydst);
-
 		if (!chain) {
 			void *p = xfrm_policy_inexact_insert(policy, dir, 0);
 
--- a/tools/testing/selftests/net/xfrm_policy.sh
+++ b/tools/testing/selftests/net/xfrm_policy.sh
@@ -257,6 +257,29 @@ check_exceptions()
 	return $lret
 }
 
+check_hthresh_repeat()
+{
+	local log=$1
+	i=0
+
+	for i in $(seq 1 10);do
+		ip -net ns1 xfrm policy update src e000:0001::0000 dst ff01::0014:0000:0001 dir in tmpl src :: dst :: proto esp mode tunnel priority 100 action allow || break
+		ip -net ns1 xfrm policy set hthresh6 0 28 || break
+
+		ip -net ns1 xfrm policy update src e000:0001::0000 dst ff01::01 dir in tmpl src :: dst :: proto esp mode tunnel priority 100 action allow || break
+		ip -net ns1 xfrm policy set hthresh6 0 28 || break
+	done
+
+	if [ $i -ne 10 ] ;then
+		echo "FAIL: $log" 1>&2
+		ret=1
+		return 1
+	fi
+
+	echo "PASS: $log"
+	return 0
+}
+
 #check for needed privileges
 if [ "$(id -u)" -ne 0 ];then
 	echo "SKIP: Need root privileges"
@@ -404,7 +427,9 @@ for n in ns3 ns4;do
 	ip -net $n xfrm policy set hthresh4 32 32 hthresh6 128 128
 	sleep $((RANDOM%5))
 done
-check_exceptions "exceptions and block policies after hresh change to normal"
+check_exceptions "exceptions and block policies after htresh change to normal"
+
+check_hthresh_repeat "policies with repeated htresh change"
 
 for i in 1 2 3 4;do ip netns del ns$i;done
 


