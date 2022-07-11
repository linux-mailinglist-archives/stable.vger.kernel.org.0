Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0548570EF1
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 02:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbiGLAds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 20:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiGLAdr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 20:33:47 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C271261A
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 17:33:44 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id g4so6198588pgc.1
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 17:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ti0C5xab/5kDqDKYjHrnv6fD7vOYV0VSIifA6sunqqM=;
        b=XORqPXdxn8L1WpRMLVZeoGz+I3la1Lzf/Ogve9kYHbmy+kM/Pr8ry1/D7p5jN/BrQN
         oYGgElFHZjnGR6neB7LhDwVbxCbNSacPtkNWbJzacIdhVxanV4cCpqZW8NGRtDpuCc5M
         fIDDKVJdOtsmskgmTMoxnJsQDuOz86qIcUaANSciwpk+Bs1f3yCZkWuFGbYlIeDNiXtW
         kCupp0WUX2MC0I2KDchdSS3S5BEOhxfO3YbzVr6PuRoqNypwsQ2av44cK4EnpoTkVmHI
         S95UTC/j8QFjUw8vt9DE11hf5vafBcZx6JpSEXVYg8adgtIkocg1UNsL3rUY1xK9eb9H
         CzIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ti0C5xab/5kDqDKYjHrnv6fD7vOYV0VSIifA6sunqqM=;
        b=ZaENd66Pg2ADHWtmsauGLQYpeTyEQud/ax5U4oCItXZa+RXKuHe9kn/ITUlPe1U/fr
         Ru9dw6LtDVtfeYaNCDfEBkIj+XxdBLScVhGrZ9oFvHhrYRbZsFKrKzHt6GcEq/vch0zY
         wyZOpwPqs3ZHcuIMJPjyGzPyvwuCbbkYQy+zdZpaAtzgH0dIcoTIAjQ85X8ryiSA0HCH
         iCZ80qmdsV9mty7mO4vk8ROp/k+csCMoCSbJZoJcCNkPDOeQ5N8LZrpyASs8jLelvv5x
         I8E81vlxNhqfQ0OmzAXIDHj62ruQkcH3KcRMOpptO6JuzRvjpwIG8t5QJAYhLzZlfEJe
         8IWg==
X-Gm-Message-State: AJIora/Th/tF/G1oOoxBsCc1hfX87zSunxlE+/IXuJHpI4o1oLOdpthe
        8dMikUOd/wFe1BS1VZWvvuM=
X-Google-Smtp-Source: AGRyM1u8mq01hXRym4iEcmpnDSmqpJXy216tb9zXA+hUsAi2nNnAklahyKOPDSahKlwEDJGgKhy+/w==
X-Received: by 2002:a05:6a00:889:b0:510:91e6:6463 with SMTP id q9-20020a056a00088900b0051091e66463mr20757829pfj.58.1657586023850;
        Mon, 11 Jul 2022 17:33:43 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id p2-20020a170902e74200b0016be596c8afsm5383138plf.282.2022.07.11.17.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 17:33:43 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, Nadav Amit <namit@vmware.com>,
        James Houghton <jthoughton@google.com>,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>, Jan Kara <jack@suse.cz>,
        Andrea Arcangeli <aarcange@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] userfaultfd: provide properly masked address for huge-pages
Date:   Mon, 11 Jul 2022 09:59:06 -0700
Message-Id: <20220711165906.2682-1-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

Commit 824ddc601adc ("userfaultfd: provide unmasked address on
page-fault") was introduced to fix an old bug, in which the offset in
the address of a page-fault was masked. Concerns were raised - although
were never backed by actual code - that some userspace code might break
because the bug has been around for quite a while. To address these
concerns a new flag was introduced, and only when this flag is set by
the user, userfaultfd provides the exact address of the page-fault.

The commit however had a bug, and if the flag is unset, the offset was
always masked based on a base-page granularity. Yet, for huge-pages, the
behavior prior to the commit was that the address is masked to the
huge-page granulrity.

While there are no reports on real breakage, fix this issue. If the flag
is unset, use the address with the masking that was done before.

Fixes: 824ddc601adc ("userfaultfd: provide unmasked address on page-fault")
Reported-by: James Houghton <jthoughton@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 fs/userfaultfd.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index e943370107d0..de86f5b2859f 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -192,17 +192,19 @@ static inline void msg_init(struct uffd_msg *msg)
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
@@ -488,8 +490,8 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 
 	init_waitqueue_func_entry(&uwq.wq, userfaultfd_wake_function);
 	uwq.wq.private = current;
-	uwq.msg = userfault_msg(vmf->real_address, vmf->flags, reason,
-			ctx->features);
+	uwq.msg = userfault_msg(vmf->address, vmf->real_address, vmf->flags,
+				reason, ctx->features);
 	uwq.ctx = ctx;
 	uwq.waken = false;
 
-- 
2.25.1

