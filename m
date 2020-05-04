Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513131C4495
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731448AbgEDSHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:07:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732069AbgEDSHB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:07:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3300020721;
        Mon,  4 May 2020 18:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615620;
        bh=+0rl559zqU13cGt0peKypDpVOI4E6NSvUr7iBXcVnmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1tFyA/lPoHpwqfp02JHZ89/ekvMpLEYFB8+USa8L96N3TgpNribQVAN7vD6zDCBZB
         uhFIEZwHFom9gyRbiX6ADL7ZVWgkwnAEEe8wHGgHkI+3dy4tL0M154ZM2g7eM1Xblx
         4LqwBvqpIIZkSTTBNMr+L3/EnhVE1TB50JLmwx4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.6 38/73] dm multipath: use updated MPATHF_QUEUE_IO on mapping for bio-based mpath
Date:   Mon,  4 May 2020 19:57:41 +0200
Message-Id: <20200504165507.844317915@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
References: <20200504165501.781878940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriel Krisman Bertazi <krisman@collabora.com>

commit 5686dee34dbfe0238c0274e0454fa0174ac0a57a upstream.

When adding devices that don't have a scsi_dh on a BIO based multipath,
I was able to consistently hit the warning below and lock-up the system.

The problem is that __map_bio reads the flag before it potentially being
modified by choose_pgpath, and ends up using the older value.

The WARN_ON below is not trivially linked to the issue. It goes like
this: The activate_path delayed_work is not initialized for non-scsi_dh
devices, but we always set MPATHF_QUEUE_IO, asking for initialization.
That is fine, since MPATHF_QUEUE_IO would be cleared in choose_pgpath.
Nevertheless, only for BIO-based mpath, we cache the flag before calling
choose_pgpath, and use the older version when deciding if we should
initialize the path.  Therefore, we end up trying to initialize the
paths, and calling the non-initialized activate_path work.

[   82.437100] ------------[ cut here ]------------
[   82.437659] WARNING: CPU: 3 PID: 602 at kernel/workqueue.c:1624
  __queue_delayed_work+0x71/0x90
[   82.438436] Modules linked in:
[   82.438911] CPU: 3 PID: 602 Comm: systemd-udevd Not tainted 5.6.0-rc6+ #339
[   82.439680] RIP: 0010:__queue_delayed_work+0x71/0x90
[   82.440287] Code: c1 48 89 4a 50 81 ff 00 02 00 00 75 2a 4c 89 cf e9
94 d6 07 00 e9 7f e9 ff ff 0f 0b eb c7 0f 0b 48 81 7a 58 40 74 a8 94 74
a7 <0f> 0b 48 83 7a 48 00 74 a5 0f 0b eb a1 89 fe 4c 89 cf e9 c8 c4 07
[   82.441719] RSP: 0018:ffffb738803977c0 EFLAGS: 00010007
[   82.442121] RAX: ffffa086389f9740 RBX: 0000000000000002 RCX: 0000000000000000
[   82.442718] RDX: ffffa086350dd930 RSI: ffffa0863d76f600 RDI: 0000000000000200
[   82.443484] RBP: 0000000000000200 R08: 0000000000000000 R09: ffffa086350dd970
[   82.444128] R10: 0000000000000000 R11: 0000000000000000 R12: ffffa086350dd930
[   82.444773] R13: ffffa0863d76f600 R14: 0000000000000000 R15: ffffa08636738008
[   82.445427] FS:  00007f6abfe9dd40(0000) GS:ffffa0863dd80000(0000) knlGS:00000
[   82.446040] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   82.446478] CR2: 0000557d288db4e8 CR3: 0000000078b36000 CR4: 00000000000006e0
[   82.447104] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   82.447561] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   82.448012] Call Trace:
[   82.448164]  queue_delayed_work_on+0x6d/0x80
[   82.448472]  __pg_init_all_paths+0x7b/0xf0
[   82.448714]  pg_init_all_paths+0x26/0x40
[   82.448980]  __multipath_map_bio.isra.0+0x84/0x210
[   82.449267]  __map_bio+0x3c/0x1f0
[   82.449468]  __split_and_process_non_flush+0x14a/0x1b0
[   82.449775]  __split_and_process_bio+0xde/0x340
[   82.450045]  ? dm_get_live_table+0x5/0xb0
[   82.450278]  dm_process_bio+0x98/0x290
[   82.450518]  dm_make_request+0x54/0x120
[   82.450778]  generic_make_request+0xd2/0x3e0
[   82.451038]  ? submit_bio+0x3c/0x150
[   82.451278]  submit_bio+0x3c/0x150
[   82.451492]  mpage_readpages+0x129/0x160
[   82.451756]  ? bdev_evict_inode+0x1d0/0x1d0
[   82.452033]  read_pages+0x72/0x170
[   82.452260]  __do_page_cache_readahead+0x1ba/0x1d0
[   82.452624]  force_page_cache_readahead+0x96/0x110
[   82.452903]  generic_file_read_iter+0x84f/0xae0
[   82.453192]  ? __seccomp_filter+0x7c/0x670
[   82.453547]  new_sync_read+0x10e/0x190
[   82.453883]  vfs_read+0x9d/0x150
[   82.454172]  ksys_read+0x65/0xe0
[   82.454466]  do_syscall_64+0x4e/0x210
[   82.454828]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[...]
[   82.462501] ---[ end trace bb39975e9cf45daa ]---

Cc: stable@vger.kernel.org
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-mpath.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -585,10 +585,12 @@ static struct pgpath *__map_bio(struct m
 
 	/* Do we need to select a new pgpath? */
 	pgpath = READ_ONCE(m->current_pgpath);
-	queue_io = test_bit(MPATHF_QUEUE_IO, &m->flags);
-	if (!pgpath || !queue_io)
+	if (!pgpath || !test_bit(MPATHF_QUEUE_IO, &m->flags))
 		pgpath = choose_pgpath(m, bio->bi_iter.bi_size);
 
+	/* MPATHF_QUEUE_IO might have been cleared by choose_pgpath. */
+	queue_io = test_bit(MPATHF_QUEUE_IO, &m->flags);
+
 	if ((pgpath && queue_io) ||
 	    (!pgpath && test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))) {
 		/* Queue for the daemon to resubmit */


