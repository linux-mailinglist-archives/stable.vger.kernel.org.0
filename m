Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B10B2FFD53
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 04:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbfKRD1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Nov 2019 22:27:48 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:6244 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726283AbfKRD1r (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Nov 2019 22:27:47 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C0A5536BBF0E1CE91910;
        Mon, 18 Nov 2019 11:27:45 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Mon, 18 Nov 2019 11:27:38 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <sashal@kernel.org>, <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <willy@infradead.org>
CC:     <linux-mm@kvack.org>, <yangyingliang@huawei.com>
Subject: [PATCH 4.19] memfd: Use radix_tree_deref_slot_protected to avoid the warning.
Date:   Mon, 18 Nov 2019 11:26:08 +0800
Message-ID: <20191118032610.182862-2-zhongjiang@huawei.com>
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

The commit 99b45e7a1ba1 ("memfd: Fix locking when tagging pins")
introduces the following warning messages.

*WARNING: suspicious RCU usage in memfd_wait_for_pins*

It is because we still use radix_tree_deref_slot without read_rcu_lock.
We should use radix_tree_deref_slot_protected instead in the case.

Cc: stable@vger.kernel.org
Fixes: 99b45e7a1ba1 ("memfd: Fix locking when tagging pins")
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 mm/memfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memfd.c b/mm/memfd.c
index 5859705dafe1..9e68a4320a0e 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -41,7 +41,7 @@ static void memfd_tag_pins(struct address_space *mapping)
 
 	xa_lock_irq(&mapping->i_pages);
 	radix_tree_for_each_slot(slot, &mapping->i_pages, &iter, start) {
-		page = radix_tree_deref_slot(slot);
+		page = radix_tree_deref_slot_protected(slot, &mapping->i_pages.xa_lock);
 		if (!page || radix_tree_exception(page)) {
 			if (radix_tree_deref_retry(page)) {
 				slot = radix_tree_iter_retry(&iter);
-- 
2.20.1

