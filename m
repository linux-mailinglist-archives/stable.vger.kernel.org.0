Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE9DA9021
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389666AbfIDSHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:07:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389673AbfIDSHv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:07:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9611722CEA;
        Wed,  4 Sep 2019 18:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620470;
        bh=0JTnuWsTelDkywrJ0M1VQsfCLhs1bVpfAngi0Bt8z9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qik2EbBDcfB8OyGfrBcU4zWn1PLWAp6oHaGib4Q/17J/MKAIIRZZoSO601xUNWCb6
         UsHJ8DCipxRz9Rw5fIoNTZZWkLzDgX9GfWOHTahxo8LTkbSa48ClpCzlcR+tH98zuz
         dFc+48F8qmibVyPlPtYjvUy7lyhWImaotGQl/i18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>
Subject: [PATCH 4.19 70/93] lib: logic_pio: Fix RCU usage
Date:   Wed,  4 Sep 2019 19:54:12 +0200
Message-Id: <20190904175309.102352926@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

commit 06709e81c668f5f56c65b806895b278517bd44e0 upstream.

The traversing of io_range_list with list_for_each_entry_rcu()
is not properly protected by rcu_read_lock() and rcu_read_unlock(),
so add them.

These functions mark the critical section scope where the list is
protected for the reader, it cannot be  "reclaimed". Any updater - in
this case, the logical PIO registration functions - cannot update the
list until the reader exits this critical section.

In addition, the list traversing used in logic_pio_register_range()
does not need to use the rcu variant.

This is because we are already using io_range_mutex to guarantee mutual
exclusion from mutating the list.

Cc: stable@vger.kernel.org
Fixes: 031e3601869c ("lib: Add generic PIO mapping method")
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/logic_pio.c |   49 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 14 deletions(-)

--- a/lib/logic_pio.c
+++ b/lib/logic_pio.c
@@ -46,7 +46,7 @@ int logic_pio_register_range(struct logi
 	end = new_range->hw_start + new_range->size;
 
 	mutex_lock(&io_range_mutex);
-	list_for_each_entry_rcu(range, &io_range_list, list) {
+	list_for_each_entry(range, &io_range_list, list) {
 		if (range->fwnode == new_range->fwnode) {
 			/* range already there */
 			goto end_register;
@@ -108,26 +108,38 @@ end_register:
  */
 struct logic_pio_hwaddr *find_io_range_by_fwnode(struct fwnode_handle *fwnode)
 {
-	struct logic_pio_hwaddr *range;
+	struct logic_pio_hwaddr *range, *found_range = NULL;
 
+	rcu_read_lock();
 	list_for_each_entry_rcu(range, &io_range_list, list) {
-		if (range->fwnode == fwnode)
-			return range;
+		if (range->fwnode == fwnode) {
+			found_range = range;
+			break;
+		}
 	}
-	return NULL;
+	rcu_read_unlock();
+
+	return found_range;
 }
 
 /* Return a registered range given an input PIO token */
 static struct logic_pio_hwaddr *find_io_range(unsigned long pio)
 {
-	struct logic_pio_hwaddr *range;
+	struct logic_pio_hwaddr *range, *found_range = NULL;
 
+	rcu_read_lock();
 	list_for_each_entry_rcu(range, &io_range_list, list) {
-		if (in_range(pio, range->io_start, range->size))
-			return range;
+		if (in_range(pio, range->io_start, range->size)) {
+			found_range = range;
+			break;
+		}
 	}
-	pr_err("PIO entry token %lx invalid\n", pio);
-	return NULL;
+	rcu_read_unlock();
+
+	if (!found_range)
+		pr_err("PIO entry token 0x%lx invalid\n", pio);
+
+	return found_range;
 }
 
 /**
@@ -180,14 +192,23 @@ unsigned long logic_pio_trans_cpuaddr(re
 {
 	struct logic_pio_hwaddr *range;
 
+	rcu_read_lock();
 	list_for_each_entry_rcu(range, &io_range_list, list) {
 		if (range->flags != LOGIC_PIO_CPU_MMIO)
 			continue;
-		if (in_range(addr, range->hw_start, range->size))
-			return addr - range->hw_start + range->io_start;
+		if (in_range(addr, range->hw_start, range->size)) {
+			unsigned long cpuaddr;
+
+			cpuaddr = addr - range->hw_start + range->io_start;
+
+			rcu_read_unlock();
+			return cpuaddr;
+		}
 	}
-	pr_err("addr %llx not registered in io_range_list\n",
-	       (unsigned long long) addr);
+	rcu_read_unlock();
+
+	pr_err("addr %pa not registered in io_range_list\n", &addr);
+
 	return ~0UL;
 }
 


