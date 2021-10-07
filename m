Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA82842652A
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 09:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbhJHHYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 03:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232031AbhJHHYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 03:24:00 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C08DC061755;
        Fri,  8 Oct 2021 00:22:06 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id x8so5562097plv.8;
        Fri, 08 Oct 2021 00:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QgZDXufZT6HKl/lBj8C0d09aIeUA5f6RLZG86dMpu7k=;
        b=M63ZBGUdgFZB/d9TMgxemztWqBUSTyQpUmePUT/8Ns0SQM4XHJkluWs7JRzLIfZRn1
         iyMJ/dtNf/Kfq9DmK62cvwSMbbKAKyjEOADLu5AYLuRQfZoZRRFdUUsxWrTjbpvSgWfq
         c595/TZ3wVyRQ2od4m7qnXMBxkVjm0HQ3gRVZ+eA8O29V6FDDBoDfiBXCgPpyNw0070s
         vTGgIiLIsBb9cFtSVQXTgE5fkqpwW4N3W+xYvYfdTyFVzHtUlelFQ9BtojGbCtu98MlE
         RDK8iiVPMJCJl+Aa5wl24BXz+VaRuxlKYNf6qn5pLFvmfnFAtdaJsgEQTfZTkZs/E1nS
         1xlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QgZDXufZT6HKl/lBj8C0d09aIeUA5f6RLZG86dMpu7k=;
        b=lpmw0wPbLOvR/oCkABvlywNgH7Ct92PPy4sGRGxIybkj2wt2VTvXJ9xCep+LpeI3hJ
         3nguc+a1fqEUZXY8xK5tQVOscaNN0eBQwNcoOMzOz/zgGN21CkJf1PAGbu6q57mrtPOA
         xfGPJbJcLUzR58NW9rJ/L4u566hH5uH60EqMACvI83JpXQmXYQaQR2hdVtyXO6l26QMN
         2cjOTq8Bq9CEJpjKNHblW2L7WPExLLH73UQsORfctt8hbubBpMdePU6g3Ys+nG1oXdtW
         bV37s5Db0QPxk6IX/xJLXVXjcyopoDoxe6bCU+788UvTIZbEh6jtsKB2S58lRmJKvX/G
         hxxA==
X-Gm-Message-State: AOAM533rOKYSSavavy85DIOaoYLCibImUkNh4tQC+hzgjSk5RRWNhIiS
        FNYgQH6698zAyHAotlqOYn4=
X-Google-Smtp-Source: ABdhPJzGcX/FpZZkyYgmMcL7AezXWg7k6v+xPhh0/XrE/fVqF0dI+yWdSplZlcFoI8NvQgqrTzuHCA==
X-Received: by 2002:a17:903:1112:b0:13d:ce49:e275 with SMTP id n18-20020a170903111200b0013dce49e275mr8280504plh.5.1633677725365;
        Fri, 08 Oct 2021 00:22:05 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id f84sm1565319pfa.25.2021.10.08.00.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 00:22:04 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Nadav Amit <namit@vmware.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Peter Xu <peterx@redhat.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH] mm/userfaultfd: provide unmasked address on page-fault
Date:   Thu,  7 Oct 2021 16:50:55 -0700
Message-Id: <20211007235055.469587-1-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

Userfaultfd is supposed to provide the full address (i.e., unmasked) of
the faulting access back to userspace. However, that is not the case for
quite some time.

Even running "userfaultfd_demo" from the userfaultfd man page provides
the wrong output (and contradicts the man page). Notice that
"UFFD_EVENT_PAGEFAULT event" shows the masked address.

	Address returned by mmap() = 0x7fc5e30b3000

	fault_handler_thread():
	    poll() returns: nready = 1; POLLIN = 1; POLLERR = 0
	    UFFD_EVENT_PAGEFAULT event: flags = 0; address = 7fc5e30b3000
		(uffdio_copy.copy returned 4096)
	Read address 0x7fc5e30b300f in main(): A
	Read address 0x7fc5e30b340f in main(): A
	Read address 0x7fc5e30b380f in main(): A
	Read address 0x7fc5e30b3c0f in main(): A

Add a new "real_address" field to vmf to hold the unmasked address. It
is possible to keep the unmasked address in the existing address field
(and mask whenever necessary) instead, but this is likely to cause
backporting problems of this patch.

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org
Fixes: 1a29d85eb0f19 ("mm: use vmf->address instead of of vmf->virtual_address")
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 fs/userfaultfd.c   | 2 +-
 include/linux/mm.h | 3 ++-
 mm/memory.c        | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 003f0d31743e..1dfc0fcd83c1 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -481,7 +481,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 
 	init_waitqueue_func_entry(&uwq.wq, userfaultfd_wake_function);
 	uwq.wq.private = current;
-	uwq.msg = userfault_msg(vmf->address, vmf->flags, reason,
+	uwq.msg = userfault_msg(vmf->real_address, vmf->flags, reason,
 			ctx->features);
 	uwq.ctx = ctx;
 	uwq.waken = false;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 00bb2d938df4..f3f324e3f2bf 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -523,7 +523,8 @@ struct vm_fault {
 		struct vm_area_struct *vma;	/* Target VMA */
 		gfp_t gfp_mask;			/* gfp mask to be used for allocations */
 		pgoff_t pgoff;			/* Logical page offset based on vma */
-		unsigned long address;		/* Faulting virtual address */
+		unsigned long address;		/* Faulting virtual address - masked */
+		unsigned long real_address;	/* Faulting virtual address - unmaked */
 	};
 	enum fault_flag flags;		/* FAULT_FLAG_xxx flags
 					 * XXX: should really be 'const' */
diff --git a/mm/memory.c b/mm/memory.c
index 12a7b2094434..3d2d7fdbb7dc 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4594,6 +4594,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 	struct vm_fault vmf = {
 		.vma = vma,
 		.address = address & PAGE_MASK,
+		.real_address = address,
 		.flags = flags,
 		.pgoff = linear_page_index(vma, address),
 		.gfp_mask = __get_fault_gfp_mask(vma),
-- 
2.25.1

