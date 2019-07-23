Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFB3A70F9E
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 05:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbfGWDJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 23:09:14 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36472 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387880AbfGWDIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 23:08:43 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so41501913wrs.3
        for <stable@vger.kernel.org>; Mon, 22 Jul 2019 20:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=plexistor-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2PtG4zp50XPwrR+6BzWVC0eSAfvVyl2TtA+I12FZ4Qs=;
        b=t088Puwr+O8xjDR0LPzH0uhmskUhFRDzq/e5yWqd9g4mTsJFSj1S8dO3Udg3AD+2dq
         577gq+lrNqf7sOUaIKlAIg68s6dMsyjSs0AyIDSOkpt5PhVWmunLgfW4eLp513Mlb1dz
         hAthKC5YrLG3+UsBNzzMEn66Vp8I84yf4OmLzUtLOIDsydvY/m2V9Y1SBBuZm56n/NjR
         3VI7f9unQ+ojYhFSe+nzZrMq0XIIGh1qqLtK6pZX2UPkTPmhyqD7TeoDZgVK21zQ6zVp
         kGifCWbuMNbOthtwiH4tiML3heQt5GgCfkR2Jfx9fgtIhwEbgVELVaS9zHJdqsUoWHgv
         +95g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2PtG4zp50XPwrR+6BzWVC0eSAfvVyl2TtA+I12FZ4Qs=;
        b=F2h7czqf/7307iLlgEE3bkxRzY45GwRIJ8raDpAnwDMTFbCcAnCYST8pIkJxXKSfuW
         yQDQ1I4qtzeo50fZPZNzGrNXR9XIjIbdftNjMNNyMA5ip+S81yQKX3Ec098ZjJFuCU/z
         6skI70wfhHLl+4BynT2R80Zxs458EgI40Z6MJoX0Tj1x21WYRMPHcZDKDX2QCkqXT81q
         RJzF18gAjSe5XAJHoXD37lbil4Yw3sDH4O4R9ONB3V9fFgxPCebr0fu5rcpUldRtolzn
         7Azw2FQr58OsdS4PupQ5I+5XhgM0UYctZKlahlKEbWUUeUd4Y2YPYP5DrDnh1nl2zPma
         4AUw==
X-Gm-Message-State: APjAAAWgdhXKkZOPtmmrmBVQJqyZhQhR22loE0zXm8DIxlbhiRrHLGxx
        cp6NBzMrJF1N0fJDvvkw9Khxw6sn
X-Google-Smtp-Source: APXvYqwNjbQQHEnQf9EO2BooRCjynSwNWlhbjrMQSdKfWJ6RSFiQMVrNJoUDRH/BuXrQurKluvxoFg==
X-Received: by 2002:adf:e941:: with SMTP id m1mr68919804wrn.279.1563851321164;
        Mon, 22 Jul 2019 20:08:41 -0700 (PDT)
Received: from [10.68.217.182] ([217.70.211.18])
        by smtp.googlemail.com with ESMTPSA id e6sm41743574wrw.23.2019.07.22.20.08.39
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 20:08:40 -0700 (PDT)
Subject: Re: [PATCH 1/3] mm: Handle MADV_WILLNEED through vfs_fadvise()
To:     Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
Cc:     linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        Amir Goldstein <amir73il@gmail.com>,
        Boaz Harrosh <boaz@plexistor.com>, stable@vger.kernel.org
References: <20190711140012.1671-1-jack@suse.cz>
 <20190711140012.1671-2-jack@suse.cz>
From:   Boaz Harrosh <boaz@plexistor.com>
Message-ID: <9da4596e-7de2-9ba1-0fc0-62bf83c39488@plexistor.com>
Date:   Tue, 23 Jul 2019 06:08:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190711140012.1671-2-jack@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/07/2019 17:00, Jan Kara wrote:
> Currently handling of MADV_WILLNEED hint calls directly into readahead
> code. Handle it by calling vfs_fadvise() instead so that filesystem can
> use its ->fadvise() callback to acquire necessary locks or otherwise
> prepare for the request.
> 
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> CC: stable@vger.kernel.org # Needed by "xfs: Fix stale data exposure
> 					when readahead races with hole punch"
> Signed-off-by: Jan Kara <jack@suse.cz>

I had a similar patch for my needs. But did not drop the mmap_sem when calling into
the FS. This one is much better.

Reviewed-by: Boaz Harrosh <boazh@netapp.com>

I tested this patch, Works perfect for my needs.

Thank you for this patch
Boaz

> ---
>  mm/madvise.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 628022e674a7..ae56d0ef337d 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -14,6 +14,7 @@
>  #include <linux/userfaultfd_k.h>
>  #include <linux/hugetlb.h>
>  #include <linux/falloc.h>
> +#include <linux/fadvise.h>
>  #include <linux/sched.h>
>  #include <linux/ksm.h>
>  #include <linux/fs.h>
> @@ -275,6 +276,7 @@ static long madvise_willneed(struct vm_area_struct *vma,
>  			     unsigned long start, unsigned long end)
>  {
>  	struct file *file = vma->vm_file;
> +	loff_t offset;
>  
>  	*prev = vma;
>  #ifdef CONFIG_SWAP
> @@ -298,12 +300,20 @@ static long madvise_willneed(struct vm_area_struct *vma,
>  		return 0;
>  	}
>  
> -	start = ((start - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
> -	if (end > vma->vm_end)
> -		end = vma->vm_end;
> -	end = ((end - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
> -
> -	force_page_cache_readahead(file->f_mapping, file, start, end - start);
> +	/*
> +	 * Filesystem's fadvise may need to take various locks.  We need to
> +	 * explicitly grab a reference because the vma (and hence the
> +	 * vma's reference to the file) can go away as soon as we drop
> +	 * mmap_sem.
> +	 */
> +	*prev = NULL;	/* tell sys_madvise we drop mmap_sem */
> +	get_file(file);
> +	up_read(&current->mm->mmap_sem);
> +	offset = (loff_t)(start - vma->vm_start)
> +			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
> +	vfs_fadvise(file, offset, end - start, POSIX_FADV_WILLNEED);
> +	fput(file);
> +	down_read(&current->mm->mmap_sem);
>  	return 0;
>  }
>  
> 

