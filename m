Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 599AF624BD9
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 21:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbiKJUcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 15:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbiKJUck (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 15:32:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58E6240B4
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 12:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668112297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ff4uIKDwEIX1/MsTGENOmYM+Xv3Uc0BmHEC53Fnq3vY=;
        b=fO5ncn0BdyuBNXtQzyxtq9VlbhBGAKcszrRDQTo/jkWRwUjWIFdAx2zVmQco//k/pFiUFu
        LDYJQG4yQbPqtZMI1VVEeA5GT1dpvgq6yp9Qj7JbL+lcJ92xcKXvCkr/pEA7q+rFzxclKY
        CWYl0HpgpF0rwOkcb0LBjDEkuMdgkvg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-183-CB8Mw5u4Nhukov4Qccx-Hg-1; Thu, 10 Nov 2022 15:31:36 -0500
X-MC-Unique: CB8Mw5u4Nhukov4Qccx-Hg-1
Received: by mail-qk1-f197.google.com with SMTP id h8-20020a05620a284800b006b5c98f09fbso3056280qkp.21
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 12:31:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ff4uIKDwEIX1/MsTGENOmYM+Xv3Uc0BmHEC53Fnq3vY=;
        b=AuH8y9HwEUDtza/W9oznjMwsfEQwVE7larV+64THTtLfltpbkdfr1QsNp3w/iU/218
         MWTXniDNBymPpdiXOzgJSn2LHNhvEawEnUNx90WNbadKZ/eGwAUpfUkWN4a0eizYS+jy
         wKOgAZ9Ogepn71ILmVEuMd+3ZHscGbOzevYFbcx5CfVfdhUTTPOUaPS3nMWB1rhqJsI+
         pvfV5dUNKvbHT+4h12P7vjAkNYzG7CxXieQNBbrQlJqgNRwqjVF4CLj3jKdB/ZgpA9Nt
         sM/UxT+/6uEj5VmMtbwzWrjnYUH7kN6I6gV9o88K33U9kWs8mN7/+snNongGYCIQ/T3P
         jWgg==
X-Gm-Message-State: ACrzQf0X+qU3PKzlUHWKfGf42kfrgfz7mBGwm55JdghnXRoxVi15ku7D
        Z5pgW/xTDQ17f8t9LmSSnJP13wpOQmBzr/0MwGjEgpEhCYL+G1Qtx8LsVkzhlVNDpuqrd1XuCJb
        /6CqfhjckXen/T9t9
X-Received: by 2002:a05:620a:2455:b0:6fa:3fbf:6b51 with SMTP id h21-20020a05620a245500b006fa3fbf6b51mr1747395qkn.519.1668112296209;
        Thu, 10 Nov 2022 12:31:36 -0800 (PST)
X-Google-Smtp-Source: AMsMyM48Dbsd61+EMKMLnYyrMapQFxdZHIJkOTIgyuDxqxIk8mfk0DBVx1tPHeFMdbbAkCTVyomt5g==
X-Received: by 2002:a05:620a:2455:b0:6fa:3fbf:6b51 with SMTP id h21-20020a05620a245500b006fa3fbf6b51mr1747373qkn.519.1668112295954;
        Thu, 10 Nov 2022 12:31:35 -0800 (PST)
Received: from x1n.redhat.com (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id i1-20020ac860c1000000b00399edda03dfsm123588qtm.67.2022.11.10.12.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 12:31:35 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     peterx@redhat.com, Andrea Arcangeli <aarcange@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Ives van Hoorne <ives@codesandbox.io>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] mm/migrate: Fix read-only page got writable when recover pte
Date:   Thu, 10 Nov 2022 15:31:31 -0500
Message-Id: <20221110203132.1498183-2-peterx@redhat.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221110203132.1498183-1-peterx@redhat.com>
References: <20221110203132.1498183-1-peterx@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ives van Hoorne from codesandbox.io reported an issue regarding possible
data loss of uffd-wp when applied to memfds on heavily loaded systems.  The
sympton is some read page got data mismatch from the snapshot child VMs.

Here I can also reproduce with a Rust reproducer that was provided by Ives
that keeps taking snapshot of a 256MB VM, on a 32G system when I initiate
80 instances I can trigger the issues in ten minutes.

It turns out that we got some pages write-through even if uffd-wp is
applied to the pte.

The problem is, when removing migration entries, we didn't really worry
about write bit as long as we know it's not a write migration entry.  That
may not be true, for some memory types (e.g. writable shmem) mk_pte can
return a pte with write bit set, then to recover the migration entry to its
original state we need to explicit wr-protect the pte or it'll has the
write bit set if it's a read migration entry.

For uffd it can cause write-through.  I didn't verify, but I think it'll be
the same for mprotect()ed pages and after migration we can miss the sigbus
instead.

The relevant code on uffd was introduced in the anon support, which is
commit f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration",
2020-04-07).  However anon shouldn't suffer from this problem because anon
should already have the write bit cleared always, so that may not be a
proper Fixes target.  To satisfy the need on the backport, I'm attaching
the Fixes tag to the uffd-wp shmem support.  Since no one had issue with
mprotect, so I assume that's also the kernel version we should start to
backport for stable, and we shouldn't need to worry before that.

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: stable@vger.kernel.org
Fixes: b1f9e876862d ("mm/uffd: enable write protection for shmem & hugetlbfs")
Reported-by: Ives van Hoorne <ives@codesandbox.io>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/migrate.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index dff333593a8a..8b6351c08c78 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -213,8 +213,14 @@ static bool remove_migration_pte(struct folio *folio,
 			pte = pte_mkdirty(pte);
 		if (is_writable_migration_entry(entry))
 			pte = maybe_mkwrite(pte, vma);
-		else if (pte_swp_uffd_wp(*pvmw.pte))
+		else
+			/* NOTE: mk_pte can have write bit set */
+			pte = pte_wrprotect(pte);
+
+		if (pte_swp_uffd_wp(*pvmw.pte)) {
+			WARN_ON_ONCE(pte_write(pte));
 			pte = pte_mkuffd_wp(pte);
+		}
 
 		if (folio_test_anon(folio) && !is_readable_migration_entry(entry))
 			rmap_flags |= RMAP_EXCLUSIVE;
-- 
2.37.3

