Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECAD102542
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 14:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbfKSNT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 08:19:26 -0500
Received: from relay.sw.ru ([185.231.240.75]:37432 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726378AbfKSNT0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 08:19:26 -0500
Received: from dhcp-172-16-25-5.sw.ru ([172.16.25.5] helo=i7.sw.ru)
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <aryabinin@virtuozzo.com>)
        id 1iX3PT-0007Sl-0S; Tue, 19 Nov 2019 16:19:11 +0300
From:   Andrey Ryabinin <aryabinin@virtuozzo.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        stable@vger.kernel.org
Subject: [PATCH] mm/ksm: Don't WARN if page is still mapped in remove_stable_node()
Date:   Tue, 19 Nov 2019 16:18:50 +0300
Message-Id: <20191119131850.5675-1-aryabinin@virtuozzo.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It's possible to hit the WARN_ON_ONCE(page_mapped(page)) in
remove_stable_node() when it races with __mmput() and squeezes
in between ksm_exit() and exit_mmap().

 WARNING: CPU: 0 PID: 3295 at mm/ksm.c:888 remove_stable_node+0x10c/0x150

 Call Trace:
  remove_all_stable_nodes+0x12b/0x330
  run_store+0x4ef/0x7b0
  kernfs_fop_write+0x200/0x420
  vfs_write+0x154/0x450
  ksys_write+0xf9/0x1d0
  do_syscall_64+0x99/0x510
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Remove the warning as there is nothing scary going on.

Fixes: cbf86cfe04a6 ("ksm: remove old stable nodes more thoroughly")
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: <stable@vger.kernel.org>
---
 mm/ksm.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index dbee2eb4dd05..7905934cd3ad 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -885,13 +885,13 @@ static int remove_stable_node(struct stable_node *stable_node)
 		return 0;
 	}
 
-	if (WARN_ON_ONCE(page_mapped(page))) {
-		/*
-		 * This should not happen: but if it does, just refuse to let
-		 * merge_across_nodes be switched - there is no need to panic.
-		 */
-		err = -EBUSY;
-	} else {
+	/*
+	 * Page could be still mapped if this races with __mmput() running in
+	 * between ksm_exit() and exit_mmap(). Just refuse to let
+	 * merge_across_nodes/max_page_sharing be switched.
+	 */
+	err = -EBUSY;
+	if (!page_mapped(page)) {
 		/*
 		 * The stable node did not yet appear stale to get_ksm_page(),
 		 * since that allows for an unmapped ksm page to be recognized
-- 
2.23.0

