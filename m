Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8289B55193D
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 14:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238541AbiFTMre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237161AbiFTMre (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:47:34 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6B9120A4;
        Mon, 20 Jun 2022 05:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=1Qtj9avAPxxxcxlS9R24X+qIn7gqwbxWq3fY/ZtZ/r0=; b=QlKX47fxikFPWZhUCHG1+dih53
        +IQ1EPYovRtFDHyFK51GCH+/ADR1j/xK2zZVc+lRnViEosZ0+hVbFHjGr4epb/e4IQ/A/XD5qyi3P
        31JWYdCVF4pvM2OuUhiXPrmrdCjBREULJaYQM2JBlmxCuCEbi9quzpa0GlYPiOqRreh5mfYExqNF0
        PzKsF6VDKUiS3lmP9uncFN+a4GujEfno7m6R0wUc/C+aaEwnWd0Ux1O+8sY8RWHa8jTPhU9fYNUDT
        FX3dwzudZySs8lZAOPgW7hdh7NZ3ChRSRbJ9JHVq6u7owMgK5Hz8USfRRX90/HxHxxRm/ZZz08xjL
        /IemGjqeXVnfxarAMwvNlSX0lg2t43yaJ7KweIKPytdqLxHiCkUlq/jnDrIGQyd/NKm+27yH4bJIO
        nEJDTkAei3fYeuZSl58CImb6ArNRPexjSn49WxS1pIWQIvahpU3DYdahmLVcLpgNBs4M6Vu5PW175
        WR89O7dvixywSsXXcmgTE/4Q4fYWz+b+rMJzYr7YMzyTKa9YqxeWl2oKi6l6Y5ZBtDtCyBA9FQt22
        ftZMJ3LeBzedMjOwbp6PhqBpBMzj7FlWKH5NqMRP0vNi67Z/muNBZovTLZuGl9cujvClzVuLlzosY
        GrF4WyrvZ3iSKfEoMklGnypWIV/lcL+y5rcF8+5E4=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        David Howells <dhowells@redhat.com>, stable@vger.kernel.org
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] 9p: fix EBADF errors in cached mode
Date:   Mon, 20 Jun 2022 14:47:24 +0200
Message-ID: <1902408.H94Nh90b8Q@silver>
In-Reply-To: <20220616211025.1790171-1-asmadeus@codewreck.org>
References: <15767273.MGizftpLG7@silver>
 <20220616211025.1790171-1-asmadeus@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Donnerstag, 16. Juni 2022 23:10:25 CEST Dominique Martinet wrote:
> cached operations sometimes need to do invalid operations (e.g. read
> on a write only file)
> Historic fscache had added a "writeback fid", a special handle opened
> RW as root, for this. The conversion to new fscache missed that bit.
> 
> This commit reinstates a slightly lesser variant of the original code
> that uses the writeback fid for partial pages backfills if the regular
> user fid had been open as WRONLY, and thus would lack read permissions.
> 
> Link:
> https://lkml.kernel.org/r/20220614033802.1606738-1-asmadeus@codewreck.org
> Fixes: eb497943fa21 ("9p: Convert to using the netfs helper lib to do reads
> and caching") Cc: stable@vger.kernel.org
> Cc: David Howells <dhowells@redhat.com>
> Reported-By: Christian Schoenebeck <linux_oss@crudebyte.com>
> Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
> Tested-by: Christian Schoenebeck <linux_oss@crudebyte.com>
> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> ---
> v3: use the least permissive version of the patch that only uses
> writeback fid when really required
> 
> If no problem shows up by then I'll post this patch around Wed 23 (next
> week) with the other stable fixes.
> 
>  fs/9p/vfs_addr.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
> index a8f512b44a85..d0833fa69faf 100644
> --- a/fs/9p/vfs_addr.c
> +++ b/fs/9p/vfs_addr.c
> @@ -58,8 +58,21 @@ static void v9fs_issue_read(struct netfs_io_subrequest
> *subreq) */
>  static int v9fs_init_request(struct netfs_io_request *rreq, struct file
> *file) {
> +	struct inode *inode = file_inode(file);
> +	struct v9fs_inode *v9inode = V9FS_I(inode);
>  	struct p9_fid *fid = file->private_data;
> 
> +	BUG_ON(!fid);
> +
> +	/* we might need to read from a fid that was opened write-only
> +	 * for read-modify-write of page cache, use the writeback fid
> +	 * for that */
> +	if (rreq->origin == NETFS_READ_FOR_WRITE &&
> +			(fid->mode & O_ACCMODE) == O_WRONLY) {
> +		fid = v9inode->writeback_fid;
> +		BUG_ON(!fid);
> +	}
> +
>  	refcount_inc(&fid->count);
>  	rreq->netfs_priv = fid;
>  	return 0;

Some more tests this weekend; all looks fine. It appears that this also fixed
the performance degradation that I reported early in this thread. Again,
benchmarks compiling a bunch of sources:

Case  Linux kernel version         msize   cache  duration (average)

A)    EBADF fix only [1]           512000  loose  31m 14s
B)    EBADF fix only [1]           512000  mmap   44m 1s
C)    EBADF fix + clunk fixes [2]  512000  loose  29m 32s
D)    EBADF fix + clunk fixes [2]  512000  mmap   44m 0s
E)    5.10.84                      512000  loose  35m 5s
F)    5.10.84                      512000  mmap   65m 5s

[1] 5.19.0-rc2 + EBADF fix v3 patch (alone):
https://lore.kernel.org/lkml/20220616211025.1790171-1-asmadeus@codewreck.org/

[2] 5.19.0-rc2 + EBADF fix v3 patch + clunk fix patches, a.k.a. 9p-next:
https://github.com/martinetd/linux/commit/b0017602fdf6bd3f344dd49eaee8b6ffeed6dbac

Conclusion: all thumbs in my possession pointing upwards. :)

Thanks Dominique!

Best regards,
Christian Schoenebeck


