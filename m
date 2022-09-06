Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01BB65AF36A
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 20:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiIFSPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 14:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiIFSPU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 14:15:20 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9274E81698;
        Tue,  6 Sep 2022 11:15:18 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id a15so8802975qko.4;
        Tue, 06 Sep 2022 11:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=45cnuKzTX9yD4rACt8dlvXhLELqrTsVbBuIM+uLibzc=;
        b=FKRdDHRSTAK0iudQVjAn58238YES03tZ8NajDz73fvMwN0CZR29UFRKaID2Rpir3Gp
         veaQNHCarhHqjy2MxWFCbQNbSa2COG9NIXf9JC1r9R0z+eBgyxLybaf6Dmxf316ifJP6
         3IGm+fodhx7g2QypA+FT4HN6vimtPj6/ZwmIS5hRRHEJ3yGgvILor/WLuree1+P64u/q
         tJhG6ijoD0oLRWZwwjD4HFBdHrGvlN3C6qvq9cAWFcpGAxubJh4DS29kohPjQdfz9/Tm
         fEQ2X1E47FwzthULwylk6owi83VMHkWIHBD0/AsJpizRIeqMwModZJiYbqEj5xP0RNkG
         aUTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=45cnuKzTX9yD4rACt8dlvXhLELqrTsVbBuIM+uLibzc=;
        b=GGJ1M/KrPytHS2dI1vZbzsDS3PXCx1JaI99WWJ6uqew4+ty0urhEtN3JiEIIBZWPaV
         7ajXgwerEZSiGSr3OolelX8XWM1LMqX9UMh18VfboOy8YjPot1eifDILkmH7cN41JV/E
         ghhyAqMa/wUt9JU/ibw+DJWS/PeutZ80mQumoeikeQK4GGx1yXY8Ok443RTPXzuw0KdO
         o1huGWyWGiw1D7DaG5TP71eLSkTslUQLPyKnxlIimbpOxb1v2nL69nLGZvZLGX1+ceka
         xX0YHhitnmCPTCk2vB61Jcz56t5MNhOX/uQA5yTSq/hxWLti4+avsO0RlO1zwjus5A8r
         Ya4g==
X-Gm-Message-State: ACgBeo1UQcRzqdPFRZXK0C4zycdfbfP4ZmEgRwPvo97F4dQ+R0qCGVQZ
        M6nMlKtfse5LKHpda8mnD10=
X-Google-Smtp-Source: AA6agR6fqio8JZ2ipWrOXWuk5FRRgCqrSpulALReluMuC5RCL0p8IHecxg0nue3m+iUJRXyCOj6dgA==
X-Received: by 2002:ae9:ed12:0:b0:6bb:3386:4c41 with SMTP id c18-20020ae9ed12000000b006bb33864c41mr36632032qkg.648.1662488117613;
        Tue, 06 Sep 2022 11:15:17 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:20bc:1817:1631:6d06])
        by smtp.gmail.com with ESMTPSA id y13-20020a05620a25cd00b006b5e50057basm11984912qko.95.2022.09.06.11.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 11:15:17 -0700 (PDT)
Date:   Tue, 6 Sep 2022 11:15:16 -0700
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
Message-ID: <YxeONJ2mtCkReozc@yury-laptop>
References: <20220906160430.1169837-1-pauld@redhat.com>
 <YxeM8WKek/3gp8Fl@yury-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxeM8WKek/3gp8Fl@yury-laptop>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 11:09:54AM -0700, Yury Norov wrote:
> On Tue, Sep 06, 2022 at 12:04:30PM -0400, Phil Auld wrote:
> > As PAGE_SIZE is unsigned long, -1 > PAGE_SIZE when NR_CPUS <= 3.
> > This leads to very large file sizes:
> > 
> > topology$ ls -l
> > total 0
> > -r--r--r-- 1 root root 18446744073709551615 Sep  5 11:59 core_cpus
> > -r--r--r-- 1 root root                 4096 Sep  5 11:59 core_cpus_list
> > -r--r--r-- 1 root root                 4096 Sep  5 10:58 core_id
> > -r--r--r-- 1 root root 18446744073709551615 Sep  5 10:10 core_siblings
> > -r--r--r-- 1 root root                 4096 Sep  5 11:59 core_siblings_list
> > -r--r--r-- 1 root root 18446744073709551615 Sep  5 11:59 die_cpus
> > -r--r--r-- 1 root root                 4096 Sep  5 11:59 die_cpus_list
> > -r--r--r-- 1 root root                 4096 Sep  5 11:59 die_id
> > -r--r--r-- 1 root root 18446744073709551615 Sep  5 11:59 package_cpus
> > -r--r--r-- 1 root root                 4096 Sep  5 11:59 package_cpus_list
> > -r--r--r-- 1 root root                 4096 Sep  5 10:58 physical_package_id
> > -r--r--r-- 1 root root 18446744073709551615 Sep  5 10:10 thread_siblings
> > -r--r--r-- 1 root root                 4096 Sep  5 11:59 thread_siblings_list
> > 
> > Adjust the inequality to catch the case when NR_CPUS is configured
> > to a small value.
> > 
> > Fixes: 7ee951acd31a ("drivers/base: fix userspace break from using bin_attributes for cpumap and cpulist")
> > Reported-by: feng xiangjun <fengxj325@gmail.com>
> > Signed-off-by: Phil Auld <pauld@redhat.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> > Cc: Yury Norov <yury.norov@gmail.com>
> > Cc: stable@vger.kernel.org
> > Cc: feng xiangjun <fengxj325@gmail.com>
> > ---
> >  include/linux/cpumask.h | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> > index bd047864c7ac..7b1349612d6d 100644
> > --- a/include/linux/cpumask.h
> > +++ b/include/linux/cpumask.h
> > @@ -1127,9 +1127,10 @@ cpumap_print_list_to_buf(char *buf, const struct cpumask *mask,
> >   * cover a worst-case of every other cpu being on one of two nodes for a
> >   * very large NR_CPUS.
> >   *
> > - *  Use PAGE_SIZE as a minimum for smaller configurations.
> > + *  Use PAGE_SIZE as a minimum for smaller configurations while avoiding
> > + *  unsigned comparison to -1.
> >   */
> > -#define CPUMAP_FILE_MAX_BYTES  ((((NR_CPUS * 9)/32 - 1) > PAGE_SIZE) \
> > +#define CPUMAP_FILE_MAX_BYTES  ((((NR_CPUS * 9)/32) > PAGE_SIZE + 1) \
> 
> Maybe it would be easier to read with less braces and '>=' instead of '>'?
>   #define CPUMAP_FILE_MAX_BYTES \
>         (NR_CPUS * 9 / 32 >= PAGE_SIZE ? NR_CPUS * 9 / 32 - 1 : PAGE_SIZE)
> 
> Anyways, this is a good catch. If you think it doesn't worth an
> update, I can take it in bitmap-for-next as-is.

Ah, I screwed in math. '>=' wouldn't work of course... 
