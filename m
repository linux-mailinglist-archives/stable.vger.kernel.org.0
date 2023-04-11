Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C8C6DDCA5
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 15:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjDKNsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 09:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbjDKNr6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 09:47:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618505263
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 06:47:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97DAA620A1
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 13:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC37AC433D2;
        Tue, 11 Apr 2023 13:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681220858;
        bh=+uZW0vXAk8wIfog/MTLW635WGPH/DPqt5eUq/QpD7po=;
        h=Subject:To:Cc:From:Date:From;
        b=n3NSxYfT3Im0sSqLG3gCjZxfXgaLzxx1eYJ6eXlVrjAAph/OLKYAg5GDN+YOjsIL2
         xLTmMhxLR2VxnRsqClzLUesgeoGgyG6tEFXSFFHu2kC4tRP9i39b1+lfU62oD3QzcQ
         BR9n3ickeKhn8sx8NLIl21wo4ydWiUbsg1AbBxU4=
Subject: FAILED: patch "[PATCH] maple_tree: add smp_rmb() to dead node detection" failed to apply to 6.2-stable tree
To:     Liam.Howlett@oracle.com, akpm@linux-foundation.org,
        stable@vger.kernel.org, surenb@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 11 Apr 2023 15:47:33 +0200
Message-ID: <2023041133-corroding-underdone-8e9f@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.2.y
git checkout FETCH_HEAD
git cherry-pick -x 0a2b18d948838e16912b3b627b504ab062b7d02a
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041133-corroding-underdone-8e9f@gregkh' --subject-prefix 'PATCH 6.2.y' HEAD^..

Possible dependencies:

0a2b18d94883 ("maple_tree: add smp_rmb() to dead node detection")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0a2b18d948838e16912b3b627b504ab062b7d02a Mon Sep 17 00:00:00 2001
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Date: Mon, 27 Feb 2023 09:36:05 -0800
Subject: [PATCH] maple_tree: add smp_rmb() to dead node detection

Add an smp_rmb() before reading the parent pointer to ensure that anything
read from the node prior to the parent pointer hasn't been reordered ahead
of this check.

The is necessary for RCU mode.

Link: https://lkml.kernel.org/r/20230227173632.3292573-7-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 5202d89ba56e..72c89eb03393 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -539,9 +539,11 @@ static inline struct maple_node *mte_parent(const struct maple_enode *enode)
  */
 static inline bool ma_dead_node(const struct maple_node *node)
 {
-	struct maple_node *parent = (void *)((unsigned long)
-					     node->parent & ~MAPLE_NODE_MASK);
+	struct maple_node *parent;
 
+	/* Do not reorder reads from the node prior to the parent check */
+	smp_rmb();
+	parent = (void *)((unsigned long) node->parent & ~MAPLE_NODE_MASK);
 	return (parent == node);
 }
 
@@ -556,6 +558,8 @@ static inline bool mte_dead_node(const struct maple_enode *enode)
 	struct maple_node *parent, *node;
 
 	node = mte_to_node(enode);
+	/* Do not reorder reads from the node prior to the parent check */
+	smp_rmb();
 	parent = mte_parent(enode);
 	return (parent == node);
 }

