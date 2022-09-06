Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680695AF3FF
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 20:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiIFS6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 14:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiIFS5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 14:57:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213FE5E306
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 11:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662490667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xFe5nbfa4cPKFz06ph4fehEDhqSnRc9j+k9A8lBvtDk=;
        b=Y1GmAe6i+OOB0gwNH5h9J4SFYPsNuR82xXYV1SDKkvVSlgWYGlexjn0dAdVpYNM6IWs3Np
        Jtj1kzFEY36WTuVwrTNemMRkO+FZGTESjVHbuqiaG57+dznYjT2mKbdjxoipZzKmpjiAsm
        vKsu66Fx4lo7Z1VTYgYsNckKk/VxE0o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-GCkmG9JUNOaNRv2HLWlwVw-1; Tue, 06 Sep 2022 14:57:43 -0400
X-MC-Unique: GCkmG9JUNOaNRv2HLWlwVw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 418B62A59541;
        Tue,  6 Sep 2022 18:57:43 +0000 (UTC)
Received: from lorien.usersys.redhat.com (unknown [10.22.32.243])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A3FCB2026D4C;
        Tue,  6 Sep 2022 18:57:42 +0000 (UTC)
Date:   Tue, 6 Sep 2022 14:57:41 -0400
From:   Phil Auld <pauld@redhat.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Barry Song <21cnbao@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        feng xiangjun <fengxj325@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] drivers/base: Fix unsigned comparison to -1 in
 CPUMAP_FILE_MAX_BYTES
Message-ID: <YxeYJcFVEURPRQu/@lorien.usersys.redhat.com>
References: <20220906160430.1169837-1-pauld@redhat.com>
 <YxeM8WKek/3gp8Fl@yury-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxeM8WKek/3gp8Fl@yury-laptop>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 11:09:53AM -0700 Yury Norov wrote:
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
>

It would work as
   #define CPUMAP_FILE_MAX_BYTES  (((NR_CPUS * 9)/32 > PAGE_SIZE) \
   	   			     ? (NR_CPUS * 9)/32 - 1 : PAGE_SIZE)

Since 4097 > PAGE_SIZE and then you'd get PAGE_SIZE anyway. That is we could just
leave the 1 out of the inequality completely. 

If I recall at least some of the parens are needed to make the compiler happy.

I can resend with the above if you want.  

Cheers,
Phil

> >  					? (NR_CPUS * 9)/32 - 1 : PAGE_SIZE)
> >  #define CPULIST_FILE_MAX_BYTES  (((NR_CPUS * 7)/2 > PAGE_SIZE) ? (NR_CPUS * 7)/2 : PAGE_SIZE)
> >  
> > -- 
> > 2.31.1
> 

-- 

