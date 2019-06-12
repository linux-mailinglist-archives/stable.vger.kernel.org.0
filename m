Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB4A4201D
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 10:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfFLI5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 04:57:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:51982 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726286AbfFLI5i (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jun 2019 04:57:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0BB60AF49;
        Wed, 12 Jun 2019 08:57:37 +0000 (UTC)
Subject: Re: [PATCH v2 1/3] fs/fuse, splice_write: Don't access pipe->buffers
 without pipe_lock()
To:     Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <CAJfpegvAAQTAjxLcQLefvFOQDJ6ug_G8Jggt=UZci+YnNP741A@mail.gmail.com>
 <20180717160035.9422-1-aryabinin@virtuozzo.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <b7aceb99-9631-cbcf-fdec-3abef72c949d@suse.cz>
Date:   Wed, 12 Jun 2019 10:57:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20180717160035.9422-1-aryabinin@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/17/18 6:00 PM, Andrey Ryabinin wrote:
> fuse_dev_splice_write() reads pipe->buffers to determine the size of
> 'bufs' array before taking the pipe_lock(). This is not safe as
> another thread might change the 'pipe->buffers' between the allocation
> and taking the pipe_lock(). So we end up with too small 'bufs' array.
> 
> Move the bufs allocations inside pipe_lock()/pipe_unlock() to fix this.
> 
> Fixes: dd3bb14f44a6 ("fuse: support splice() writing to fuse device")
> Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Cc: <stable@vger.kernel.org>

BTW, why don't we need to do the same in fuse_dev_splice_read()?

Thanks,
Vlastimil

> ---
>  fs/fuse/dev.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index c6b88fa85e2e..702592cce546 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -1944,12 +1944,15 @@ static ssize_t fuse_dev_splice_write(struct pipe_inode_info *pipe,
>  	if (!fud)
>  		return -EPERM;
>  
> +	pipe_lock(pipe);
> +
>  	bufs = kmalloc_array(pipe->buffers, sizeof(struct pipe_buffer),
>  			     GFP_KERNEL);
> -	if (!bufs)
> +	if (!bufs) {
> +		pipe_unlock(pipe);
>  		return -ENOMEM;
> +	}
>  
> -	pipe_lock(pipe);
>  	nbuf = 0;
>  	rem = 0;
>  	for (idx = 0; idx < pipe->nrbufs && rem < len; idx++)
> 

