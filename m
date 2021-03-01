Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7791E328F26
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240872AbhCATpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:45:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:50632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236189AbhCATgA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:36:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BC9C6511C;
        Mon,  1 Mar 2021 17:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618167;
        bh=dGE1v0GCG/8MKspbHGh5FzQxyvr/FyJabl5fOrzZqdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ypNzlYlWacAdAiMlOKaPlOW8Zg45eT8m9mLP3161ebYDcdSKk3AGunfzKDOAoMnhg
         SySa27035N2C66TsLPDFvVkhYVh92JfrgjvMbI9goLppAgsi4elDdeggYrFy2b9D3G
         ojpEkAQvwQvDdEmvMxUFOctPo2ZVFnFJn7YBB7RQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wim Osterholt <wim@djo.tudelft.nl>,
        Jiri Kosina <jkosina@suse.cz>,
        Denis Efremov <efremov@linux.com>,
        Kurt Garloff <kurt@garloff.de>
Subject: [PATCH 5.4 290/340] floppy: reintroduce O_NDELAY fix
Date:   Mon,  1 Mar 2021 17:13:54 +0100
Message-Id: <20210301161102.563379034@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

commit 8a0c014cd20516ade9654fc13b51345ec58e7be8 upstream.

This issue was originally fixed in 09954bad4 ("floppy: refactor open()
flags handling").

The fix as a side-effect, however, introduce issue for open(O_ACCMODE)
that is being used for ioctl-only open. I wrote a fix for that, but
instead of it being merged, full revert of 09954bad4 was performed,
re-introducing the O_NDELAY / O_NONBLOCK issue, and it strikes again.

This is a forward-port of the original fix to current codebase; the
original submission had the changelog below:

====
Commit 09954bad4 ("floppy: refactor open() flags handling"), as a
side-effect, causes open(/dev/fdX, O_ACCMODE) to fail. It turns out that
this is being used setfdprm userspace for ioctl-only open().

Reintroduce back the original behavior wrt !(FMODE_READ|FMODE_WRITE)
modes, while still keeping the original O_NDELAY bug fixed.

Link: https://lore.kernel.org/r/nycvar.YFH.7.76.2101221209060.5622@cbobk.fhfr.pm
Cc: stable@vger.kernel.org
Reported-by: Wim Osterholt <wim@djo.tudelft.nl>
Tested-by: Wim Osterholt <wim@djo.tudelft.nl>
Reported-and-tested-by: Kurt Garloff <kurt@garloff.de>
Fixes: 09954bad4 ("floppy: refactor open() flags handling")
Fixes: f2791e7ead ("Revert "floppy: refactor open() flags handling"")
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/floppy.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4063,21 +4063,22 @@ static int floppy_open(struct block_devi
 	if (UFDCS->rawcmd == 1)
 		UFDCS->rawcmd = 2;
 
-	if (!(mode & FMODE_NDELAY)) {
-		if (mode & (FMODE_READ|FMODE_WRITE)) {
-			UDRS->last_checked = 0;
-			clear_bit(FD_OPEN_SHOULD_FAIL_BIT, &UDRS->flags);
-			check_disk_change(bdev);
-			if (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags))
-				goto out;
-			if (test_bit(FD_OPEN_SHOULD_FAIL_BIT, &UDRS->flags))
-				goto out;
-		}
-		res = -EROFS;
-		if ((mode & FMODE_WRITE) &&
-		    !test_bit(FD_DISK_WRITABLE_BIT, &UDRS->flags))
+	if (mode & (FMODE_READ|FMODE_WRITE)) {
+		UDRS->last_checked = 0;
+		clear_bit(FD_OPEN_SHOULD_FAIL_BIT, &UDRS->flags);
+		check_disk_change(bdev);
+		if (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags))
+			goto out;
+		if (test_bit(FD_OPEN_SHOULD_FAIL_BIT, &UDRS->flags))
 			goto out;
 	}
+
+	res = -EROFS;
+
+	if ((mode & FMODE_WRITE) &&
+			!test_bit(FD_DISK_WRITABLE_BIT, &UDRS->flags))
+		goto out;
+
 	mutex_unlock(&open_lock);
 	mutex_unlock(&floppy_mutex);
 	return 0;


