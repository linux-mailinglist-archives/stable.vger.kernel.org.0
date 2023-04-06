Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 256536D8C6A
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 03:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbjDFBG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 21:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233939AbjDFBGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 21:06:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30D87281;
        Wed,  5 Apr 2023 18:06:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FD8364296;
        Thu,  6 Apr 2023 01:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88BDAC433D2;
        Thu,  6 Apr 2023 01:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680743208;
        bh=vVA04hLwla/1oS/X5cPe3GH4TIvFOTodJ25mYBJRY9Y=;
        h=Date:To:From:Subject:From;
        b=C5VAAtLDpIcwEcb09Zpv4i+MsFkD/2c7FHd7GKkGva35HpI9mM1/duiE48MW47oe3
         jSlhLERiODbvoe4BDK2s/ZoaUAEi1x9nQ0M6rpCN5i/DDqTtPqzlrm5cf07BTZghI4
         Yf+2+zIHWPC7hWck1xnxcNs0RhJoiHVyAl5i9W9Q=
Date:   Wed, 05 Apr 2023 18:06:47 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        stable@vger.kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-remove-extra-smp_wmb-from-mas_dead_leaves.patch removed from -mm tree
Message-Id: <20230406010648.88BDAC433D2@smtp.kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: remove extra smp_wmb() from mas_dead_leaves()
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-extra-smp_wmb-from-mas_dead_leaves.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liam Howlett <Liam.Howlett@oracle.com>
Subject: maple_tree: remove extra smp_wmb() from mas_dead_leaves()
Date: Mon, 27 Feb 2023 09:36:03 -0800

The call to mte_set_dead_node() before the smp_wmb() already calls
smp_wmb() so this is not needed.  This is an optimization for the RCU mode
of the maple tree.

Link: https://lkml.kernel.org/r/20230227173632.3292573-5-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-remove-extra-smp_wmb-from-mas_dead_leaves
+++ a/lib/maple_tree.c
@@ -5503,7 +5503,6 @@ unsigned char mas_dead_leaves(struct ma_
 			break;
 
 		mte_set_node_dead(entry);
-		smp_wmb(); /* Needed for RCU */
 		node->type = type;
 		rcu_assign_pointer(slots[offset], node);
 	}
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


