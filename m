Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B863119B1FD
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389260AbgDAQjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:39:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388679AbgDAQjw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:39:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C2C82063A;
        Wed,  1 Apr 2020 16:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759191;
        bh=LJtBTb/Sow7taQZdBDfk1yauNSZSrc+lBOspPnDxCo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sTNDwmTe/2ZMldIHb6wH+9+PHHFvvBD4kdJfW13FG96OVwrqTr+/NbyBU5KQD8Aos
         C89x6STcVEC/+Vgt/Ju6U+qTKXS6fnioQ/c9YpZrj+lNfqF7vKXSw2DHxa/iSz8uOL
         qzUzu6w29TgKgqtsqRg0muJ3nCcOrRZMWRfVPHnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+fcab69d1ada3e8d6f06b@syzkaller.appspotmail.com,
        Alexander Potapenko <glider@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 4.9 085/102] libfs: fix infoleak in simple_attr_read()
Date:   Wed,  1 Apr 2020 18:18:28 +0200
Message-Id: <20200401161546.651142648@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
References: <20200401161530.451355388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit a65cab7d7f05c2061a3e2490257d3086ff3202c6 upstream.

Reading from a debugfs file at a nonzero position, without first reading
at position 0, leaks uninitialized memory to userspace.

It's a bit tricky to do this, since lseek() and pread() aren't allowed
on these files, and write() doesn't update the position on them.  But
writing to them with splice() *does* update the position:

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
		printf("\n");
	}

Output:
	5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a30

Fix the infoleak by making simple_attr_read() always fill
simple_attr::get_buf if it hasn't been filled yet.

Reported-by: syzbot+fcab69d1ada3e8d6f06b@syzkaller.appspotmail.com
Reported-by: Alexander Potapenko <glider@google.com>
Fixes: acaefc25d21f ("[PATCH] libfs: add simple attribute files")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20200308023849.988264-1-ebiggers@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/libfs.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -799,7 +799,7 @@ int simple_attr_open(struct inode *inode
 {
 	struct simple_attr *attr;
 
-	attr = kmalloc(sizeof(*attr), GFP_KERNEL);
+	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
 	if (!attr)
 		return -ENOMEM;
 
@@ -839,9 +839,11 @@ ssize_t simple_attr_read(struct file *fi
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


