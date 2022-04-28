Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528265138E6
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 17:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349446AbiD1PqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 11:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349384AbiD1Pp6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 11:45:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA861B820F;
        Thu, 28 Apr 2022 08:42:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9885961FCF;
        Thu, 28 Apr 2022 15:42:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C296C385A0;
        Thu, 28 Apr 2022 15:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651160560;
        bh=ilVGieZZEUUvQGWgxV/ekNNEKBv8j99uQo8L2J5iPnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TphhwJI1zDAFX85nU7OlzRbFcWxeMhtHQXNO03ghzEVhdh+AnuBmpXvO05ukLPq7w
         0r2qwhfPcteuyDNlPvIfVvk2dGevzA8z0PqgEwEZOJ7LY9H2r/vjq8H/8D6b5ab4Kg
         gF0vGZbGbRGXCWzjyld3aE0UXSXnS0vq58UdCfLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hugh Dickins <hughd@google.com>, Yang Shi <shy828301@gmail.com>,
        Ralph Campbell <rcampbell@nvidia.com>, Zi Yan <ziy@nvidia.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH AUTOSEL 12/14] mm/thp: refix __split_huge_pmd_locked() for migration PMD
Date:   Thu, 28 Apr 2022 17:42:20 +0200
Message-Id: <20220428154222.1230793-12-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
References: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2125; i=gregkh@linuxfoundation.org; h=from:subject; bh=2n4FFedWfpMpKCUPl3SXm4kSvYrTBoaoARY2+jFW1hk=; b=owGbwMvMwCRo6H6F97bub03G02pJDElZW++pcwp8fCAvs2yu/Yys01Pe9v9Y9m9xb8FF0fsRe97w nOXU64hlYRBkYpAVU2T5so3n6P6KQ4pehranYeawMoEMYeDiFICJfLrEsKCha/qJglfTnob7dEYvW/ HF7Xnr230M80vSHtmarV24JTdQ/Mb+UmHJ9D13+AA=
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

commit 9d84604b845c3888d1bede43d16ab3ebedb13e24 upstream.

Migration entries do not contribute to a page's reference count: move
__split_huge_pmd_locked()'s page_ref_add() into pmd_migration's else
block (along with the page_count() check - a page is quite likely to
have reference count frozen to 0 when a migration entry is found).

This will fix a very rare anonymous memory leak, after a
split_huge_pmd() raced with an anon split_huge_page() or an anon THP
migrate_pages(): since the wrongly raised refcount stopped the page
(perhaps small, perhaps huge, depending on when the race hit) from ever
being freed.

At first I thought there were worse risks, from prematurely unfreezing a
frozen page: but now think that would only affect page cache pages,
which do not come this way (except for anonymous pages in swap cache,
perhaps).

Link: https://lkml.kernel.org/r/84792468-f512-e48f-378c-e34c3641e97@google.com
Fixes: ec0abae6dcdf ("mm/thp: fix __split_huge_pmd_locked() for migration PMD")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 406a3c28c026..468fca576bc2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2055,9 +2055,9 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		young = pmd_young(old_pmd);
 		soft_dirty = pmd_soft_dirty(old_pmd);
 		uffd_wp = pmd_uffd_wp(old_pmd);
+		VM_BUG_ON_PAGE(!page_count(page), page);
+		page_ref_add(page, HPAGE_PMD_NR - 1);
 	}
-	VM_BUG_ON_PAGE(!page_count(page), page);
-	page_ref_add(page, HPAGE_PMD_NR - 1);
 
 	/*
 	 * Withdraw the table only after we mark the pmd entry invalid.
-- 
2.36.0

