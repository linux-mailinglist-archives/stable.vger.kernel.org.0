Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71891154361
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 12:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbgBFLqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 06:46:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:36786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726538AbgBFLqa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 06:46:30 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6A9321741;
        Thu,  6 Feb 2020 11:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580989589;
        bh=6GUHZBcWcsn4ojh9JNJ8oG/rmTYEQXxR7VWpZUWgw7c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CUjOOdSilh7/I/uqGXI/mKxCf9U4WLq1ZWq4tbu5VxIzBDnk+ag6BZ+CEOvQWM5MN
         GY7HnI0tNAmVFV9BE7KFYu5GgwE/2evTXIgZgnqhbDwW0eTQrI91HnAhdP1+vh5Zcd
         fah4YX92ml1JOzq05PdtXP9WWEQjgeeR30L+RZQQ=
Message-ID: <fceaee0128a0c81991df6e3531e746e4ebbe5a01.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: fix copy_file_range error path in short copies
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>, Gregory Farnum <gfarnum@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Thu, 06 Feb 2020 06:46:27 -0500
In-Reply-To: <20200206103842.14936-1-lhenriques@suse.com>
References: <20200205192414.GA27345@suse.com>
         <20200206103842.14936-1-lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-02-06 at 10:38 +0000, Luis Henriques wrote:
> When there's an error in the copying loop but some bytes have already been
> copied into the destination file, it is necessary to dirty the caps and
> eventually update the MDS with the file metadata (timestamps, size).  This
> patch fixes this error path.
> 
> Another issue this patch fixes is the destination file size being reported
> to the MDS.  If we're on the error path but the amount of bytes written
> has already changed the destination file size, the offset to use is
> dst_off and not endoff.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> ---
>  fs/ceph/file.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 11929d2bb594..f7f8cb6c243f 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -2104,9 +2104,16 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>  			CEPH_OSD_OP_FLAG_FADVISE_DONTNEED, 0);
>  		if (err) {
>  			dout("ceph_osdc_copy_from returned %d\n", err);
> -			if (!ret)
> +			/*
> +			 * If we haven't done any copy yet, just exit with the
> +			 * error code; otherwise, return the number of bytes
> +			 * already copied, update metadata and dirty caps.
> +			 */
> +			if (!ret) {
>  				ret = err;
> -			goto out_caps;
> +				goto out_caps;
> +			}
> +			goto update_dst_inode;
>  		}
>  		len -= object_size;
>  		src_off += object_size;
> @@ -2118,16 +2125,17 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>  		/* We still need one final local copy */
>  		do_final_copy = true;
>  
> +update_dst_inode:
>  	file_update_time(dst_file);
>  	inode_inc_iversion_raw(dst_inode);
>  
> -	if (endoff > size) {
> +	if (dst_off > size) {
>  		int caps_flags = 0;
>  
>  		/* Let the MDS know about dst file size change */
> -		if (ceph_quota_is_max_bytes_approaching(dst_inode, endoff))
> +		if (ceph_quota_is_max_bytes_approaching(dst_inode, dst_off))
>  			caps_flags |= CHECK_CAPS_NODELAY;
> -		if (ceph_inode_set_size(dst_inode, endoff))
> +		if (ceph_inode_set_size(dst_inode, dst_off))
>  			caps_flags |= CHECK_CAPS_AUTHONLY;
>  		if (caps_flags)
>  			ceph_check_caps(dst_ci, caps_flags, NULL);

Looks good to me. Merged into ceph-client/testing. We'll see about
getting it in before 5.6 ships.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

