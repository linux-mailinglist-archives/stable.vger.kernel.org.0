Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0DC75764C9
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 17:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiGOP5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 11:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiGOP5n (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 11:57:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC1A261D7C
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 08:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657900660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/FdZSaJ6nYpAHiWDAVZdlLoPRtdepjpdp6VwK6oqQrM=;
        b=WpGmXC9V5NNLNZGIWxBqTe9Ucy7DanhTpNlzu/wV/qSw7f3HblnsbEThcWQnnzQnsm0nFl
        jQfkjeST+E1plJdoabzR65iEtmh4NoJlu/5YwOzt6WAbl2vjgn/3jtCXK08ODhMC7Z1j0V
        73C3NOpohhQHK2UxMrFjXQNGDaQ+9VM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-IlLMWm90MDWU3IvRpObP7g-1; Fri, 15 Jul 2022 11:57:38 -0400
X-MC-Unique: IlLMWm90MDWU3IvRpObP7g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B7EC299E76B;
        Fri, 15 Jul 2022 15:57:37 +0000 (UTC)
Received: from lorien.usersys.redhat.com (unknown [10.39.193.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9ADC91121314;
        Fri, 15 Jul 2022 15:57:34 +0000 (UTC)
Date:   Fri, 15 Jul 2022 11:57:30 -0400
From:   Phil Auld <pauld@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Barry Song <21cnbao@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        Yury Norov <yury.norov@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v5] drivers/base: fix userspace break from using
 bin_attributes for cpumap and cpulist
Message-ID: <YtGOajQ7vmqUEjO8@lorien.usersys.redhat.com>
References: <20220715134924.3466194-1-pauld@redhat.com>
 <YtGJqYrbSPq9q19U@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtGJqYrbSPq9q19U@kroah.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 15, 2022 at 05:37:13PM +0200 Greg Kroah-Hartman wrote:
> On Fri, Jul 15, 2022 at 09:49:24AM -0400, Phil Auld wrote:
> > Using bin_attributes with a 0 size causes fstat and friends to return that
> > 0 size. This breaks userspace code that retrieves the size before reading
> > the file. Rather than reverting 75bd50fa841 ("drivers/base/node.c: use
> > bin_attribute to break the size limitation of cpumap ABI") let's put in a
> > size value at compile time.
> > 
> > For cpulist the maximum size is on the order of
> > 	NR_CPUS * (ceil(log10(NR_CPUS)) + 1)/2
> > 
> > which for 8192 is 20480 (8192 * 5)/2. In order to get near that you'd need
> > a system with every other CPU on one node. For example: (0,2,4,8, ... ).
> > To simplify the math and support larger NR_CPUS in the future we are using
> > (NR_CPUS * 7)/2. We also set it to a min of PAGE_SIZE to retain the older
> > behavior for smaller NR_CPUS.
> > 
> > The cpumap file the size works out to be NR_CPUS/4 + NR_CPUS/32 - 1
> > (or NR_CPUS * 9/32 - 1) including the ","s.
> > 
> > Add a set of macros for these values to cpumask.h so they can be used in
> > multiple places. Apply these to the handful of such files in
> > drivers/base/topology.c as well as node.c.
> > 
> > As an example, on an 80 cpu 4-node system (NR_CPUS == 8192):
> > 
> > before:
> > 
> > -r--r--r--. 1 root root 0 Jul 12 14:08 system/node/node0/cpulist
> > -r--r--r--. 1 root root 0 Jul 11 17:25 system/node/node0/cpumap
> > 
> > after:
> > 
> > -r--r--r--. 1 root root 28672 Jul 13 11:32 system/node/node0/cpulist
> > -r--r--r--. 1 root root  4096 Jul 13 11:31 system/node/node0/cpumap
> > 
> > CONFIG_NR_CPUS = 16384
> > -r--r--r--. 1 root root 57344 Jul 13 14:03 system/node/node0/cpulist
> > -r--r--r--. 1 root root  4607 Jul 13 14:02 system/node/node0/cpumap
> > 
> > The actual number of cpus doesn't matter for the reported size since they
> > are based on NR_CPUS.
> > 
> > Fixes: 75bd50fa841 ("drivers/base/node.c: use bin_attribute to break the size limitation of cpumap ABI")
> > Fixes: bb9ec13d156 ("topology: use bin_attribute to break the size limitation of cpumap ABI")
> 
> Nit, use the full 12 characters otherwise our tools will complain.  I'll
> go fix it up by hand...
>

Erm, counting is hard...  I thought I did have 12 :)

> thanks for sticking with this.

Thanks for the patience.


Cheers,
Phil

> 
> greg k-h
> 

-- 

