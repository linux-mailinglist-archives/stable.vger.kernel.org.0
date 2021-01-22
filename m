Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A47300B8C
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 19:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbhAVSkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:40:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:39308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728202AbhAVOTp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:19:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 041AB23AA9;
        Fri, 22 Jan 2021 14:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324862;
        bh=u204TgGO/4BDw82yYCpdPhK75rsavS1oAKSO44J18YE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0WoxpXw1ru7Ok8iHHi4KVukok/W5jME5RVO8aorTOVQIquuA/NtRKQLAns2PTaENp
         RCvXBgXhHXc/yyhJhfsfCSU1W7Um98aG/C+ghQS4TgvgqnJ4BL0zGyh8pFQapjqpr/
         bFmIQYcN+VwIE0gUOJE+nizCZV+1TBMGt2c28V98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 06/50] mm/hugetlb: fix potential missing huge page size info
Date:   Fri, 22 Jan 2021 15:11:47 +0100
Message-Id: <20210122135735.433953389@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.176469491@linuxfoundation.org>
References: <20210122135735.176469491@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

commit 0eb98f1588c2cc7a79816d84ab18a55d254f481c upstream.

The huge page size is encoded for VM_FAULT_HWPOISON errors only.  So if
we return VM_FAULT_HWPOISON, huge page size would just be ignored.

Link: https://lkml.kernel.org/r/20210107123449.38481-1-linmiaohe@huawei.com
Fixes: aa50d3a7aa81 ("Encode huge page size for VM_FAULT_HWPOISON errors")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3797,7 +3797,7 @@ retry:
 		 * So we need to block hugepage fault by PG_hwpoison bit check.
 		 */
 		if (unlikely(PageHWPoison(page))) {
-			ret = VM_FAULT_HWPOISON |
+			ret = VM_FAULT_HWPOISON_LARGE |
 				VM_FAULT_SET_HINDEX(hstate_index(h));
 			goto backout_unlocked;
 		}


