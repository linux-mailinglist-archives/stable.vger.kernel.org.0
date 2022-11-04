Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC3A619109
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 07:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbiKDGZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 02:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbiKDGZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 02:25:09 -0400
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112545FE1;
        Thu,  3 Nov 2022 23:25:05 -0700 (PDT)
Received: by mail-wr1-f43.google.com with SMTP id cl5so5669796wrb.9;
        Thu, 03 Nov 2022 23:25:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LWHoRHPkqrmeG+hiuWGL48/5B+q3CyL5rXd2G/yB4LY=;
        b=VmlFUlviMj6ZSFTqh7FIgoUeBYpqGRrXz89wX9BtaHGygyz37trWlwsaf/fohR1Wq/
         0tUoFELkeaN246ZVdxZXMv6LW9LsnqPz2k2y1h+0birXtoT9PM+TKcdZGN6IEantCPTR
         8d99asytO2gGmYIHd5QtTiOc7euvWvCuE+6urZlkuShTy7TYhntz0AY15/vI76lRyq6l
         1bD5kGlYmP4IenmVnvkLHnT13z9WR0Cl0kZ+8XKRlgm9hOgxWr36FSArz/BqbfnBnIp3
         SCukdlZ37v6tYZu+y0U4xvorUpxsjn0rozk816eaSKpn3muucxkoq01tVp69VyUFnnTw
         Le1Q==
X-Gm-Message-State: ACrzQf0wX9VM53i05Wg/MNppMkYxkWVKqeYbNlzl76d4l4aGHv5pnkI+
        4b3vLYrZMLqUsBmhOo11/UA=
X-Google-Smtp-Source: AMsMyM6ELLkCViZP9S+BjozkioNNxKU3qVKRVolbwfydrl3pvkISKZMDfTo6ZWGhIp/e9Qdqhk2BrA==
X-Received: by 2002:a5d:5a99:0:b0:236:7751:4e43 with SMTP id bp25-20020a5d5a99000000b0023677514e43mr20846137wrb.241.1667543103424;
        Thu, 03 Nov 2022 23:25:03 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id n35-20020a05600c502300b003c6b874a0dfsm2411233wmr.14.2022.11.03.23.25.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 23:25:02 -0700 (PDT)
Message-ID: <90de2e70-1802-b26b-798e-74421389180e@kernel.org>
Date:   Fri, 4 Nov 2022 07:25:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v2 2/2] PM: hibernate: add check of preallocate mem for
 image size pages
Content-Language: en-US
To:     TGSP <tgsp002@gmail.com>, rafael@kernel.org, len.brown@intel.com,
        pavel@ucw.cz, huanglei@kylinos.cn
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiongxin <xiongxin@kylinos.cn>, stable@vger.kernel.org
References: <20221104054119.1946073-1-tgsp002@gmail.com>
 <20221104054119.1946073-3-tgsp002@gmail.com>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20221104054119.1946073-3-tgsp002@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04. 11. 22, 6:41, TGSP wrote:
> From: xiongxin <xiongxin@kylinos.cn>
> 
> Added a check on the return value of preallocate_image_highmem(). If
> memory preallocate is insufficient, S4 cannot be done;
> 
> I am playing 4K video on a machine with AMD or other graphics card and
> only 8GiB memory, and the kernel is not configured with CONFIG_HIGHMEM.
> When doing the S4 test, the analysis found that when the pages get from
> minimum_image_size() is large enough, The preallocate_image_memory() and
> preallocate_image_highmem() calls failed to obtain enough memory. Add
> the judgment that memory preallocate is insufficient;
> 
> The detailed debugging data is as follows:
> 
> image_size: 3225923584, totalram_pages: 1968948 in
> hibernate_reserved_size_init();
> 
> in hibernate_preallocate_memory():
> code pages = minimum_image_size(saveable) = 717992, at this time(line):
> count: 2030858
> avail_normal: 2053753
> highmem: 0
> totalreserve_pages: 22895
> max_size: 1013336
> size: 787579
> saveable: 1819905
> 
> When the code executes to:
> pages = preallocate_image_memory(alloc, avail_normal), at that
> time(line):
> pages_highmem: 0
> avail_normal: 1335761
> alloc: 1017522
> pages: 1017522
> 
> So enter the else branch judged by (pages < alloc), When executed to
> size = preallocate_image_memory(alloc, avail_normal):
> alloc = max_size - size = 225757;
> size = preallocate_image_memory(alloc, avail_normal) = 168671, That is,
> preallocate_image_memory() does not apply for all alloc memory pages,
> because highmem is not enabled, and size_highmem will return 0 here, so
> there is a memory page that has not been preallocated, so I think a
> judgment needs to be added here.
> 
> But what I can't understand is that although pages are not preallocated
> enough, "pages -= free_unnecessary_pages()" in the code below can also
> discard some pages that have been preallocated, so I am not sure whether
> it is appropriate to add a judgment here.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: xiongxin <xiongxin@kylinos.cn>
> Signed-off-by: huanglei <huanglei@kylinos.cn>
> ---
>   kernel/power/snapshot.c | 11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
> index c20ca5fb9adc..546d544cf7de 100644
> --- a/kernel/power/snapshot.c
> +++ b/kernel/power/snapshot.c
> @@ -1854,6 +1854,8 @@ int hibernate_preallocate_memory(void)
>   		alloc = (count - pages) - size;
>   		pages += preallocate_image_highmem(alloc);
>   	} else {
> +		unsigned long size_highmem = 0;

This needs not be initialized, right?

> @@ -1863,8 +1865,13 @@ int hibernate_preallocate_memory(void)
>   		pages_highmem += size;
>   		alloc -= size;
>   		size = preallocate_image_memory(alloc, avail_normal);
> -		pages_highmem += preallocate_image_highmem(alloc - size);
> -		pages += pages_highmem + size;
> +		size_highmem = preallocate_image_highmem(alloc - size);
> +		if (size_highmem < (alloc - size)) {
> +			pr_err("Image allocation is %lu pages short, exit\n",
> +				alloc - size - pages_highmem);
> +			goto err_out;
> +		}
> +		pages += pages_highmem + size_highmem + size;
>   	}
>   
>   	/*

-- 
js
suse labs

