Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F0145BF15
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345232AbhKXMzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:55:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:60974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346233AbhKXMxK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:53:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3806E615E1;
        Wed, 24 Nov 2021 12:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757052;
        bh=Sn9NZOvgIdRdl4KeShZfgfK7cy/czSSbKuln5UZG/P0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lJ+17L+Wv9+zy3tVAfOMkpf0HyIraSsqvxVy65GdwUOzdUfX2Cp8x1SksYod3gR9P
         TPrK5zr1P1BFRnmySGhgtyIPy8rzRKjJcqUYcWiPsc8qJ1PX57IhEWxpPmir+pmAIz
         UUmYTF1nhhHBcT9jhmWSli3cIvlHrjTgi0XtbAL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 040/323] btrfs: call btrfs_check_rw_degradable only if there is a missing device
Date:   Wed, 24 Nov 2021 12:53:50 +0100
Message-Id: <20211124115720.227236077@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

commit 5c78a5e7aa835c4f08a7c90fe02d19f95a776f29 upstream.

In open_ctree() in btrfs_check_rw_degradable() [1], we check each block
group individually if at least the minimum number of devices is available
for that profile. If all the devices are available, then we don't have to
check degradable.

[1]
open_ctree()
::
3559 if (!sb_rdonly(sb) && !btrfs_check_rw_degradable(fs_info, NULL)) {

Also before calling btrfs_check_rw_degradable() in open_ctee() at the
line number shown below [2] we call btrfs_read_chunk_tree() and down to
add_missing_dev() to record number of missing devices.

[2]
open_ctree()
::
3454         ret = btrfs_read_chunk_tree(fs_info);

btrfs_read_chunk_tree()
  read_one_chunk() / read_one_dev()
    add_missing_dev()

So, check if there is any missing device before btrfs_check_rw_degradable()
in open_ctree().

Also, with this the mount command could save ~16ms.[3] in the most
common case, that is no device is missing.

[3]
 1) * 16934.96 us | btrfs_check_rw_degradable [btrfs]();

CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3095,7 +3095,8 @@ retry_root_backup:
 		goto fail_sysfs;
 	}
 
-	if (!sb_rdonly(sb) && !btrfs_check_rw_degradable(fs_info, NULL)) {
+	if (!sb_rdonly(sb) && fs_info->fs_devices->missing_devices &&
+	    !btrfs_check_rw_degradable(fs_info, NULL)) {
 		btrfs_warn(fs_info,
 		"writeable mount is not allowed due to too many missing devices");
 		goto fail_sysfs;


