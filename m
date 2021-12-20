Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D4947AFDB
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238439AbhLTPUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239477AbhLTPSj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:18:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFFEC019D8A;
        Mon, 20 Dec 2021 06:59:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C86DCB80EE8;
        Mon, 20 Dec 2021 14:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2DBC36AE8;
        Mon, 20 Dec 2021 14:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012373;
        bh=EHVOOZVW3K4HICA6jyZoySDbsGs3yaaV7IPnYMUFHj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ppFuiM3zXWGbgp+3wQlB8qTu+hMNQ/4qQEEYEXVsUORrmysu2k+yPN5jy1bQWRzht
         NlKZOgsF3U4aIyKEv89Age1Vq3ezCM0NTThByFEb1bgxgMmNToZlI2pQHwaPkxmZUI
         b/IvViNJC8ctkGrdRsZSxuzjrpSpJRJBcEZAX2BE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 135/177] btrfs: fix missing blkdev_put() call in btrfs_scan_one_device()
Date:   Mon, 20 Dec 2021 15:34:45 +0100
Message-Id: <20211220143044.631719032@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit 4989d4a0aed3fb30f5b48787a689d7090de6f86d upstream.

The function btrfs_scan_one_device() calls blkdev_get_by_path() and
blkdev_put() to get and release its target block device. However, when
btrfs_sb_log_location_bdev() fails, blkdev_put() is not called and the
block device is left without clean up. This triggered failure of fstests
generic/085. Fix the failure path of btrfs_sb_log_location_bdev() to
call blkdev_put().

Fixes: 12659251ca5df ("btrfs: implement log-structured superblock for ZONED mode")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1366,8 +1366,10 @@ struct btrfs_device *btrfs_scan_one_devi
 
 	bytenr_orig = btrfs_sb_offset(0);
 	ret = btrfs_sb_log_location_bdev(bdev, 0, READ, &bytenr);
-	if (ret)
-		return ERR_PTR(ret);
+	if (ret) {
+		device = ERR_PTR(ret);
+		goto error_bdev_put;
+	}
 
 	disk_super = btrfs_read_disk_super(bdev, bytenr, bytenr_orig);
 	if (IS_ERR(disk_super)) {


