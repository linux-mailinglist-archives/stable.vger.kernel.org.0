Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48EBA1332DD
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbgAGVOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:14:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:35484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729858AbgAGVJl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:09:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEC8A20880;
        Tue,  7 Jan 2020 21:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431381;
        bh=vpWXOJ4+oz3ooR0QIgwHEzbKOTpT6bLzdgkQ+M6zneY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PaC46PHZfkLh25bYcah838RLwfN/D2svBlPFcKaOUxlE3HtDuU0kpcGz61Zmq1b01
         wHTapwKCcHaKL/lpdMpE9lkfQbdR+4wuls/YXFPZIw78LLqNpHR84ELo8mnQ34SWI0
         a6xSCCyVB/xbkG5dCBZRyXf7ChGmDkX9/0Qsz3mM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.14 34/74] compat_ioctl: block: handle Persistent Reservations
Date:   Tue,  7 Jan 2020 21:54:59 +0100
Message-Id: <20200107205204.052887080@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205135.369001641@linuxfoundation.org>
References: <20200107205135.369001641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit b2c0fcd28772f99236d261509bcd242135677965 upstream.

These were added to blkdev_ioctl() in linux-5.5 but not
blkdev_compat_ioctl, so add them now.

Cc: <stable@vger.kernel.org> # v4.4+
Fixes: bbd3e064362e ("block: add an API for Persistent Reservations")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Fold in followup patch from Arnd with missing pr.h header include.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---
 block/compat_ioctl.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -6,6 +6,7 @@
 #include <linux/compat.h>
 #include <linux/elevator.h>
 #include <linux/hdreg.h>
+#include <linux/pr.h>
 #include <linux/slab.h>
 #include <linux/syscalls.h>
 #include <linux/types.h>
@@ -401,6 +402,14 @@ long compat_blkdev_ioctl(struct file *fi
 	case BLKTRACETEARDOWN: /* compatible */
 		ret = blk_trace_ioctl(bdev, cmd, compat_ptr(arg));
 		return ret;
+	case IOC_PR_REGISTER:
+	case IOC_PR_RESERVE:
+	case IOC_PR_RELEASE:
+	case IOC_PR_PREEMPT:
+	case IOC_PR_PREEMPT_ABORT:
+	case IOC_PR_CLEAR:
+		return blkdev_ioctl(bdev, mode, cmd,
+				(unsigned long)compat_ptr(arg));
 	default:
 		if (disk->fops->compat_ioctl)
 			ret = disk->fops->compat_ioctl(bdev, mode, cmd, arg);


