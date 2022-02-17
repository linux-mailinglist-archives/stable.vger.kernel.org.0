Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01BC24BAB99
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 22:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242205AbiBQVPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 16:15:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241058AbiBQVPV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 16:15:21 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554B7522D6
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 13:15:05 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id h7-20020a17090a648700b001b927560c2bso6645275pjj.1
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 13:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hCNaVxcWS3VUbwdvK8nt8k1Mldzabsrh0v1l5jxvv+k=;
        b=lLUfdhsG9xVUMYi0auPoNM5e5ITz7q96N1Kc87jC+NJvf1qsv+5K/Ls/XCoDcRghcR
         8jG7DmE/oEjsuGTLiupxAFwe+b8ei0WUJ4TcQsgm2GE0pc0RTpLqQTFeaoioGIoT34pq
         7lihIRu3UCIvEQ+Hkiha94m/aBD4yGU0pGAz6vibzb9Db1FrOo4hh4cAStML2bgA0evA
         4ClQt2hAYghYmJqYbhZNDtpIi21LVFOUsPgKEFIxbu9ebAIK/eZHdarnCYakExWMZ/C1
         ycHu0WzJeANcZWwU/+KhBCmlv3NvXZx6FqonJMUBXPaMDBb/X0myl5vZh72a6k9R4vzR
         z2RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hCNaVxcWS3VUbwdvK8nt8k1Mldzabsrh0v1l5jxvv+k=;
        b=sgP9I1igxt2Uo/WgnQCzw6YFN0rYqLjP3mz8OyhhV4B9HIRE8+lqGGGRIKtqbH56zN
         0IlWXBLu3uvUfwRnbpZMvTv8Oolz2hk8fYZTzaBIB1/bwGgjOrHT5OcWHHCAne9TgIhU
         OV+IBlu83qAtmXlmfBH1lfK+qlStmw+auuSL1OFpMQbB4mlltohXYLnkZc/dKA35U9BD
         tCGcQ1lIDmXbE8LMLx+NHQVjkM+NYmgmR72sLxY0X5AKtnER5nLvVxNRhOaKikptzH2A
         SuuZb8ZHkKVLeKFAEWEDvUe9jRx9MbEs5DIG1olKg3wswGhMExsgKkhdU/k/Dnhc9e06
         LWPA==
X-Gm-Message-State: AOAM532Bv5lcl+xVaJ/R3fiNgS2nA+w1RSMwxYwfts/QWmQO+Gy8SnGh
        Mv+ihwghsHiUYHCVr6P4RXk=
X-Google-Smtp-Source: ABdhPJwSp2QqYHSi8pN9rSIsxL6OKB/UAYwX0TanEoOR6096W+JtBcOxrt98RAr+0CI4aBD/lvWegA==
X-Received: by 2002:a17:902:db05:b0:14d:743f:5162 with SMTP id m5-20020a170902db0500b0014d743f5162mr4481648plx.12.1645132504644;
        Thu, 17 Feb 2022 13:15:04 -0800 (PST)
Received: from sc2-hs2-b1628.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id t14sm9282541pgo.19.2022.02.17.13.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 13:15:04 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, Nadav Amit <namit@vmware.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] userfaultfd: mark uffd_wp regardless of VM_WRITE flag
Date:   Thu, 17 Feb 2022 21:16:02 +0000
Message-Id: <20220217211602.2769-1-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

When a PTE is set by UFFD operations such as UFFDIO_COPY, the PTE is
currently only marked as write-protected if the VMA has VM_WRITE flag
set. This seems incorrect or at least would be unexpected by the users.

Consider the following sequence of operations that are being performed
on a certain page:

	mprotect(PROT_READ)
	UFFDIO_COPY(UFFDIO_COPY_MODE_WP)
	mprotect(PROT_READ|PROT_WRITE)

At this point the user would expect to still get UFFD notification when
the page is accessed for write, but the user would not get one, since
the PTE was not marked as UFFD_WP during UFFDIO_COPY.

Fix it by always marking PTEs as UFFD_WP regardless on the
write-permission in the VMA flags.

Fixes: 292924b26024 ("userfaultfd: wp: apply _PAGE_UFFD_WP bit")
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 mm/userfaultfd.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 0780c2a57ff1..885e5adb0168 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -72,12 +72,15 @@ int mfill_atomic_install_pte(struct mm_struct *dst_mm, pmd_t *dst_pmd,
 	_dst_pte = pte_mkdirty(_dst_pte);
 	if (page_in_cache && !vm_shared)
 		writable = false;
-	if (writable) {
-		if (wp_copy)
-			_dst_pte = pte_mkuffd_wp(_dst_pte);
-		else
-			_dst_pte = pte_mkwrite(_dst_pte);
-	}
+
+	/*
+	 * Always mark a PTE as write-protected when needed, regardless of
+	 * VM_WRITE, which the user might change.
+	 */
+	if (wp_copy)
+		_dst_pte = pte_mkuffd_wp(_dst_pte);
+	else if (writable)
+		_dst_pte = pte_mkwrite(_dst_pte);
 
 	dst_pte = pte_offset_map_lock(dst_mm, dst_pmd, dst_addr, &ptl);
 
-- 
2.25.1

