Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 912464B995A
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 07:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbiBQGnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 01:43:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiBQGnk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 01:43:40 -0500
X-Greylist: delayed 292 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 16 Feb 2022 22:43:24 PST
Received: from ha.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2809714864F;
        Wed, 16 Feb 2022 22:43:23 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by ha.nfschina.com (Postfix) with ESMTP id 45DF81E80D5E;
        Thu, 17 Feb 2022 14:34:06 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from ha.nfschina.com ([127.0.0.1])
        by localhost (ha.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ck-wX0osscM8; Thu, 17 Feb 2022 14:34:03 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: liqiong@nfschina.com)
        by ha.nfschina.com (Postfix) with ESMTPA id 3FAA61E80CB5;
        Thu, 17 Feb 2022 14:34:03 +0800 (CST)
From:   liqiong <liqiong@nfschina.com>
To:     linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org, liqiong <liqiong@nfschina.com>,
        stable@vger.kernel.org
Subject: [PATCH] mm: fix dereference a null pointer in migrate[_huge]_page_move_mapping()
Date:   Thu, 17 Feb 2022 14:38:08 +0800
Message-Id: <20220217063808.42018-1-liqiong@nfschina.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream has no this bug.

The two functions look up a slot and dereference the pointer,
If the pointer is null, the kernel would crash and dump.

The 'numad' service calls 'migrate_pages' periodically. If some slots
being replaced (Cache Eviction), the radix_tree_lookup_slot() returns
a null pointer, then, kernel crash.

"numad":  crash> bt
[exception RIP: migrate_page_move_mapping+337]

Introduct a pointer checking to avoid dereference a null pointer.

Cc: <stable@vger.kernel.org> # v4.19-rc8
Signed-off-by: liqiong <liqiong@nfschina.com>
---
 mm/migrate.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index 84381b55b2bd..1ff95c259511 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -474,6 +474,10 @@ int migrate_page_move_mapping(struct address_space *mapping,
 
 	pslot = radix_tree_lookup_slot(&mapping->i_pages,
  					page_index(page));
+	if (pslot == NULL) {
+		xa_unlock_irq(&mapping->i_pages);
+		return -EAGAIN;
+	}
 
 	expected_count += hpage_nr_pages(page) + page_has_private(page);
 	if (page_count(page) != expected_count ||
@@ -592,6 +596,10 @@ int migrate_huge_page_move_mapping(struct address_space *mapping,
 	xa_lock_irq(&mapping->i_pages);
 
 	pslot = radix_tree_lookup_slot(&mapping->i_pages, page_index(page));
+	if (pslot == NULL) {
+		xa_unlock_irq(&mapping->i_pages);
+		return -EAGAIN;
+	}
 
 	expected_count = 2 + page_has_private(page);
 	if (page_count(page) != expected_count ||
-- 
2.25.1

