Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69DB84ABB4E
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384325AbiBGL15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382290AbiBGLSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:18:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32900C0401C4;
        Mon,  7 Feb 2022 03:18:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B164761388;
        Mon,  7 Feb 2022 11:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA264C004E1;
        Mon,  7 Feb 2022 11:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232710;
        bh=eO66bblHotUaQQr6rj5DB9ysK3KxlrmkQ4Nqnmw5nrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aNgiPYPUiNeTnLNAlQDrhnE6D+Qvr8C3mCVu5aQ07fErdnP0HcwWlRurXw2NABiDl
         URV7zv+pA42O1An7Axh0pXCgQv7X47OHmt7hkqqQPn6fxwb5q8gWbJbMWQQzlQojJn
         hTaoISrTKI413UgVNhFKq5u3WHydNTd4URs9/g3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lang Yu <lang.yu@amd.com>,
        David Hildenbrand <david@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oscar Salvador <osalvador@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 12/44] mm/kmemleak: avoid scanning potential huge holes
Date:   Mon,  7 Feb 2022 12:06:28 +0100
Message-Id: <20220207103753.556364034@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103753.155627314@linuxfoundation.org>
References: <20220207103753.155627314@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Lang Yu <lang.yu@amd.com>

commit c10a0f877fe007021d70f9cada240f42adc2b5db upstream.

When using devm_request_free_mem_region() and devm_memremap_pages() to
add ZONE_DEVICE memory, if requested free mem region's end pfn were
huge(e.g., 0x400000000), the node_end_pfn() will be also huge (see
move_pfn_range_to_zone()).  Thus it creates a huge hole between
node_start_pfn() and node_end_pfn().

We found on some AMD APUs, amdkfd requested such a free mem region and
created a huge hole.  In such a case, following code snippet was just
doing busy test_bit() looping on the huge hole.

  for (pfn = start_pfn; pfn < end_pfn; pfn++) {
	struct page *page = pfn_to_online_page(pfn);
		if (!page)
			continue;
	...
  }

So we got a soft lockup:

  watchdog: BUG: soft lockup - CPU#6 stuck for 26s! [bash:1221]
  CPU: 6 PID: 1221 Comm: bash Not tainted 5.15.0-custom #1
  RIP: 0010:pfn_to_online_page+0x5/0xd0
  Call Trace:
    ? kmemleak_scan+0x16a/0x440
    kmemleak_write+0x306/0x3a0
    ? common_file_perm+0x72/0x170
    full_proxy_write+0x5c/0x90
    vfs_write+0xb9/0x260
    ksys_write+0x67/0xe0
    __x64_sys_write+0x1a/0x20
    do_syscall_64+0x3b/0xc0
    entry_SYSCALL_64_after_hwframe+0x44/0xae

I did some tests with the patch.

(1) amdgpu module unloaded

before the patch:

  real    0m0.976s
  user    0m0.000s
  sys     0m0.968s

after the patch:

  real    0m0.981s
  user    0m0.000s
  sys     0m0.973s

(2) amdgpu module loaded

before the patch:

  real    0m35.365s
  user    0m0.000s
  sys     0m35.354s

after the patch:

  real    0m1.049s
  user    0m0.000s
  sys     0m1.042s

Link: https://lkml.kernel.org/r/20211108140029.721144-1-lang.yu@amd.com
Signed-off-by: Lang Yu <lang.yu@amd.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kmemleak.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1399,7 +1399,8 @@ static void kmemleak_scan(void)
 {
 	unsigned long flags;
 	struct kmemleak_object *object;
-	int i;
+	struct zone *zone;
+	int __maybe_unused i;
 	int new_leaks = 0;
 
 	jiffies_last_scan = jiffies;
@@ -1439,9 +1440,9 @@ static void kmemleak_scan(void)
 	 * Struct page scanning for each node.
 	 */
 	get_online_mems();
-	for_each_online_node(i) {
-		unsigned long start_pfn = node_start_pfn(i);
-		unsigned long end_pfn = node_end_pfn(i);
+	for_each_populated_zone(zone) {
+		unsigned long start_pfn = zone->zone_start_pfn;
+		unsigned long end_pfn = zone_end_pfn(zone);
 		unsigned long pfn;
 
 		for (pfn = start_pfn; pfn < end_pfn; pfn++) {
@@ -1450,8 +1451,8 @@ static void kmemleak_scan(void)
 			if (!page)
 				continue;
 
-			/* only scan pages belonging to this node */
-			if (page_to_nid(page) != i)
+			/* only scan pages belonging to this zone */
+			if (page_zone(page) != zone)
 				continue;
 			/* only scan if page is in use */
 			if (page_count(page) == 0)


