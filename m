Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20E3592543
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243176AbiHNQjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242737AbiHNQiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:38:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DA51CFDE;
        Sun, 14 Aug 2022 09:29:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D154BB80B83;
        Sun, 14 Aug 2022 16:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03B5C433C1;
        Sun, 14 Aug 2022 16:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494564;
        bh=5QEhkpbOIt5ZQhJj4twQe+roC+RNayxcEOZD8bg916A=;
        h=From:To:Cc:Subject:Date:From;
        b=OeAdBJ3GiSlxCXF9IvSK7YqKI0jChZgmHwpjduMphwBesMMqUPUYaXignEaOk3Kh5
         JKmPIp4dSDAnrujLoLQPsUhZCp/0rEx7xe7heA4ZlTheT1QUtZnPhhvcpTC2xiUiXY
         dPzGSfDJqv9qOVnOdrTbu/jMUdy/Dg+dc7McDD72kuRcXWGFjFsZYsPaCppdyhfnbs
         XybJ9Wb0Gk9w6qqg5k5WpX6c3rFmTwlaUNCBKWAYlpWmd7WfdE7+STDbgAT4BNGANf
         4/7QnEzxvq/FpjLMpsHkJDIUk8bAaQ6WyQT11p0V1TMXi5McsFS2q8fv2MYzLSSMK6
         rZW7dUrsy95cQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, thunder.leizhen@huawei.com
Subject: [PATCH AUTOSEL 4.19 01/14] lib/list_debug.c: Detect uninitialized lists
Date:   Sun, 14 Aug 2022 12:29:07 -0400
Message-Id: <20220814162922.2398723-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 0cc011c576aaa4de505046f7a6c90933d7c749a9 ]

In some circumstances, attempts are made to add entries to or to remove
entries from an uninitialized list.  A prime example is
amdgpu_bo_vm_destroy(): It is indirectly called from
ttm_bo_init_reserved() if that function fails, and tries to remove an
entry from a list.  However, that list is only initialized in
amdgpu_bo_create_vm() after the call to ttm_bo_init_reserved() returned
success.  This results in crashes such as

 BUG: kernel NULL pointer dereference, address: 0000000000000000
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] PREEMPT SMP NOPTI
 CPU: 1 PID: 1479 Comm: chrome Not tainted 5.10.110-15768-g29a72e65dae5
 Hardware name: Google Grunt/Grunt, BIOS Google_Grunt.11031.149.0 07/15/2020
 RIP: 0010:__list_del_entry_valid+0x26/0x7d
 ...
 Call Trace:
  amdgpu_bo_vm_destroy+0x48/0x8b
  ttm_bo_init_reserved+0x1d7/0x1e0
  amdgpu_bo_create+0x212/0x476
  ? amdgpu_bo_user_destroy+0x23/0x23
  ? kmem_cache_alloc+0x60/0x271
  amdgpu_bo_create_vm+0x40/0x7d
  amdgpu_vm_pt_create+0xe8/0x24b
 ...

Check if the list's prev and next pointers are NULL to catch such problems.

Link: https://lkml.kernel.org/r/20220531222951.92073-1-linux@roeck-us.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/list_debug.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/lib/list_debug.c b/lib/list_debug.c
index 5d5424b51b74..413daa72a3d8 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -20,7 +20,11 @@
 bool __list_add_valid(struct list_head *new, struct list_head *prev,
 		      struct list_head *next)
 {
-	if (CHECK_DATA_CORRUPTION(next->prev != prev,
+	if (CHECK_DATA_CORRUPTION(prev == NULL,
+			"list_add corruption. prev is NULL.\n") ||
+	    CHECK_DATA_CORRUPTION(next == NULL,
+			"list_add corruption. next is NULL.\n") ||
+	    CHECK_DATA_CORRUPTION(next->prev != prev,
 			"list_add corruption. next->prev should be prev (%px), but was %px. (next=%px).\n",
 			prev, next->prev, next) ||
 	    CHECK_DATA_CORRUPTION(prev->next != next,
@@ -42,7 +46,11 @@ bool __list_del_entry_valid(struct list_head *entry)
 	prev = entry->prev;
 	next = entry->next;
 
-	if (CHECK_DATA_CORRUPTION(next == LIST_POISON1,
+	if (CHECK_DATA_CORRUPTION(next == NULL,
+			"list_del corruption, %px->next is NULL\n", entry) ||
+	    CHECK_DATA_CORRUPTION(prev == NULL,
+			"list_del corruption, %px->prev is NULL\n", entry) ||
+	    CHECK_DATA_CORRUPTION(next == LIST_POISON1,
 			"list_del corruption, %px->next is LIST_POISON1 (%px)\n",
 			entry, LIST_POISON1) ||
 	    CHECK_DATA_CORRUPTION(prev == LIST_POISON2,
-- 
2.35.1

