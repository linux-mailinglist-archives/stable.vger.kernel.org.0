Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96886E513D
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 21:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjDQTyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 15:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjDQTya (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 15:54:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243346A66
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 12:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681761206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZZajLRXbE1gHSG0/rWcJydl4VAkwntQbZfH27HHj2cI=;
        b=UERaqskK3tXv/LdQiirxN4czmv8yGqF3TI6D2EFVZHjOnUfZqY4oLMb9TYlCkxFVu3B16b
        VvF3rQL4NGcNUE7LvuBbtSlVkQ4+rBVF0tM2RJNxbu12VD7w1pNHqcGEXN4Zs3pwVd3ysi
        n54kKzWAELzAIITExzh8MVQhe3jKEWg=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-335-3IlHRMTNPjqzk3TVcET3Yw-1; Mon, 17 Apr 2023 15:53:24 -0400
X-MC-Unique: 3IlHRMTNPjqzk3TVcET3Yw-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-3ef32210cabso1434741cf.0
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 12:53:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681761204; x=1684353204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZZajLRXbE1gHSG0/rWcJydl4VAkwntQbZfH27HHj2cI=;
        b=N0ZRGRqahYcS/U9M1wVhALOr9UwQfiIgLwpVR4+KSVlF5lUk46p8VSYGYNJ3GVzAqQ
         64zTWeOA8+6Z7QK6UeiydBeNGX+cr8mnUy3z/kwUz6TbkPUzCdolV/rKVjUdT8cWhpyq
         p6szrA9p/cPR5VJwpGDf5f0+EoFCue2OmioPQSzguEFTCGhLJPifai562TdN5mzpqTRb
         Tltl2YDMIiDiEs3i4tB/8fnJTGPOSSctWUs3eox5scarVOr+oA/Jy0G4nlsI9G1r+K3C
         6Tm4pxhc2N5Vbfp8pX7UaLGquBXueIsxDqhNCKxlIXcIsPOGMl1CScRHIbkhO5BtqrE/
         6r5A==
X-Gm-Message-State: AAQBX9eV0uWjHEo8Zud9D08Ld2Hzjw2D3Sry81fMsJXQD84dcpi4KafE
        4fGDxo0KX79iGavw+9OgeFvbk6NsDrJHyOCe71yaa/wemVxfuee9WlPpAxmbRurZAGksnrXFGzi
        dCwtCOdI0FYe9nvfu
X-Received: by 2002:a05:622a:1a9b:b0:3ea:ef5:5b8c with SMTP id s27-20020a05622a1a9b00b003ea0ef55b8cmr19155687qtc.3.1681761204296;
        Mon, 17 Apr 2023 12:53:24 -0700 (PDT)
X-Google-Smtp-Source: AKy350aPbpBAnSBo8hIMWFwYiZl6fBgvrueoUnmaQeBSdZmgAZBXgdsikL50SEQY0Q9p7+B82l1+8Q==
X-Received: by 2002:a05:622a:1a9b:b0:3ea:ef5:5b8c with SMTP id s27-20020a05622a1a9b00b003ea0ef55b8cmr19155663qtc.3.1681761204064;
        Mon, 17 Apr 2023 12:53:24 -0700 (PDT)
Received: from x1n.redhat.com (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id r17-20020ac87ef1000000b003edfb5d7637sm1731278qtc.73.2023.04.17.12.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 12:53:23 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        =?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, peterx@redhat.com,
        Axel Rasmussen <axelrasmussen@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        linux-stable <stable@vger.kernel.org>
Subject: [PATCH v2 2/6] mm/hugetlb: Fix uffd-wp bit lost when unsharing happens
Date:   Mon, 17 Apr 2023 15:53:13 -0400
Message-Id: <20230417195317.898696-3-peterx@redhat.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230417195317.898696-1-peterx@redhat.com>
References: <20230417195317.898696-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When we try to unshare a pinned page for a private hugetlb, uffd-wp bit can
get lost during unsharing.  Fix it by carrying it over.

This should be very rare, only if an unsharing happened on a private
hugetlb page with uffd-wp protected (e.g. in a child which shares the same
page with parent with UFFD_FEATURE_EVENT_FORK enabled).

Cc: linux-stable <stable@vger.kernel.org>
Fixes: 166f3ecc0daf ("mm/hugetlb: hook page faults for uffd write protection")
Reported-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/hugetlb.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0213efaf31be..cd3a9d8f4b70 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5637,13 +5637,16 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
 	spin_lock(ptl);
 	ptep = hugetlb_walk(vma, haddr, huge_page_size(h));
 	if (likely(ptep && pte_same(huge_ptep_get(ptep), pte))) {
+		pte_t newpte = make_huge_pte(vma, &new_folio->page, !unshare);
+
 		/* Break COW or unshare */
 		huge_ptep_clear_flush(vma, haddr, ptep);
 		mmu_notifier_invalidate_range(mm, range.start, range.end);
 		page_remove_rmap(old_page, vma, true);
 		hugepage_add_new_anon_rmap(new_folio, vma, haddr);
-		set_huge_pte_at(mm, haddr, ptep,
-				make_huge_pte(vma, &new_folio->page, !unshare));
+		if (huge_pte_uffd_wp(pte))
+			newpte = huge_pte_mkuffd_wp(newpte);
+		set_huge_pte_at(mm, haddr, ptep, newpte);
 		folio_set_hugetlb_migratable(new_folio);
 		/* Make the old page be freed below */
 		new_folio = page_folio(old_page);
-- 
2.39.1

