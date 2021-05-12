Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068F237C297
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbhELPMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:12:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233655AbhELPJ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:09:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B96161624;
        Wed, 12 May 2021 15:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831762;
        bh=d9X5NxkEiroEuYcPpx1vSI/9JRS1drUH9eNkvuqUvOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2hyXkaRUL/rnEf7rfGsHKzUFY8CGpr5y58jTpSWcE61s7lYj2xlJLC82RkXMkZ//Y
         MCQNqXQIE4G1m15L/o5uqe1Z9kI1WvvakfX4XS+Kg3Si3CAz2+2xMBMzkRW9szWMaj
         sWprJMLg9yJ7mHYdjhAHQ9fJF+t1Mkf5HOfum4gs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jane Chu <jane.chu@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 238/244] mm/memory-failure: unnecessary amount of unmapping
Date:   Wed, 12 May 2021 16:50:09 +0200
Message-Id: <20210512144750.616936480@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jane Chu <jane.chu@oracle.com>

[ Upstream commit 4d75136be8bf3ae01b0bc3e725b2cdc921e103bd ]

It appears that unmap_mapping_range() actually takes a 'size' as its third
argument rather than a location, the current calling fashion causes
unnecessary amount of unmapping to occur.

Link: https://lkml.kernel.org/r/20210420002821.2749748-1-jane.chu@oracle.com
Fixes: 6100e34b2526e ("mm, memory_failure: Teach memory_failure() about dev_pagemap pages")
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory-failure.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 3151c87dff73..d823ec74f3fc 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1215,7 +1215,7 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 		 * communicated in siginfo, see kill_proc()
 		 */
 		start = (page->index << PAGE_SHIFT) & ~(size - 1);
-		unmap_mapping_range(page->mapping, start, start + size, 0);
+		unmap_mapping_range(page->mapping, start, size, 0);
 	}
 	kill_procs(&tokill, flags & MF_MUST_KILL, !unmap_success, pfn, flags);
 	rc = 0;
-- 
2.30.2



