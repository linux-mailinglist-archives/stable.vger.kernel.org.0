Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B625024BA54
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730381AbgHTJ6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:58:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbgHTJ6M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:58:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBB972067C;
        Thu, 20 Aug 2020 09:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917491;
        bh=B9I86CKSfEkWeYcKIy1EwsYk+OARDO/f2z7E9feAlY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GlIUtJMwzvGRN04NkHsfNsJ1WbeuRyXWum3ATxaG2TtJzhUfKsAQl31Wu1Gwo9818
         D582SD722ixq5tWczw9Rp8l4toYWHaC8XsEkE/PEz6lvk40+s7QJC3BQElc/0ym/B9
         baWfN2yKa+LuMgLGBp0goFEjTGAyjXoEo1xLWTJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Wang Long <wanglong19@meituan.com>,
        Jiang Ying <jiangying8582@126.com>
Subject: [PATCH 4.9 050/212] ext4: fix direct I/O read error
Date:   Thu, 20 Aug 2020 11:20:23 +0200
Message-Id: <20200820091604.894804916@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiang Ying <jiangying8582@126.com>

This patch is used to fix ext4 direct I/O read error when
the read size is not aligned with block size.

Then, I will use a test to explain the error.

(1) Make a file that is not aligned with block size:
	$dd if=/dev/zero of=./test.jar bs=1000 count=3

(2) I wrote a source file named "direct_io_read_file.c" as following:

	#include <stdio.h>
	#include <stdlib.h>
	#include <unistd.h>
	#include <sys/file.h>
	#include <sys/types.h>
	#include <sys/stat.h>
	#include <string.h>
	#define BUF_SIZE 1024

	int main()
	{
		int fd;
		int ret;

		unsigned char *buf;
		ret = posix_memalign((void **)&buf, 512, BUF_SIZE);
		if (ret) {
			perror("posix_memalign failed");
			exit(1);
		}
		fd = open("./test.jar", O_RDONLY | O_DIRECT, 0755);
		if (fd < 0){
			perror("open ./test.jar failed");
			exit(1);
		}

		do {
			ret = read(fd, buf, BUF_SIZE);
			printf("ret=%d\n",ret);
			if (ret < 0) {
				perror("write test.jar failed");
			}
		} while (ret > 0);

		free(buf);
		close(fd);
	}

(3) Compile the source file:
	$gcc direct_io_read_file.c -D_GNU_SOURCE

(4) Run the test program:
	$./a.out

	The result is as following:
	ret=1024
	ret=1024
	ret=952
	ret=-1
	write test.jar failed: Invalid argument.

I have tested this program on XFS filesystem, XFS does not have
this problem, because XFS use iomap_dio_rw() to do direct I/O
read. And the comparing between read offset and file size is done
in iomap_dio_rw(), the code is as following:

	if (pos < size) {
		retval = filemap_write_and_wait_range(mapping, pos,
				pos + iov_length(iov, nr_segs) - 1);

		if (!retval) {
			retval = mapping->a_ops->direct_IO(READ, iocb,
						iov, pos, nr_segs);
		}
		...
	}

...only when "pos < size", direct I/O can be done, or 0 will be return.

I have tested the fix patch on Ext4, it is up to the mustard of
EINVAL in man2(read) as following:
	#include <unistd.h>
	ssize_t read(int fd, void *buf, size_t count);

	EINVAL
		fd is attached to an object which is unsuitable for reading;
		or the file was opened with the O_DIRECT flag, and either the
		address specified in buf, the value specified in count, or the
		current file offset is not suitably aligned.

So I think this patch can be applied to fix ext4 direct I/O error.

However Ext4 introduces direct I/O read using iomap infrastructure
on kernel 5.5, the patch is commit <b1b4705d54ab>
("ext4: introduce direct I/O read using iomap infrastructure"),
then Ext4 will be the same as XFS, they all use iomap_dio_rw() to do direct
I/O read. So this problem does not exist on kernel 5.5 for Ext4.

>From above description, we can see this problem exists on all the kernel
versions between kernel 3.14 and kernel 5.4. It will cause the Applications
to fail to read. For example, when the search service downloads a new full
index file, the search engine is loading the previous index file and is
processing the search request, it can not use buffer io that may squeeze
the previous index file in use from pagecache, so the serch service must
use direct I/O read.

Please apply this patch on these kernel versions, or please use the method
on kernel 5.5 to fix this problem.

Fixes: 9fe55eea7e4b ("Fix race when checking i_size on direct i/o read")
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Wang Long <wanglong19@meituan.com>
Signed-off-by: Jiang Ying <jiangying8582@126.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3575,6 +3575,11 @@ static ssize_t ext4_direct_IO_read(struc
 	struct address_space *mapping = iocb->ki_filp->f_mapping;
 	struct inode *inode = mapping->host;
 	ssize_t ret;
+	loff_t offset = iocb->ki_pos;
+	loff_t size = i_size_read(inode);
+
+	if (offset >= size)
+		return 0;
 
 	/*
 	 * Shared inode_lock is enough for us - it protects against concurrent


