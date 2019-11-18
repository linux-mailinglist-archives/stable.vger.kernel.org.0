Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF01FFD54
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 04:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfKRD1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Nov 2019 22:27:48 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:6242 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726266AbfKRD1s (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Nov 2019 22:27:48 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B522B381036568F775A9;
        Mon, 18 Nov 2019 11:27:45 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Mon, 18 Nov 2019 11:27:39 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <sashal@kernel.org>, <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <willy@infradead.org>
CC:     <linux-mm@kvack.org>, <yangyingliang@huawei.com>
Subject: [PATCH 4.4] memfd: Use radix_tree_deref_slot_protected to avoid the warning.
Date:   Mon, 18 Nov 2019 11:26:09 +0800
Message-ID: <20191118032610.182862-3-zhongjiang@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191118032610.182862-1-zhongjiang@huawei.com>
References: <20191118032610.182862-1-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The commit eb4058d8daf8 ("memfd: Fix locking when tagging pins")
introduces the following warning messages.

*WARNING: suspicious RCU usage in memfd_wait_for_pins*

It is because we still use radix_tree_deref_slot without read_rcu_lock.
We should use radix_tree_deref_slot_protected instead in the case.

Cc: stable@vger.kernel.org
Fixes: eb4058d8daf8 ("memfd: Fix locking when tagging pins")
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 mm/shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 62668379623b..e40239bf6dfe 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1862,7 +1862,7 @@ static void shmem_tag_pins(struct address_space *mapping)
 	spin_lock_irq(&mapping->tree_lock);
 restart:
 	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
-		page = radix_tree_deref_slot(slot);
+		page = radix_tree_deref_slot_protected(slot, &mapping->tree_lock);
 		if (!page || radix_tree_exception(page)) {
 			if (radix_tree_deref_retry(page))
 				goto restart;
-- 
2.20.1

