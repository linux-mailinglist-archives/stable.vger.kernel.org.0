Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D50569E9AC
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 22:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjBUVop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 16:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjBUVop (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 16:44:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA872CFD0
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 13:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677015829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=34+UtMogjW73Ol6iiDYppo7y7ytBwPtcRfcoT5tMa8w=;
        b=GzvKwmL+DeVQONq5fJVvo75zVv3VM1ACnsHDBLGHUYElFbxQ8nTg3/WyAWf2V2vMvFyXCV
        ZFLBpRnuGWRYHPq7z98vK/FHFQnVpWDRliZqpa3h0iQWZcJqcTEosOfpdYXKbJHCxNUe60
        EQlBQAFb3yVTPzOm2HamwQV5NO5sxkU=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-631-UvOBjWnuN9q4kIOSND6KdQ-1; Tue, 21 Feb 2023 16:43:47 -0500
X-MC-Unique: UvOBjWnuN9q4kIOSND6KdQ-1
Received: by mail-qk1-f198.google.com with SMTP id bi9-20020a05620a318900b007423009db80so1059307qkb.7
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 13:43:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=34+UtMogjW73Ol6iiDYppo7y7ytBwPtcRfcoT5tMa8w=;
        b=aDtuu7nIOtx6/AzZ5RN+i/dl9fjSmEHXIyTdDilbnQpX+iQcTPn/I4sCglpWSEj/O1
         iqoVRDTF6o2uJqMC0wrWqyaTwk4TJb9/jKP/JhuLcCPUeyOtS8SODe4r39apVre4WNUz
         kI0bu5DDif1oQvowhbmCrNEC4ASnIsWYCAu+OMn4Nf28PomSDm27qtM/YfdfPfu/fPca
         KzsHXPsiCXYMD19ShuDyDFm/ZL9hQskjiXNzpLuuIjz/bsYpFr4KMA1sf2CDVyTcWSxa
         9vKaXu0KaHOKwCacpvPv4Z973U4+rXai5hT99LGVDpQKnFEk0/ejgpOkBLRMeZnA3q0f
         37/g==
X-Gm-Message-State: AO0yUKWVNkIOoYjrvBrVH84N0Dm3cL+1F+A6AoApSfNDezCJ+TShDEtF
        PifgSUwOgK3DXhvrD6VK/xoJ2+zx2cmqaOwyDce8ihdTV6aKxLBL6XaS2mkFctpGewjLP6VVHQm
        lcaklZzuPekB7oYFW
X-Received: by 2002:a05:622a:1002:b0:3b8:5199:f841 with SMTP id d2-20020a05622a100200b003b85199f841mr11179944qte.0.1677015827126;
        Tue, 21 Feb 2023 13:43:47 -0800 (PST)
X-Google-Smtp-Source: AK7set9TjAz8/InPJTdc2s1mAVbPGVdOmao8Z1FprSX/1ePcDq6rM6cu8qZFayZuieS9/eTg0PTxfg==
X-Received: by 2002:a05:622a:1002:b0:3b8:5199:f841 with SMTP id d2-20020a05622a100200b003b85199f841mr11179923qte.0.1677015826887;
        Tue, 21 Feb 2023 13:43:46 -0800 (PST)
Received: from x1n.redhat.com (bras-base-aurron9127w-grc-56-70-30-145-63.dsl.bell.ca. [70.30.145.63])
        by smtp.gmail.com with ESMTPSA id t144-20020a37aa96000000b0073b79edf46csm8989100qke.83.2023.02.21.13.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 13:43:46 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     Andrew Morton <akpm@linux-foundation.org>, peterx@redhat.com,
        Johannes Weiner <hannes@cmpxchg.org>,
        Yang Shi <shy828301@gmail.com>,
        David Stevens <stevensd@chromium.org>, stable@vger.kernel.org
Subject: [PATCH] mm/khugepaged: alloc_charge_hpage() take care of mem charge errors
Date:   Tue, 21 Feb 2023 16:43:44 -0500
Message-Id: <20230221214344.609226-1-peterx@redhat.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
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

If memory charge failed, the caller shouldn't call mem_cgroup_uncharge().
Let alloc_charge_hpage() handle the error itself and clear hpage properly
if mem charge fails.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: David Stevens <stevensd@chromium.org>
Cc: stable@vger.kernel.org
Fixes: 9d82c69438d0 ("mm: memcontrol: convert anon and file-thp to new mem_cgroup_charge() API")
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/khugepaged.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 8dbc39896811..941d1c7ea910 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1063,12 +1063,19 @@ static int alloc_charge_hpage(struct page **hpage, struct mm_struct *mm,
 	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
 		     GFP_TRANSHUGE);
 	int node = hpage_collapse_find_target_node(cc);
+	struct folio *folio;
 
 	if (!hpage_collapse_alloc_page(hpage, gfp, node, &cc->alloc_nmask))
 		return SCAN_ALLOC_HUGE_PAGE_FAIL;
-	if (unlikely(mem_cgroup_charge(page_folio(*hpage), mm, gfp)))
+
+	folio = page_folio(*hpage);
+	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
+		folio_put(folio);
+		*hpage = NULL;
 		return SCAN_CGROUP_CHARGE_FAIL;
+	}
 	count_memcg_page_event(*hpage, THP_COLLAPSE_ALLOC);
+
 	return SCAN_SUCCEED;
 }
 
-- 
2.39.1

