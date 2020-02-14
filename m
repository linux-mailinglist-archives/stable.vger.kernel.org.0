Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2A8C15F00D
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388610AbgBNP6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:58:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:42518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388603AbgBNP6a (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:58:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FE05206D7;
        Fri, 14 Feb 2020 15:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695909;
        bh=1DR/GWaW9CSgGTPT5u/Hw+nrWr3h63KmxvHEXN9F2Tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=we9gPWHSS9VJjwddmo0k0hn7YwHPw0MKsSgmvZDiUIVBClwx+lzzleMZL0YDMBlS5
         rLpH2SGbAIhgitYxtOSXKdi13xiskwnrj0y3/h4HkDAUJMrKXRKdcv8lKfQiRhXxem
         7YlbKpiaL7xmlPpBGXisPLohwrxmNfdGifAFCMQU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>, Su Yue <Damenly_Su@gmx.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 449/542] btrfs: Fix split-brain handling when changing FSID to metadata uuid
Date:   Fri, 14 Feb 2020 10:47:21 -0500
Message-Id: <20200214154854.6746-449-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

[ Upstream commit 1362089d2ad7e20d16371b39d3c11990d4ec23e4 ]

Current code doesn't correctly handle the situation which arises when
a file system that has METADATA_UUID_INCOMPAT flag set and has its FSID
changed to the one in metadata uuid. This causes the incompat flag to
disappear.

In case of a power failure we could end up in a situation where part of
the disks in a multi-disk filesystem are correctly reverted to
METADATA_UUID_INCOMPAT flag unset state, while others have
METADATA_UUID_INCOMPAT set and CHANGING_FSID_V2_IN_PROGRESS.

This patch corrects the behavior required to handle the case where a
disk of the second type is scanned first, creating the necessary
btrfs_fs_devices. Subsequently, when a disk which has already completed
the transition is scanned it should overwrite the data in
btrfs_fs_devices.

Reported-by: Su Yue <Damenly_Su@gmx.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 42 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c5c0dc0cbf517..a8b71ded4d212 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -723,6 +723,32 @@ static struct btrfs_fs_devices *find_fsid_changed(
 
 	return NULL;
 }
+
+static struct btrfs_fs_devices *find_fsid_reverted_metadata(
+				struct btrfs_super_block *disk_super)
+{
+	struct btrfs_fs_devices *fs_devices;
+
+	/*
+	 * Handle the case where the scanned device is part of an fs whose last
+	 * metadata UUID change reverted it to the original FSID. At the same
+	 * time * fs_devices was first created by another constitutent device
+	 * which didn't fully observe the operation. This results in an
+	 * btrfs_fs_devices created with metadata/fsid different AND
+	 * btrfs_fs_devices::fsid_change set AND the metadata_uuid of the
+	 * fs_devices equal to the FSID of the disk.
+	 */
+	list_for_each_entry(fs_devices, &fs_uuids, fs_list) {
+		if (memcmp(fs_devices->fsid, fs_devices->metadata_uuid,
+			   BTRFS_FSID_SIZE) != 0 &&
+		    memcmp(fs_devices->metadata_uuid, disk_super->fsid,
+			   BTRFS_FSID_SIZE) == 0 &&
+		    fs_devices->fsid_change)
+			return fs_devices;
+	}
+
+	return NULL;
+}
 /*
  * Add new device to list of registered devices
  *
@@ -762,7 +788,9 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 		fs_devices = find_fsid(disk_super->fsid,
 				       disk_super->metadata_uuid);
 	} else {
-		fs_devices = find_fsid(disk_super->fsid, NULL);
+		fs_devices = find_fsid_reverted_metadata(disk_super);
+		if (!fs_devices)
+			fs_devices = find_fsid(disk_super->fsid, NULL);
 	}
 
 
@@ -792,12 +820,18 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 		 * a device which had the CHANGING_FSID_V2 flag then replace the
 		 * metadata_uuid/fsid values of the fs_devices.
 		 */
-		if (has_metadata_uuid && fs_devices->fsid_change &&
+		if (fs_devices->fsid_change &&
 		    found_transid > fs_devices->latest_generation) {
 			memcpy(fs_devices->fsid, disk_super->fsid,
 					BTRFS_FSID_SIZE);
-			memcpy(fs_devices->metadata_uuid,
-					disk_super->metadata_uuid, BTRFS_FSID_SIZE);
+
+			if (has_metadata_uuid)
+				memcpy(fs_devices->metadata_uuid,
+				       disk_super->metadata_uuid,
+				       BTRFS_FSID_SIZE);
+			else
+				memcpy(fs_devices->metadata_uuid,
+				       disk_super->fsid, BTRFS_FSID_SIZE);
 
 			fs_devices->fsid_change = false;
 		}
-- 
2.20.1

