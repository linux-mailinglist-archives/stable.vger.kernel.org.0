Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DABC4891C9
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240250AbiAJHge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:36:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60872 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240857AbiAJHcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:32:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42255B81213;
        Mon, 10 Jan 2022 07:32:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73241C36AED;
        Mon, 10 Jan 2022 07:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799969;
        bh=V3CsWTO+/8vOVLZMCWRNWCH1UqB2p2pJz3ESHO5hvxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UrnsTAKrWkM7rQ/A1c/vibaDl8j7ZM2BiO+8ic2f9b5NUKR0UmADfkjNe3ts8lq+J
         NJkosHiv43FA+qZw/+lBb2hAf7ZsMEA16VPqAEb7RuCjC2BRBXj3ROxIW+QhgORntG
         hD3dgajQ72sPOMmZMl4F86t1UL+ipjRW3SEhRZp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guoqing Jiang <guoqing.jiang@linux.dev>,
        Jens Axboe <axboe@kernel.dk>,
        Norbert Warmuth <nwarmuth@t-online.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Song Liu <song@kernel.org>
Subject: [PATCH 5.15 32/72] md/raid1: fix missing bitmap update w/o WriteMostly devices
Date:   Mon, 10 Jan 2022 08:23:09 +0100
Message-Id: <20220110071822.642410774@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Liu <song@kernel.org>

commit 46669e8616c649c71c4cfcd712fd3d107e771380 upstream.

commit [1] causes missing bitmap updates when there isn't any WriteMostly
devices.

Detailed steps to reproduce by Norbert (which somehow didn't make to lore):

   # setup md10 (raid1) with two drives (1 GByte sparse files)
   dd if=/dev/zero of=disk1 bs=1024k seek=1024 count=0
   dd if=/dev/zero of=disk2 bs=1024k seek=1024 count=0

   losetup /dev/loop11 disk1
   losetup /dev/loop12 disk2

   mdadm --create /dev/md10 --level=1 --raid-devices=2 /dev/loop11 /dev/loop12

   # add bitmap (aka write-intent log)
   mdadm /dev/md10 --grow --bitmap=internal

   echo check > /sys/block/md10/md/sync_action

   root:# cat /sys/block/md10/md/mismatch_cnt
   0
   root:#

   # remove member drive disk2 (loop12)
   mdadm /dev/md10 -f loop12 ; mdadm /dev/md10 -r loop12

   # modify degraded md device
   dd if=/dev/urandom of=/dev/md10 bs=512 count=1

   # no blocks recorded as out of sync on the remaining member disk1/loop11
   root:# mdadm -X /dev/loop11 | grep Bitmap
             Bitmap : 16 bits (chunks), 0 dirty (0.0%)
   root:#

   # re-add disk2, nothing synced because of empty bitmap
   mdadm /dev/md10 --re-add /dev/loop12

   # check integrity again
   echo check > /sys/block/md10/md/sync_action

   # disk1 and disk2 are no longer in sync, reads return differend data
   root:# cat /sys/block/md10/md/mismatch_cnt
   128
   root:#

   # clean up
   mdadm -S /dev/md10
   losetup -d /dev/loop11
   losetup -d /dev/loop12
   rm disk1 disk2

Fix this by moving the WriteMostly check to the if condition for
alloc_behind_master_bio().

[1] commit fd3b6975e9c1 ("md/raid1: only allocate write behind bio for WriteMostly device")
Fixes: fd3b6975e9c1 ("md/raid1: only allocate write behind bio for WriteMostly device")
Cc: stable@vger.kernel.org # v5.12+
Cc: Guoqing Jiang <guoqing.jiang@linux.dev>
Cc: Jens Axboe <axboe@kernel.dk>
Reported-by: Norbert Warmuth <nwarmuth@t-online.de>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid1.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1496,12 +1496,13 @@ static void raid1_write_request(struct m
 		if (!r1_bio->bios[i])
 			continue;
 
-		if (first_clone && test_bit(WriteMostly, &rdev->flags)) {
+		if (first_clone) {
 			/* do behind I/O ?
 			 * Not if there are too many, or cannot
 			 * allocate memory, or a reader on WriteMostly
 			 * is waiting for behind writes to flush */
 			if (bitmap &&
+			    test_bit(WriteMostly, &rdev->flags) &&
 			    (atomic_read(&bitmap->behind_writes)
 			     < mddev->bitmap_info.max_write_behind) &&
 			    !waitqueue_active(&bitmap->behind_wait)) {


