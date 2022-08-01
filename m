Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E37A586414
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 08:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiHAG3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 02:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiHAG3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 02:29:49 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB5B1260D
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 23:29:47 -0700 (PDT)
Date:   Mon, 1 Aug 2022 15:29:37 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1659335385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IYbD1tPDd1A26aCDdhm4i3Wh+pM5Gpdp0D/RRf9i1WA=;
        b=Q/xVQJykbBVfheS1zRHR0dB48tHDw7rv9TIDkbqUspcb3NoCHy5uupZdSdbBgvS99Of9sf
        k/aYGFTo1yzaqboHjAo0tgSHnYGvPwHzOzh/QsllnzDZJWBN1DgU/hkBw7A8bOOn+hPoLy
        /y9073y9PVpPc5RfPp3OxkRQRzZ/YZg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Naoya Horiguchi <naoya.horiguchi@linux.dev>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        liushixin2@huawei.com, mike.kravetz@oracle.com, osalvador@suse.de,
        shy828301@gmail.com, songmuchun@bytedance.com,
        naoya.horiguchi@nec.com, naoya.horiguchi@linux.dev
Subject: Re: FAILED: patch "[PATCH] mm/hugetlb: separate path for hwpoison
 entry in" failed to apply to 5.18-stable tree
Message-ID: <20220801062937.GA192992@ik1-406-35019.vs.sakura.ne.jp>
References: <165919533798118@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <165919533798118@kroah.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 30, 2022 at 05:35:37PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.18-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,

Hello,

I updated the patch for 5.18-stable, could you apply this?

Thanks,
Naoya Horiguchi
---
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Date: Mon, 1 Aug 2022 15:09:17 +0900
Subject: [PATCH] mm/hugetlb: separate path for hwpoison entry in
 copy_hugetlb_page_range()

commit c2cb0dcce9dd8b748b6ca8bb8d4a389f2e232307 upstream.

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

[naoya.horiguchi: Resolved conflict to apply for 5.18-stable.]

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
---
 mm/hugetlb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 410bbb0aee32..0aa670addd8c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4764,8 +4764,9 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 			 * sharing with another vma.
 			 */
 			;
-		} else if (unlikely(is_hugetlb_entry_migration(entry) ||
-				    is_hugetlb_entry_hwpoisoned(entry))) {
+		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry))) {
+			set_huge_pte_at(dst, addr, dst_pte, entry);
+		} else if (unlikely(is_hugetlb_entry_migration(entry))) {
 			swp_entry_t swp_entry = pte_to_swp_entry(entry);
 
 			if (is_writable_migration_entry(swp_entry) && cow) {
-- 
2.26.1.8815.g6a475b71f8



> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From c2cb0dcce9dd8b748b6ca8bb8d4a389f2e232307 Mon Sep 17 00:00:00 2001
> From: Naoya Horiguchi <naoya.horiguchi@nec.com>
> Date: Mon, 4 Jul 2022 10:33:05 +0900
> Subject: [PATCH] mm/hugetlb: separate path for hwpoison entry in
>  copy_hugetlb_page_range()
> 
> Originally copy_hugetlb_page_range() handles migration entries and
> hwpoisoned entries in similar manner.  But recently the related code path
> has more code for migration entries, and when
> is_writable_migration_entry() was converted to
> !is_readable_migration_entry(), hwpoison entries on source processes got
> to be unexpectedly updated (which is legitimate for migration entries, but
> not for hwpoison entries).  This results in unexpected serious issues like
> kernel panic when forking processes with hwpoison entries in pmd.
> 
> Separate the if branch into one for hwpoison entries and one for migration
> entries.
> 
> Link: https://lkml.kernel.org/r/20220704013312.2415700-3-naoya.horiguchi@linux.dev
> Fixes: 6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_anon_exclusive")
> Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
> Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
> Reviewed-by: Muchun Song <songmuchun@bytedance.com>
> Cc: <stable@vger.kernel.org>	[5.18]
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Liu Shixin <liushixin2@huawei.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Yang Shi <shy828301@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index a57e1be41401..baf7f6b19ce6 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4788,8 +4788,13 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
>  			 * sharing with another vma.
>  			 */
>  			;
> -		} else if (unlikely(is_hugetlb_entry_migration(entry) ||
> -				    is_hugetlb_entry_hwpoisoned(entry))) {
> +		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry))) {
> +			bool uffd_wp = huge_pte_uffd_wp(entry);
> +
> +			if (!userfaultfd_wp(dst_vma) && uffd_wp)
> +				entry = huge_pte_clear_uffd_wp(entry);
> +			set_huge_pte_at(dst, addr, dst_pte, entry);
> +		} else if (unlikely(is_hugetlb_entry_migration(entry))) {
>  			swp_entry_t swp_entry = pte_to_swp_entry(entry);
>  			bool uffd_wp = huge_pte_uffd_wp(entry);
>  
