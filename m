Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64BFB3656C
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 22:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbfFEUZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 16:25:03 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:37427 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726464AbfFEUZD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 16:25:03 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04446;MF=bo.liu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0TTW4sPz_1559766298;
Received: from US-160370MP2.local(mailfrom:bo.liu@linux.alibaba.com fp:SMTPD_---0TTW4sPz_1559766298)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 06 Jun 2019 04:25:00 +0800
Date:   Wed, 5 Jun 2019 13:24:57 -0700
From:   Liu Bo <bo.liu@linux.alibaba.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.4 23/56] fuse: honor RLIMIT_FSIZE in
 fuse_file_fallocate
Message-ID: <20190605202456.2emhy5t26c7mg4f2@US-160370MP2.local>
Reply-To: bo.liu@linux.alibaba.com
References: <20190601132600.27427-1-sashal@kernel.org>
 <20190601132600.27427-23-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190601132600.27427-23-sashal@kernel.org>
User-Agent: NeoMutt/20180323
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 01, 2019 at 09:25:27AM -0400, Sasha Levin wrote:
> From: Liu Bo <bo.liu@linux.alibaba.com>
> 
> [ Upstream commit 0cbade024ba501313da3b7e5dd2a188a6bc491b5 ]
> 
> fstests generic/228 reported this failure that fuse fallocate does not
> honor what 'ulimit -f' has set.
> 
> This adds the necessary inode_newsize_ok() check.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> Fixes: 05ba1f082300 ("fuse: add FALLOCATE operation")
> Cc: <stable@vger.kernel.org> # v3.5
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/fuse/file.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index d40c2451487cb..3ba45758e0938 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -2947,6 +2947,13 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
>  		}
>  	}
>  
> +	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
> +	    offset + length > i_size_read(inode)) {
> +		err = inode_newsize_ok(inode, offset + length);
> +		if (err)
> +			return err;

A later commit [1] was proposed to fix a problem of returning without unlock.

[1]: https://kernel.googlesource.com/pub/scm/linux/kernel/git/mszeredi/fuse/+/35d6fcbb7c3e296a52136347346a698a35af3fda

thanks,
-liubo

> +	}
> +
>  	if (!(mode & FALLOC_FL_KEEP_SIZE))
>  		set_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
>  
> -- 
> 2.20.1
