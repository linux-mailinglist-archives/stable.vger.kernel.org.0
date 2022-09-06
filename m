Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F8A5AF2B7
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 19:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239439AbiIFRbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 13:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbiIFRat (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 13:30:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6241027CD5
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 10:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662485090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8jj5ltO1LOk0SlLaaEAJAylbk3vvryd3UX57GATziA8=;
        b=EyN/11aCfOMZnqYSK9YxRMPL9AF80mQdtDacyTss56MGInbR9qZ1//AYAD4HKTHT9ROD8x
        9ZyhUco5e0D/xQkV/lGN4VIFPt4edX8ulJrX9ikZJScVYm/+m/6Qv8E4gfWovI9AlVzjHv
        gaHjEUY8jNTVdHe6EdgtUBvvIsc6INo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-x_4o4RaGNtOjYIbWvCLvmQ-1; Tue, 06 Sep 2022 13:24:46 -0400
X-MC-Unique: x_4o4RaGNtOjYIbWvCLvmQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BDD7382ECC1;
        Tue,  6 Sep 2022 17:24:46 +0000 (UTC)
Received: from lorien.usersys.redhat.com (unknown [10.22.32.243])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BF4D32166B26;
        Tue,  6 Sep 2022 17:24:45 +0000 (UTC)
Date:   Tue, 6 Sep 2022 13:24:44 -0400
From:   Phil Auld <pauld@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Barry Song <21cnbao@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        Yury Norov <yury.norov@gmail.com>,
        feng xiangjun <fengxj325@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] drivers/base: Fix unsigned comparison to -1 in
 CPUMAP_FILE_MAX_BYTES
Message-ID: <YxeCXALgsIGxiSlG@lorien.usersys.redhat.com>
References: <20220906160430.1169837-1-pauld@redhat.com>
 <Yxd9LRH+3wkM0fot@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yxd9LRH+3wkM0fot@kroah.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 07:02:37PM +0200 Greg Kroah-Hartman wrote:
> On Tue, Sep 06, 2022 at 12:04:30PM -0400, Phil Auld wrote:
> > As PAGE_SIZE is unsigned long, -1 > PAGE_SIZE when NR_CPUS <= 3.
> > This leads to very large file sizes:
> > 
> > topology$ ls -l
> > total 0
> > -r--r--r-- 1 root root 18446744073709551615 Sep  5 11:59 core_cpus
> 
> Yeah, lots of CPUs!  :)
>

Yep, apparently things like lscpu fail with this size. 


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
> >  					? (NR_CPUS * 9)/32 - 1 : PAGE_SIZE)
> >  #define CPULIST_FILE_MAX_BYTES  (((NR_CPUS * 7)/2 > PAGE_SIZE) ? (NR_CPUS * 7)/2 : PAGE_SIZE)
> >  
> > -- 
> > 2.31.1
> > 
> 
> Nice catch.  What type of systems did you run this on to verify it will
> work?
>

Feng ran it on his 2 cpu laptop.  I ran it on my usual test bed (80 cpus) but
configured both with NR_CPUS at 8192 and at 2.

It's not really dependent on the actual system. It's a compile time config
option.  I failed to set it small when testing the first one.

The fix here is just maths :) 

With NR_CPUS == 2:

# ls -l /sys/devices/system/cpu/cpu0/topology/
total 0
-r--r--r--. 1 root root 4096 Sep  6 11:40 cluster_cpus
-r--r--r--. 1 root root 4096 Sep  6 11:40 cluster_cpus_list
-r--r--r--. 1 root root 4096 Sep  6 11:40 cluster_id
-r--r--r--. 1 root root 4096 Sep  6 11:40 core_cpus
-r--r--r--. 1 root root 4096 Sep  6 11:40 core_cpus_list
-r--r--r--. 1 root root 4096 Sep  6 11:40 core_id
-r--r--r--. 1 root root 4096 Sep  6 11:29 core_siblings
-r--r--r--. 1 root root 4096 Sep  6 11:40 core_siblings_list
...



Cheers,
Phil

> thanks,
> 
> greg k-h
> 

-- 

