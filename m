Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64C25A54C8
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 21:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiH2Tvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 15:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiH2Tvw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 15:51:52 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D9880341
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 12:51:51 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 196-20020a6301cd000000b0041b0f053fd1so4448471pgb.6
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 12:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=eTDsJIGXIfDtddp3EWZE5tD/DxUUSJ1qqUNwyCP9O8U=;
        b=FfhkGklaFdHvnIJ+EIm99gNGDQMMO8xpC3c0ZyZZPwxun6m/CbEExnfaOi7vRvhVDH
         pXv0yXXb+8+cmUyTrdZ6xHWL5vhXJlgJQeZWjeHiRFrXVTya8bKWBJ2vPnofa4z9CYrQ
         YHyeopzhcNuzTkpAOBLq4JSh29vgveiGtmhFC3UkNSdFKDxtWO9x5mHpvEEcgePatX8q
         Etfr2+AlBNAco5cdjIX7/539H4gOWWzcogT/fVU55RcQTZQbIBBjkMuFr1tLk0BnSWM0
         v0TPur1dbGQv8QTn48b5472pMYGBiAcxS4D5FDU96i+7N2KzmUtAeHsVawmvuYv7UQcC
         vfdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=eTDsJIGXIfDtddp3EWZE5tD/DxUUSJ1qqUNwyCP9O8U=;
        b=1oP0WKj2Dg6CAFg01pRyDTkPkJqXuNiTz50/qbN//9OBA2Bqifp5Mkv0j0cbWuadUe
         L7OjSNxrAJEaG/8dKTAvFO9PSATJiFaJMxnTRaZUZYSEUsdmObI/SfzQcfXpegF9b4dH
         s6gOcf+/eYmC8dA5p3GY4+tGRP533ZToqMBw2KO74HgXQ/xUC3z2wNpCOSRJ4bOzMBuj
         rCPneVXlLSw/XCGPjH5GWxeeDLmemqMFP/Wy5cLB+72n2unVQMuXUJyBC2kebQqPiOtb
         LJQyyWhz9JRBAB7Aw7tbk+Ve8EMt57/PydsKUJJiJlmdQFV7RYg+oPLyiK/7LP7oa0o1
         c29Q==
X-Gm-Message-State: ACgBeo3Oo0tqfgt9FhuXTZ9KTJXp9R87ZqXT4LFiM6p+dIg+PAaEk0I2
        1jOxPXWBahAq9suuXXDDomikstPqxs4AKGlFv4dYULLzPvdvbna3RlLBqhlVrBdIV9DLEI9iJSZ
        sQFEzLk9wI86QFNOBh4C4uQpo/fBeaDe+dtXAmZVh0bH3ivoj2I/VFCTWFF/VXiQvGbG8aNCHtP
        ZTWsO0
X-Google-Smtp-Source: AA6agR6OSsANVFScoBRXuIDaj3IQcx6MP8aLPfMfS4j3WSkXA2hG/EVqaEvnGnjfFxKPHH9wOD1oxjtAaNV0w2Z9O4dc
X-Received: from ajr0.svl.corp.google.com ([2620:15c:2d4:203:3f93:1c9a:457e:d2d1])
 (user=axelrasmussen job=sendgmr) by 2002:a17:902:f686:b0:175:44a:c707 with
 SMTP id l6-20020a170902f68600b00175044ac707mr2184326plg.62.1661802710736;
 Mon, 29 Aug 2022 12:51:50 -0700 (PDT)
Date:   Mon, 29 Aug 2022 12:51:46 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220829195146.1543063-1-axelrasmussen@google.com>
Subject: [PATCH 5.15-stable] mm/hugetlb: avoid corrupting page->mapping in hugetlb_mcopy_atomic_pte
From:   Axel Rasmussen <axelrasmussen@google.com>
To:     stable@vger.kernel.org
Cc:     linmiaohe@huawei.com, akpm@linux-foundation.org,
        mike.kravetz@oracle.com, peterx@redhat.com,
        Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

commit ab74ef708dc51df7cf2b8a890b9c6990fac5c0c6 upstream.

In MCOPY_ATOMIC_CONTINUE case with a non-shared VMA, pages in the page
cache are installed in the ptes.  But hugepage_add_new_anon_rmap is called
for them mistakenly because they're not vm_shared.  This will corrupt the
page->mapping used by page cache code.

Link: https://lkml.kernel.org/r/20220712130542.18836-1-linmiaohe@huawei.com
Fixes: f619147104c8 ("userfaultfd: add UFFDIO_CONTINUE ioctl")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
---
 mm/hugetlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 405793b8cf0d..d61b665c45d6 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5371,7 +5371,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 	if (!huge_pte_none(huge_ptep_get(dst_pte)))
 		goto out_release_unlock;
 
-	if (vm_shared) {
+	if (page_in_pagecache) {
 		page_dup_rmap(page, true);
 	} else {
 		ClearHPageRestoreReserve(page);
-- 
2.37.2.672.g94769d06f0-goog

