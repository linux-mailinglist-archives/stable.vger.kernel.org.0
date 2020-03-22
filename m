Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4869B18E66D
	for <lists+stable@lfdr.de>; Sun, 22 Mar 2020 05:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbgCVEtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Mar 2020 00:49:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbgCVEtO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Mar 2020 00:49:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9F46206F9;
        Sun, 22 Mar 2020 04:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584851984;
        bh=+XT11jeDv1p40IvxgewUHNGU1dbfEDAW2ShYPS7T1NM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1hAISbPPVyKb42pUBTWTbyH7exhT5RkABtL0Qe/1vrBEn8N9BmuHZWSeKKCRtAeoR
         91IkRZXSC4VR/h5M4Aj4reOVhh9kr/+WPc5f7jofxtEtkNgsfW2DadNC6loz8rZwWL
         aqfUUXFM7E5CbBk43WSD8nvBPTab3vgLrx9MipCY=
Date:   Sat, 21 Mar 2020 21:39:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     arnd@arndb.de, ebiggers@google.com, glider@google.com,
        gregkh@linuxfoundation.org, keescook@chromium.org,
        mm-commits@vger.kernel.org, rafael@kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk
Subject:  + libfs-fix-infoleak-in-simple_attr_read.patch added to
 -mm tree
Message-ID: <20200322043943.GCnF6HIYE%akpm@linux-foundation.org>
In-Reply-To: <20200321181954.c0564dfd5514cd742b534884@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: libfs: fix infoleak in simple_attr_read()
has been added to the -mm tree.  Its filename is
     libfs-fix-infoleak-in-simple_attr_read.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/libfs-fix-infoleak-in-simple_attr_read.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/libfs-fix-infoleak-in-simple_attr_read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

libfs-fix-infoleak-in-simple_attr_read.patch
kmod-make-request_module-return-an-error-when-autoloading-is-disabled.patch
fs-filesystemsc-downgrade-user-reachable-warn_once-to-pr_warn_once.patch
docs-admin-guide-document-the-kernelmodprobe-sysctl.patch
selftests-kmod-fix-handling-test-numbers-above-9.patch
selftests-kmod-test-disabling-module-autoloading.patch

