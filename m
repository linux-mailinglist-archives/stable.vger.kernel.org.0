Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62C251577CB
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730612AbgBJNCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:02:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:40578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729749AbgBJMkb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:31 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A91BD20873;
        Mon, 10 Feb 2020 12:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338430;
        bh=KV0NiS2aOHN6RwhExLIB01bPY4Iwsa8czE2TsEoKgXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u5U1rnqFqfOHkqhEKTa/fiamQuB1G3rKPGusMrik1ACug8v3BC5BdKViA+nVuujFz
         2KB9DX0vf39pP7JFfChYrbk1gSpOnxLI/DF4Reb2utGB9ZiFp5s/B2x3+ud/cTMM5m
         qYy8Q8k3IARuLw5DP2Uwkh9NKIrDDMczcvUnjNeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Su Yue <Damenly_Su@gmx.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.5 156/367] btrfs: Handle another split brain scenario with metadata uuid feature
Date:   Mon, 10 Feb 2020 04:31:09 -0800
Message-Id: <20200210122439.222143017@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

commit 05840710149c7d1a78ea85a2db5723f706e97d8f upstream.

There is one more cases which isn't handled by the original metadata
uuid work. Namely, when a filesystem has METADATA_UUID incompat bit and
the user decides to change the FSID to the original one e.g. have
metadata_uuid and fsid match. In case of power failure while this
operation is in progress we could end up in a situation where some of
the disks have the incompat bit removed and the other half have both
METADATA_UUID_INCOMPAT and FSID_CHANGING_IN_PROGRESS flags.

This patch handles the case where a disk that has successfully changed
its FSID such that it equals METADATA_UUID is scanned first.
Subsequently when a disk with both
METADATA_UUID_INCOMPAT/FSID_CHANGING_IN_PROGRESS flags is scanned
find_fsid_changed won't be able to find an appropriate btrfs_fs_devices.
This is done by extending find_fsid_changed to correctly find
btrfs_fs_devices whose metadata_uuid/fsid are the same and they match
the metadata_uuid of the currently scanned device.

Fixes: cc5de4e70256 ("btrfs: Handle final split-brain possibility during fsid change")
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reported-by: Su Yue <Damenly_Su@gmx.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/volumes.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -697,17 +697,28 @@ static struct btrfs_fs_devices *find_fsi
 	/*
 	 * Handles the case where scanned device is part of an fs that had
 	 * multiple successful changes of FSID but curently device didn't
-	 * observe it. Meaning our fsid will be different than theirs.
+	 * observe it. Meaning our fsid will be different than theirs. We need
+	 * to handle two subcases :
+	 *  1 - The fs still continues to have different METADATA/FSID uuids.
+	 *  2 - The fs is switched back to its original FSID (METADATA/FSID
+	 *  are equal).
 	 */
 	list_for_each_entry(fs_devices, &fs_uuids, fs_list) {
+		/* Changed UUIDs */
 		if (memcmp(fs_devices->metadata_uuid, fs_devices->fsid,
 			   BTRFS_FSID_SIZE) != 0 &&
 		    memcmp(fs_devices->metadata_uuid, disk_super->metadata_uuid,
 			   BTRFS_FSID_SIZE) == 0 &&
 		    memcmp(fs_devices->fsid, disk_super->fsid,
-			   BTRFS_FSID_SIZE) != 0) {
+			   BTRFS_FSID_SIZE) != 0)
+			return fs_devices;
+
+		/* Unchanged UUIDs */
+		if (memcmp(fs_devices->metadata_uuid, fs_devices->fsid,
+			   BTRFS_FSID_SIZE) == 0 &&
+		    memcmp(fs_devices->fsid, disk_super->metadata_uuid,
+			   BTRFS_FSID_SIZE) == 0)
 			return fs_devices;
-		}
 	}
 
 	return NULL;


