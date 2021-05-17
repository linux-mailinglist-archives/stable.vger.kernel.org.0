Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7C83830D3
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240179AbhEQObr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239932AbhEQO3i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:29:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40BBE6162F;
        Mon, 17 May 2021 14:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260882;
        bh=jZg9Nfkp6NaT9j+pNjhQadU8Qkt9QEg7dV8blh+bJ6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3/v6bY3JWo7CJm5h0oI4Bwn5q1+xkN/fdbkGAYDbIp0ziF6tT34/Pq5jRQ0wyPNo
         6S++9QzX0ezBbDwfXCx3nJmSaBH4Xd7VLqs3jo0o1jTiXGPRRYJySM0LWUnTkZFvGj
         /c68jcnLzF3wzXuqqUGMEn8UEjMXmNPZDcqJTgtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Hugh Dickins <hughd@google.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 259/363] mm/hugetlb: fix cow where page writtable in child
Date:   Mon, 17 May 2021 16:02:05 +0200
Message-Id: <20210517140311.350695394@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

commit 84894e1c42e9f25c17f2888e0c0e1505cb727538 upstream.

When rework early cow of pinned hugetlb pages, we moved huge_ptep_get()
upper but overlooked a side effect that the huge_ptep_get() will fetch the
pte after wr-protection.  After moving it upwards, we need explicit
wr-protect of child pte or we will keep the write bit set in the child
process, which could cause data corrution where the child can write to the
original page directly.

This issue can also be exposed by "memfd_test hugetlbfs" kselftest.

Link: https://lkml.kernel.org/r/20210503234356.9097-3-peterx@redhat.com
Fixes: 4eae4efa2c299 ("hugetlb: do early cow when page pinned on src mm")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3905,6 +3905,7 @@ again:
 				 * See Documentation/vm/mmu_notifier.rst
 				 */
 				huge_ptep_set_wrprotect(src, addr, src_pte);
+				entry = huge_pte_wrprotect(entry);
 			}
 
 			page_dup_rmap(ptepage, true);


