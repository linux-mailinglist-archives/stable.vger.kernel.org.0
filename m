Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A43E41A76D
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238912AbhI1F5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238897AbhI1F5H (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:57:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3967E611CA;
        Tue, 28 Sep 2021 05:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808528;
        bh=ocHDUoH0RhXf7AGDrf7+ILi7srsnNByBjdiGUOU3nu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WU0RqoXbtXVm1kLSjvz42aR8TYI2fIs8qFIgHudn4lu6Y3yODEPLLkybYybN/6729
         T29gH3976BYduxusMYldzIwaeRdATYRfP43xMvn39hgy6jyHHWEq6QeqWNZyeb5NOi
         tx8FX79x6fU4M2MMqeTIbE7JkdHPPGhXA84BsDGNIVWj/vWAaC095i6DaYTV5JzUEf
         xuuwHLApuyiG57oC3Sg46qXkzZoxKCWcYlTxS6UThJJNmcbllRzrDtaJmHucoC7R+b
         k3n3LHzSXJ9VPT21egUkkq/F2spn+tdVd5pQyEv6+zpzXwRcVsp8lmYalhwH9YquSy
         rqRiO3TofvHcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 07/40] btrfs: fix mount failure due to past and transient device flush error
Date:   Tue, 28 Sep 2021 01:54:51 -0400
Message-Id: <20210928055524.172051-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 6b225baababf1e3d41a4250e802cbd193e1343fb ]

When we get an error flushing one device, during a super block commit, we
record the error in the device structure, in the field 'last_flush_error'.
This is used to later check if we should error out the super block commit,
depending on whether the number of flush errors is greater than or equals
to the maximum tolerated device failures for a raid profile.

However if we get a transient device flush error, unmount the filesystem
and later try to mount it, we can fail the mount because we treat that
past error as critical and consider the device is missing. Even if it's
very likely that the error will happen again, as it's probably due to a
hardware related problem, there may be cases where the error might not
happen again. One example is during testing, and a test case like the
new generic/648 from fstests always triggers this. The test cases
generic/019 and generic/475 also trigger this scenario, but very
sporadically.

When this happens we get an error like this:

  $ mount /dev/sdc /mnt
  mount: /mnt wrong fs type, bad option, bad superblock on /dev/sdc, missing codepage or helper program, or other error.

  $ dmesg
  (...)
  [12918.886926] BTRFS warning (device sdc): chunk 13631488 missing 1 devices, max tolerance is 0 for writable mount
  [12918.888293] BTRFS warning (device sdc): writable mount is not allowed due to too many missing devices
  [12918.890853] BTRFS error (device sdc): open_ctree failed

The failure happens because when btrfs_check_rw_degradable() is called at
mount time, or at remount from RO to RW time, is sees a non zero value in
a device's ->last_flush_error attribute, and therefore considers that the
device is 'missing'.

Fix this by setting a device's ->last_flush_error to zero when we close a
device, making sure the error is not seen on the next mount attempt. We
only need to track flush errors during the current mount, so that we never
commit a super block if such errors happened.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 682416d4edef..19c780242e12 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1149,6 +1149,19 @@ static void btrfs_close_one_device(struct btrfs_device *device)
 	atomic_set(&device->dev_stats_ccnt, 0);
 	extent_io_tree_release(&device->alloc_state);
 
+	/*
+	 * Reset the flush error record. We might have a transient flush error
+	 * in this mount, and if so we aborted the current transaction and set
+	 * the fs to an error state, guaranteeing no super blocks can be further
+	 * committed. However that error might be transient and if we unmount the
+	 * filesystem and mount it again, we should allow the mount to succeed
+	 * (btrfs_check_rw_degradable() should not fail) - if after mounting the
+	 * filesystem again we still get flush errors, then we will again abort
+	 * any transaction and set the error state, guaranteeing no commits of
+	 * unsafe super blocks.
+	 */
+	device->last_flush_error = 0;
+
 	/* Verify the device is back in a pristine state  */
 	ASSERT(!test_bit(BTRFS_DEV_STATE_FLUSH_SENT, &device->dev_state));
 	ASSERT(!test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state));
-- 
2.33.0

