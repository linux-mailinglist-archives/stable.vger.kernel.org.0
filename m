Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC405AF443
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 21:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiIFTOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 15:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiIFTOG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 15:14:06 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8C3A894B;
        Tue,  6 Sep 2022 12:14:03 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-1278a61bd57so12058215fac.7;
        Tue, 06 Sep 2022 12:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=yyFnJEeFnbtMtSAcAH7sHUm0rKeS0DESBmJhkjy5TGc=;
        b=DTV87E77lD4ICvOcwvSC/ZWTxGRiuucq83iEYksb2V4d4AfVKmIiVxyCQLVDzxtyXO
         PKbU1x+BuCmWE/UefxGg0b8YtwK1QHQQD9tCoXUzFhRMnLFi+zpjIe047V84sH2zVsKe
         FWx4FMjzjJXdkN0LHxq8IfHqM+gnv+4Y8TEwZkbBxinjcyzjNC520XlHn6TaZ4QGG7NS
         mvV8IVpk/cvcQIJeOHmnq7Sc9nftFoXYfXtbfMj3HYLUK0a1X/7aHOqo5jincJg1zkZg
         h6DQFasWZ1qftqBMnKcj6PfGsDrdA5O1Lv2AKHPR+68PES/mpTT4MiYaTQdiV/OH2Wi4
         UekA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=yyFnJEeFnbtMtSAcAH7sHUm0rKeS0DESBmJhkjy5TGc=;
        b=qiqh0YWmMWgqcWHkD+xHS4CbA6F7g48IGLrvQQTLx3QyB/VLEYwC5liAGe+4e/THxN
         nyPmZXFGSXDIZEVV/RKcs62VluzPUzJDEnWAOjbX/o69Rl+MK6+7grzqCkyznilO+4jC
         TBNu9gSSB3wtLbd2WAXFX9tsEEReWnEQ+DnvUNSxxROQFsgISh5OHYnDdeLb8YgiuiPa
         +ayor60AjYGHTa4ATVJZJ867jz0RdBxly4BQonCXSapDd8sPvm59Sg4NEy5EQ1S0bGwF
         3C5qMpFOpxb/DeSLfQ6YjAzQveW0bvER4ak3/CnANRMmcav27Tqvw4ISFE5bu+vbfJK8
         YYnA==
X-Gm-Message-State: ACgBeo2JM+rDd5iO0yTifrPN70pnQlFj5en5d63uQ9cgtNd4zQyEHnwj
        dAWm+B6fFRWagwIzOsj6uf+EV7To5Jc=
X-Google-Smtp-Source: AA6agR7xbGZJz+r8GBQ5cCQNhGe6geu50+9kj45mDYEXGZ2g9FZs01fWU+k90FnIU309Y8wheyw+Ew==
X-Received: by 2002:a05:6870:6317:b0:10e:631c:5e63 with SMTP id s23-20020a056870631700b0010e631c5e63mr13640198oao.262.1662491642901;
        Tue, 06 Sep 2022 12:14:02 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id a19-20020a544e13000000b0033e8629b323sm5711600oiy.35.2022.09.06.12.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 12:14:02 -0700 (PDT)
Date:   Tue, 6 Sep 2022 12:11:51 -0700
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
Message-ID: <YxebdxbVGuU655MB@yury-laptop>
References: <20220906160430.1169837-1-pauld@redhat.com>
 <YxeM8WKek/3gp8Fl@yury-laptop>
 <YxeYJcFVEURPRQu/@lorien.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxeYJcFVEURPRQu/@lorien.usersys.redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 02:57:41PM -0400, Phil Auld wrote:
