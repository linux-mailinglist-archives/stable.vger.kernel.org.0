Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F3B3D34FA
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 09:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbhGWGVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 02:21:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234089AbhGWGVe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Jul 2021 02:21:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F252A60EE2;
        Fri, 23 Jul 2021 07:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627023728;
        bh=02LUfP9gRBAKznttDT6gEA8Wm5l4jpvhTQOhmSmp6TY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oYElD2rhN77kwhk3cHbdJs1c1K4EEL9wI8fe4Uw3mOaPEtxJSMnhDjUPbEEf1SAzA
         YEHykz6fGqLgjZZ4asnYJ3GIswCFOu2g/Z98w+hF9lyqReoghUDstiJGuK44r8OyR6
         EhDzQXwJgbKvoHxsJjXUSHkuXAx5ulAcvQyMelNA=
Date:   Fri, 23 Jul 2021 09:02:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Miaohe Lin <linmiaohe@huawei.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Zhouyi Zhou <zhouzhouyi@gmail.com>,
        Chris Clayton <chris2553@googlemail.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
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
Message-ID: <YPppbUqSPTNcm3f9@kroah.com>
References: <YPVtBBumSTMKGuld@casper.infradead.org>
 <2237123.PRLUojbHBq@natalenko.name>
 <CAABZP2w4VKRPjNz+TW1_n=NhGw=CBNccMp-WGVRy32XxAVobRg@mail.gmail.com>
 <CAABZP2yh3J8+P=3PLZVaC47ymKC7PcfQCBBxjXJ9Ybn+HREbdg@mail.gmail.com>
 <fb8b8639-bf2d-161e-dc9a-6a63bf9db46e@googlemail.com>
 <CAABZP2xST9787xNujWeKODEW79KpjL7vHtqYjjGxOwoqXSWXDQ@mail.gmail.com>
 <YPlmMnZKgkcLderp@casper.infradead.org>
 <YPlyHF5eNDiTMKzq@kroah.com>
 <YPl5+PkfBPI0pdHn@kroah.com>
 <01fef2db-bd7e-12b6-ec21-2addd02e7062@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01fef2db-bd7e-12b6-ec21-2addd02e7062@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 23, 2021 at 09:51:09AM +0800, Miaohe Lin wrote:
> On 2021/7/22 22:00, Greg KH wrote:
> > On Thu, Jul 22, 2021 at 03:26:52PM +0200, Greg KH wrote:
> >> On Thu, Jul 22, 2021 at 01:36:02PM +0100, Matthew Wilcox wrote:
> >>> On Thu, Jul 22, 2021 at 04:57:57PM +0800, Zhouyi Zhou wrote:
> >>>> Thanks for reviewing,
> >>>>
> >>>> What I have deduced from the dmesg  is:
> >>>> In function do_swap_page,
> >>>> after invoking
> >>>> 3385        si = get_swap_device(entry); /* rcu_read_lock */
> >>>> and before
> >>>> 3561    out:
> >>>> 3562        if (si)
> >>>> 3563            put_swap_device(si);
> >>>> The thread got scheduled out in
> >>>> 3454        locked = lock_page_or_retry(page, vma->vm_mm, vmf->flags);
> >>>>
> >>>> I am only familiar with Linux RCU subsystem, hope mm people can solve our
> >>>> confusions.
> >>>
> >>> I don't understamd why you're still talking.  The problem is understood.
> >>> You need to revert the unnecessary backport of 2799e77529c2 and
> >>> 2efa33fc7f6e
> >>
> >> Sorry for the delay, will go do so in a minute...
> > 
> > Both now reverted from 5.10.y and 5.13.y.
> > 
> 
> I browsed my previous backport notifying email and found that these two patches are also
> backported into 5.12. And it seems it's missed.

5.12 is now end-of-life, it's not being touched anymore, and no one
should continue to use it.

thanks,

greg k-h
