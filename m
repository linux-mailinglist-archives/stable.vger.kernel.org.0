Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325AF4725AE
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbhLMJp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:45:27 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:36854 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbhLMJnZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:43:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9CC2ECE0DDE;
        Mon, 13 Dec 2021 09:43:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EEEC341D9;
        Mon, 13 Dec 2021 09:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388601;
        bh=1TH5wYC6mxA/Q6kiTTGKLjo+TNP0CuvzZAtrLuK2/kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u+xswljOCMaGufaHJuyoAfqb8T8l2eYsRXaJIY/tidihEviMcxtNKeoTpMSBcTNqH
         gw0RySUxlfJCC9ACC7cmeZ+TpgnH/B7bGZxi3FHq11gaUzyQ6BQDsc21q8eLt9kc/M
         ZE6JhpzGkCZKJn1l4otqR1Ecv9PFcb6imLPdAmdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 33/88] btrfs: clear extent buffer uptodate when we fail to write it
Date:   Mon, 13 Dec 2021 10:30:03 +0100
Message-Id: <20211213092934.378921709@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit c2e39305299f0118298c2201f6d6cc7d3485f29e upstream.

I got dmesg errors on generic/281 on our overnight fstests.  Looking at
the history this happens occasionally, with errors like this

  WARNING: CPU: 0 PID: 673217 at fs/btrfs/extent_io.c:6848 assert_eb_page_uptodate+0x3f/0x50
  CPU: 0 PID: 673217 Comm: kworker/u4:13 Tainted: G        W         5.16.0-rc2+ #469
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-2.fc32 04/01/2014
  Workqueue: btrfs-cache btrfs_work_helper
  RIP: 0010:assert_eb_page_uptodate+0x3f/0x50
  RSP: 0018:ffffae598230bc60 EFLAGS: 00010246
  RAX: 0017ffffc0002112 RBX: ffffebaec4100900 RCX: 0000000000001000
  RDX: ffffebaec45733c7 RSI: ffffebaec4100900 RDI: ffff9fd98919f340
  RBP: 0000000000000d56 R08: ffff9fd98e300000 R09: 0000000000000000
  R10: 0001207370a91c50 R11: 0000000000000000 R12: 00000000000007b0
  R13: ffff9fd98919f340 R14: 0000000001500000 R15: 0000000001cb0000
  FS:  0000000000000000(0000) GS:ffff9fd9fbc00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f549fcf8940 CR3: 0000000114908004 CR4: 0000000000370ef0
  Call Trace:

   extent_buffer_test_bit+0x3f/0x70
   free_space_test_bit+0xa6/0xc0
   load_free_space_tree+0x1d6/0x430
   caching_thread+0x454/0x630
   ? rcu_read_lock_sched_held+0x12/0x60
   ? rcu_read_lock_sched_held+0x12/0x60
   ? rcu_read_lock_sched_held+0x12/0x60
   ? lock_release+0x1f0/0x2d0
   btrfs_work_helper+0xf2/0x3e0
   ? lock_release+0x1f0/0x2d0
   ? finish_task_switch.isra.0+0xf9/0x3a0
   process_one_work+0x270/0x5a0
   worker_thread+0x55/0x3c0
   ? process_one_work+0x5a0/0x5a0
   kthread+0x174/0x1a0
   ? set_kthread_struct+0x40/0x40
   ret_from_fork+0x1f/0x30

This happens because we're trying to read from a extent buffer page that
is !PageUptodate.  This happens because we will clear the page uptodate
when we have an IO error, but we don't clear the extent buffer uptodate.
If we do a read later and find this extent buffer we'll think its valid
and not return an error, and then trip over this warning.

Fix this by also clearing uptodate on the extent buffer when this
happens, so that we get an error when we do a btrfs_search_slot() and
find this block later.

CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3755,6 +3755,12 @@ static void set_btree_ioerr(struct page
 		return;
 
 	/*
+	 * A read may stumble upon this buffer later, make sure that it gets an
+	 * error and knows there was an error.
+	 */
+	clear_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
+
+	/*
 	 * If we error out, we should add back the dirty_metadata_bytes
 	 * to make it consistent.
 	 */


