Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C348F3FD9AD
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 14:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244258AbhIAM20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:28:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244263AbhIAM2T (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:28:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF51061056;
        Wed,  1 Sep 2021 12:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499243;
        bh=0mBjFpwEvCqDgZS1o5JhwA7zR5CXALkw2iUrffsZf/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wTC+qtXaXgYuj5m5bt4O4XfdxiPuE4pC3mHC8V4XgZVp+24mt/4VTPOHWkGc65A6f
         nu/lSZKUPw2gpYPLfo9b4vabm5aOLpEUEfCMHWXVEu6gD/I73nPy+XAqaF2u1Yer28
         xcMtKgRVsa78JgeM9cwMG76iLKdUyr7a/CmvfSts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Hounschell <markh@compro.net>,
        Jiri Kosina <jkosina@suse.cz>,
        Wim Osterholt <wim@djo.tudelft.nl>,
        Kurt Garloff <kurt@garloff.de>,
        Denis Efremov <efremov@linux.com>
Subject: [PATCH 4.9 16/16] Revert "floppy: reintroduce O_NDELAY fix"
Date:   Wed,  1 Sep 2021 14:26:42 +0200
Message-Id: <20210901122249.423594340@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122248.920548099@linuxfoundation.org>
References: <20210901122248.920548099@linuxfoundation.org>
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
 drivers/block/floppy.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4067,22 +4067,21 @@ static int floppy_open(struct block_devi
 	if (UFDCS->rawcmd == 1)
 		UFDCS->rawcmd = 2;
 
-	if (mode & (FMODE_READ|FMODE_WRITE)) {
-		UDRS->last_checked = 0;
-		clear_bit(FD_OPEN_SHOULD_FAIL_BIT, &UDRS->flags);
-		check_disk_change(bdev);
-		if (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags))
-			goto out;
-		if (test_bit(FD_OPEN_SHOULD_FAIL_BIT, &UDRS->flags))
+	if (!(mode & FMODE_NDELAY)) {
+		if (mode & (FMODE_READ|FMODE_WRITE)) {
+			UDRS->last_checked = 0;
+			clear_bit(FD_OPEN_SHOULD_FAIL_BIT, &UDRS->flags);
+			check_disk_change(bdev);
+			if (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags))
+				goto out;
+			if (test_bit(FD_OPEN_SHOULD_FAIL_BIT, &UDRS->flags))
+				goto out;
+		}
+		res = -EROFS;
+		if ((mode & FMODE_WRITE) &&
+		    !test_bit(FD_DISK_WRITABLE_BIT, &UDRS->flags))
 			goto out;
 	}
-
-	res = -EROFS;
-
-	if ((mode & FMODE_WRITE) &&
-			!test_bit(FD_DISK_WRITABLE_BIT, &UDRS->flags))
-		goto out;
-
 	mutex_unlock(&open_lock);
 	mutex_unlock(&floppy_mutex);
 	return 0;


