Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5462D4A434A
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbiAaLUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:20:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35386 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358824AbiAaLQM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:16:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78A42B82A60;
        Mon, 31 Jan 2022 11:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04A8C340F6;
        Mon, 31 Jan 2022 11:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627770;
        bh=fyW3VQY1hsrMVTxcCkB3SrRtd1fxSMkjIxRB1Iq4xes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V72NRstsH69VAiJQ88hro2v914q0rVedUiyg5Lv6HZlHsJnLQawLF5em0B4wwfKf3
         LD8E9BZ4LSLLt5YEo5TuqFRCnEPSAKvWtpHXvAR4GN+aeS68QXs3yZ+dCO81VKiXx9
         52Q1+UXXoQ8WigSVdgbGpefIwWPOZAU0JX3U2XwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Ruhier <aruhier@mailbox.org>,
        Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 002/200] btrfs: fix too long loop when defragging a 1 byte file
Date:   Mon, 31 Jan 2022 11:54:25 +0100
Message-Id: <20220131105233.642599121@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 6b34cd8e175bfbf4f3f01b6d19eae18245e1a8cc upstream.

When attempting to defrag a file with a single byte, we can end up in a
too long loop, which is nearly infinite because at btrfs_defrag_file()
we end up with the variable last_byte assigned with a value of
18446744073709551615 (which is (u64)-1). The problem comes from the fact
we end up doing:

    last_byte = round_up(last_byte, fs_info->sectorsize) - 1;

So if last_byte was assigned 0, which is i_size - 1, we underflow and
end up with the value 18446744073709551615.

This is trivial to reproduce and the following script triggers it:

  $ cat test.sh
  #!/bin/bash

  DEV=/dev/sdj
  MNT=/mnt/sdj

  mkfs.btrfs -f $DEV
  mount $DEV $MNT

  echo -n "X" > $MNT/foobar

  btrfs filesystem defragment $MNT/foobar

  umount $MNT

So fix this by not decrementing last_byte by 1 before doing the sector
size round up. Also, to make it easier to follow, make the round up right
after computing last_byte.

Reported-by: Anthony Ruhier <aruhier@mailbox.org>
Fixes: 7b508037d4cac3 ("btrfs: defrag: use defrag_one_cluster() to implement btrfs_defrag_file()")
Link: https://lore.kernel.org/linux-btrfs/0a269612-e43f-da22-c5bc-b34b1b56ebe8@mailbox.org/
CC: stable@vger.kernel.org # 5.16
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1492,12 +1492,16 @@ int btrfs_defrag_file(struct inode *inod
 
 	if (range->start + range->len > range->start) {
 		/* Got a specific range */
-		last_byte = min(isize, range->start + range->len) - 1;
+		last_byte = min(isize, range->start + range->len);
 	} else {
 		/* Defrag until file end */
-		last_byte = isize - 1;
+		last_byte = isize;
 	}
 
+	/* Align the range */
+	cur = round_down(range->start, fs_info->sectorsize);
+	last_byte = round_up(last_byte, fs_info->sectorsize) - 1;
+
 	/*
 	 * If we were not given a ra, allocate a readahead context. As
 	 * readahead is just an optimization, defrag will work without it so
@@ -1510,10 +1514,6 @@ int btrfs_defrag_file(struct inode *inod
 			file_ra_state_init(ra, inode->i_mapping);
 	}
 
-	/* Align the range */
-	cur = round_down(range->start, fs_info->sectorsize);
-	last_byte = round_up(last_byte, fs_info->sectorsize) - 1;
-
 	while (cur < last_byte) {
 		u64 cluster_end;
 


