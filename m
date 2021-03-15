Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC6C33B506
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhCONxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:53:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229922AbhCONwx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:52:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0BDE64EEA;
        Mon, 15 Mar 2021 13:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816373;
        bh=UClx/LucMLqlASlWFLJafc3T41WL1daS9geyLoGYMsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5gOwbJmLp6E2cCdoWQN/YXlezUo91rEz4JjaOd+6q6gr6UMlXwhNP/y3jcYnkkEC
         o3gYV8oOkjDcgkn6Bq+1C3wzRAY5EPLBJlyq09I8lLDIpTc0qIPjm1G89GmGnqe43d
         STt6p8qWWel+Br2urJoYSF0Fn+1J1Pb0xLfvx02w=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Wade Mealing <wmealing@redhat.com>
Subject: [PATCH 4.4 09/75] floppy: fix lock_fdc() signal handling
Date:   Mon, 15 Mar 2021 14:51:23 +0100
Message-Id: <20210315135208.569811301@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135208.252034256@linuxfoundation.org>
References: <20210315135208.252034256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jiri Kosina <jkosina@suse.cz>

commit a0c80efe5956ccce9fe7ae5c78542578c07bc20a upstream.

floppy_revalidate() doesn't perform any error handling on lock_fdc()
result. lock_fdc() might actually be interrupted by a signal (it waits for
fdc becoming non-busy interruptibly). In such case, floppy_revalidate()
proceeds as if it had claimed the lock, but it fact it doesn't.

In case of multiple threads trying to open("/dev/fdX"), this leads to
serious corruptions all over the place, because all of a sudden there is
no critical section protection (that'd otherwise be guaranteed by locked
fd) whatsoever.

While at this, fix the fact that the 'interruptible' parameter to
lock_fdc() doesn't make any sense whatsoever, because we always wait
interruptibly anyway.

Most of the lock_fdc() callsites do properly handle error (and propagate
EINTR), but floppy_revalidate() and floppy_check_events() don't. Fix this.

Spotted by 'syzkaller' tool.

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Tested-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Wade Mealing <wmealing@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/floppy.c |   35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -870,7 +870,7 @@ static void set_fdc(int drive)
 }
 
 /* locks the driver */
