Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172CB333696
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 08:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhCJHr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 02:47:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:56338 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231208AbhCJHry (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 02:47:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C7605AD87;
        Wed, 10 Mar 2021 07:47:52 +0000 (UTC)
Subject: Re: [PATCH] media: videobuf2: Fix integer overrun in vb2_mmap
To:     Ricardo Ribalda <ribalda@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        stable@vger.kernel.org
References: <20210310074028.1042475-1-ribalda@chromium.org>
From:   Jiri Slaby <jslaby@suse.cz>
Message-ID: <48e8ffd7-7f42-8e22-bf9d-646d9bd89bd9@suse.cz>
Date:   Wed, 10 Mar 2021 08:47:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210310074028.1042475-1-ribalda@chromium.org>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10. 03. 21, 8:40, Ricardo Ribalda wrote:
> The plane_length is an unsigned integer. So, if we have a size of
> 0xffffffff bytes we incorrectly allocate 0 bytes instead of 1 << 32.
> 
> Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: stable@vger.kernel.org
> Fixes: 7f8414594e47 ("[media] media: videobuf2: fix the length check for mmap")
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> ---
>   drivers/media/common/videobuf2/videobuf2-core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index 543da515c761..876db5886867 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -2256,7 +2256,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
>   	 * The buffer length was page_aligned at __vb2_buf_mem_alloc(),
>   	 * so, we need to do the same here.
>   	 */
> -	length = PAGE_ALIGN(vb->planes[plane].length);
> +	length = PAGE_ALIGN((unsigned int)vb->planes[plane].length);

Hi,

I fail to see how case from uint to uint helps -- IOW, did you mean ulong?

regards,
-- 
js
suse labs
