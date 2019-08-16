Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA91D8F982
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 05:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfHPDlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 23:41:15 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46153 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbfHPDlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Aug 2019 23:41:15 -0400
Received: by mail-pf1-f195.google.com with SMTP id q139so2375020pfc.13;
        Thu, 15 Aug 2019 20:41:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d1MgiyMIUytxSAsHS5KMLRsMEm7jWjLG7XrFozd18So=;
        b=OIZqjf2jenohAW0u5c1mmR4x1zRm4xoG5TeWF2XLgrVQbzt893jT0+Bp4v1ULt6x36
         XgYlFKL0QXQ28+UInBwpdtO+lWLWwlsmR3Kn3qmT1+mnVIIFOefFzGsOuMxL9amqBNB3
         jE+nXAgt0j8VdQKcDoO+OGsx5IjDny2Y44yGpeH9D3RmL2pSDsZ11rQbCRNmZhzFU+LF
         27ciK6gv0UhDUoAAvmScXLIIO6NBf7AxnWoBwSd1AC+pth9NZCF2Mtuw60Kxez8gi+jd
         EHU4ifK99p3QyTmAg1XOd/JSQGWRyXhToxoM6WuV0GX51St0jECLDBHBRPkiqrByBDSx
         jqIg==
X-Gm-Message-State: APjAAAVTln2DWclpyyEu/MlPbyDRi62Q9+NrJJF+VhfUdO9r621bsnpj
        sD/FEb+c2UUSbhHCi3qRkH4=
X-Google-Smtp-Source: APXvYqyoNqbegaijSQPuIVnjHyu2L+RaH7swFZofy+xyZDjAMYWCyatuNhdQnj6rSbGsLWbOqxrtLw==
X-Received: by 2002:aa7:8b10:: with SMTP id f16mr8901352pfd.44.1565926874757;
        Thu, 15 Aug 2019 20:41:14 -0700 (PDT)
Received: from asus.site (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id ce20sm3299042pjb.16.2019.08.15.20.41.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2019 20:41:13 -0700 (PDT)
Subject: Re: [PATCH V2] blk-mq: avoid sysfs buffer overflow by too many CPU
 cores
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, stable@vger.kernel.org,
        Mark Ray <mark.ray@hpe.com>,
        Greg KH <gregkh@linuxfoundation.org>
References: <20190816025417.28964-1-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <effdfa46-880f-2d05-19be-8af4f451b8f4@acm.org>
Date:   Thu, 15 Aug 2019 20:39:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190816025417.28964-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/15/19 7:54 PM, Ming Lei wrote:
> It is reported that sysfs buffer overflow can be triggered in case
> of too many CPU cores(>841 on 4K PAGE_SIZE) when showing CPUs in
> blk_mq_hw_sysfs_cpus_show().
> 
> So use cpumap_print_to_pagebuf() to print the info and fix the potential
> buffer overflow issue.
> 
> Cc: stable@vger.kernel.org
> Cc: Mark Ray <mark.ray@hpe.com>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Fixes: 676141e48af7("blk-mq: don't dump CPU -> hw queue map on driver load")
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   block/blk-mq-sysfs.c | 15 +--------------
>   1 file changed, 1 insertion(+), 14 deletions(-)
> 
> diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
> index d6e1a9bd7131..4d0d32377ba3 100644
> --- a/block/blk-mq-sysfs.c
> +++ b/block/blk-mq-sysfs.c
> @@ -166,20 +166,7 @@ static ssize_t blk_mq_hw_sysfs_nr_reserved_tags_show(struct blk_mq_hw_ctx *hctx,
>   
>   static ssize_t blk_mq_hw_sysfs_cpus_show(struct blk_mq_hw_ctx *hctx, char *page)
>   {
> -	unsigned int i, first = 1;
> -	ssize_t ret = 0;
> -
> -	for_each_cpu(i, hctx->cpumask) {
> -		if (first)
> -			ret += sprintf(ret + page, "%u", i);
> -		else
> -			ret += sprintf(ret + page, ", %u", i);
> -
> -		first = 0;
> -	}
> -
> -	ret += sprintf(ret + page, "\n");
> -	return ret;
> +	return cpumap_print_to_pagebuf(true, page, hctx->cpumask);
>   }
>   
>   static struct blk_mq_hw_ctx_sysfs_entry blk_mq_hw_sysfs_nr_tags = {

Although this patch looks fine to me, shouldn't this attribute be 
documented under Documentation/ABI/?

Thanks,

Bart.


