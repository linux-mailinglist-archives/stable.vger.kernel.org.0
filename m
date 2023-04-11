Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD8C6DDC9A
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 15:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbjDKNrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 09:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjDKNrY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 09:47:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1017EC4
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 06:47:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FC64626BE
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 13:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0AEC433D2;
        Tue, 11 Apr 2023 13:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681220843;
        bh=0QkT0icn84fuUpPcD260MRCTZ7O5Ac3vqCyfq4JhnjU=;
        h=Subject:To:Cc:From:Date:From;
        b=liSQWRv+lGI2Y2ZaKaAAZX2P8q8V1Zdnv/ugX4f//XXgUflzTr78fdUVY2M9TrVNH
         zOX9qwkl0KJt9zn6koAgPK/2cJT/n1TPEWcDP+pZm55/bKoSEbplEwCeiUJvj8cb9m
         D1X6dB61pgjfYni6BeA6BsACo4Z8YeRX+bbcO+f4=
Subject: FAILED: patch "[PATCH] maple_tree: remove extra smp_wmb() from mas_dead_leaves()" failed to apply to 6.1-stable tree
To:     Liam.Howlett@oracle.com, akpm@linux-foundation.org,
        stable@vger.kernel.org, surenb@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 11 Apr 2023 15:47:19 +0200
Message-ID: <2023041119-pacemaker-division-7192@gregkh>
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
git cherry-pick -x 8372f4d83f96f35915106093cde4565836587123
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041119-pacemaker-division-7192@gregkh' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

8372f4d83f96 ("maple_tree: remove extra smp_wmb() from mas_dead_leaves()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8372f4d83f96f35915106093cde4565836587123 Mon Sep 17 00:00:00 2001
From: Liam Howlett <Liam.Howlett@oracle.com>
Date: Mon, 27 Feb 2023 09:36:03 -0800
Subject: [PATCH] maple_tree: remove extra smp_wmb() from mas_dead_leaves()

The call to mte_set_dead_node() before the smp_wmb() already calls
smp_wmb() so this is not needed.  This is an optimization for the RCU mode
of the maple tree.

Link: https://lkml.kernel.org/r/20230227173632.3292573-5-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 946acda29521..96d673e4ba5b 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5503,7 +5503,6 @@ unsigned char mas_dead_leaves(struct ma_state *mas, void __rcu **slots,
 			break;
 
 		mte_set_node_dead(entry);
-		smp_wmb(); /* Needed for RCU */
 		node->type = type;
 		rcu_assign_pointer(slots[offset], node);
 	}

