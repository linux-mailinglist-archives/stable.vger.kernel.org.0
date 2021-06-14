Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E1E3A63E1
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbhFNLSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:18:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234411AbhFNLQL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:16:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7450261968;
        Mon, 14 Jun 2021 10:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667792;
        bh=+F8xpImmdVQXzyqKqEh+hK8gMc4YEWI7TVM+tHzuNxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WvDjmYsDLkxwdZcuz83ARwCHp1qaTairtqHQFsTqYEVsNqsJtCrGgFKznlDTevw7U
         pFvLOe4YXvpco+ppB+G8vz9GhnN//C1t0vOEd3tDYTRjnJh3kCxv7cVCIwvioQt+GM
         PgwfzMHNZqL0FgRR44dShQNJZCdT54AWu8rmHA0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a6bf271c02e4fe66b4e4@syzkaller.appspotmail.com,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Qu Wenruo <wqu@suse.com>, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.12 077/173] btrfs: promote debugging asserts to full-fledged checks in validate_super
Date:   Mon, 14 Jun 2021 12:26:49 +0200
Message-Id: <20210614102700.718726995@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

commit aefd7f7065567a4666f42c0fc8cdb379d2e036bf upstream.

Syzbot managed to trigger this assert while performing its fuzzing.
Turns out it's better to have those asserts turned into full-fledged
checks so that in case buggy btrfs images are mounted the users gets
an error and mounting is stopped. Alternatively with CONFIG_BTRFS_ASSERT
disabled such image would have been erroneously allowed to be mounted.

Reported-by: syzbot+a6bf271c02e4fe66b4e4@syzkaller.appspotmail.com
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add uuids to the messages ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2558,6 +2558,24 @@ static int validate_super(struct btrfs_f
 		ret = -EINVAL;
 	}
 
+	if (memcmp(fs_info->fs_devices->fsid, fs_info->super_copy->fsid,
+		   BTRFS_FSID_SIZE)) {
+		btrfs_err(fs_info,
+		"superblock fsid doesn't match fsid of fs_devices: %pU != %pU",
+			fs_info->super_copy->fsid, fs_info->fs_devices->fsid);
+		ret = -EINVAL;
+	}
+
+	if (btrfs_fs_incompat(fs_info, METADATA_UUID) &&
+	    memcmp(fs_info->fs_devices->metadata_uuid,
+		   fs_info->super_copy->metadata_uuid, BTRFS_FSID_SIZE)) {
+		btrfs_err(fs_info,
+"superblock metadata_uuid doesn't match metadata uuid of fs_devices: %pU != %pU",
+			fs_info->super_copy->metadata_uuid,
+			fs_info->fs_devices->metadata_uuid);
+		ret = -EINVAL;
+	}
+
 	if (memcmp(fs_info->fs_devices->metadata_uuid, sb->dev_item.fsid,
 		   BTRFS_FSID_SIZE) != 0) {
 		btrfs_err(fs_info,
@@ -3185,14 +3203,6 @@ int __cold open_ctree(struct super_block
 
 	disk_super = fs_info->super_copy;
 
-	ASSERT(!memcmp(fs_info->fs_devices->fsid, fs_info->super_copy->fsid,
-		       BTRFS_FSID_SIZE));
-
-	if (btrfs_fs_incompat(fs_info, METADATA_UUID)) {
-		ASSERT(!memcmp(fs_info->fs_devices->metadata_uuid,
-				fs_info->super_copy->metadata_uuid,
-				BTRFS_FSID_SIZE));
-	}
 
 	features = btrfs_super_flags(disk_super);
 	if (features & BTRFS_SUPER_FLAG_CHANGING_FSID_V2) {


