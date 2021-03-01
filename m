Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8488B327DC2
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 13:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbhCAMAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 07:00:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:36956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234587AbhCAMAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 07:00:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47EF464E09;
        Mon,  1 Mar 2021 11:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614599969;
        bh=xxI25iWl+kywtHNgGVP0mVL7WhfMjuRjOMuNm1XBJwM=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=AvqclXM5aR/vhdb86AqjPv3wMkOCv4il+7f4NY/I+TiskIgUbkDl9oEe5Vc5qONxK
         YpVS/hfRxfpiRE52U9geM8tJtVRmKFgyZ3Rod5Xpp9m5eqObtu4LUPx5HjnL0M5v98
         r2+CArsR3ICDYh7HNUzLzkkWJWneZxRFjeTaws21GHBFVFUOmKFiZNQDtFJ/btWc/4
         YCUucYdkQdVqz0y3/5j2X2H0qGB/tO65d0aATXeOOYpBK7eQ7/VjI68Wuer009bkcU
         WhEOhRDUUA+Tzus7zvyz9Y0UkcHmEzJuTO3pPoK9ibP1eSZQ0mx3VRENyaTG93qBFE
         0h/AsimsjpoQA==
Date:   Mon, 1 Mar 2021 12:59:26 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
cc:     efremov@linux.com, kurt@garloff.de, wim@djo.tudelft.nl
Subject: Re: FAILED: patch "[PATCH] floppy: reintroduce O_NDELAY fix" failed
 to apply to 5.4-stable tree
In-Reply-To: <1614597396146166@kroah.com>
Message-ID: <nycvar.YFH.7.76.2103011256400.12405@cbobk.fhfr.pm>
References: <1614597396146166@kroah.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 1 Mar 2021, gregkh@linuxfoundation.org wrote:

> The patch below does not apply to the 5.4-stable tree. If someone wants 
> it applied there, or to any other stable or longterm tree, then please 
> email the backport, including the original git commit id to 
> <stable@vger.kernel.org>.

Below is a backport of upstream commit 8a0c014cd20516a taken from SUSE 
kernel tree.


From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] floppy: reintroduce O_NDELAY fix

Originally fixed in 09954bad4 ("floppy: refactor open() flags handling")
then reverted for unknown reason in f2791e7eadf437 instead of taking
the open(O_ACCMODE) for ioctl-only open fix, which had the changelog below

====
Commit 09954bad4 ("floppy: refactor open() flags handling"), as a
side-effect, causes open(/dev/fdX, O_ACCMODE) to fail. It turns out that
this is being used setfdprm userspace for ioctl-only open().

Reintroduce back the original behavior wrt !(FMODE_READ|FMODE_WRITE)
modes, while still keeping the original O_NDELAY bug fixed.

Cc: stable@vger.kernel.org # v4.5+
Reported-by: Wim Osterholt <wim@djo.tudelft.nl>
Tested-by: Wim Osterholt <wim@djo.tudelft.nl>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
=====

Link: https://lore.kernel.org/r/nycvar.YFH.7.76.2101221209060.5622@cbobk.fhfr.pm
Cc: stable@vger.kernel.org
Reported-by: Wim Osterholt <wim@djo.tudelft.nl>
Tested-by: Wim Osterholt <wim@djo.tudelft.nl>
Reported-and-tested-by: Kurt Garloff <kurt@garloff.de>
Fixes: 09954bad4 ("floppy: refactor open() flags handling")
Fixes: f2791e7ead ("Revert "floppy: refactor open() flags handling"")
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/block/floppy.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

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

-- 
Jiri Kosina
SUSE Labs

