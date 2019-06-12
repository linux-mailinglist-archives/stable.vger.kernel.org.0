Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD524233C
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 13:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438141AbfFLLBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 07:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438139AbfFLLBJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jun 2019 07:01:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19A30215EA;
        Wed, 12 Jun 2019 11:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560337268;
        bh=Bc8DSSK/Q4dKW34UNtmlQQLvhF3WzSmicjElN1lBdIc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TIBJgUyxfRdK8s0b1w5SkuM6q5N1Um/kDz+QYCpUeiRYTuO6CePCfvhKplIO+U9dJ
         diqzVipkM5iRgMFDL9ILseL8+kifsW7fUvo+bAlQKYc9J9s3qcXP/KCy6mX3rjTmH8
         ZkR4ZDd2vuLKSUA9dBjAARn+R5QOZ20Qfzi4zXmI=
Date:   Wed, 12 Jun 2019 13:01:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>, mingo@redhat.com,
        peterz@infradead.org, dvhart@infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] futex: Fix futex lock the wrong page
Message-ID: <20190612110105.GB22303@kroah.com>
References: <1560304465-68966-1-git-send-email-zhangxiaoxu5@huawei.com>
 <d00fc9d7-ea10-1577-40e9-03df1578acbe@huawei.com>
 <20190612071534.GA14367@kroah.com>
 <alpine.DEB.2.21.1906120917040.2214@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1906120917040.2214@nanos.tec.linutronix.de>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 12, 2019 at 09:29:48AM +0200, Thomas Gleixner wrote:
> On Wed, 12 Jun 2019, Greg KH wrote:
> > On Wed, Jun 12, 2019 at 09:50:25AM +0800, zhangxiaoxu (A) wrote:
> > > This patch is for stable branch linux-4.4-y.
> > > 
> > > On 2019/6/12 9:54, ZhangXiaoxu wrote:
> > > > The upstram commit 65d8fc777f6d ("futex: Remove requirement
> > > > for lock_page() in get_futex_key()") use variable 'page' as
> > > > the page head, when merge it to stable branch, the variable
> > > > `page_head` is page head.
> > > > 
> > > > In the stable branch, the variable `page` not means the page
> > > > head, when lock the page head, we should lock 'page_head',
> > > > rather than 'page'.
> > > > 
> > > > It maybe lead a hung task problem.
> > > > 
> > > > Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
> > > > Cc: stable@vger.kernel.org
> > > > ---
> > > >   kernel/futex.c | 4 ++--
> > > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > I do not understand.
> > 
> > Please read
> >     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > for how to submit a patch to the stable trees properly.
> > 
> > If the commit is not in Linus's tree, then we can not take it, unless
> > something is _very_ broken and it is the only way it can be resolved.
> 
> There is something _very_ broken. Upstream is correct but the 4.4. backport
> of the above commit is broken (93dcb09e29bb24a86aa7b7eff65e424f7dc98af2) in
> the way Zhang described. So it's a 4.4. only issue.

That wasn't obvious at all, and wasn't cc:ed to stable to start with...

Anyway, I'll go queue this up to the 4.4.y tree if no one objects...

thanks,

greg k-h
