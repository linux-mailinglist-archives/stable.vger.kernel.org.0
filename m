Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFBCB585B0A
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 17:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234503AbiG3Pfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jul 2022 11:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235063AbiG3Pfp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jul 2022 11:35:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947AEB860
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 08:35:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3239060DC8
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 15:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3596DC433D6;
        Sat, 30 Jul 2022 15:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659195340;
        bh=hiOUB2jdeeTbs4f5tTn8X/bdCJR4USroAMIfHrcPWV0=;
        h=Subject:To:Cc:From:Date:From;
        b=KWWqasiJU5KcWRMJKwu31W147l9+bmso1BOf2hCIaogRq+dg88vC8JinPafa+HZay
         qMPRasScpAEo6HvYOTcN5166gHUIjCwxzE+wgLstamZzWTET204fSv8DMwg/bNfKrE
         Il6l4ltKV9o/0kpFbm+v8xkIw6K/dVbJkk3avIO8=
Subject: FAILED: patch "[PATCH] mm/hugetlb: separate path for hwpoison entry in" failed to apply to 5.18-stable tree
To:     naoya.horiguchi@nec.com, akpm@linux-foundation.org,
        david@redhat.com, linmiaohe@huawei.com, liushixin2@huawei.com,
        mike.kravetz@oracle.com, osalvador@suse.de, shy828301@gmail.com,
        songmuchun@bytedance.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Jul 2022 17:35:37 +0200
Message-ID: <165919533798118@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c2cb0dcce9dd8b748b6ca8bb8d4a389f2e232307 Mon Sep 17 00:00:00 2001
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Date: Mon, 4 Jul 2022 10:33:05 +0900
Subject: [PATCH] mm/hugetlb: separate path for hwpoison entry in
 copy_hugetlb_page_range()

Originally copy_hugetlb_page_range() handles migration entries and
hwpoisoned entries in similar manner.  But recently the related code path
has more code for migration entries, and when
is_writable_migration_entry() was converted to
!is_readable_migration_entry(), hwpoison entries on source processes got
to be unexpectedly updated (which is legitimate for migration entries, but
not for hwpoison entries).  This results in unexpected serious issues like
kernel panic when forking processes with hwpoison entries in pmd.

Separate the if branch into one for hwpoison entries and one for migration
entries.

Link: https://lkml.kernel.org/r/20220704013312.2415700-3-naoya.horiguchi@linux.dev
Fixes: 6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_anon_exclusive")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>	[5.18]
Cc: David Hildenbrand <david@redhat.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a57e1be41401..baf7f6b19ce6 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4788,8 +4788,13 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 			 * sharing with another vma.
 			 */
 			;
-		} else if (unlikely(is_hugetlb_entry_migration(entry) ||
-				    is_hugetlb_entry_hwpoisoned(entry))) {
+		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry))) {
+			bool uffd_wp = huge_pte_uffd_wp(entry);
+
+			if (!userfaultfd_wp(dst_vma) && uffd_wp)
+				entry = huge_pte_clear_uffd_wp(entry);
+			set_huge_pte_at(dst, addr, dst_pte, entry);
+		} else if (unlikely(is_hugetlb_entry_migration(entry))) {
 			swp_entry_t swp_entry = pte_to_swp_entry(entry);
 			bool uffd_wp = huge_pte_uffd_wp(entry);
 

