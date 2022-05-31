Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A44C5395AC
	for <lists+stable@lfdr.de>; Tue, 31 May 2022 19:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245133AbiEaR50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 May 2022 13:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239219AbiEaR50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 May 2022 13:57:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B4333E27;
        Tue, 31 May 2022 10:57:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3234610A5;
        Tue, 31 May 2022 17:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44599C385A9;
        Tue, 31 May 2022 17:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654019843;
        bh=ueWQI/6M9ZmJjFMQ+LvGG7h4tEaNsx2HarM9S0SaMTE=;
        h=Date:To:From:Subject:From;
        b=h8HclQLl9G2imkN1iDG4t9d3viTXl7KqRT7Wz6Pd5X+jyYbPBGCV5PwyLN3rz4eAD
         9AQVF7HcYppkdIeKrx7zyg1RlUj8/2xBIPqN3JyH/m+/wtPvMWSDqU8wNVvlO+PbCZ
         8EcsekazwBYga52a5bpj/H5nR0lyfMMb4fU33hio=
Date:   Tue, 31 May 2022 10:57:22 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, osalvador@suse.de, david@redhat.com,
        anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memremap-fix-missing-call-to-untrack_pfn-in-pagemap_range.patch added to mm-hotfixes-unstable branch
Message-Id: <20220531175723.44599C385A9@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/memremap: fix missing call to untrack_pfn() in pagemap_range()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memremap-fix-missing-call-to-untrack_pfn-in-pagemap_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memremap-fix-missing-call-to-untrack_pfn-in-pagemap_range.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memremap: fix missing call to untrack_pfn() in pagemap_range()
Date: Tue, 31 May 2022 20:26:43 +0800

We forget to call untrack_pfn() to pair with track_pfn_remap() when range
is not allowed to hotplug.  Fix it by jump err_kasan.

Link: https://lkml.kernel.org/r/20220531122643.25249-1-linmiaohe@huawei.com
Fixes: bca3feaa0764 ("mm/memory_hotplug: prevalidate the address range being added with platform")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memremap.c~mm-memremap-fix-missing-call-to-untrack_pfn-in-pagemap_range
+++ a/mm/memremap.c
@@ -214,7 +214,7 @@ static int pagemap_range(struct dev_page
 
 	if (!mhp_range_allowed(range->start, range_len(range), !is_private)) {
 		error = -EINVAL;
-		goto err_pfn_remap;
+		goto err_kasan;
 	}
 
 	mem_hotplug_begin();
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

maintainers-add-maintainer-information-for-z3fold.patch
mm-memremap-fix-missing-call-to-untrack_pfn-in-pagemap_range.patch
mm-shmemc-clean-up-comment-of-shmem_swapin_folio.patch
mm-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch

