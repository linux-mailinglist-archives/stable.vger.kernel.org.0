Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702A823C82D
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 10:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgHEIvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 04:51:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:59056 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbgHEIvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 04:51:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 30D24AC12;
        Wed,  5 Aug 2020 08:51:24 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 066041E12CB; Wed,  5 Aug 2020 10:51:07 +0200 (CEST)
Date:   Wed, 5 Aug 2020 10:51:07 +0200
From:   Jan Kara <jack@suse.cz>
To:     stable@vger.kernel.org
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        wanglong19@meituan.com, heguanjun@meituan.com, jack@suse.cz,
        Jiang Ying <jiangying8582@126.com>
Subject: Re: [PATCH v4] ext4: fix direct I/O read error
Message-ID: <20200805085107.GC4117@quack2.suse.cz>
References: <1596614241-178185-1-git-send-email-jiangying8582@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596614241-178185-1-git-send-email-jiangying8582@126.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Note to stable tree maintainers (summary from the rather long changelog):
This is a non-upstream patch. It will not go upstream because the problem
there has been fixed by converting ext4 to use iomap infrastructure.
However that change is out of scope for stable kernels and this is a
minimal fix for the problem that has hit real-world applications so I think
it would be worth it to include the fix in stable trees. Thanks.

								Honza

On Wed 05-08-20 15:57:21, Jiang Ying wrote:
> This patch is used to fix ext4 direct I/O read error when
> the read size is not aligned with block size.
> 
> Then, I will use a test to explain the error.
> 
> (1) Make a file that is not aligned with block size:
> 	$dd if=/dev/zero of=./test.jar bs=1000 count=3
> 
> (2) I wrote a source file named "direct_io_read_file.c" as following:
> 
> 	#include <stdio.h>
> 	#include <stdlib.h>
> 	#include <unistd.h>
> 	#include <sys/file.h>
> 	#include <sys/types.h>
> 	#include <sys/stat.h>
> 	#include <string.h>
> 	#define BUF_SIZE 1024
> 
> 	int main()
> 	{
> 		int fd;
> 		int ret;
> 
> 		unsigned char *buf;
> 		ret = posix_memalign((void **)&buf, 512, BUF_SIZE);
> 		if (ret) {
> 			perror("posix_memalign failed");
> 			exit(1);
> 		}
> 		fd = open("./test.jar", O_RDONLY | O_DIRECT, 0755);
> 		if (fd < 0){
> 			perror("open ./test.jar failed");
> 			exit(1);
> 		}
> 
> 		do {
> 			ret = read(fd, buf, BUF_SIZE);
> 			printf("ret=%d\n",ret);
> 			if (ret < 0) {
> 				perror("write test.jar failed");
> 			}
> 		} while (ret > 0);
> 
> 		free(buf);
> 		close(fd);
> 	}
> 
> (3) Compile the source file:
> 	$gcc direct_io_read_file.c -D_GNU_SOURCE
> 
> (4) Run the test program:
> 	$./a.out
> 
> 	The result is as following:
> 	ret=1024
> 	ret=1024
> 	ret=952
> 	ret=-1
> 	write test.jar failed: Invalid argument.
> 
> I have tested this program on XFS filesystem, XFS does not have
> this problem, because XFS use iomap_dio_rw() to do direct I/O
> read. And the comparing between read offset and file size is done
> in iomap_dio_rw(), the code is as following:
> 
> 	if (pos < size) {
> 		retval = filemap_write_and_wait_range(mapping, pos,
> 				pos + iov_length(iov, nr_segs) - 1);
> 
> 		if (!retval) {
> 			retval = mapping->a_ops->direct_IO(READ, iocb,
> 						iov, pos, nr_segs);
> 		}
> 		...
> 	}
> 
> ...only when "pos < size", direct I/O can be done, or 0 will be return.
> 
> I have tested the fix patch on Ext4, it is up to the mustard of
> EINVAL in man2(read) as following:
> 	#include <unistd.h>
> 	ssize_t read(int fd, void *buf, size_t count);
> 
> 	EINVAL
> 		fd is attached to an object which is unsuitable for reading;
> 		or the file was opened with the O_DIRECT flag, and either the
> 		address specified in buf, the value specified in count, or the
> 		current file offset is not suitably aligned.
> 
> So I think this patch can be applied to fix ext4 direct I/O error.
> 
> However Ext4 introduces direct I/O read using iomap infrastructure
> on kernel 5.5, the patch is commit <b1b4705d54ab>
> ("ext4: introduce direct I/O read using iomap infrastructure"),
> then Ext4 will be the same as XFS, they all use iomap_dio_rw() to do direct
> I/O read. So this problem does not exist on kernel 5.5 for Ext4.
> 
> From above description, we can see this problem exists on all the kernel
> versions between kernel 3.14 and kernel 5.4. It will cause the Applications
> to fail to read. For example, when the search service downloads a new full
> index file, the search engine is loading the previous index file and is
> processing the search request, it can not use buffer io that may squeeze
> the previous index file in use from pagecache, so the serch service must
> use direct I/O read.
> 
> Please apply this patch on these kernel versions, or please use the method
> on kernel 5.5 to fix this problem.
> 
> Fixes: 9fe55eea7e4b ("Fix race when checking i_size on direct i/o read")
> Reviewed-by: Jan Kara <jack@suse.cz>
> Co-developed-by: Wang Long <wanglong19@meituan.com>
> Signed-off-by: Wang Long <wanglong19@meituan.com>
> Signed-off-by: Jiang Ying <jiangying8582@126.com>
> 
> Changes since V3:
> 	Add the info: this bug could break some application that use the
> 	stable kernel releases.
> 
> Changes since V2:
> 	Optimize the description of the commit message and make a variation for
> 	the patch, e.g. with:
> 
> 		Before:
> 			loff_t size;
> 			size = i_size_read(inode);
> 		After:
> 			loff_t size = i_size_read(inode);
> 
> Changes since V1:
> 	Signed-off use real name and add "Fixes:" flag
> 
> ---
>  fs/ext4/inode.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 516faa2..a66b0ac 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3821,6 +3821,11 @@ static ssize_t ext4_direct_IO_read(struct kiocb *iocb, struct iov_iter *iter)
>  	struct inode *inode = mapping->host;
>  	size_t count = iov_iter_count(iter);
>  	ssize_t ret;
> +	loff_t offset = iocb->ki_pos;
> +	loff_t size = i_size_read(inode);
> +
> +	if (offset >= size)
> +		return 0;
>  
>  	/*
>  	 * Shared inode_lock is enough for us - it protects against concurrent
> -- 
> 1.8.3.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
