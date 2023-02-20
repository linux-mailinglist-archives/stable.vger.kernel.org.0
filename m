Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8CA69CE90
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbjBTOAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbjBTOAQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:00:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47CCC1F4BA
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:59:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E762160E8A
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08609C433D2;
        Mon, 20 Feb 2023 13:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901577;
        bh=JpbgTkXum74TX30au09WBwW3qPMFbAxfuvW5DG4RRtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mmxcdtN4TXBy+a69g6ITtIfSsOY5R2509PhfE/Z+gqSXMNyb75k5DI5I0JqCQ931O
         zKZVKfCoaN3Vejkbk8HU75czkbF3d3src39e75mdTxzIMHosNjvzJGDDnF37ZdPGtu
         RxcoQLx19ky/nzmD4hTZZfJhf4db1LmeEdNE9Dvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Xu <peterx@redhat.com>,
        Nick Bowler <nbowler@draconx.ca>,
        David Hildenbrand <david@redhat.com>,
        regressions@lists.linux.dev,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 071/118] mm/migrate: fix wrongly apply write bit after mkdirty on sparc64
Date:   Mon, 20 Feb 2023 14:36:27 +0100
Message-Id: <20230220133603.268017039@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

commit 96a9c287e25d690fd9623b5133703b8e310fbed1 upstream.

Nick Bowler reported another sparc64 breakage after the young/dirty
persistent work for page migration (per "Link:" below).  That's after a
similar report [2].

It turns out page migration was overlooked, and it wasn't failing before
because page migration was not enabled in the initial report test
environment.

David proposed another way [2] to fix this from sparc64 side, but that
patch didn't land somehow.  Neither did I check whether there's any other
arch that has similar issues.

Let's fix it for now as simple as moving the write bit handling to be
after dirty, like what we did before.

Note: this is based on mm-unstable, because the breakage was since 6.1 and
we're at a very late stage of 6.2 (-rc8), so I assume for this specific
case we should target this at 6.3.

[1] https://lore.kernel.org/all/20221021160603.GA23307@u164.east.ru/
[2] https://lore.kernel.org/all/20221212130213.136267-1-david@redhat.com/

Link: https://lkml.kernel.org/r/20230216153059.256739-1-peterx@redhat.com
Fixes: 2e3468778dbe ("mm: remember young/dirty bit for page migrations")
Link: https://lore.kernel.org/all/CADyTPExpEqaJiMGoV+Z6xVgL50ZoMJg49B10LcZ=8eg19u34BA@mail.gmail.com/
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Nick Bowler <nbowler@draconx.ca>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Nick Bowler <nbowler@draconx.ca>
Cc: <regressions@lists.linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    6 ++++--
 mm/migrate.c     |    2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3253,8 +3253,6 @@ void remove_migration_pmd(struct page_vm
 	pmde = mk_huge_pmd(new, READ_ONCE(vma->vm_page_prot));
 	if (pmd_swp_soft_dirty(*pvmw->pmd))
 		pmde = pmd_mksoft_dirty(pmde);
-	if (is_writable_migration_entry(entry))
-		pmde = maybe_pmd_mkwrite(pmde, vma);
 	if (pmd_swp_uffd_wp(*pvmw->pmd))
 		pmde = pmd_wrprotect(pmd_mkuffd_wp(pmde));
 	if (!is_migration_entry_young(entry))
@@ -3262,6 +3260,10 @@ void remove_migration_pmd(struct page_vm
 	/* NOTE: this may contain setting soft-dirty on some archs */
 	if (PageDirty(new) && is_migration_entry_dirty(entry))
 		pmde = pmd_mkdirty(pmde);
+	if (is_writable_migration_entry(entry))
+		pmde = maybe_pmd_mkwrite(pmde, vma);
+	else
+		pmde = pmd_wrprotect(pmde);
 
 	if (PageAnon(new)) {
 		rmap_t rmap_flags = RMAP_COMPOUND;
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -215,6 +215,8 @@ static bool remove_migration_pte(struct
 			pte = maybe_mkwrite(pte, vma);
 		else if (pte_swp_uffd_wp(*pvmw.pte))
 			pte = pte_mkuffd_wp(pte);
+		else
+			pte = pte_wrprotect(pte);
 
 		if (folio_test_anon(folio) && !is_readable_migration_entry(entry))
 			rmap_flags |= RMAP_EXCLUSIVE;


