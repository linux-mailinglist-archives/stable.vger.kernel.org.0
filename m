Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53CB226F35
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 21:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbgGTTqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 15:46:55 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:37147 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgGTTqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 15:46:54 -0400
Received: by mail-pj1-f68.google.com with SMTP id o22so400816pjw.2;
        Mon, 20 Jul 2020 12:46:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hF8palGIv8TI4BXkf/MtnUqfeyrr+QIHoD4KLAnuRtA=;
        b=qCjsnq8D5S+vk7AM9FqOdjEC1RKQesIEdQyDaR1Zu7LngByLyR6Wg0h1IwtCjLQ6BR
         dTDchOhCSLSg3sY5Ar5/7l7RmmXh9pGtQnzk4WzYT+yn2jO/sJFGwB/j4t01iHhwNdu6
         TpourmnW5j334N+1JK7ScwR8x7DwPKREUsBWJpWBHcxCNIkLvTolzalTUXlfJUhh7C6F
         4tUialu2fPsTb908CkSzzIK0L/VEnSdZ49xA7mpMuv0yE2ZztwE+i4TOAPyNaXPsY/uE
         sCYGuRl15ANAnQ26RkZNVTGZQ9TXAsD1INl1ZixihSpdaJjfaQgFnuo0i4IfCapy+MBW
         aNaA==
X-Gm-Message-State: AOAM531sQulrtAxACvMgncEYU0/WOxDZJM4bE3ibrQXPyLcZpZZ7wsgs
        OkfuqbtfFpnIGwDJJL+YSJCCKVri
X-Google-Smtp-Source: ABdhPJxQ+Wt1oXs2Yt1z/f2sFOZ4lWJvrpfWgApnTaWJqLQpNjFxeO5byMOGFMOtE9bIim1Cgltyxg==
X-Received: by 2002:a17:902:7284:: with SMTP id d4mr18116121pll.164.1595274413951;
        Mon, 20 Jul 2020 12:46:53 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:81fd:84d6:3c38:f7ef? ([2601:647:4802:9070:81fd:84d6:3c38:f7ef])
        by smtp.gmail.com with ESMTPSA id f6sm18054206pfe.174.2020.07.20.12.46.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2020 12:46:53 -0700 (PDT)
Subject: Re: [PATCH v2] nvme-tcp: don't use sendpage for pages not taking
 reference counter
To:     Coly Li <colyli@suse.de>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        hch@lst.de
Cc:     Jens Axboe <axboe@kernel.dk>, Vlastimil Babka <vbabka@suse.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Jan Kara <jack@suse.com>,
        Mikhail Skorzhinskii <mskorzhinskiy@solarflare.com>
References: <20200713124444.19640-1-colyli@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <75efd1ba-284d-f5b0-faeb-ca8cefd673c0@grimberg.me>
Date:   Mon, 20 Jul 2020 12:46:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200713124444.19640-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/13/20 5:44 AM, Coly Li wrote:
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
> v2: fix typo in patch subject.
> v1: the initial version.
>   drivers/nvme/host/tcp.c | 13 +++++++++++--
>   1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
> index 79ef2b8e2b3c..faa71db7522a 100644
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
> +		if (unlikely(PageSlab(page) || page_count(page) < 1)) {

Can we unify these checks to a common sendpage_ok(page) ?
