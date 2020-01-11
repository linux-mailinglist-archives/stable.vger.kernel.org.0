Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1506137DA4
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbgAKJ7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:59:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728844AbgAKJ7u (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:59:50 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C85C2084D;
        Sat, 11 Jan 2020 09:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736790;
        bh=AbrQFtx9N34mKmVEcJbnyQLMvOXnHZk2LJ4igkh5RJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LaN9Py3UMazPD+vy+BBNU2aYc5zfviNe+MKhxr1NOfBtO6c8yMqh567fkEIdwSjbb
         xofQm5udTYuJU8Yahn47ONAQ77camRfjH3b4/55UNYVNkZZIDRvgF6shvz6A44mrrf
         av87HIJgA8RtoUHgOKZXcFZ48bDs8lOgJo+2VvrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.9 25/91] compat_ioctl: block: handle Persistent Reservations
Date:   Sat, 11 Jan 2020 10:49:18 +0100
Message-Id: <20200111094853.623611249@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
References: <20200111094844.748507863@linuxfoundation.org>
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
@@ -5,6 +5,7 @@
 #include <linux/compat.h>
 #include <linux/elevator.h>
 #include <linux/hdreg.h>
+#include <linux/pr.h>
 #include <linux/slab.h>
 #include <linux/syscalls.h>
 #include <linux/types.h>
@@ -406,6 +407,14 @@ long compat_blkdev_ioctl(struct file *fi
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


