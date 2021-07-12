Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A743C507F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244639AbhGLHdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240869AbhGLHbi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:31:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18FD560230;
        Mon, 12 Jul 2021 07:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074930;
        bh=pgI+/Df8121ZUDQT2I5B+VvmDU3J0R2g8tw16QXFORM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=emSIml7krWQPFZFKGDRzx6Uuyx+wPpwE9EyjpZox8Ngvq4Cu2D6d37dmpxOPBa3Lj
         Fp1Alqs0vr2GmY3mUDdpKU31qLs3ptVpyzSmFVqqiZpr3e7yO1bDR00qUnHVQzu4ae
         447ksdYofl+46gyHqutqBMgeWZna8rjieJdH6YhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.13 047/800] btrfs: zoned: bail out if we cant read a reliable write pointer
Date:   Mon, 12 Jul 2021 08:01:10 +0200
Message-Id: <20210712060920.013662599@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 06e1e7f4223c98965fb721b4b1e12083cfbe777e upstream.

If we can't read a reliable write pointer from a sequential zone fail
creating the block group with an I/O error.

Also if the read write pointer is beyond the end of the respective zone,
fail the creation of the block group on this zone with an I/O error.

While this could also happen in real world scenarios with misbehaving
drives, this issue addresses a problem uncovered by fstests' test case
generic/475.

CC: stable@vger.kernel.org # 5.12+
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/zoned.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1204,6 +1204,13 @@ int btrfs_load_block_group_zone_info(str
 
 	switch (map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
 	case 0: /* single */
+		if (alloc_offsets[0] == WP_MISSING_DEV) {
+			btrfs_err(fs_info,
+			"zoned: cannot recover write pointer for zone %llu",
+				physical);
+			ret = -EIO;
+			goto out;
+		}
 		cache->alloc_offset = alloc_offsets[0];
 		break;
 	case BTRFS_BLOCK_GROUP_DUP:
@@ -1221,6 +1228,13 @@ int btrfs_load_block_group_zone_info(str
 	}
 
 out:
+	if (cache->alloc_offset > fs_info->zone_size) {
+		btrfs_err(fs_info,
+			"zoned: invalid write pointer %llu in block group %llu",
+			cache->alloc_offset, cache->start);
+		ret = -EIO;
+	}
+
 	/* An extent is allocated after the write pointer */
 	if (!ret && num_conventional && last_alloc > cache->alloc_offset) {
 		btrfs_err(fs_info,


