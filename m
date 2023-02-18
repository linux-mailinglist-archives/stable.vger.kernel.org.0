Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C166569B99A
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 12:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjBRLNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Feb 2023 06:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjBRLNF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Feb 2023 06:13:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E33A1A940
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 03:13:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49EAAB822A4
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 11:13:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFF2C433EF;
        Sat, 18 Feb 2023 11:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676718780;
        bh=SnGQxaMPEKmEwHYMa31zfvxuKqjbV5KIDmGTKzAAOfc=;
        h=Subject:To:Cc:From:Date:From;
        b=GHJWjQziTZbriuSJRRW4JjJ8cwgNzLyn5cs00ysxdm4fFVLlpUUbUPwGHrVKNZnkL
         mFc7FC/mGRpeyRuxMf9yvx39FdpV1qQvAqm38xgjyYC8yapJ4E4HL10wHldPX4OpoX
         7cHaDs5JAg0FICApkFfmOqb3k6ayIyNiCVHFuYdI=
Subject: FAILED: patch "[PATCH] net/sched: tcindex: update imperfect hash filters respecting" failed to apply to 5.4-stable tree
To:     pctammela@mojatatu.com, jhs@mojatatu.com, kuba@kernel.org,
        sec@valis.email
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 18 Feb 2023 12:12:17 +0100
Message-ID: <16767187371266@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

ee059170b1f7 ("net/sched: tcindex: update imperfect hash filters respecting rcu")
304e024216a8 ("net_sched: add a temporary refcnt for struct tcindex_data")
599be01ee567 ("net_sched: fix an OOB access in cls_tcindex")

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
 

