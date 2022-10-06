Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 731335F6EC0
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 22:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbiJFUP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Oct 2022 16:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiJFUPz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Oct 2022 16:15:55 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80181B03C8
        for <stable@vger.kernel.org>; Thu,  6 Oct 2022 13:15:54 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id 13so7075860ejn.3
        for <stable@vger.kernel.org>; Thu, 06 Oct 2022 13:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ffslzyhovix66SuNo1fNLtEXNp0U8o9uSFXQEaxg9aY=;
        b=pn7LZWTZwNJgx4UKsu1GNG3jVDRrhCZUdbuD0+b6fr2Nzlv1BPSPXFvvPW15KSZfDd
         lcQPyszZUeIl4A87VFIK4vQCvs1FDWRqQoou/pZX4znLZeOSeLYGIzYLNB3K1BBAZn0w
         zudtE/f4S0sQ4opL69So1flMP24bTWBpn0R52fD4eP8KM2i/cK3YLnk/u6ciHn8rjfGS
         z7ZOAWYvZu/yxhyWdhcas3stAaQamMoWghv9vpvD/0U3avRKL2K6u/EaWxKvgwWRKCBY
         Jbe9/UEaLSQkPj7voGWTFnvmFhylS8I8VI5JtipF5TYei7kkqbK7WhrdKJgyDCkPgrOv
         ewnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ffslzyhovix66SuNo1fNLtEXNp0U8o9uSFXQEaxg9aY=;
        b=atcVf84TeiOZ3ButXXJBBQ9oxBkRMtnKfBm4Yk6Vi+RhnPqq/uqbDXhYSRsobjaskX
         UKNwn5FMExD4yPLJTOTUtCjfk7v7IFx/Kv+1el7jkwTKCiNaligBVPcT6hmHtkarisBQ
         SCDtig4slgWbtU11mlmuoRYNWGsOQ1/vY4XGWI70IKMm/ygTrayOiT7TU5zs0D31YG/u
         IxspnajZnIfcRRDUixZE0fo3iOetGt84nOnMbBxg69sjBn87sH7kleJsHzFcT0we8Ydu
         RR6RTtT8sLWdS79X58YiA4HRzXii/8IIi0n7BBAV5O5uuu+6sOj5zvHRWfDrAR3YhbF+
         2t2A==
X-Gm-Message-State: ACrzQf0r8W9GVHYMUVgRbPd9IqcH8Uu0NHygoPI8vUESNN/U48Lbo/2r
        xF0D8gJw3Rj2GhwE+SPbPQJiqnGe6e6SVw==
X-Google-Smtp-Source: AMsMyM7ftsSuASUkNtnziiN6++V3HNJGr7BJZ1WsJp1oSpsvPnKe8YCPTjJj9xLihitGoWdx2Lifww==
X-Received: by 2002:a17:907:7dab:b0:782:fe13:6102 with SMTP id oz43-20020a1709077dab00b00782fe136102mr1270352ejc.617.1665087352949;
        Thu, 06 Oct 2022 13:15:52 -0700 (PDT)
Received: from localhost ([2a00:79e0:9d:4:96ba:f291:aa3b:107e])
        by smtp.gmail.com with ESMTPSA id z21-20020a1709063a1500b00780636a85fasm113328eje.221.2022.10.06.13.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 13:15:50 -0700 (PDT)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Cc:     Steven Price <steven.price@arm.com>
Subject: [PATCH stable 5.4] mm: pagewalk: Fix race between unmap and page walker
Date:   Thu,  6 Oct 2022 22:15:41 +0200
Message-Id: <20221006201541.2004831-1-jannh@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

[ Upstream commit 8782fb61cc848364e1e1599d76d3c9dd58a1cc06 ]

The mmap lock protects the page walker from changes to the page tables
during the walk.  However a read lock is insufficient to protect those
areas which don't have a VMA as munmap() detaches the VMAs before
downgrading to a read lock and actually tearing down PTEs/page tables.

For users of walk_page_range() the solution is to simply call pte_hole()
immediately without checking the actual page tables when a VMA is not
present. We now never call __walk_page_range() without a valid vma.

For walk_page_range_novma() the locking requirements are tightened to
require the mmap write lock to be taken, and then walking the pgd
directly with 'no_vma' set.

This in turn means that all page walkers either have a valid vma, or
it's that special 'novma' case for page table debugging.  As a result,
all the odd '(!walk->vma && !walk->no_vma)' tests can be removed.

Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[manually backported. backport note: walk_page_range_novma() does not exist=
 in
5.4, so I'm omitting it from the backport]
Signed-off-by: Jann Horn <jannh@google.com>
---
 mm/pagewalk.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 4eb09e0898817..ec41e7552f37c 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -38,7 +38,7 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr,=
 unsigned long end,
 	do {
 again:
 		next =3D pmd_addr_end(addr, end);
-		if (pmd_none(*pmd) || !walk->vma) {
+		if (pmd_none(*pmd)) {
 			if (ops->pte_hole)
 				err =3D ops->pte_hole(addr, next, walk);
 			if (err)
@@ -84,7 +84,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long addr,=
 unsigned long end,
 	do {
  again:
 		next =3D pud_addr_end(addr, end);
-		if (pud_none(*pud) || !walk->vma) {
+		if (pud_none(*pud)) {
 			if (ops->pte_hole)
 				err =3D ops->pte_hole(addr, next, walk);
 			if (err)
@@ -254,7 +254,7 @@ static int __walk_page_range(unsigned long start, unsig=
ned long end,
 	int err =3D 0;
 	struct vm_area_struct *vma =3D walk->vma;
=20
-	if (vma && is_vm_hugetlb_page(vma)) {
+	if (is_vm_hugetlb_page(vma)) {
 		if (walk->ops->hugetlb_entry)
 			err =3D walk_hugetlb_range(start, end, walk);
 	} else
@@ -324,9 +324,13 @@ int walk_page_range(struct mm_struct *mm, unsigned lon=
g start,
 		if (!vma) { /* after the last vma */
 			walk.vma =3D NULL;
 			next =3D end;
+			if (ops->pte_hole)
+				err =3D ops->pte_hole(start, next, &walk);
 		} else if (start < vma->vm_start) { /* outside vma */
 			walk.vma =3D NULL;
 			next =3D min(end, vma->vm_start);
+			if (ops->pte_hole)
+				err =3D ops->pte_hole(start, next, &walk);
 		} else { /* inside vma */
 			walk.vma =3D vma;
 			next =3D min(end, vma->vm_end);
@@ -344,9 +348,8 @@ int walk_page_range(struct mm_struct *mm, unsigned long=
 start,
 			}
 			if (err < 0)
 				break;
-		}
-		if (walk.vma || walk.ops->pte_hole)
 			err =3D __walk_page_range(start, next, &walk);
+		}
 		if (err)
 			break;
 	} while (start =3D next, start < end);

base-commit: f28b7414ab715e6069e72a7bbe2f1354b2524beb
--=20
2.38.0.rc1.362.ged0d419d3c-goog

