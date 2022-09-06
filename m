Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7EA5AF35F
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 20:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiIFSKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 14:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiIFSKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 14:10:03 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342A873920;
        Tue,  6 Sep 2022 11:09:55 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id m5so8804814qkk.1;
        Tue, 06 Sep 2022 11:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=IPemDTbWwGYli8WKOHE+A4lybL0KbD2c7lnslmhp4HY=;
        b=Eak0RLws326jam9PY3Ivjxr6NDfkFwF1G9XGqnWurG+kP8qQSf6cmkDQLprsiNq2Xh
         vKm6vYQ/ZfUWi/jm5bD42sgn03xUSNSXi3gTk2seGkXx7PoOwPlBqVaU3IV05rxcbCRa
         JusSrLabUpS+ICu3q7u0DyIiBAClXK08IoTvZ72blv52hWG3Kx7V0pTso4Oot4i6gzvk
         NVHZ8lYdZ9bSGeRwSbu5CIktx/MFwbLdsYn/+tI/wSPq/RqlIq8nsDqKzRyn6pwqtcmW
         +suKhWrlJ1EGLUoOGSrhQ8CP82Iskx+t6dMAiUrUpo2zpzXdrc7CcHTl2voobFUEkQu4
         gzew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=IPemDTbWwGYli8WKOHE+A4lybL0KbD2c7lnslmhp4HY=;
        b=0s9Wpsj5g7x6+apxRKAAr96IXFd9t9auc3Hdp+6KjrQdPtDleHP7btHKVkkiq8dzyh
         L3bCAqutAawPhgbajpmZeJ1rAEx/U/l6uwdGd0QtwwZHjDlqeHK1zBz9gJ3Q6CR5df6V
         f2IcjYonUE4WRG9OaBf+RQjk8S7ZmDwttZenODnXHVE3UlpXY94TVJrmDrySYhOqdEH5
         y1VMk8h5Gta5onLBcz5yqCo7VGWSWucDC18oVaQ5htWWD2KxeEKvr1hpKbPbkUhLbH+Y
         3/pZABQXHLUo7BodPuEFJGt/GFTdRB2aBVkgO0txxofpomIn60fd0NdTkWzu785MxHYz
         jpGA==
X-Gm-Message-State: ACgBeo2hOZCVxov94AyPzW8LJCqy3ldSrcxEuTmNQHRC8qy+ghcgmRv0
        KoRHLsnC292QV31EA9psaqY=
X-Google-Smtp-Source: AA6agR7w8VBmU1DoE2Pj+aCqiovGksWw/gTULctjxrudhLOJiyhfdOZcjsKNOA9U4yeQLeh7hQUMDQ==
X-Received: by 2002:a05:620a:4626:b0:6bb:78d0:95d0 with SMTP id br38-20020a05620a462600b006bb78d095d0mr37688625qkb.631.1662487794430;
        Tue, 06 Sep 2022 11:09:54 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:20bc:1817:1631:6d06])
        by smtp.gmail.com with ESMTPSA id r9-20020a05620a298900b006b919c6749esm12640971qkp.91.2022.09.06.11.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 11:09:54 -0700 (PDT)
Date:   Tue, 6 Sep 2022 11:09:53 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Phil Auld <pauld@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Barry Song <21cnbao@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        feng xiangjun <fengxj325@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] drivers/base: Fix unsigned comparison to -1 in
 CPUMAP_FILE_MAX_BYTES
Message-ID: <YxeM8WKek/3gp8Fl@yury-laptop>
References: <20220906160430.1169837-1-pauld@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906160430.1169837-1-pauld@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

Maybe it would be easier to read with less braces and '>=' instead of '>'?
  #define CPUMAP_FILE_MAX_BYTES \
        (NR_CPUS * 9 / 32 >= PAGE_SIZE ? NR_CPUS * 9 / 32 - 1 : PAGE_SIZE)

Anyways, this is a good catch. If you think it doesn't worth an
update, I can take it in bitmap-for-next as-is.

>  					? (NR_CPUS * 9)/32 - 1 : PAGE_SIZE)
>  #define CPULIST_FILE_MAX_BYTES  (((NR_CPUS * 7)/2 > PAGE_SIZE) ? (NR_CPUS * 7)/2 : PAGE_SIZE)
>  
> -- 
> 2.31.1
