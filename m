Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA92C22F687
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 19:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730685AbgG0RZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 13:25:33 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:36578 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgG0RZd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 13:25:33 -0400
Received: by mail-pj1-f67.google.com with SMTP id ha11so2631191pjb.1;
        Mon, 27 Jul 2020 10:25:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aNt663yDzifzzB0XK1Rn3vQdJUzIbPRGw9BRhlu+BgI=;
        b=VicB0PepQcwIzEF73B1eE8t73zu7gGSrVgXVDIhjZkiQqCee3/27vUFZLSX59pwPM+
         O2uzKLAe2RCZfZNIrNF0OlgaXzSJwI+6AyBos0HDPdSHY5UEVwsVtNLASQ2D1Jf/vFW0
         CQxpRcyN3g0cnd7qKORFS3mFynoFiR/NOMmc88eOWywJxGGzCmKM22RRBWDKBeF5V2YT
         /jRfRFLhmFW0isrKV/pXKC4VSoV0mTXBs+HhhJA9vy3Mnbs208h58wY0gyj7oRrbov7p
         ndGt93BtpTWmTFkzb0rBBDP89JgXWW+sRyKa9DOLOuYAaoJC8tb3EpZM5O9ww8lHcygC
         smCA==
X-Gm-Message-State: AOAM531jqvMDeX8wdfYrpyVfFZMoB3qTxgczOl2371aa7GDTFtY+GAKF
        QZcfXcGhHwzeNevzedNhLio7dFHI
X-Google-Smtp-Source: ABdhPJwUsW0OrmXzZI8dD+BwqaXmVKJG1zwM2eWYgiCDypR1jFOoZNeU280jcxCdzhCI8GCiXVaXyg==
X-Received: by 2002:a17:902:bc49:: with SMTP id t9mr9726393plz.20.1595870731350;
        Mon, 27 Jul 2020 10:25:31 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:5d7d:f206:b163:f30b? ([2601:647:4802:9070:5d7d:f206:b163:f30b])
        by smtp.gmail.com with ESMTPSA id k23sm15148773pgb.92.2020.07.27.10.25.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2020 10:25:30 -0700 (PDT)
Subject: Re: [PATCH 1/2] nvme-tcp: use sendpage_ok() to check page for
 kernel_sendpage()
To:     Coly Li <colyli@suse.de>, philipp.reisner@linbit.com,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        linux-bcache@vger.kernel.org, hch@lst.de
Cc:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Jan Kara <jack@suse.com>,
        Jens Axboe <axboe@kernel.dk>,
        Mikhail Skorzhinskii <mskorzhinskiy@solarflare.com>,
        Vlastimil Babka <vbabka@suse.com>, stable@vger.kernel.org
References: <20200726135224.107516-1-colyli@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <f6cf7563-9d8c-baa8-e8e7-e41f9b13e787@grimberg.me>
Date:   Mon, 27 Jul 2020 10:25:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200726135224.107516-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/26/20 6:52 AM, Coly Li wrote:
> Currently nvme_tcp_try_send_data() doesn't use kernel_sendpage() to
> send slab pages. But for pages allocated by __get_free_pages() without
> __GFP_COMP, which also have refcount as 0, they are still sent by
> kernel_sendpage() to remote end, this is problematic.
> 
> When bcache uses a remote NVMe SSD via nvme-over-tcp as its cache
> device, writing meta data e.g. cache_set->disk_buckets to remote SSD may
> trigger a kernel panic due to the above problem. Bcause the meta data
> pages for cache_set->disk_buckets are allocated by __get_free_pages()
> without __GFP_COMP.
> 
> This problem should be fixed both in upper layer driver (bcache) and
> nvme-over-tcp code. This patch fixes the nvme-over-tcp code by checking
> whether the page refcount is 0, if yes then don't use kernel_sendpage()
> and call sock_no_sendpage() to send the page into network stack.
> 
> Such check is done by macro sendpage_ok() in this patch, which is defined
> in include/linux/net.h as,
> 	(!PageSlab(page) && page_count(page) >= 1)
> If sendpage_ok() returns false, sock_no_sendpage() will handle the page
> other than kernel_sendpage().
> 
> The code comments in this patch is copied and modified from drbd where
> the similar problem already gets solved by Philipp Reisner. This is the
> best code comment including my own version.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Jan Kara <jack@suse.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Mikhail Skorzhinskii <mskorzhinskiy@solarflare.com>
> Cc: Philipp Reisner <philipp.reisner@linbit.com>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: Vlastimil Babka <vbabka@suse.com>
> Cc: stable@vger.kernel.org
> ---
> Changelog:
> v3: introduce a more common name sendpage_ok() for the open coded check
> v2: fix typo in patch subject.
> v1: the initial version.
> 
>   drivers/nvme/host/tcp.c | 13 +++++++++++--
>   include/linux/net.h     |  2 ++
>   2 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
> index 79ef2b8e2b3c..f9952f6d94b9 100644
> --- a/drivers/nvme/host/tcp.c
> +++ b/drivers/nvme/host/tcp.c
> @@ -887,8 +887,17 @@ static int nvme_tcp_try_send_data(struct nvme_tcp_request *req)
>   		else
>   			flags |= MSG_MORE | MSG_SENDPAGE_NOTLAST;
>   
> -		/* can't zcopy slab pages */
> -		if (unlikely(PageSlab(page))) {
> +		/*
> +		 * e.g. XFS meta- & log-data is in slab pages, or bcache meta
> +		 * data pages, or other high order pages allocated by
> +		 * __get_free_pages() without __GFP_COMP, which have a page_count
> +		 * of 0 and/or have PageSlab() set. We cannot use send_page for
> +		 * those, as that does get_page(); put_page(); and would cause
> +		 * either a VM_BUG directly, or __page_cache_release a page that
> +		 * would actually still be referenced by someone, leading to some
> +		 * obscure delayed Oops somewhere else.
> +		 */

I was hoping that this comment would move to the helper as well.

Agree with Christoph comment as well.
