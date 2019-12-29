Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E455012CA53
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfL2RVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:21:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:36404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726264AbfL2RVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:21:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2774B207FF;
        Sun, 29 Dec 2019 17:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640081;
        bh=3ZYC5+MquSt1XMcYyrgvKkz9qymnD4I1vRxST9MVI4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8t6Ajxra8mIZr7gxiXc7T124yHXv4FkOdp3jD9hkY6R4KGJlYHfbhA7QKD9w0KPV
         jICJSGo6pFdJM8ayfm8DYAo/dyaCzGLvCqY3lk9z7j+WhUw3a+Uvd9M3eTHZ0Q2fQ/
         /nrTxmhiIwyUMlfmhDHwEQ8GXjhlyTb3MzzCCDyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.14 011/161] btrfs: dont double lock the subvol_sem for rename exchange
Date:   Sun, 29 Dec 2019 18:17:39 +0100
Message-Id: <20191229162359.127861755@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 943eb3bf25f4a7b745dd799e031be276aa104d82 upstream.

If we're rename exchanging two subvols we'll try to lock this lock
twice, which is bad.  Just lock once if either of the ino's are subvols.

Fixes: cdd1fedf8261 ("btrfs: add support for RENAME_EXCHANGE and RENAME_WHITEOUT")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9820,9 +9820,8 @@ static int btrfs_rename_exchange(struct
 		return -EXDEV;
 
 	/* close the race window with snapshot create/destroy ioctl */
-	if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
-		down_read(&fs_info->subvol_sem);
-	if (new_ino == BTRFS_FIRST_FREE_OBJECTID)
+	if (old_ino == BTRFS_FIRST_FREE_OBJECTID ||
+	    new_ino == BTRFS_FIRST_FREE_OBJECTID)
 		down_read(&fs_info->subvol_sem);
 
 	/*
@@ -10014,9 +10013,8 @@ out_fail:
 	ret2 = btrfs_end_transaction(trans);
 	ret = ret ? ret : ret2;
 out_notrans:
-	if (new_ino == BTRFS_FIRST_FREE_OBJECTID)
-		up_read(&fs_info->subvol_sem);
-	if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
+	if (new_ino == BTRFS_FIRST_FREE_OBJECTID ||
+	    old_ino == BTRFS_FIRST_FREE_OBJECTID)
 		up_read(&fs_info->subvol_sem);
 
 	return ret;


