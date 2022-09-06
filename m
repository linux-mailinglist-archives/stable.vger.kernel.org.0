Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAD25AF7C8
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 00:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiIFWTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 18:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiIFWTg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 18:19:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBF77641
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 15:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662502774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K111mClAVKBb8x/inphQinCwssocvNLnhBz225LosPQ=;
        b=TRuNGHnPrIh8x5tCULsTXazWhTJr80KoSnZc5ungEAx0s7HxuLqTyrKMHD8lAXum8bGaOz
        UBaVWaVhFTe62AA/qUznDWtbEw+8/YO5xWTCr58QPnFMpLn0ZO0zM943jmlJPGMeD4qCO6
        JWLOGl1eVPSRNvywmq9V/1BxAJE7f6A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-sM63FM_uPU-5bcyz9UgM3g-1; Tue, 06 Sep 2022 18:19:29 -0400
X-MC-Unique: sM63FM_uPU-5bcyz9UgM3g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C893803301;
        Tue,  6 Sep 2022 22:19:25 +0000 (UTC)
Received: from lorien.usersys.redhat.com (unknown [10.22.32.243])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D61ED2166B26;
        Tue,  6 Sep 2022 22:19:24 +0000 (UTC)
Date:   Tue, 6 Sep 2022 18:19:23 -0400
From:   Phil Auld <pauld@redhat.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Barry Song <21cnbao@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        feng xiangjun <fengxj325@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] drivers/base: Fix unsigned comparison to -1 in
 CPUMAP_FILE_MAX_BYTES
Message-ID: <YxfHa+CBpxoXsM/d@lorien.usersys.redhat.com>
References: <20220906203542.1796629-1-pauld@redhat.com>
 <Yxe0yXz1u4mjKmDe@yury-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yxe0yXz1u4mjKmDe@yury-laptop>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 01:59:53PM -0700 Yury Norov wrote:
> On Tue, Sep 06, 2022 at 04:35:42PM -0400, Phil Auld wrote:
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
> 
> Applied on bitmap-for-next. Thanks!
>

Great, thanks!

> > ---
> > 
> > v2: Remove the +/-1 completely from the test since it will produce the
> > same results, and remove some extra parentheses.
> > 
> >  include/linux/cpumask.h | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> > index bd047864c7ac..e8ad12b5b9d2 100644
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
> > +#define CPUMAP_FILE_MAX_BYTES  (((NR_CPUS * 9)/32 > PAGE_SIZE) \
> >  					? (NR_CPUS * 9)/32 - 1 : PAGE_SIZE)
> >  #define CPULIST_FILE_MAX_BYTES  (((NR_CPUS * 7)/2 > PAGE_SIZE) ? (NR_CPUS * 7)/2 : PAGE_SIZE)
> >  
> > -- 
> > 2.31.1
> 

-- 

