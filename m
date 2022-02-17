Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952DF4B9F6E
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 12:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233749AbiBQLyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 06:54:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbiBQLyj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 06:54:39 -0500
Received: from ha.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 547D0291FA6;
        Thu, 17 Feb 2022 03:54:24 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by ha.nfschina.com (Postfix) with ESMTP id 0C2121E80D5E;
        Thu, 17 Feb 2022 19:49:57 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from ha.nfschina.com ([127.0.0.1])
        by localhost (ha.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kVcriJz6XfI6; Thu, 17 Feb 2022 19:49:54 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: liqiong@nfschina.com)
        by ha.nfschina.com (Postfix) with ESMTPA id 0DE371E80CB5;
        Thu, 17 Feb 2022 19:49:54 +0800 (CST)
From:   liqiong <liqiong@nfschina.com>
To:     david@redhat.com, gregkh@linuxfoundation.org
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        liqiong <liqiong@nfschina.com>, stable@vger.kernel.org
Subject: [PATCH] [PATCH 4.19 STABLE] mm: fix dereference a null pointer in migrate[_huge]_page_move_mapping()
Date:   Thu, 17 Feb 2022 19:54:16 +0800
Message-Id: <20220217115416.55835-1-liqiong@nfschina.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220217063808.42018-1-liqiong@nfschina.com>
References: <20220217063808.42018-1-liqiong@nfschina.com>
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

Upstream doesn't use radix tree any more in migrate.c, no need this patch.

The two functions look up a slot and dereference the pointer,
If the pointer is null, the kernel would crash and dump.

The 'numad' service calls 'migrate_pages' periodically. If some slots
being replaced (Cache Eviction), the radix_tree_lookup_slot() returns
a null pointer that causes kernel crash.

"numad":  crash> bt
[exception RIP: migrate_page_move_mapping+337]

Introduce pointer checking to avoid dereference a null pointer.

Cc: <stable@vger.kernel.org> # linux-4.19.y
Signed-off-by: liqiong <liqiong@nfschina.com>
---
 mm/migrate.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index a69b842f95da..76f8dedc0e02 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -472,6 +472,10 @@ int migrate_page_move_mapping(struct address_space *mapping,
 
 	pslot = radix_tree_lookup_slot(&mapping->i_pages,
  					page_index(page));
+	if (pslot == NULL) {
+		xa_unlock_irq(&mapping->i_pages);
+		return -EAGAIN;
+	}
 
 	expected_count += hpage_nr_pages(page) + page_has_private(page);
 	if (page_count(page) != expected_count ||
@@ -590,6 +594,10 @@ int migrate_huge_page_move_mapping(struct address_space *mapping,
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

