Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779A15AF67C
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 23:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiIFVCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 17:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiIFVCH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 17:02:07 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C065A8329;
        Tue,  6 Sep 2022 14:02:06 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id d18-20020a9d72d2000000b0063934f06268so8937626otk.0;
        Tue, 06 Sep 2022 14:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=R/GeMVdeipKPN7zttj4B+pOEQuWCvLsDBS9vCKBBd8I=;
        b=ZOPfQzNQ2v9USvxkErBbcoyD7bw6ll/yTA7Jilr93OsRx73MWdSaayoXU26YMoZchr
         tOt6biggMO5i9nAcq4g5/wEK4muRedDp9Dpw9fxy75BrD/4Zstd3QOLsJLQTrwvh542j
         vYVMFMqB/s9HAMmPApY5Qh15dJ2VodbjvK7WIlq//9+dGPVOKYhg6yLukTKSB4hLgmsY
         xeLcOe74CMUFN2BdphLxpG08riDAo70p4s/INHkQLXaQt9ExntLCB3gwOrMQg9+DWmaa
         mGplfLa9CeL/LmK3TdTrMumN/bl7tDlR3aPclDQkmSirfDuzffHvM3QJeca0EdXyfpUf
         ahmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=R/GeMVdeipKPN7zttj4B+pOEQuWCvLsDBS9vCKBBd8I=;
        b=wGenYxdP+mJRoBi98oZENXKWNmCqRX7O6Lhrr3TPS9V09qvL+T0yxjGPSlguGVaIeP
         6Wt7FifAvYpYqPeCzBtEhd+cPiRL7hk49YTSt8id69ExwOQqnjadtoZx3HgjKWfDmDUr
         pAjekkC+glQCkuGM4iEEnZUMnyahyA3SMBMdJGxXCdfCSjsRY3gZFEFoGkTorAHy5Evd
         rPSproaMsAkrY4CZMHfmAtELVTlZXfBXY1mi+o5LlsaCCv4MUnBdtsi+Q5TnRKzvvois
         H25LTWGG6cgUZA3azm+Hqr3CUWT//a1bhrcmRVNnuupLmpYuFEhXdS9K7/y57Oq67/4+
         waCg==
X-Gm-Message-State: ACgBeo1K+NNZaKU3plDz/KdRY2fhpKvoo/Ba7aKA41KmutJIM8FbN27K
        HZVGnAR3Pc0mzpWAKVYQRQ4=
X-Google-Smtp-Source: AA6agR5mwf8je7p5PW8Pr3irimUDceYMTqm7M2kFrpC7xvZILd3cWb2Qmfn+qLrDP+CiW3HwetKlOg==
X-Received: by 2002:a05:6830:20ca:b0:636:d7f8:a404 with SMTP id z10-20020a05683020ca00b00636d7f8a404mr146455otq.373.1662498125229;
        Tue, 06 Sep 2022 14:02:05 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id h19-20020a056830165300b00636d0984f5asm6244038otr.11.2022.09.06.14.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 14:02:04 -0700 (PDT)
Date:   Tue, 6 Sep 2022 13:59:53 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Phil Auld <pauld@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Barry Song <21cnbao@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        feng xiangjun <fengxj325@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] drivers/base: Fix unsigned comparison to -1 in
 CPUMAP_FILE_MAX_BYTES
Message-ID: <Yxe0yXz1u4mjKmDe@yury-laptop>
References: <20220906203542.1796629-1-pauld@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906203542.1796629-1-pauld@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 04:35:42PM -0400, Phil Auld wrote:
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

Applied on bitmap-for-next. Thanks!

> ---
> 
> v2: Remove the +/-1 completely from the test since it will produce the
> same results, and remove some extra parentheses.
> 
>  include/linux/cpumask.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> index bd047864c7ac..e8ad12b5b9d2 100644
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
> +#define CPUMAP_FILE_MAX_BYTES  (((NR_CPUS * 9)/32 > PAGE_SIZE) \
>  					? (NR_CPUS * 9)/32 - 1 : PAGE_SIZE)
>  #define CPULIST_FILE_MAX_BYTES  (((NR_CPUS * 7)/2 > PAGE_SIZE) ? (NR_CPUS * 7)/2 : PAGE_SIZE)
>  
> -- 
> 2.31.1
