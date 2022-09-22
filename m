Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5425E6291
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 14:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbiIVMim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 08:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbiIVMik (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 08:38:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5E2E723B
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 05:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663850319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N8wouGppMh/lqIofR8IYJpGJSos9sXEZ5ESpwY6OiUY=;
        b=dOQtFSnEPIFYGrhonqAjYJ4txWy2xaiKkGtgxSuhJ1yhEnzjkn0ygw43PpQ4seNWsER/+I
        O6ssm+Gz1AtunZDZ41TCwDOChdiIrkZxLS2DAaytarKnQY9kVpyEVOhmyFJLof3W5NLin1
        JUHJ42du1Ag0gT43rVC1x8TMUNaU1I0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-314-XTl8e8CMN_yFI3o0dUOprg-1; Thu, 22 Sep 2022 08:38:33 -0400
X-MC-Unique: XTl8e8CMN_yFI3o0dUOprg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41E6A3825789;
        Thu, 22 Sep 2022 12:38:31 +0000 (UTC)
Received: from lorien.usersys.redhat.com (unknown [10.22.33.123])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C0E72112131B;
        Thu, 22 Sep 2022 12:38:29 +0000 (UTC)
Date:   Thu, 22 Sep 2022 08:38:27 -0400
From:   Phil Auld <pauld@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Barry Song <21cnbao@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        feng xiangjun <fengxj325@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] drivers/base: Fix unsigned comparison to -1 in
 CPUMAP_FILE_MAX_BYTES
Message-ID: <YyxXQ1iH1gwI/wP6@lorien.usersys.redhat.com>
References: <20220906203542.1796629-1-pauld@redhat.com>
 <Yxe0yXz1u4mjKmDe@yury-laptop>
 <YxfHa+CBpxoXsM/d@lorien.usersys.redhat.com>
 <YyxA1Q9SEqFJJk8Y@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyxA1Q9SEqFJJk8Y@kroah.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 22, 2022 at 01:02:45PM +0200 Greg Kroah-Hartman wrote:
> On Tue, Sep 06, 2022 at 06:19:23PM -0400, Phil Auld wrote:
> > On Tue, Sep 06, 2022 at 01:59:53PM -0700 Yury Norov wrote:
> > > On Tue, Sep 06, 2022 at 04:35:42PM -0400, Phil Auld wrote:
> > > > As PAGE_SIZE is unsigned long, -1 > PAGE_SIZE when NR_CPUS <= 3.
> > > > This leads to very large file sizes:
> > > > 
> > > > topology$ ls -l
> > > > total 0
> > > > -r--r--r-- 1 root root 18446744073709551615 Sep  5 11:59 core_cpus
> > > > -r--r--r-- 1 root root                 4096 Sep  5 11:59 core_cpus_list
> > > > -r--r--r-- 1 root root                 4096 Sep  5 10:58 core_id
> > > > -r--r--r-- 1 root root 18446744073709551615 Sep  5 10:10 core_siblings
> > > > -r--r--r-- 1 root root                 4096 Sep  5 11:59 core_siblings_list
> > > > -r--r--r-- 1 root root 18446744073709551615 Sep  5 11:59 die_cpus
> > > > -r--r--r-- 1 root root                 4096 Sep  5 11:59 die_cpus_list
> > > > -r--r--r-- 1 root root                 4096 Sep  5 11:59 die_id
> > > > -r--r--r-- 1 root root 18446744073709551615 Sep  5 11:59 package_cpus
> > > > -r--r--r-- 1 root root                 4096 Sep  5 11:59 package_cpus_list
> > > > -r--r--r-- 1 root root                 4096 Sep  5 10:58 physical_package_id
> > > > -r--r--r-- 1 root root 18446744073709551615 Sep  5 10:10 thread_siblings
> > > > -r--r--r-- 1 root root                 4096 Sep  5 11:59 thread_siblings_list
> > > > 
> > > > Adjust the inequality to catch the case when NR_CPUS is configured
> > > > to a small value.
> > > > 
> > > > Fixes: 7ee951acd31a ("drivers/base: fix userspace break from using bin_attributes for cpumap and cpulist")
> > > > Reported-by: feng xiangjun <fengxj325@gmail.com>
> > > > Signed-off-by: Phil Auld <pauld@redhat.com>
> > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> > > > Cc: Yury Norov <yury.norov@gmail.com>
> > > > Cc: stable@vger.kernel.org
> > > > Cc: feng xiangjun <fengxj325@gmail.com>
> > > 
> > > Applied on bitmap-for-next. Thanks!
> > >
> > 
> > Great, thanks!
> 
> This is hitting people already and causing problems, so I'll go add it
> to my tree as well to get it to Linus quicker.  Here's one report of the
> problem:
> 	https://github.com/util-linux/util-linux/issues/1810
>

Arrgh! Thanks Greg. I stopped watching it when it got merged above but yeah,
this needs to get in soon and then get into any stable trees that got the first
one. Sorry about that!

Cheers,
Phil


> thanks,
> 
> greg k-h
> 

-- 

