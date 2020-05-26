Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3231A5932
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgDKXJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:09:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728600AbgDKXJC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:09:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF99620708;
        Sat, 11 Apr 2020 23:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646541;
        bh=7euqKfoRpG2MKpUTp1qj6xDKj4ind4SgjVj4CnTiWo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RtFcYIWBy4/osco08WSGjTQYvRSeo2rHqp8WSx67zn4H+ohaoxTfumkjn1QvHIcFP
         6BqUcBFgJDR0I2vr3I9XAQPBL5W+mCf4j874xSik2MWhOZw6WvjFkhfWvQ82k8ZfeB
         XDOaJVjfc2QSGW74Lwh5BDtlUiLRkLy27EcO1V2Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 093/121] xfs: prohibit fs freezing when using empty transactions
Date:   Sat, 11 Apr 2020 19:06:38 -0400
Message-Id: <20200411230706.23855-93-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit 27fb5a72f50aa770dd38b0478c07acacef97e3e7 ]

I noticed that fsfreeze can take a very long time to freeze an XFS if
there happens to be a GETFSMAP caller running in the background.  I also
happened to notice the following in dmesg:

------------[ cut here ]------------
WARNING: CPU: 2 PID: 43492 at fs/xfs/xfs_super.c:853 xfs_quiesce_attr+0x83/0x90 [xfs]
Modules linked in: xfs libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 ip_set_hash_ip ip_set_hash_net xt_tcpudp xt_set ip_set_hash_mac ip_set nfnetlink ip6table_filter ip6_tables bfq iptable_filter sch_fq_codel ip_tables x_tables nfsv4 af_packet [last unloaded: xfs]
CPU: 2 PID: 43492 Comm: xfs_io Not tainted 5.6.0-rc4-djw #rc4
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
RIP: 0010:xfs_quiesce_attr+0x83/0x90 [xfs]
Code: 7c 07 00 00 85 c0 75 22 48 89 df 5b e9 96 c1 00 00 48 c7 c6 b0 2d 38 a0 48 89 df e8 57 64 ff ff 8b 83 7c 07 00 00 85 c0 74 de <0f> 0b 48 89 df 5b e9 72 c1 00 00 66 90 0f 1f 44 00 00 41 55 41 54
RSP: 0018:ffffc900030f3e28 EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffff88802ac54000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff81e4a6f0 RDI: 00000000ffffffff
RBP: ffff88807859f070 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000010 R12: 0000000000000000
R13: ffff88807859f388 R14: ffff88807859f4b8 R15: ffff88807859f5e8
FS:  00007fad1c6c0fc0(0000) GS:ffff88807e000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0c7d237000 CR3: 0000000077f01003 CR4: 00000000001606a0
Call Trace:
 xfs_fs_freeze+0x25/0x40 [xfs]
 freeze_super+0xc8/0x180
 do_vfs_ioctl+0x70b/0x750
 ? __fget_files+0x135/0x210
 ksys_ioctl+0x3a/0xb0
 __x64_sys_ioctl+0x16/0x20
 do_syscall_64+0x50/0x1a0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

These two things appear to be related.  The assertion trips when another
thread initiates a fsmap request (which uses an empty transaction) after
the freezer waited for m_active_trans to hit zero but before the the
freezer executes the WARN_ON just prior to calling xfs_log_quiesce.

The lengthy delays in freezing happen because the freezer calls
xfs_wait_buftarg to clean out the buffer lru list.  Meanwhile, the
GETFSMAP caller is continuing to grab and release buffers, which means
that it can take a very long time for the buffer lru list to empty out.

We fix both of these races by calling sb_start_write to obtain freeze
protection while using empty transactions for GETFSMAP and for metadata
scrubbing.  The other two users occur during mount, during which time we
cannot fs freeze.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/scrub.c | 9 +++++++++
 fs/xfs/xfs_fsmap.c   | 9 +++++++++
 fs/xfs/xfs_trans.c   | 5 +++++
 3 files changed, 23 insertions(+)

diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index f1775bb193135..8ebf35b115ce2 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -168,6 +168,7 @@ xchk_teardown(
 			xfs_irele(sc->ip);
 		sc->ip = NULL;
 	}
+	sb_end_write(sc->mp->m_super);
 	if (sc->flags & XCHK_REAPING_DISABLED)
 		xchk_start_reaping(sc);
 	if (sc->flags & XCHK_HAS_QUOTAOFFLOCK) {
@@ -490,6 +491,14 @@ xfs_scrub_metadata(
 	sc.ops = &meta_scrub_ops[sm->sm_type];
 	sc.sick_mask = xchk_health_mask_for_scrub_type(sm->sm_type);
 retry_op:
+	/*
+	 * If freeze runs concurrently with a scrub, the freeze can be delayed
+	 * indefinitely as we walk the filesystem and iterate over metadata
+	 * buffers.  Freeze quiesces the log (which waits for the buffer LRU to
+	 * be emptied) and that won't happen while checking is running.
+	 */
+	sb_start_write(mp->m_super);
+
 	/* Set up for the operation. */
 	error = sc.ops->setup(&sc, ip);
 	if (error)
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 918456ca29e16..442fd4311f180 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -896,6 +896,14 @@ xfs_getfsmap(
 	info.format_arg = arg;
 	info.head = head;
 
+	/*
+	 * If fsmap runs concurrently with a scrub, the freeze can be delayed
+	 * indefinitely as we walk the rmapbt and iterate over metadata
+	 * buffers.  Freeze quiesces the log (which waits for the buffer LRU to
+	 * be emptied) and that won't happen while we're reading buffers.
+	 */
+	sb_start_write(mp->m_super);
+
 	/* For each device we support... */
 	for (i = 0; i < XFS_GETFSMAP_DEVS; i++) {
 		/* Is this device within the range the user asked for? */
@@ -935,6 +943,7 @@ xfs_getfsmap(
 
 	if (tp)
 		xfs_trans_cancel(tp);
+	sb_end_write(mp->m_super);
 	head->fmh_oflags = FMH_OF_DEV_T;
 	return error;
 }
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 3b208f9a865cb..a65dc227e40d0 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -306,6 +306,11 @@ xfs_trans_alloc(
  *
  * Note the zero-length reservation; this transaction MUST be cancelled
  * without any dirty data.
+ *
+ * Callers should obtain freeze protection to avoid two conflicts with fs
+ * freezing: (1) having active transactions trip the m_active_trans ASSERTs;
+ * and (2) grabbing buffers at the same time that freeze is trying to drain
+ * the buffer LRU list.
  */
 int
 xfs_trans_alloc_empty(
-- 
2.20.1

