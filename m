Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318E323C70C
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 09:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgHEHii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 03:38:38 -0400
Received: from mail-m964.mail.126.com ([123.126.96.4]:36342 "EHLO
        mail-m964.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbgHEHih (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 03:38:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=DOCU5HntHDoMHJxp9H
        qyRoF18SUiP/lo+VubNRBp8Xc=; b=Nu3by3850DqlQbsM3JfwhbaoDTs0M517vu
        whCR84Wi2xa5Y/WCxKT357WDAgJTi23qTs4myC80qOJ/jdI9EPm/FTicIRTuMl8X
        UgUh2WJiYss5aLqjZxzZHivHVJ623yEkrAs8V/KYR5C3L4fdraTg/bGzSYp/3OwZ
        XBuxuJOHI=
Received: from xr-hulk-k8s-node1933.gh.sankuai.com (unknown [101.236.11.3])
        by smtp9 (Coremail) with SMTP id NeRpCgDn7y+xYSpfzH34Ew--.23S2;
        Wed, 05 Aug 2020 15:37:31 +0800 (CST)
From:   Jiang Ying <jiangying8582@126.com>
To:     tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     wanglong19@meituan.com, heguanjun@meituan.com
Subject: [PATCH] ext4: fix direct I/O read error
Date:   Wed,  5 Aug 2020 15:37:21 +0800
Message-Id: <1596613041-173057-1-git-send-email-jiangying8582@126.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: NeRpCgDn7y+xYSpfzH34Ew--.23S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAw47WFW8tw4rCr1UZr4xZwb_yoWrXr4rpF
        sxCa15WrWkZr4rCanFk3W7Za4Fy3yDGFWUXF98uw1UZr43Kr9YyrW8KF1UGayUGrWF9w4F
        qFZ8tryfXw1UZFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UEfOcUUUUU=
X-Originating-IP: [101.236.11.3]
X-CM-SenderInfo: xmld0wp1lqwmqvysqiyswou0bp/1tbi7xt3AFpD+oBi7wAAst
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

From above description, we can see this problem exists on all the kernel
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
Co-developed-by: Wang Long <wanglong19@meituan.com>
Signed-off-by: Wang Long <wanglong19@meituan.com>
Signed-off-by: Jiang Ying <jiangying8582@126.com>
---
 fs/ext4/inode.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 516faa2..a66b0ac 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3821,6 +3821,11 @@ static ssize_t ext4_direct_IO_read(struct kiocb *iocb, struct iov_iter *iter)
 	struct inode *inode = mapping->host;
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
+	loff_t offset = iocb->ki_pos;
+	loff_t size = i_size_read(inode);
+
+	if (offset >= size)
+		return 0;
 
 	/*
 	 * Shared inode_lock is enough for us - it protects against concurrent
-- 
1.8.3.1

