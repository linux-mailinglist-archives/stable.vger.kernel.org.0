Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 119BA5494D7
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353075AbiFMLU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352696AbiFMLRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:17:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C49838D99;
        Mon, 13 Jun 2022 03:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55B72B80EA8;
        Mon, 13 Jun 2022 10:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4132C34114;
        Mon, 13 Jun 2022 10:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116816;
        bh=FgMO41oDpurxXSoImFSQ1ra0Y6FhQ+nF/NQMi1WfjiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T2rlZt9fA3c0F/sskhWC2uDQ3ivpUAF/LJwP/bNRqtRhffMmrqVnaPq7GxobJoDOV
         6ZD+hzq/RQdjJZRHAA/YZVrhZ7muJ3rylBKkDjS6mluw701rnrvX5c4ZDjmsITkQpg
         R6t8802gN4pWTwyN8HTZBNokGt+lXMBM+UBa6tyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 183/411] ipc/mqueue: use get_tree_nodev() in mqueue_get_tree()
Date:   Mon, 13 Jun 2022 12:07:36 +0200
Message-Id: <20220613094934.147146149@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit d60c4d01a98bc1942dba6e3adc02031f5519f94b ]

When running the stress-ng clone benchmark with multiple testing threads,
it was found that there were significant spinlock contention in sget_fc().
The contended spinlock was the sb_lock.  It is under heavy contention
because the following code in the critcal section of sget_fc():

  hlist_for_each_entry(old, &fc->fs_type->fs_supers, s_instances) {
      if (test(old, fc))
          goto share_extant_sb;
  }

After testing with added instrumentation code, it was found that the
benchmark could generate thousands of ipc namespaces with the
corresponding number of entries in the mqueue's fs_supers list where the
namespaces are the key for the search.  This leads to excessive time in
scanning the list for a match.

Looking back at the mqueue calling sequence leading to sget_fc():

  mq_init_ns()
  => mq_create_mount()
  => fc_mount()
  => vfs_get_tree()
  => mqueue_get_tree()
  => get_tree_keyed()
  => vfs_get_super()
  => sget_fc()

Currently, mq_init_ns() is the only mqueue function that will indirectly
call mqueue_get_tree() with a newly allocated ipc namespace as the key for
searching.  As a result, there will never be a match with the exising ipc
namespaces stored in the mqueue's fs_supers list.

So using get_tree_keyed() to do an existing ipc namespace search is just a
waste of time.  Instead, we could use get_tree_nodev() to eliminate the
useless search.  By doing so, we can greatly reduce the sb_lock hold time
and avoid the spinlock contention problem in case a large number of ipc
namespaces are present.

Of course, if the code is modified in the future to allow
mqueue_get_tree() to be called with an existing ipc namespace instead of a
new one, we will have to use get_tree_keyed() in this case.

The following stress-ng clone benchmark command was run on a 2-socket
48-core Intel system:

./stress-ng --clone 32 --verbose --oomable --metrics-brief -t 20

The "bogo ops/s" increased from 5948.45 before patch to 9137.06 after
patch. This is an increase of 54% in performance.

Link: https://lkml.kernel.org/r/20220121172315.19652-1-longman@redhat.com
Fixes: 935c6912b198 ("ipc: Convert mqueue fs to fs_context")
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 ipc/mqueue.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 2ea0c08188e6..12519bf5f330 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -45,6 +45,7 @@
 
 struct mqueue_fs_context {
 	struct ipc_namespace	*ipc_ns;
+	bool			 newns;	/* Set if newly created ipc namespace */
 };
 
 #define MQUEUE_MAGIC	0x19800202
@@ -365,6 +366,14 @@ static int mqueue_get_tree(struct fs_context *fc)
 {
 	struct mqueue_fs_context *ctx = fc->fs_private;
 
+	/*
+	 * With a newly created ipc namespace, we don't need to do a search
+	 * for an ipc namespace match, but we still need to set s_fs_info.
+	 */
+	if (ctx->newns) {
+		fc->s_fs_info = ctx->ipc_ns;
+		return get_tree_nodev(fc, mqueue_fill_super);
+	}
 	return get_tree_keyed(fc, mqueue_fill_super, ctx->ipc_ns);
 }
 
@@ -392,6 +401,10 @@ static int mqueue_init_fs_context(struct fs_context *fc)
 	return 0;
 }
 
+/*
+ * mq_init_ns() is currently the only caller of mq_create_mount().
+ * So the ns parameter is always a newly created ipc namespace.
+ */
 static struct vfsmount *mq_create_mount(struct ipc_namespace *ns)
 {
 	struct mqueue_fs_context *ctx;
@@ -403,6 +416,7 @@ static struct vfsmount *mq_create_mount(struct ipc_namespace *ns)
 		return ERR_CAST(fc);
 
 	ctx = fc->fs_private;
+	ctx->newns = true;
 	put_ipc_ns(ctx->ipc_ns);
 	ctx->ipc_ns = get_ipc_ns(ns);
 	put_user_ns(fc->user_ns);
-- 
2.35.1