-static int lock_fdc(int drive, bool interruptible)
+static int lock_fdc(int drive)
 {
 	if (WARN(atomic_read(&usage_count) == 0,
 		 "Trying to lock fdc while usage count=0\n"))
@@ -2180,7 +2180,7 @@ static int do_format(int drive, struct f
 {
 	int ret;
 
-	if (lock_fdc(drive, true))
+	if (lock_fdc(drive))
 		return -EINTR;
 
 	set_floppy(drive);
@@ -2967,7 +2967,7 @@ static int user_reset_fdc(int drive, int
 {
 	int ret;
 
-	if (lock_fdc(drive, interruptible))
+	if (lock_fdc(drive))
 		return -EINTR;
 
 	if (arg == FD_RESET_ALWAYS)
@@ -3254,7 +3254,7 @@ static int set_geometry(unsigned int cmd
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 		mutex_lock(&open_lock);
-		if (lock_fdc(drive, true)) {
+		if (lock_fdc(drive)) {
 			mutex_unlock(&open_lock);
 			return -EINTR;
 		}
@@ -3274,7 +3274,7 @@ static int set_geometry(unsigned int cmd
 	} else {
 		int oldStretch;
 
-		if (lock_fdc(drive, true))
+		if (lock_fdc(drive))
 			return -EINTR;
 		if (cmd != FDDEFPRM) {
 			/* notice a disk change immediately, else
@@ -3360,7 +3360,7 @@ static int get_floppy_geometry(int drive
 	if (type)
 		*g = &floppy_type[type];
 	else {
-		if (lock_fdc(drive, false))
+		if (lock_fdc(drive))
 			return -EINTR;
 		if (poll_drive(false, 0) == -EINTR)
 			return -EINTR;
@@ -3462,7 +3462,7 @@ static int fd_locked_ioctl(struct block_
 		if (UDRS->fd_ref != 1)
 			/* somebody else has this drive open */
 			return -EBUSY;
-		if (lock_fdc(drive, true))
+		if (lock_fdc(drive))
 			return -EINTR;
 
 		/* do the actual eject. Fails on
@@ -3474,7 +3474,7 @@ static int fd_locked_ioctl(struct block_
 		process_fd_request();
 		return ret;
 	case FDCLRPRM:
-		if (lock_fdc(drive, true))
+		if (lock_fdc(drive))
 			return -EINTR;
 		current_type[drive] = NULL;
 		floppy_sizes[drive] = MAX_DISK_SIZE << 1;
@@ -3499,7 +3499,7 @@ static int fd_locked_ioctl(struct block_
 		UDP->flags &= ~FTD_MSG;
 		return 0;
 	case FDFMTBEG:
-		if (lock_fdc(drive, true))
+		if (lock_fdc(drive))
 			return -EINTR;
 		if (poll_drive(true, FD_RAW_NEED_DISK) == -EINTR)
 			return -EINTR;
@@ -3516,7 +3516,7 @@ static int fd_locked_ioctl(struct block_
 		return do_format(drive, &inparam.f);
 	case FDFMTEND:
 	case FDFLUSH:
-		if (lock_fdc(drive, true))
+		if (lock_fdc(drive))
 			return -EINTR;
 		return invalidate_drive(bdev);
 	case FDSETEMSGTRESH:
@@ -3542,7 +3542,7 @@ static int fd_locked_ioctl(struct block_
 		outparam = UDP;
 		break;
 	case FDPOLLDRVSTAT:
-		if (lock_fdc(drive, true))
+		if (lock_fdc(drive))
 			return -EINTR;
 		if (poll_drive(true, FD_RAW_NEED_DISK) == -EINTR)
 			return -EINTR;
@@ -3565,7 +3565,7 @@ static int fd_locked_ioctl(struct block_
 	case FDRAWCMD:
 		if (type)
 			return -EINVAL;
-		if (lock_fdc(drive, true))
+		if (lock_fdc(drive))
 			return -EINTR;
 		set_floppy(drive);
 		i = raw_cmd_ioctl(cmd, (void __user *)param);
@@ -3574,7 +3574,7 @@ static int fd_locked_ioctl(struct block_
 		process_fd_request();
 		return i;
 	case FDTWADDLE:
-		if (lock_fdc(drive, true))
+		if (lock_fdc(drive))
 			return -EINTR;
 		twaddle();
 		process_fd_request();
@@ -3801,7 +3801,7 @@ static int compat_getdrvstat(int drive,
 	mutex_lock(&floppy_mutex);
 
 	if (poll) {
-		if (lock_fdc(drive, true))
+		if (lock_fdc(drive))
 			goto Eintr;
 		if (poll_drive(true, FD_RAW_NEED_DISK) == -EINTR)
 			goto Eintr;
@@ -4109,7 +4109,8 @@ static unsigned int floppy_check_events(
 		return DISK_EVENT_MEDIA_CHANGE;
 
 	if (time_after(jiffies, UDRS->last_checked + UDP->checkfreq)) {
-		lock_fdc(drive, false);
+		if (lock_fdc(drive))
+			return -EINTR;
 		poll_drive(false, 0);
 		process_fd_request();
 	}
@@ -4208,7 +4209,9 @@ static int floppy_revalidate(struct gend
 			 "VFS: revalidate called on non-open device.\n"))
 			return -EFAULT;
 
-		lock_fdc(drive, false);
+		res = lock_fdc(drive);
+		if (res)
+			return res;
 		cf = (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags) ||
 		      test_bit(FD_VERIFY_BIT, &UDRS->flags));
 		if (!(cf || test_bit(drive, &fake_change) || drive_no_geom(drive))) {


