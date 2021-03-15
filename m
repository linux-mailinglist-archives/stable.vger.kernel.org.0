Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885AE33BC89
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhCOO0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:26:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231339AbhCOOZF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:25:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD41565034;
        Mon, 15 Mar 2021 14:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615818303;
        bh=i2wPDpQepoyd174IhYDaTZz9t19/Nyu9TiRjhF4kV7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Up5hsmNq9aXgkoR3kQ93cE6T2x2BSIAGkrslVbdJRKWHvDVnpu3HmYk1+x1hYBOWu
         SgqD2Pkd3ZnQYxXNDlQD/jHf7xDQ97CF7UF2QTw6JgJBcxnUdCKCNEzMky2ZAsaWlj
         ojU+HMnHdWFrKG/orvo3/V6q5byvnAq81jBivuDw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhou Guanghui <zhouguanghui1@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Hugh Dickins <hughd@google.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Rui Xiang <rui.xiang@huawei.com>,
        Tianhong Ding <dingtianhong@huawei.com>,
        Weilong Chen <chenweilong@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 303/306] mm/memcg: set memcg when splitting page
Date:   Mon, 15 Mar 2021 15:24:28 +0100
Message-Id: <20210315135517.947042710@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135517.556638562@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
 <20210315135517.556638562@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Zhou Guanghui <zhouguanghui1@huawei.com>

commit e1baddf8475b06cc56f4bafecf9a32a124343d9f upstream.

As described in the split_page() comment, for the non-compound high order
page, the sub-pages must be freed individually.  If the memcg of the first
page is valid, the tail pages cannot be uncharged when be freed.

For example, when alloc_pages_exact is used to allocate 1MB continuous
physical memory, 2MB is charged(kmemcg is enabled and __GFP_ACCOUNT is
set).  When make_alloc_exact free the unused 1MB and free_pages_exact free
the applied 1MB, actually, only 4KB(one page) is uncharged.

Therefore, the memcg of the tail page needs to be set when splitting a
page.

Michel:

There are at least two explicit users of __GFP_ACCOUNT with
alloc_exact_pages added recently.  See 7efe8ef274024 ("KVM: arm64:
Allocate stage-2 pgd pages with GFP_KERNEL_ACCOUNT") and c419621873713
("KVM: s390: Add memcg accounting to KVM allocations"), so this is not
just a theoretical issue.

Link: https://lkml.kernel.org/r/20210304074053.65527-3-zhouguanghui1@huawei.com
Signed-off-by: Zhou Guanghui <zhouguanghui1@huawei.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Rui Xiang <rui.xiang@huawei.com>
Cc: Tianhong Ding <dingtianhong@huawei.com>
Cc: Weilong Chen <chenweilong@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3313,6 +3313,7 @@ void split_page(struct page *page, unsig
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
 	split_page_owner(page, 1 << order);
+	split_page_memcg(page, 1 << order);
 }
 EXPORT_SYMBOL_GPL(split_page);
 


