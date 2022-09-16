Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E775BA9FE
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiIPKJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiIPKIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:08:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B934ABF01;
        Fri, 16 Sep 2022 03:08:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68422B82504;
        Fri, 16 Sep 2022 10:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD684C433C1;
        Fri, 16 Sep 2022 10:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663322899;
        bh=JwgEMcm8ImgwOu3IkVy+p4cHjDKBDufgt2Mp2DMsJS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YyDPPdrNc4szVE9TxExqC0ZdafshE9+qqGqvAcyZEWXaeIW/2eeLdPwgEQKUVqwGq
         svG+tVigujFcLUP2batZXh3NK9rb8VXjjpdsowkVBwRWohWoguHwePN7SOG/rx1RmK
         WvSaE8gCRrp05TCgz0O2l7ILO8qiDXEv6r01pO3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>
Subject: [PATCH 4.14 1/7] mm: Fix TLB flush for not-first PFNMAP mappings in unmap_region()
Date:   Fri, 16 Sep 2022 12:07:53 +0200
Message-Id: <20220916100441.611930325@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100441.528608977@linuxfoundation.org>
References: <20220916100441.528608977@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

This is a stable-specific patch.
I botched the stable-specific rewrite of
commit b67fbebd4cf98 ("mmu_gather: Force tlb-flush VM_PFNMAP vmas"):
As Hugh pointed out, unmap_region() actually operates on a list of VMAs,
and the variable "vma" merely points to the first VMA in that list.
So if we want to check whether any of the VMAs we're operating on is
PFNMAP or MIXEDMAP, we have to iterate through the list and check each VMA.

Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmap.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2524,6 +2524,7 @@ static void unmap_region(struct mm_struc
 {
 	struct vm_area_struct *next = prev ? prev->vm_next : mm->mmap;
 	struct mmu_gather tlb;
+	struct vm_area_struct *cur_vma;
 
 	lru_add_drain();
 	tlb_gather_mmu(&tlb, mm, start, end);
@@ -2538,8 +2539,12 @@ static void unmap_region(struct mm_struc
 	 * concurrent flush in this region has to be coming through the rmap,
 	 * and we synchronize against that using the rmap lock.
 	 */
-	if ((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) != 0)
-		tlb_flush_mmu(&tlb);
+	for (cur_vma = vma; cur_vma; cur_vma = cur_vma->vm_next) {
+		if ((cur_vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) != 0) {
+			tlb_flush_mmu(&tlb);
+			break;
+		}
+	}
 
 	free_pgtables(&tlb, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
 				 next ? next->vm_start : USER_PGTABLES_CEILING);


