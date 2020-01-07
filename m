Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4E76133302
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbgAGVIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:08:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729023AbgAGVIO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:08:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC3012072A;
        Tue,  7 Jan 2020 21:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431294;
        bh=fXjGtSfV8QP65VDuktsocMkzXUFmWK/vAVxuE/HBZLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m75l9ijrQWAB2LgAn43qpnA9Y9W8R5zDAl9O8niY/Y/zPhc8BeYVjRq9PfrNYJkqj
         r473BWzU3ej0gfA8EEyQD5DQBWFTlhR7jOC69+pnHbKMCp3ZA4XrH+D3ybhbG2ppSp
         B+JxPRIVzoE074567x104yaAs/T6aLMCXkyyHR5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 112/115] ubifs: ubifs_tnc_start_commit: Fix OOB in layout_in_gaps
Date:   Tue,  7 Jan 2020 21:55:22 +0100
Message-Id: <20200107205310.309945803@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 6abf57262166b4f4294667fb5206ae7ba1ba96f5 ]

Running stress-test test_2 in mtd-utils on ubi device, sometimes we can
get following oops message:

  BUG: unable to handle page fault for address: ffffffff00000140
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 280a067 P4D 280a067 PUD 0
  Oops: 0000 [#1] SMP
  CPU: 0 PID: 60 Comm: kworker/u16:1 Kdump: loaded Not tainted 5.2.0 #13
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0
  -0-ga698c8995f-prebuilt.qemu.org 04/01/2014
  Workqueue: writeback wb_workfn (flush-ubifs_0_0)
  RIP: 0010:rb_next_postorder+0x2e/0xb0
  Code: 80 db 03 01 48 85 ff 0f 84 97 00 00 00 48 8b 17 48 83 05 bc 80 db
  03 01 48 83 e2 fc 0f 84 82 00 00 00 48 83 05 b2 80 db 03 01 <48> 3b 7a
  10 48 89 d0 74 02 f3 c3 48 8b 52 08 48 83 05 a3 80 db 03
  RSP: 0018:ffffc90000887758 EFLAGS: 00010202
  RAX: ffff888129ae4700 RBX: ffff888138b08400 RCX: 0000000080800001
  RDX: ffffffff00000130 RSI: 0000000080800024 RDI: ffff888138b08400
  RBP: ffff888138b08400 R08: ffffea0004a6b920 R09: 0000000000000000
  R10: ffffc90000887740 R11: 0000000000000001 R12: ffff888128d48000
  R13: 0000000000000800 R14: 000000000000011e R15: 00000000000007c8
  FS:  0000000000000000(0000) GS:ffff88813ba00000(0000)
  knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffffffff00000140 CR3: 000000013789d000 CR4: 00000000000006f0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
    destroy_old_idx+0x5d/0xa0 [ubifs]
    ubifs_tnc_start_commit+0x4fe/0x1380 [ubifs]
    do_commit+0x3eb/0x830 [ubifs]
    ubifs_run_commit+0xdc/0x1c0 [ubifs]

Above Oops are due to the slab-out-of-bounds happened in do-while of
function layout_in_gaps indirectly called by ubifs_tnc_start_commit. In
function layout_in_gaps, there is a do-while loop placing index nodes
into the gaps created by obsolete index nodes in non-empty index LEBs
until rest index nodes can totally be placed into pre-allocated empty
LEBs. @c->gap_lebs points to a memory area(integer array) which records
LEB numbers used by 'in-the-gaps' method. Whenever a fitable index LEB
is found, corresponding lnum will be incrementally written into the
memory area pointed by @c->gap_lebs. The size
((@c->lst.idx_lebs + 1) * sizeof(int)) of memory area is allocated before
do-while loop and can not be changed in the loop. But @c->lst.idx_lebs
could be increased by function ubifs_change_lp (called by
layout_leb_in_gaps->ubifs_find_dirty_idx_leb->get_idx_gc_leb) during the
loop. So, sometimes oob happens when number of cycles in do-while loop
exceeds the original value of @c->lst.idx_lebs. See detail in
https://bugzilla.kernel.org/show_bug.cgi?id=204229.
This patch fixes oob in layout_in_gaps.

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/tnc_commit.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/fs/ubifs/tnc_commit.c b/fs/ubifs/tnc_commit.c
index dba87d09b989..95630f9f40dd 100644
--- a/fs/ubifs/tnc_commit.c
+++ b/fs/ubifs/tnc_commit.c
@@ -219,7 +219,7 @@ static int is_idx_node_in_use(struct ubifs_info *c, union ubifs_key *key,
 /**
  * layout_leb_in_gaps - layout index nodes using in-the-gaps method.
  * @c: UBIFS file-system description object
- * @p: return LEB number here
+ * @p: return LEB number in @c->gap_lebs[p]
  *
  * This function lays out new index nodes for dirty znodes using in-the-gaps
  * method of TNC commit.
@@ -228,7 +228,7 @@ static int is_idx_node_in_use(struct ubifs_info *c, union ubifs_key *key,
  * This function returns the number of index nodes written into the gaps, or a
  * negative error code on failure.
  */
-static int layout_leb_in_gaps(struct ubifs_info *c, int *p)
+static int layout_leb_in_gaps(struct ubifs_info *c, int p)
 {
 	struct ubifs_scan_leb *sleb;
 	struct ubifs_scan_node *snod;
@@ -243,7 +243,7 @@ static int layout_leb_in_gaps(struct ubifs_info *c, int *p)
 		 * filled, however we do not check there at present.
 		 */
 		return lnum; /* Error code */
-	*p = lnum;
+	c->gap_lebs[p] = lnum;
 	dbg_gc("LEB %d", lnum);
 	/*
 	 * Scan the index LEB.  We use the generic scan for this even though
@@ -362,7 +362,7 @@ static int get_leb_cnt(struct ubifs_info *c, int cnt)
  */
 static int layout_in_gaps(struct ubifs_info *c, int cnt)
 {
-	int err, leb_needed_cnt, written, *p;
+	int err, leb_needed_cnt, written, p = 0, old_idx_lebs, *gap_lebs;
 
 	dbg_gc("%d znodes to write", cnt);
 
@@ -371,9 +371,9 @@ static int layout_in_gaps(struct ubifs_info *c, int cnt)
 	if (!c->gap_lebs)
 		return -ENOMEM;
 
-	p = c->gap_lebs;
+	old_idx_lebs = c->lst.idx_lebs;
 	do {
-		ubifs_assert(c, p < c->gap_lebs + c->lst.idx_lebs);
+		ubifs_assert(c, p < c->lst.idx_lebs);
 		written = layout_leb_in_gaps(c, p);
 		if (written < 0) {
 			err = written;
@@ -399,9 +399,29 @@ static int layout_in_gaps(struct ubifs_info *c, int cnt)
 		leb_needed_cnt = get_leb_cnt(c, cnt);
 		dbg_gc("%d znodes remaining, need %d LEBs, have %d", cnt,
 		       leb_needed_cnt, c->ileb_cnt);
+		/*
+		 * Dynamically change the size of @c->gap_lebs to prevent
+		 * oob, because @c->lst.idx_lebs could be increased by
+		 * function @get_idx_gc_leb (called by layout_leb_in_gaps->
+		 * ubifs_find_dirty_idx_leb) during loop. Only enlarge
+		 * @c->gap_lebs when needed.
+		 *
+		 */
+		if (leb_needed_cnt > c->ileb_cnt && p >= old_idx_lebs &&
+		    old_idx_lebs < c->lst.idx_lebs) {
+			old_idx_lebs = c->lst.idx_lebs;
+			gap_lebs = krealloc(c->gap_lebs, sizeof(int) *
+					       (old_idx_lebs + 1), GFP_NOFS);
+			if (!gap_lebs) {
+				kfree(c->gap_lebs);
+				c->gap_lebs = NULL;
+				return -ENOMEM;
+			}
+			c->gap_lebs = gap_lebs;
+		}
 	} while (leb_needed_cnt > c->ileb_cnt);
 
-	*p = -1;
+	c->gap_lebs[p] = -1;
 	return 0;
 }
 
-- 
2.20.1



