Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA701579D46
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241488AbiGSMuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241769AbiGSMss (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:48:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF898E1C8;
        Tue, 19 Jul 2022 05:19:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 445D9B81B1A;
        Tue, 19 Jul 2022 12:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9938EC341C6;
        Tue, 19 Jul 2022 12:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233137;
        bh=H2Kb4/sN5o+k5/06jEyvGqNLtfKnh+jjfO9cO4iOzDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vlNMb0bcVNFysG+Nfti0FegqZZxgkOxJz83QJDqqRl1B0DEe6tJ5GPmVuKLmoiSma
         YabW5Pb0RANWNX7xwrA4cwHh5KwD3O+ImmHxSy5JpT8x8wyh0YCgBfYF34AHZFlrY8
         B8QKCQUP+Mm8IvbwFfDfvaQZCLJvEtXPPemhhxG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        SeongJae Park <sj@kernel.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.18 019/231] mm/damon: use set_huge_pte_at() to make huge pte old
Date:   Tue, 19 Jul 2022 13:51:44 +0200
Message-Id: <20220719114715.615690833@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baolin Wang <baolin.wang@linux.alibaba.com>

commit ed1523a895ffdabcab6e067af18685ed00f5ce15 upstream.

The huge_ptep_set_access_flags() can not make the huge pte old according
to the discussion [1], that means we will always mornitor the young state
of the hugetlb though we stopped accessing the hugetlb, as a result DAMON
will get inaccurate accessing statistics.

So changing to use set_huge_pte_at() to make the huge pte old to fix this
issue.

[1] https://lore.kernel.org/all/Yqy97gXI4Nqb7dYo@arm.com/

Link: https://lkml.kernel.org/r/1655692482-28797-1-git-send-email-baolin.wang@linux.alibaba.com
Fixes: 49f4203aae06 ("mm/damon: add access checking for hugetlb pages")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/vaddr.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -407,8 +407,7 @@ static void damon_hugetlb_mkold(pte_t *p
 	if (pte_young(entry)) {
 		referenced = true;
 		entry = pte_mkold(entry);
-		huge_ptep_set_access_flags(vma, addr, pte, entry,
-					   vma->vm_flags & VM_WRITE);
+		set_huge_pte_at(mm, addr, pte, entry);
 	}
 
 #ifdef CONFIG_MMU_NOTIFIER