> On Tue, Sep 06, 2022 at 11:09:53AM -0700 Yury Norov wrote:
> > On Tue, Sep 06, 2022 at 12:04:30PM -0400, Phil Auld wrote:
> > > As PAGE_SIZE is unsigned long, -1 > PAGE_SIZE when NR_CPUS <= 3.
> > > This leads to very large file sizes:
> > > 
> > > topology$ ls -l
> > > total 0
> > > -r--r--r-- 1 root root 18446744073709551615 Sep  5 11:59 core_cpus
> > > -r--r--r-- 1 root root                 4096 Sep  5 11:59 core_cpus_list
> > > -r--r--r-- 1 root root                 4096 Sep  5 10:58 core_id
> > > -r--r--r-- 1 root root 18446744073709551615 Sep  5 10:10 core_siblings
> > > -r--r--r-- 1 root root                 4096 Sep  5 11:59 core_siblings_list
> > > -r--r--r-- 1 root root 18446744073709551615 Sep  5 11:59 die_cpus
> > > -r--r--r-- 1 root root                 4096 Sep  5 11:59 die_cpus_list
> > > -r--r--r-- 1 root root                 4096 Sep  5 11:59 die_id
> > > -r--r--r-- 1 root root 18446744073709551615 Sep  5 11:59 package_cpus
> > > -r--r--r-- 1 root root                 4096 Sep  5 11:59 package_cpus_list
> > > -r--r--r-- 1 root root                 4096 Sep  5 10:58 physical_package_id
> > > -r--r--r-- 1 root root 18446744073709551615 Sep  5 10:10 thread_siblings
> > > -r--r--r-- 1 root root                 4096 Sep  5 11:59 thread_siblings_list
> > > 
> > > Adjust the inequality to catch the case when NR_CPUS is configured
> > > to a small value.
> > > 
> > > Fixes: 7ee951acd31a ("drivers/base: fix userspace break from using bin_attributes for cpumap and cpulist")
> > > Reported-by: feng xiangjun <fengxj325@gmail.com>
> > > Signed-off-by: Phil Auld <pauld@redhat.com>
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> > > Cc: Yury Norov <yury.norov@gmail.com>
> > > Cc: stable@vger.kernel.org
> > > Cc: feng xiangjun <fengxj325@gmail.com>
> > > ---
> > >  include/linux/cpumask.h | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> > > index bd047864c7ac..7b1349612d6d 100644
> > > --- a/include/linux/cpumask.h
> > > +++ b/include/linux/cpumask.h
> > > @@ -1127,9 +1127,10 @@ cpumap_print_list_to_buf(char *buf, const struct cpumask *mask,
> > >   * cover a worst-case of every other cpu being on one of two nodes for a
> > >   * very large NR_CPUS.
> > >   *
> > > - *  Use PAGE_SIZE as a minimum for smaller configurations.
> > > + *  Use PAGE_SIZE as a minimum for smaller configurations while avoiding
> > > + *  unsigned comparison to -1.
> > >   */
> > > -#define CPUMAP_FILE_MAX_BYTES  ((((NR_CPUS * 9)/32 - 1) > PAGE_SIZE) \
> > > +#define CPUMAP_FILE_MAX_BYTES  ((((NR_CPUS * 9)/32) > PAGE_SIZE + 1) \
> > 
> > Maybe it would be easier to read with less braces and '>=' instead of '>'?
> >   #define CPUMAP_FILE_MAX_BYTES \
> >         (NR_CPUS * 9 / 32 >= PAGE_SIZE ? NR_CPUS * 9 / 32 - 1 : PAGE_SIZE)
> > 
> > Anyways, this is a good catch. If you think it doesn't worth an
> > update, I can take it in bitmap-for-next as-is.
> >
> 
> It would work as
>    #define CPUMAP_FILE_MAX_BYTES  (((NR_CPUS * 9)/32 > PAGE_SIZE) \
>    	   			     ? (NR_CPUS * 9)/32 - 1 : PAGE_SIZE)
> 
> Since 4097 > PAGE_SIZE and then you'd get PAGE_SIZE anyway. That is we could just
> leave the 1 out of the inequality completely. 
> 
> If I recall at least some of the parens are needed to make the compiler happy.
> 
> I can resend with the above if you want.  

Yes, please
