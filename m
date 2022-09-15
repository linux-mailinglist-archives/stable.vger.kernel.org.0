Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4715B9D09
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 16:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiIOO0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 10:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiIOOZr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 10:25:47 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD789DB42
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 07:25:28 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id g3so10255380wrq.13
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 07:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=Gi8oMlfnGzIv9eT6nJxAEmP0uxba17Ad6+WYam2LBeo=;
        b=Tv08bzMRa1U1tUL8sZW211+bxNDYzvmFmNt4JUj2QPZdbw9bBC/3dTe78aOoD7ZQpK
         6o7gmIp+GNszk+XnIeEnQJW0r7TJ3PENCCO+F3V26jUgZPMReyx6kb4J1rDMm/sPqcSs
         iVjTrwzwb1nGv0K0GA+bilT4hn1nszIvPO+jfy+f7T6O4WzyNU2L/urRAPBbD3uTy37K
         DX0fts2VJhn7J4aj246jBvasndIIU1LlaRAJ6zffqoOp08LTjw/7z8L17h87eaGAn6sX
         SzjfqJVCSTz+sPuTcCIHmNDUkNgWgc4SjjxBOCFBdz1kOTvKXcrVzNvPqKz6lzvVLU7+
         r45Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=Gi8oMlfnGzIv9eT6nJxAEmP0uxba17Ad6+WYam2LBeo=;
        b=iU7roUyZoySdM7Lqz6IogRg7FdBjW7cBt+ElL7Uu2rElS3ZWZ2plheKC40NDJ1VLnx
         +SO5GabIocsVV09qVkPtgLtR3JgjD/wLoEtG4jKE4HNxsNZHnsgaU7/hSoovyJFD8TTa
         yArnSZFkO3pGylm34bMEiiN3vsca6uBg+QVUxjuuifoc2t4DywoFbT/ac5sMU60opDRD
         SgLbkzyWBNi/2CHK7SrY3soMrsuKehrISSwCwOXZfeXPQAJrsPU+ZBqzk/VGS7JYfOSI
         GfGWDFeucAc/0ZP0n1qHVsM++54C5ysM0qCFK1i1u5CzPxc+L1eTjpgCss9G/hcGtcbH
         HvPQ==
X-Gm-Message-State: ACgBeo3w+wZHGCduY50ylMYEfSNWviGG0ophw7xqLou/LNE2HkjxbWWO
        9gK7hzkLBAyvACfpvVhRbY2BxvzLPZA5bw==
X-Google-Smtp-Source: AA6agR5PAlyjlfrmvZCyfh/1SS2Vk11zukH7IAf2ObHEJZf0/6Pv+2vvOUDBMc4JMejhbF33RwdW7g==
X-Received: by 2002:adf:bc13:0:b0:228:e099:3822 with SMTP id s19-20020adfbc13000000b00228e0993822mr24240970wrg.551.1663251926699;
        Thu, 15 Sep 2022 07:25:26 -0700 (PDT)
Received: from localhost ([2a00:79e0:9d:4:6906:73f0:ebcd:6cf8])
        by smtp.gmail.com with ESMTPSA id az3-20020adfe183000000b0022acc19e717sm2982070wrb.92.2022.09.15.07.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 07:25:26 -0700 (PDT)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH stable 4.9-5.15] mm: Fix TLB flush for not-first PFNMAP mappings in unmap_region()
Date:   Thu, 15 Sep 2022 16:25:19 +0200
Message-Id: <20220915142519.2941949-1-jannh@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a stable-specific patch.
I botched the stable-specific rewrite of
commit b67fbebd4cf98 ("mmu_gather: Force tlb-flush VM_PFNMAP vmas"):
As Hugh pointed out, unmap_region() actually operates on a list of VMAs,
and the variable "vma" merely points to the first VMA in that list.
So if we want to check whether any of the VMAs we're operating on is
PFNMAP or MIXEDMAP, we have to iterate through the list and check each VMA.

Signed-off-by: Jann Horn <jannh@google.com>
---
 mm/mmap.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index cd1d2680ac585..5c2c7651ca298 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2638,6 +2638,7 @@ static void unmap_region(struct mm_struct *mm,
 {
 	struct vm_area_struct *next =3D vma_next(mm, prev);
 	struct mmu_gather tlb;
+	struct vm_area_struct *cur_vma;
=20
 	lru_add_drain();
 	tlb_gather_mmu(&tlb, mm);
@@ -2652,8 +2653,12 @@ static void unmap_region(struct mm_struct *mm,
 	 * concurrent flush in this region has to be coming through the rmap,
 	 * and we synchronize against that using the rmap lock.
 	 */
-	if ((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) !=3D 0)
-		tlb_flush_mmu(&tlb);
+	for (cur_vma =3D vma; cur_vma; cur_vma =3D cur_vma->vm_next) {
+		if ((cur_vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) !=3D 0) {
+			tlb_flush_mmu(&tlb);
+			break;
+		}
+	}
=20
 	free_pgtables(&tlb, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
 				 next ? next->vm_start : USER_PGTABLES_CEILING);

base-commit: dd20085f2a88b6cdb12bdcdbd2d7a761c86b184a
--=20
2.37.2.789.g6183377224-goog

