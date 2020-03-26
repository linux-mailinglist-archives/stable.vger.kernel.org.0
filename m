Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E46EA194665
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 19:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgCZSQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 14:16:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728578AbgCZSQ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 14:16:27 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73D522076A;
        Thu, 26 Mar 2020 18:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585246586;
        bh=KLUSq5iw7Z93jzWyigCr90N7a6+kueD+eE8kLHhRWyk=;
        h=Date:From:To:Subject:From;
        b=NJSPW5mSco+Qyp9MsyvJ8BNj+zEginwsTgjk8l8pUOgPOjYq8Zu5tYOYkumEurt1c
         2ppuHOZx3vbJE83RekGWPr2nLTPx6aYOIaAB/ABj2PS5XH30mUTXhHCIgJ+3ZG3xgB
         DRLBV0INC9LtYWZZu6+bSkln8WueoXyqcx2vvaqc=
Date:   Thu, 26 Mar 2020 11:16:26 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, ebiggers@google.com, glider@google.com,
        gregkh@linuxfoundation.org, keescook@chromium.org,
        mm-commits@vger.kernel.org, rafael@kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk
Subject:  [merged] libfs-fix-infoleak-in-simple_attr_read.patch
 removed from -mm tree
Message-ID: <20200326181626.7XXIS_588%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: libfs: fix infoleak in simple_attr_read()
has been removed from the -mm tree.  Its filename was
     libfs-fix-infoleak-in-simple_attr_read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: libfs: fix infoleak in simple_attr_read()

Reading from a debugfs file at a nonzero position, without first reading
at position 0, leaks uninitialized memory to userspace.

It's a bit tricky to do this, since lseek() and pread() aren't allowed on
these files, and write() doesn't update the position on them.  But writing
to them with splice() *does* update the position:

	#define _GNU_SOURCE 1
	#include <fcntl.h>
	#include <stdio.h>
	#include <unistd.h>
	int main()
	{
		int pipes[2], fd, n, i;
		char buf[32];

		pipe(pipes);
		write(pipes[1], "0", 1);
		fd = open("/sys/kernel/debug/fault_around_bytes", O_RDWR);
		splice(pipes[0], NULL, fd, NULL, 1, 0);
		n = read(fd, buf, sizeof(buf));
		for (i = 0; i < n; i++)
			printf("%02x", buf[i]);
		printf("
");
	}

Output:
	5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a30

Fix the infoleak by making simple_attr_read() always fill
simple_attr::get_buf if it hasn't been filled yet.

Link: http://lkml.kernel.org/r/20200308023849.988264-1-ebiggers@kernel.org
Fixes: acaefc25d21f ("[PATCH] libfs: add simple attribute files")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reported-by: syzbot+fcab69d1ada3e8d6f06b@syzkaller.appspotmail.com
Reported-by: Alexander Potapenko <glider@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/libfs.c~libfs-fix-infoleak-in-simple_attr_read
+++ a/fs/libfs.c
@@ -891,7 +891,7 @@ int simple_attr_open(struct inode *inode
 {
 	struct simple_attr *attr;
 
-	attr = kmalloc(sizeof(*attr), GFP_KERNEL);
+	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
 	if (!attr)
 		return -ENOMEM;
 
@@ -931,9 +931,11 @@ ssize_t simple_attr_read(struct file *fi
 	if (ret)
 		return ret;
 
-	if (*ppos) {		/* continued read */
+	if (*ppos && attr->get_buf[0]) {
+		/* continued read */
 		size = strlen(attr->get_buf);
-	} else {		/* first read */
+	} else {
+		/* first read */
 		u64 val;
 		ret = attr->get(attr->data, &val);
 		if (ret)
_

Patches currently in -mm which might be from ebiggers@google.com are

kmod-make-request_module-return-an-error-when-autoloading-is-disabled.patch
fs-filesystemsc-downgrade-user-reachable-warn_once-to-pr_warn_once.patch
docs-admin-guide-document-the-kernelmodprobe-sysctl.patch
selftests-kmod-fix-handling-test-numbers-above-9.patch
selftests-kmod-test-disabling-module-autoloading.patch

