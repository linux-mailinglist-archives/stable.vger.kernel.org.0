Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7750B426959
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241838AbhJHLgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:36:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241770AbhJHLeH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:34:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BAEA60F14;
        Fri,  8 Oct 2021 11:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692697;
        bh=+RjDmcHvWDOtR/qmxC5gHN/h/0jxri9J4EBeI0OZw7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/7jZzHbd/HWg4ZZsPiFdOgyyRt8olKmq166U+sAFhURd45ucYkUBS2dgs2nYbl4N
         8H4grdzvWp8p95uOQ6C8OReEMjrBfT+5qFp6EARB0Y469Li28n6vzT2z6yaFdNY/SA
         jubbS/WH6SdkFUOhewdWhweT+oPOuGopT1fizOog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 06/29] btrfs: fix mount failure due to past and transient device flush error
Date:   Fri,  8 Oct 2021 13:27:53 +0200
Message-Id: <20211008112717.141324446@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112716.914501436@linuxfoundation.org>
References: <20211008112716.914501436@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d8b8764f5bd1..593e0c6d6b44 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1147,6 +1147,19 @@ static void btrfs_close_one_device(struct btrfs_device *device)
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



