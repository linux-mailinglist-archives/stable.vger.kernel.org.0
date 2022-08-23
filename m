Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46A759E375
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239108AbiHWMWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbiHWMT6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:19:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317FBEF038;
        Tue, 23 Aug 2022 02:42:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8AC46138B;
        Tue, 23 Aug 2022 09:42:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4E7C433D6;
        Tue, 23 Aug 2022 09:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247745;
        bh=5QEhkpbOIt5ZQhJj4twQe+roC+RNayxcEOZD8bg916A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hu4dn9a5vfDTjDyXz4w1FPKIT5NIulTjd8J2oSJOz/bi16fH8+NqTp1WeWmaI3ZUY
         qqyFj4VcT22BMNNsANw/KWMRt8k5mkpqtUc9hkYHb5TVtvec5zR2WVrPDYxf74r+o/
         Fk0Aap04XF24tGaxl4xl+Ybbp8GaI8lKgvf8ll/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/158] lib/list_debug.c: Detect uninitialized lists
Date:   Tue, 23 Aug 2022 10:27:44 +0200
Message-Id: <20220823080051.197162529@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



