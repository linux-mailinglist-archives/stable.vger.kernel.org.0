Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 652B75E6058
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 13:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiIVLCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 07:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiIVLCw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 07:02:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B4AD07B2;
        Thu, 22 Sep 2022 04:02:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18DFEB81D49;
        Thu, 22 Sep 2022 11:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5A9C433D6;
        Thu, 22 Sep 2022 11:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663844568;
        bh=GSTCjeVVdibEpT30Ra4Eml63HxL9FJqyf9Qkwi+0Jyw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cmsplng3F9C8P/Ew1F+qqrsEDz2HQ+n/rVkEhZyj697Lrvs+lOKTzGV61h5JADeFh
         FtQ3Ck9C/btLVEfHjqilPKqjFox5YFa1rRh6aPOHqhzglerTjnw4NMUDApNWhw5ODT
         SLeXeFcXLOp3iSM38MnYVAk+No10TYdIcBT9k8Z8=
Date:   Thu, 22 Sep 2022 13:02:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Phil Auld <pauld@redhat.com>
Cc:     Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Barry Song <21cnbao@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        feng xiangjun <fengxj325@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] drivers/base: Fix unsigned comparison to -1 in
 CPUMAP_FILE_MAX_BYTES
Message-ID: <YyxA1Q9SEqFJJk8Y@kroah.com>
References: <20220906203542.1796629-1-pauld@redhat.com>
 <Yxe0yXz1u4mjKmDe@yury-laptop>
 <YxfHa+CBpxoXsM/d@lorien.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxfHa+CBpxoXsM/d@lorien.usersys.redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 06:19:23PM -0400, Phil Auld wrote:
> On Tue, Sep 06, 2022 at 01:59:53PM -0700 Yury Norov wrote:
> > On Tue, Sep 06, 2022 at 04:35:42PM -0400, Phil Auld wrote:
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
> > 
> > Applied on bitmap-for-next. Thanks!
> >
> 
> Great, thanks!

This is hitting people already and causing problems, so I'll go add it
to my tree as well to get it to Linus quicker.  Here's one report of the
problem:
	https://github.com/util-linux/util-linux/issues/1810

thanks,

greg k-h
