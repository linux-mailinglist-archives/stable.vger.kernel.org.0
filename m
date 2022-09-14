Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5995B8F28
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 21:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiINTKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 15:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiINTKE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 15:10:04 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0DC2ED60;
        Wed, 14 Sep 2022 12:10:03 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id c19so9734995qkm.7;
        Wed, 14 Sep 2022 12:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=6mBQHGkTCxpZ0kR+Uol1DB+Rk5F3r94azBv7C4epuC0=;
        b=Dw+JcD8DgkClgEkMagfiLANjV0/pvsu8mhEfMYKS7oDGdcZfuKNeFhI/Aoq7gPfQLV
         e8Kwx4FZhkAXPB+vBkt9h4Jdvp+0RBQ4LU+E4Xgr9bdlw1/FqhFU29nRGFQ9zTfZw38Z
         p7Je6UJUAwa54gPy3e+9UPpKoky64QyvHprd5ErvXlrdCDEcyXN6yTB9GhUbzi0AK5LE
         HOEpB2MnXRM+djEY0AvyrOxocKyT8YTNfyTMFmxLDwH+i94Zyu1JIR6aGOIpi60vgvOb
         WfgRj9PkKGvrrMSBQK7ouYKhoPR+A3L2SeloAaG4l7KYZViqKsgcPirutkSJJpSAvfCY
         U9sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=6mBQHGkTCxpZ0kR+Uol1DB+Rk5F3r94azBv7C4epuC0=;
        b=EJ7MvtnmSGvBYcw+KukO66V4/Ny+fepM6cq+g10KHx6g8iFDoxP3ZLeF5RBeu7k0f/
         lIYzLTfoWE4Jxyrui0HKG7JaT2Crx+sLLzMZgF1z26VR7fUCiFlVdPGZQs4TQunD1zRD
         TEsf+B8RQbM4uLCUp9S+QHKnlpI7bpSNcHQ/w0HoW/yi4gG0pvu5eEPzF1cnJM1OSfUL
         8xNMsehjNVNkCbTS8JT/5YBMDDNAYTsvSa0mgJ6ptLS1HTVbvqt+TOlAONBctlfYsQ6D
         28AEL7F5iO0MlVDLlT+2C+vn934INm0O3jufckVSIVYzRWt7AJnSjJdAkRKdGXidr3SN
         sfZQ==
X-Gm-Message-State: ACgBeo32yXgEPcHJxECtcOQEWLk3kC0fh+l3JViXa05ZPPhXtSKl/Clw
        wfApYzsRk4dY5kTV2zpljapeODrRHYg=
X-Google-Smtp-Source: AA6agR6/cTAVNB2gJ6Q5yLayiUSp9J8axMaA2UvkltnAQknb0qPfdRdMCbKdsCS63D4nEi+1IcaxrQ==
X-Received: by 2002:a05:620a:4447:b0:6c6:c438:1ced with SMTP id w7-20020a05620a444700b006c6c4381cedmr28568302qkp.658.1663182602724;
        Wed, 14 Sep 2022 12:10:02 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p8-20020a05622a00c800b0035bb8168daesm2300105qtw.57.2022.09.14.12.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 12:10:01 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Doug Berger <opendmb@gmail.com>
Subject: [PATCH] mm/hugetlb: correct demote page offset logic
Date:   Wed, 14 Sep 2022 12:09:17 -0700
Message-Id: <20220914190917.3517663-1-opendmb@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With gigantic pages it may not be true that struct page structures
are contiguous across the entire gigantic page. The nth_page macro
is used here in place of direct pointer arithmetic to correct for
this.

Fixes: 8531fc6f52f5 ("hugetlb: add hugetlb demote page support")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Cc: <stable@vger.kernel.org>
---
 mm/hugetlb.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e070b8593b37..0bdfc7e1c933 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3420,6 +3420,7 @@ static int demote_free_huge_page(struct hstate *h, struct page *page)
 {
 	int i, nid = page_to_nid(page);
 	struct hstate *target_hstate;
+	struct page *subpage;
 	int rc = 0;
 
 	target_hstate = size_to_hstate(PAGE_SIZE << h->demote_order);
@@ -3453,15 +3454,16 @@ static int demote_free_huge_page(struct hstate *h, struct page *page)
 	mutex_lock(&target_hstate->resize_lock);
 	for (i = 0; i < pages_per_huge_page(h);
 				i += pages_per_huge_page(target_hstate)) {
+		subpage = nth_page(page, i);
 		if (hstate_is_gigantic(target_hstate))
-			prep_compound_gigantic_page_for_demote(page + i,
+			prep_compound_gigantic_page_for_demote(subpage,
 							target_hstate->order);
 		else
-			prep_compound_page(page + i, target_hstate->order);
-		set_page_private(page + i, 0);
-		set_page_refcounted(page + i);
-		prep_new_huge_page(target_hstate, page + i, nid);
-		put_page(page + i);
+			prep_compound_page(subpage, target_hstate->order);
+		set_page_private(subpage, 0);
+		set_page_refcounted(subpage);
+		prep_new_huge_page(target_hstate, subpage, nid);
+		put_page(subpage);
 	}
 	mutex_unlock(&target_hstate->resize_lock);
 
-- 
2.25.1

