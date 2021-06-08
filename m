Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8183A03C4
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235934AbhFHTVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:21:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237394AbhFHTSC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:18:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B56761977;
        Tue,  8 Jun 2021 18:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178287;
        bh=/zppk98WdwQocVwLh1eYbYTfhVTbwIBa2pMVSuX3L1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FPi24uCrfwUBT0fYC8VZg4RC2NIajlvAwTM9q8chMhOMT3dU3aolOJD+/8erbc6AP
         5OuIBhsHJ36z9bR4nAzl7G1fTL9ErlrYwnOxHzOhvAChg6EKA3gqU241TCu8otmmk7
         8N++1N7ci59JjJSY+Srqs/tTeJixL+db5ZNcUVNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.12 146/161] btrfs: abort in rename_exchange if we fail to insert the second ref
Date:   Tue,  8 Jun 2021 20:27:56 +0200
Message-Id: <20210608175950.383075102@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit dc09ef3562726cd520c8338c1640872a60187af5 upstream.

Error injection stress uncovered a problem where we'd leave a dangling
inode ref if we failed during a rename_exchange.  This happens because
we insert the inode ref for one side of the rename, and then for the
other side.  If this second inode ref insert fails we'll leave the first
one dangling and leave a corrupt file system behind.  Fix this by
aborting if we did the insert for the first inode ref.

CC: stable@vger.kernel.org # 4.9+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9088,6 +9088,7 @@ static int btrfs_rename_exchange(struct
 	int ret2;
 	bool root_log_pinned = false;
 	bool dest_log_pinned = false;
+	bool need_abort = false;
 
 	/* we only allow rename subvolume link between subvolumes */
 	if (old_ino != BTRFS_FIRST_FREE_OBJECTID && root != dest)
@@ -9144,6 +9145,7 @@ static int btrfs_rename_exchange(struct
 					     old_idx);
 		if (ret)
 			goto out_fail;
+		need_abort = true;
 	}
 
 	/* And now for the dest. */
@@ -9159,8 +9161,11 @@ static int btrfs_rename_exchange(struct
 					     new_ino,
 					     btrfs_ino(BTRFS_I(old_dir)),
 					     new_idx);
-		if (ret)
+		if (ret) {
+			if (need_abort)
+				btrfs_abort_transaction(trans, ret);
 			goto out_fail;
+		}
 	}
 
 	/* Update inode version and ctime/mtime. */


