Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A563D248C
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 15:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbhGVMqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 08:46:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231938AbhGVMqU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 08:46:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 709F360FEE;
        Thu, 22 Jul 2021 13:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626960415;
        bh=+uL4L29wsoeIrn9I4PopKZ7ciOxU0fozSHm7hEtJRaA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mOzAXRtqcugR4cbq3OZ5I8AKQ8QQhGkkyOozUUY9xBQ0I5NEwtkdgEsSwZCJsdN/+
         3bjvn18Caqjm7YHAFh8jWTESB+wOgqiuj5PRefDbB42xcQurO6032HAthHLzg3O2Hd
         5NQaMgvg+iMGAQSuZ7xMqrR8uynVN49YlEvWISUc=
Date:   Thu, 22 Jul 2021 15:26:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Zhouyi Zhou <zhouzhouyi@gmail.com>,
        Chris Clayton <chris2553@googlemail.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Boqun Feng <boqun.feng@gmail.com>, paulmck@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Chris Rankin <rankincj@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        rcu <rcu@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: linux-5.13.2: warning from kernel/rcu/tree_plugin.h:359
Message-ID: <YPlyHF5eNDiTMKzq@kroah.com>
References: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com>
 <5812280.fcLxn8YiTP@natalenko.name>
 <YPVtBBumSTMKGuld@casper.infradead.org>
 <2237123.PRLUojbHBq@natalenko.name>
 <CAABZP2w4VKRPjNz+TW1_n=NhGw=CBNccMp-WGVRy32XxAVobRg@mail.gmail.com>
 <CAABZP2yh3J8+P=3PLZVaC47ymKC7PcfQCBBxjXJ9Ybn+HREbdg@mail.gmail.com>
 <fb8b8639-bf2d-161e-dc9a-6a63bf9db46e@googlemail.com>
 <CAABZP2xST9787xNujWeKODEW79KpjL7vHtqYjjGxOwoqXSWXDQ@mail.gmail.com>
 <YPlmMnZKgkcLderp@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPlmMnZKgkcLderp@casper.infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 22, 2021 at 01:36:02PM +0100, Matthew Wilcox wrote:
> On Thu, Jul 22, 2021 at 04:57:57PM +0800, Zhouyi Zhou wrote:
> > Thanks for reviewing,
> > 
> > What I have deduced from the dmesg  is:
> > In function do_swap_page,
> > after invoking
> > 3385        si = get_swap_device(entry); /* rcu_read_lock */
> > and before
> > 3561    out:
> > 3562        if (si)
> > 3563            put_swap_device(si);
> > The thread got scheduled out in
> > 3454        locked = lock_page_or_retry(page, vma->vm_mm, vmf->flags);
> > 
> > I am only familiar with Linux RCU subsystem, hope mm people can solve our
> > confusions.
> 
> I don't understamd why you're still talking.  The problem is understood.
> You need to revert the unnecessary backport of 2799e77529c2 and
> 2efa33fc7f6e

Sorry for the delay, will go do so in a minute...

greg k-h
