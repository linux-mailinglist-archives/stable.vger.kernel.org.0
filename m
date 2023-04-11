Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF5716DDC90
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 15:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjDKNrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 09:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbjDKNrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 09:47:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244BCC4
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 06:47:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABAFD61F78
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 13:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5AF0C433EF;
        Tue, 11 Apr 2023 13:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681220825;
        bh=x1dY8wWDajH9tEyMgOpQEWZVtZQLwU8vgGEZXuWAse8=;
        h=Subject:To:Cc:From:Date:From;
        b=MuxM7lFUDl0bJErDBczdulvoMYtzqScujWLVenP3ZvYz7GFu5QnysBAARQ0WmgkZC
         TVMH+l8OKb03mfa1Y/6gVsAR2L7VBqLP6/7HviZSaRBOjEvv+I6GsW1YSieSaznRjv
         eK2E7cLRPojl90CUXJh8J7EbfgzWKdQIriPQv1i8=
Subject: FAILED: patch "[PATCH] maple_tree: detect dead nodes in mas_start()" failed to apply to 6.1-stable tree
To:     Liam.Howlett@oracle.com, akpm@linux-foundation.org,
        stable@vger.kernel.org, surenb@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 11 Apr 2023 15:47:02 +0200
Message-ID: <2023041102-dust-ecosystem-f498@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x a7b92d59c885018cb7bb88539892278e4fd64b29
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041102-dust-ecosystem-f498@gregkh' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

a7b92d59c885 ("maple_tree: detect dead nodes in mas_start()")
46b345848261 ("maple_tree: refine ma_state init from mas_start()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a7b92d59c885018cb7bb88539892278e4fd64b29 Mon Sep 17 00:00:00 2001
From: Liam Howlett <Liam.Howlett@oracle.com>
Date: Mon, 27 Feb 2023 09:36:01 -0800
Subject: [PATCH] maple_tree: detect dead nodes in mas_start()

When initially starting a search, the root node may already be in the
process of being replaced in RCU mode.  Detect and restart the walk if
this is the case.  This is necessary for RCU mode of the maple tree.

Link: https://lkml.kernel.org/r/20230227173632.3292573-3-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 095b9cb1f4f1..3d53339656e1 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1360,12 +1360,16 @@ static inline struct maple_enode *mas_start(struct ma_state *mas)
 		mas->max = ULONG_MAX;
 		mas->depth = 0;
 
+retry:
 		root = mas_root(mas);
 		/* Tree with nodes */
 		if (likely(xa_is_node(root))) {
 			mas->depth = 1;
 			mas->node = mte_safe_root(root);
 			mas->offset = 0;
+			if (mte_dead_node(mas->node))
+				goto retry;
+
 			return NULL;
 		}
 

