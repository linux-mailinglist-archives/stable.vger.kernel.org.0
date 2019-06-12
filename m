Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA70341DC0
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 09:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406311AbfFLHaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 03:30:03 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:60451 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406252AbfFLHaD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 03:30:03 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1haxhd-0006Lj-Gk; Wed, 12 Jun 2019 09:29:49 +0200
Date:   Wed, 12 Jun 2019 09:29:48 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Greg KH <gregkh@linuxfoundation.org>
cc:     "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>, mingo@redhat.com,
        peterz@infradead.org, dvhart@infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] futex: Fix futex lock the wrong page
In-Reply-To: <20190612071534.GA14367@kroah.com>
Message-ID: <alpine.DEB.2.21.1906120917040.2214@nanos.tec.linutronix.de>
References: <1560304465-68966-1-git-send-email-zhangxiaoxu5@huawei.com> <d00fc9d7-ea10-1577-40e9-03df1578acbe@huawei.com> <20190612071534.GA14367@kroah.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 12 Jun 2019, Greg KH wrote:
> On Wed, Jun 12, 2019 at 09:50:25AM +0800, zhangxiaoxu (A) wrote:
> > This patch is for stable branch linux-4.4-y.
> > 
> > On 2019/6/12 9:54, ZhangXiaoxu wrote:
> > > The upstram commit 65d8fc777f6d ("futex: Remove requirement
> > > for lock_page() in get_futex_key()") use variable 'page' as
> > > the page head, when merge it to stable branch, the variable
> > > `page_head` is page head.
> > > 
> > > In the stable branch, the variable `page` not means the page
> > > head, when lock the page head, we should lock 'page_head',
> > > rather than 'page'.
> > > 
> > > It maybe lead a hung task problem.
> > > 
> > > Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >   kernel/futex.c | 4 ++--
> > >   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> I do not understand.
> 
> Please read
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to submit a patch to the stable trees properly.
> 
> If the commit is not in Linus's tree, then we can not take it, unless
> something is _very_ broken and it is the only way it can be resolved.

There is something _very_ broken. Upstream is correct but the 4.4. backport
of the above commit is broken (93dcb09e29bb24a86aa7b7eff65e424f7dc98af2) in
the way Zhang described. So it's a 4.4. only issue.

Thanks,

	tglx
