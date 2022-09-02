Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3305AAE45
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235679AbiIBMVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235900AbiIBMVP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:21:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FB65F117;
        Fri,  2 Sep 2022 05:20:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EF5FB82A90;
        Fri,  2 Sep 2022 12:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D716C433C1;
        Fri,  2 Sep 2022 12:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121239;
        bh=CaPcejMvq5lnvRq2Ub3CTht8iOus3RIxbKRjKmiWj2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xVlR/vSt0sZyT0nwViKMfRWHnrZ05XnDZ7TLJDFFFzeP9jALuYCRn+HCygGYt02Wq
         TvU4FH/icyIN3Qqhct+oGX9eLcPVXXMl4cX4oAFgKkhzELEuh2K9qDl/qYfwsPJPES
         JndOnjW2q18TvmMTTEUfkxtMRAbY0sl57l51Tu+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jann Horn <jannh@google.com>
Subject: [PATCH 4.9 17/31] mm: Force TLB flush for PFNMAP mappings before unlink_file_vma()
Date:   Fri,  2 Sep 2022 14:18:43 +0200
Message-Id: <20220902121357.380353210@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121356.732130937@linuxfoundation.org>
References: <20220902121356.732130937@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit b67fbebd4cf980aecbcc750e1462128bffe8ae15 upstream.

Some drivers rely on having all VMAs through which a PFN might be
accessible listed in the rmap for correctness.
However, on X86, it was possible for a VMA with stale TLB entries
to not be listed in the rmap.

This was fixed in mainline with
commit b67fbebd4cf9 ("mmu_gather: Force tlb-flush VM_PFNMAP vmas"),
but that commit relies on preceding refactoring in
commit 18ba064e42df3 ("mmu_gather: Let there be one tlb_{start,end}_vma()
implementation") and commit 1e9fdf21a4339 ("mmu_gather: Remove per arch
tlb_{start,end}_vma()").

This patch provides equivalent protection without needing that
refactoring, by forcing a TLB flush between removing PTEs in
unmap_vmas() and the call to unlink_file_vma() in free_pgtables().

[This is a stable-specific rewrite of the upstream commit!]
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmap.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2529,6 +2529,18 @@ static void unmap_region(struct mm_struc
 	tlb_gather_mmu(&tlb, mm, start, end);
 	update_hiwater_rss(mm);
 	unmap_vmas(&tlb, vma, start, end);
+
+	/*
+	 * Ensure we have no stale TLB entries by the time this mapping is
+	 * removed from the rmap.
+	 * Note that we don't have to worry about nested flushes here because
+	 * we're holding the mm semaphore for removing the mapping - so any
+	 * concurrent flush in this region has to be coming through the rmap,
+	 * and we synchronize against that using the rmap lock.
+	 */
+	if ((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) != 0)
+		tlb_flush_mmu(&tlb);
+
 	free_pgtables(&tlb, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
 				 next ? next->vm_start : USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb, start, end);


