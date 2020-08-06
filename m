Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD57123D92F
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 12:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbgHFKQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 06:16:21 -0400
Received: from m15112.mail.126.com ([220.181.15.112]:52946 "EHLO
        m15112.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729146AbgHFKQS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 06:16:18 -0400
X-Greylist: delayed 2058 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Aug 2020 06:16:14 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=luyhsBjuQ1lgUJ9+5g
        meLe6LuVmiVnknnb0rBb/Ua3k=; b=Z4kzREVNOFyelPCzOHVyCLqXwOlVEyqfuw
        tV/OdpR7ZZjMhtsJgM14RjtH4dacZjj8/sBCTDntM9m991JbDPIFnAxWwmFB1soB
        wM7bsKDUB9VcyhWYzdWbTVjzuLRHmIDlEfIrhadb2UG6sS7R7yim9MJOKqEGfoH3
        6kYususX8=
Received: from xr-hulk-k8s-node1933.gh.sankuai.com (unknown [101.236.11.3])
        by smtp2 (Coremail) with SMTP id DMmowAD3_OCDzytfxipQGA--.39882S2;
        Thu, 06 Aug 2020 17:38:17 +0800 (CST)
From:   Jiang Ying <jiangying8582@126.com>
To:     tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        jack@suse.cz, stable@vger.kernel.org
Cc:     wanglong19@meituan.com, heguanjun@meituan.com
Subject: [PATCH v5] ext4: fix direct I/O read error for kernel stable rc4.4
Date:   Thu,  6 Aug 2020 17:38:11 +0800
Message-Id: <1596706691-82760-1-git-send-email-jiangying8582@126.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: DMmowAD3_OCDzytfxipQGA--.39882S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAw47WFW8tw4rCr1UZr4xZwb_yoWrCF4xpr
        sxC3W5WrZYvr4xCanrG3WDuFyFyayDGFWUXF9Y934UZw45Kr95KrWIkF1UGayUJrZY9w4Y
        qFWqyryfJw1UZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jaFAJUUUUU=
X-Originating-IP: [101.236.11.3]
X-CM-SenderInfo: xmld0wp1lqwmqvysqiyswou0bp/1tbimgl4AFpEAtuHOQAAsS
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
Reviewed-by: Wang Long <wanglong19@meituan.com>
Signed-off-by: Jiang Ying <jiangying8582@126.com>

Changes since V4:
	Fix build error on kernel stable rc 4.4.
	This patch only for kernel 4.4.

Changes since V3:
	Add the info: this bug could break some application that use the
	stable kernel releases.

Changes since V2:
	Optimize the description of the commit message and make a variation for
	the patch, e.g. with:

		Before:
			loff_t size;
			size = i_size_read(inode);
		After:
			loff_t size = i_size_read(inode);

Changes since V1:
	Signed-off use real name and add "Fixes:" flag

---
 fs/ext4/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8e79970..8816016 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3353,6 +3353,13 @@ static ssize_t ext4_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
+	if (iov_iter_rw(iter) == READ) {
+		loff_t size = i_size_read(inode);
+
+		if (offset >= size)
+			return 0;
+	}
+
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
 	if (ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode))
 		return 0;
-- 
1.8.3.1

