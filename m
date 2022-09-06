Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC64B5AF232
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 19:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237321AbiIFROX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 13:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239766AbiIFRNq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 13:13:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F8498E46A;
        Tue,  6 Sep 2022 10:03:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 099F9615C4;
        Tue,  6 Sep 2022 17:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16118C433D6;
        Tue,  6 Sep 2022 17:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662483760;
        bh=jDqY++JBkfPhBn30KMlAemUpUkKo9QHIrqZMxv95CBE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xZl71PkmEDTHuH5uBDGlcvemDZfPv631zGaP8q+MLMSmiVmnLPJPQirop1O3qRKJe
         ipNrdnDK+X6r59RQgh5m6T20yDv7z+M/+TNKOHox4z6+JtbQIEh2VPeaGVKCyWXsc3
         wWkr2u4nKKmH/B9Ep8uDa3WAg0rQ7EyjlqX7GqhI=
Date:   Tue, 6 Sep 2022 19:02:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Phil Auld <pauld@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Barry Song <21cnbao@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        Yury Norov <yury.norov@gmail.com>,
        feng xiangjun <fengxj325@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] drivers/base: Fix unsigned comparison to -1 in
 CPUMAP_FILE_MAX_BYTES
Message-ID: <Yxd9LRH+3wkM0fot@kroah.com>
References: <20220906160430.1169837-1-pauld@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906160430.1169837-1-pauld@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 12:04:30PM -0400, Phil Auld wrote:
> As PAGE_SIZE is unsigned long, -1 > PAGE_SIZE when NR_CPUS <= 3.
> This leads to very large file sizes:
> 
> topology$ ls -l
> total 0
> -r--r--r-- 1 root root 18446744073709551615 Sep  5 11:59 core_cpus

Yeah, lots of CPUs!  :)

> -r--r--r-- 1 root root                 4096 Sep  5 11:59 core_cpus_list
> -r--r--r-- 1 root root                 4096 Sep  5 10:58 core_id
> -r--r--r-- 1 root root 18446744073709551615 Sep  5 10:10 core_siblings
> -r--r--r-- 1 root root                 4096 Sep  5 11:59 core_siblings_list
> -r--r--r-- 1 root root 18446744073709551615 Sep  5 11:59 die_cpus
> -r--r--r-- 1 root root                 4096 Sep  5 11:59 die_cpus_list
> -r--r--r-- 1 root root                 4096 Sep  5 11:59 die_id
> -r--r--r-- 1 root root 18446744073709551615 Sep  5 11:59 package_cpus
> -r--r--r-- 1 root root                 4096 Sep  5 11:59 package_cpus_list
> -r--r--r-- 1 root root                 4096 Sep  5 10:58 physical_package_id
> -r--r--r-- 1 root root 18446744073709551615 Sep  5 10:10 thread_siblings
> -r--r--r-- 1 root root                 4096 Sep  5 11:59 thread_siblings_list
> 
> Adjust the inequality to catch the case when NR_CPUS is configured
> to a small value.
> 
> Fixes: 7ee951acd31a ("drivers/base: fix userspace break from using bin_attributes for cpumap and cpulist")
> Reported-by: feng xiangjun <fengxj325@gmail.com>
> Signed-off-by: Phil Auld <pauld@redhat.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Yury Norov <yury.norov@gmail.com>
> Cc: stable@vger.kernel.org
> Cc: feng xiangjun <fengxj325@gmail.com>
> ---
>  include/linux/cpumask.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> index bd047864c7ac..7b1349612d6d 100644
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -1127,9 +1127,10 @@ cpumap_print_list_to_buf(char *buf, const struct cpumask *mask,
>   * cover a worst-case of every other cpu being on one of two nodes for a
>   * very large NR_CPUS.
>   *
> - *  Use PAGE_SIZE as a minimum for smaller configurations.
> + *  Use PAGE_SIZE as a minimum for smaller configurations while avoiding
> + *  unsigned comparison to -1.
>   */
> -#define CPUMAP_FILE_MAX_BYTES  ((((NR_CPUS * 9)/32 - 1) > PAGE_SIZE) \
> +#define CPUMAP_FILE_MAX_BYTES  ((((NR_CPUS * 9)/32) > PAGE_SIZE + 1) \
>  					? (NR_CPUS * 9)/32 - 1 : PAGE_SIZE)
>  #define CPULIST_FILE_MAX_BYTES  (((NR_CPUS * 7)/2 > PAGE_SIZE) ? (NR_CPUS * 7)/2 : PAGE_SIZE)
>  
> -- 
> 2.31.1
> 

Nice catch.  What type of systems did you run this on to verify it will
work?

thanks,

greg k-h
