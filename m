Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E893FDCC5
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346361AbhIAMxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:53:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345475AbhIAMvN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:51:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 697E56124C;
        Wed,  1 Sep 2021 12:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500166;
        bh=8KFKL57BU8TXiy9A2Pa1qbTuMhjJfgk8e1ia+X1m2jg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iu0xFWuZMgHBH4uhMPjXLfcYYvvwL0OjNDKwqXAvqiCe0hcmO9bQvvBhfQTAQFicb
         642sNPeIR+R9q/70ZqJR4GWLiXdF0dik9Aw3QClzL5wsJOSYonhMdE6gZk6XxkdygF
         MIALtbnA82fMhCtVFXp/cmPjnVo2IEu/8EUQ93fY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Hounschell <markh@compro.net>,
        Jiri Kosina <jkosina@suse.cz>,
        Wim Osterholt <wim@djo.tudelft.nl>,
        Kurt Garloff <kurt@garloff.de>,
        Denis Efremov <efremov@linux.com>
Subject: [PATCH 5.14 05/11] Revert "floppy: reintroduce O_NDELAY fix"
Date:   Wed,  1 Sep 2021 14:29:13 +0200
Message-Id: <20210901122249.697143977@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122249.520249736@linuxfoundation.org>
References: <20210901122249.520249736@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

commit c7e9d0020361f4308a70cdfd6d5335e273eb8717 upstream.

The patch breaks userspace implementations (e.g. fdutils) and introduces
regressions in behaviour. Previously, it was possible to O_NDELAY open a
floppy device with no media inserted or with write protected media without
an error. Some userspace tools use this particular behavior for probing.

It's not the first time when we revert this patch. Previous revert is in
commit f2791e7eadf4 (Revert "floppy: refactor open() flags handling").

This reverts commit 8a0c014cd20516ade9654fc13b51345ec58e7be8.

Link: https://lore.kernel.org/linux-block/de10cb47-34d1-5a88-7751-225ca380f735@compro.net/
Reported-by: Mark Hounschell <markh@compro.net>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Wim Osterholt <wim@djo.tudelft.nl>
Cc: Kurt Garloff <kurt@garloff.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/floppy.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4029,23 +4029,23 @@ static int floppy_open(struct block_devi
 	if (fdc_state[FDC(drive)].rawcmd == 1)
 		fdc_state[FDC(drive)].rawcmd = 2;
 
-	if (mode & (FMODE_READ|FMODE_WRITE)) {
-		drive_state[drive].last_checked = 0;
-		clear_bit(FD_OPEN_SHOULD_FAIL_BIT, &drive_state[drive].flags);
-		if (bdev_check_media_change(bdev))
-			floppy_revalidate(bdev->bd_disk);
-		if (test_bit(FD_DISK_CHANGED_BIT, &drive_state[drive].flags))
-			goto out;
-		if (test_bit(FD_OPEN_SHOULD_FAIL_BIT, &drive_state[drive].flags))
+	if (!(mode & FMODE_NDELAY)) {
+		if (mode & (FMODE_READ|FMODE_WRITE)) {
+			drive_state[drive].last_checked = 0;
+			clear_bit(FD_OPEN_SHOULD_FAIL_BIT,
+				  &drive_state[drive].flags);
+			if (bdev_check_media_change(bdev))
+				floppy_revalidate(bdev->bd_disk);
+			if (test_bit(FD_DISK_CHANGED_BIT, &drive_state[drive].flags))
+				goto out;
+			if (test_bit(FD_OPEN_SHOULD_FAIL_BIT, &drive_state[drive].flags))
+				goto out;
+		}
+		res = -EROFS;
+		if ((mode & FMODE_WRITE) &&
+		    !test_bit(FD_DISK_WRITABLE_BIT, &drive_state[drive].flags))
 			goto out;
 	}
-
-	res = -EROFS;
-
-	if ((mode & FMODE_WRITE) &&
-			!test_bit(FD_DISK_WRITABLE_BIT, &drive_state[drive].flags))
-		goto out;
-
 	mutex_unlock(&open_lock);
 	mutex_unlock(&floppy_mutex);
 	return 0;


