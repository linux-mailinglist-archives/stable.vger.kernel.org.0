Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850EC68954F
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbjBCKRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233284AbjBCKRk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:17:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F42199D047
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:17:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C5593CE2FAB
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF67C433D2;
        Fri,  3 Feb 2023 10:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419418;
        bh=jyPm1KNSmKtjnTkr16Tccpsz8TSyV0ZpYicolQ7H54s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z1wZfgjAwc1I7qE7cIOJ3ijYSjf+BGoJ7W4vf1Mo59c1ek0A19wCKvJEr6BH2TPXj
         5VL1huVPCzssNpb3MxVSyocmvYDIS/240dA7KJ+29RBUZbdGbzmLTWcWz1Gtm0Bhnb
         QtcJBy7dSBz91bpjyw3yEXTV3TSGfu9RJbqJjgHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michal Hocko <mhocko@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tom Herbert <tom@quantonium.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 4.14 60/62] mm: kvmalloc does not fallback to vmalloc for incompatible gfp flags
Date:   Fri,  3 Feb 2023 11:12:56 +0100
Message-Id: <20230203101015.541835783@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>

commit ce91f6ee5b3bbbad8caff61b1c46d845c8db19bf upstream.

kvmalloc warned about incompatible gfp_mask to catch abusers (mostly
GFP_NOFS) with an intention that this will motivate authors of the code
to fix those.  Linus argues that this just motivates people to do even
more hacks like

	if (gfp == GFP_KERNEL)
		kvmalloc
	else
		kmalloc

I haven't seen this happening much (Linus pointed to bucket_lock special
cases an atomic allocation but my git foo hasn't found much more) but it
is true that we can grow those in future.  Therefore Linus suggested to
simply not fallback to vmalloc for incompatible gfp flags and rather
stick with the kmalloc path.

Link: http://lkml.kernel.org/r/20180601115329.27807-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tom Herbert <tom@quantonium.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/util.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/util.c
+++ b/mm/util.c
@@ -400,7 +400,8 @@ EXPORT_SYMBOL(vm_mmap);
  * __GFP_RETRY_MAYFAIL is supported, and it should be used only if kmalloc is
  * preferable to the vmalloc fallback, due to visible performance drawbacks.
  *
- * Any use of gfp flags outside of GFP_KERNEL should be consulted with mm people.
+ * Please note that any use of gfp flags outside of GFP_KERNEL is careful to not
+ * fall back to vmalloc.
  */
 void *kvmalloc_node(size_t size, gfp_t flags, int node)
 {
@@ -411,7 +412,8 @@ void *kvmalloc_node(size_t size, gfp_t f
 	 * vmalloc uses GFP_KERNEL for some internal allocations (e.g page tables)
 	 * so the given set of flags has to be compatible.
 	 */
-	WARN_ON_ONCE((flags & GFP_KERNEL) != GFP_KERNEL);
+	if ((flags & GFP_KERNEL) != GFP_KERNEL)
+		return kmalloc_node(size, flags, node);
 
 	/*
 	 * We want to attempt a large physically contiguous block first because


