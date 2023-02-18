Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B9069B99B
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 12:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjBRLNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Feb 2023 06:13:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjBRLNF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Feb 2023 06:13:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243A916323
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 03:13:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B307260B5C
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 11:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7629C433EF;
        Sat, 18 Feb 2023 11:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676718783;
        bh=vREHHjwWEeFRgnGbyfYX6Tm5eFVk6UAr6VIBJfX/Olo=;
        h=Subject:To:Cc:From:Date:From;
        b=yJhNxn8Oi353N7p03Zc+kL5UWE0LRKpRYn38Josuui5G0L1y6zxtKQ7YmO7yOmjLK
         OFF7Unzg4X0QITw0PJUBShv1RIUdUrurCHnhnyghuCSghLteKVs4I8DnTtRmr10wSJ
         CI13hdTuwECAuKRIckOyOhgwv77A0EzmosFoO2bA=
Subject: FAILED: patch "[PATCH] net/sched: tcindex: update imperfect hash filters respecting" failed to apply to 4.14-stable tree
To:     pctammela@mojatatu.com, jhs@mojatatu.com, kuba@kernel.org,
        sec@valis.email
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 18 Feb 2023 12:12:51 +0100
Message-ID: <1676718771113122@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

ee059170b1f7 ("net/sched: tcindex: update imperfect hash filters respecting rcu")
304e024216a8 ("net_sched: add a temporary refcnt for struct tcindex_data")
599be01ee567 ("net_sched: fix an OOB access in cls_tcindex")
14215108a1fd ("net_sched: initialize net pointer inside tcf_exts_init()")
51dcb69de67a ("net_sched: fix a memory leak in cls_tcindex")
3d210534cc93 ("net_sched: fix a race condition in tcindex_destroy()")
12db03b65c2b ("net: sched: extend proto ops to support unlocked classifiers")
7d5509fa0d3d ("net: sched: extend proto ops with 'put' callback")
726d061286ce ("net: sched: prevent insertion of new classifiers during chain flush")
8b64678e0af8 ("net: sched: refactor tp insert/delete for concurrent execution")
fe2923afc124 ("net: sched: traverse classifiers in chain with tcf_get_next_proto()")
4dbfa766440c ("net: sched: introduce reference counting for tcf_proto")
ed76f5edccc9 ("net: sched: protect filter_chain list with filter_chain_lock mutex")
a5654820bb4b ("net: sched: protect chain template accesses with block lock")
bbf73830cd48 ("net: sched: traverse chains in block with tcf_get_next_chain()")
165f01354c52 ("net: sched: protect block->chain0 with block->lock")
c266f64dbfa2 ("net: sched: protect block state with mutex")
a030598690c6 ("net: sched: cls_u32: simplify the hell out u32_delete() emptiness check")
787ce6d02d95 ("net: sched: use reference counting for tcf blocks on rules update")
0607e439943b ("net: sched: implement tcf_block_refcnt_{get|put}()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ee059170b1f7e94e55fa6cadee544e176a6e59c2 Mon Sep 17 00:00:00 2001
From: Pedro Tammela <pctammela@mojatatu.com>
Date: Thu, 9 Feb 2023 11:37:39 -0300
Subject: [PATCH] net/sched: tcindex: update imperfect hash filters respecting
 rcu

The imperfect hash area can be updated while packets are traversing,
which will cause a use-after-free when 'tcf_exts_exec()' is called
with the destroyed tcf_ext.

CPU 0:               CPU 1:
tcindex_set_parms    tcindex_classify
tcindex_lookup
                     tcindex_lookup
tcf_exts_change
                     tcf_exts_exec [UAF]

Stop operating on the shared area directly, by using a local copy,
and update the filter with 'rcu_replace_pointer()'. Delete the old
filter version only after a rcu grace period elapsed.

Fixes: 9b0d4446b569 ("net: sched: avoid atomic swap in tcf_exts_change")
Reported-by: valis <sec@valis.email>
Suggested-by: valis <sec@valis.email>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Link: https://lore.kernel.org/r/20230209143739.279867-1-pctammela@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index ee2a050c887b..ba7f22a49397 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -12,6 +12,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/refcount.h>
+#include <linux/rcupdate.h>
 #include <net/act_api.h>
 #include <net/netlink.h>
 #include <net/pkt_cls.h>
@@ -339,6 +340,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	struct tcf_result cr = {};
 	int err, balloc = 0;
 	struct tcf_exts e;
+	bool update_h = false;
 
 	err = tcf_exts_init(&e, net, TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
 	if (err < 0)
@@ -456,10 +458,13 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 		}
 	}
 
-	if (cp->perfect)
+	if (cp->perfect) {
 		r = cp->perfect + handle;
-	else
-		r = tcindex_lookup(cp, handle) ? : &new_filter_result;
+	} else {
+		/* imperfect area is updated in-place using rcu */
+		update_h = !!tcindex_lookup(cp, handle);
+		r = &new_filter_result;
+	}
 
 	if (r == &new_filter_result) {
 		f = kzalloc(sizeof(*f), GFP_KERNEL);
@@ -485,7 +490,28 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 
 	rcu_assign_pointer(tp->root, cp);
 
-	if (r == &new_filter_result) {
+	if (update_h) {
+		struct tcindex_filter __rcu **fp;
+		struct tcindex_filter *cf;
+
+		f->result.res = r->res;
+		tcf_exts_change(&f->result.exts, &r->exts);
+
+		/* imperfect area bucket */
+		fp = cp->h + (handle % cp->hash);
+
+		/* lookup the filter, guaranteed to exist */
+		for (cf = rcu_dereference_bh_rtnl(*fp); cf;
+		     fp = &cf->next, cf = rcu_dereference_bh_rtnl(*fp))
+			if (cf->key == handle)
+				break;
+
+		f->next = cf->next;
+
+		cf = rcu_replace_pointer(*fp, f, 1);
+		tcf_exts_get_net(&cf->result.exts);
+		tcf_queue_work(&cf->rwork, tcindex_destroy_fexts_work);
+	} else if (r == &new_filter_result) {
 		struct tcindex_filter *nfp;
 		struct tcindex_filter __rcu **fp;
 

