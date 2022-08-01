Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE6A586A0E
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbiHAMMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234283AbiHAMLA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:11:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F3F6BD45;
        Mon,  1 Aug 2022 04:56:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19A8A60011;
        Mon,  1 Aug 2022 11:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E7DC433C1;
        Mon,  1 Aug 2022 11:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355008;
        bh=RvFHyvGJzY+uaEiB2xf4kqheVPtJGbgE+quiYvzgbgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ty16jX3wFs59GYrmFwAEhrytwTXOvmu4wOiMd15Oc2/grNJY6NNXVjJvqIZ2KSlAX
         WR+LeKnV4dDedqW7mZL7vNC5DZk3jKnLjyvRovbnoQum/ueT1ocb9pY+SCbJ7sK2ri
         k/A1980JBZIGFduXBiZvEwsAosXUMZvYvPmM0mcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        James Houghton <jthoughton@google.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>, Jan Kara <jack@suse.cz>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.18 06/88] userfaultfd: provide properly masked address for huge-pages
Date:   Mon,  1 Aug 2022 13:46:20 +0200
Message-Id: <20220801114138.328635281@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

commit d172b1a3bd065dd89234eac547fc62cf80681631 upstream.

Commit 824ddc601adc ("userfaultfd: provide unmasked address on
page-fault") was introduced to fix an old bug, in which the offset in the
address of a page-fault was masked.  Concerns were raised - although were
never backed by actual code - that some userspace code might break because
the bug has been around for quite a while.  To address these concerns a
new flag was introduced, and only when this flag is set by the user,
userfaultfd provides the exact address of the page-fault.

The commit however had a bug, and if the flag is unset, the offset was
always masked based on a base-page granularity.  Yet, for huge-pages, the
behavior prior to the commit was that the address is masked to the
huge-page granulrity.

While there are no reports on real breakage, fix this issue.  If the flag
is unset, use the address with the masking that was done before.

Link: https://lkml.kernel.org/r/20220711165906.2682-1-namit@vmware.com
Fixes: 824ddc601adc ("userfaultfd: provide unmasked address on page-fault")
Signed-off-by: Nadav Amit <namit@vmware.com>
Reported-by: James Houghton <jthoughton@google.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: James Houghton <jthoughton@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/userfaultfd.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -191,17 +191,19 @@ static inline void msg_init(struct uffd_
 }
 
 static inline struct uffd_msg userfault_msg(unsigned long address,
+					    unsigned long real_address,
 					    unsigned int flags,
 					    unsigned long reason,
 					    unsigned int features)
 {
 	struct uffd_msg msg;
+
 	msg_init(&msg);
 	msg.event = UFFD_EVENT_PAGEFAULT;
 
-	if (!(features & UFFD_FEATURE_EXACT_ADDRESS))
-		address &= PAGE_MASK;
-	msg.arg.pagefault.address = address;
+	msg.arg.pagefault.address = (features & UFFD_FEATURE_EXACT_ADDRESS) ?
+				    real_address : address;
+
 	/*
 	 * These flags indicate why the userfault occurred:
 	 * - UFFD_PAGEFAULT_FLAG_WP indicates a write protect fault.
@@ -485,8 +487,8 @@ vm_fault_t handle_userfault(struct vm_fa
 
 	init_waitqueue_func_entry(&uwq.wq, userfaultfd_wake_function);
 	uwq.wq.private = current;
-	uwq.msg = userfault_msg(vmf->real_address, vmf->flags, reason,
-			ctx->features);
+	uwq.msg = userfault_msg(vmf->address, vmf->real_address, vmf->flags,
+				reason, ctx->features);
 	uwq.ctx = ctx;
 	uwq.waken = false;
 


