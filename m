Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE881F55F1
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 15:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbgFJNje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 09:39:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgFJNje (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jun 2020 09:39:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6672920734;
        Wed, 10 Jun 2020 13:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591796372;
        bh=gkee2SSh/tFEinUnp6fT1LIiPzohJCb+C+stHUJ09dY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CO13W9F92shT+aA9iAl5lqYg1YbAF0qIe8ka4qfRmO933FtHAMng0a8vLbIWMNys4
         Kpw8tw/B7AyEmw6UIvFdH49brlhEUGIKtpKQaxCwqLl8A0UszhAAhgsYZCIs8Kt4SZ
         sr5AihGfkM+7DwIKK+DZKA/ZuA7q9XXSqNCX/RsQ=
Date:   Wed, 10 Jun 2020 15:39:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>,
        kernel test robot <rong.a.chen@intel.com>
Subject: Re: [PATCH 4.19.y] selftests: bpf: fix use of undeclared RET_IF macro
Message-ID: <20200610133926.GA1907610@kroah.com>
References: <20200521144841.7074-1-lmb@cloudflare.com>
 <20200522000934.GM33628@sasha-vm>
 <CACAyw9-FH7e5fXAU923xSN9ENtyBo+FkqHnd7WAbpyhnz=X9MA@mail.gmail.com>
 <20200610114956.GA1896587@kroah.com>
 <CACAyw98w=hQX+ZKc-wdGfUN_XmvrRJJ9y=1TB5=XuYSgUUnffA@mail.gmail.com>
 <20200610122413.GA1900758@kroah.com>
 <CACAyw99_zMbHJ1Rzs_r7hHm7D10SBt1nkqWW1MUP9khEHqC2Nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw99_zMbHJ1Rzs_r7hHm7D10SBt1nkqWW1MUP9khEHqC2Nw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 10, 2020 at 02:34:16PM +0100, Lorenz Bauer wrote:
> On Wed, 10 Jun 2020 at 13:24, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Jun 10, 2020 at 01:10:14PM +0100, Lorenz Bauer wrote:
> > > On Wed, 10 Jun 2020 at 12:50, Greg KH <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Wed, Jun 10, 2020 at 11:16:16AM +0100, Lorenz Bauer wrote:
> > > > > On Fri, 22 May 2020 at 01:09, Sasha Levin <sashal@kernel.org> wrote:
> > > > > >
> > > > > > On Thu, May 21, 2020 at 03:48:41PM +0100, Lorenz Bauer wrote:
> > > > > > >commit 634efb750435 ("selftests: bpf: Reset global state between
> > > > > > >reuseport test runs") uses a macro RET_IF which doesn't exist in
> > > > > > >the v4.19 tree. It is defined as follows:
> > > > > > >
> > > > > > >        #define RET_IF(condition, tag, format...) ({
> > > > > > >                if (CHECK_FAIL(condition)) {
> > > > > > >                        printf(tag " " format);
> > > > > > >                        return;
> > > > > > >                }
> > > > > > >        })
> > > > > > >
> > > > > > >CHECK_FAIL in turn is defined as:
> > > > > > >
> > > > > > >        #define CHECK_FAIL(condition) ({
> > > > > > >                int __ret = !!(condition);
> > > > > > >                int __save_errno = errno;
> > > > > > >                if (__ret) {
> > > > > > >                        test__fail();
> > > > > > >                        fprintf(stdout, "%s:FAIL:%d\n", __func__, __LINE__);
> > > > > > >                }
> > > > > > >                errno = __save_errno;
> > > > > > >                __ret;
> > > > > > >        })
> > > > > > >
> > > > > > >Replace occurences of RET_IF with CHECK. This will abort the test binary
> > > > > > >if clearing the intermediate state fails.
> > > > > > >
> > > > > > >Fixes: 634efb750435 ("selftests: bpf: Reset global state between reuseport test runs")
> > > > > > >Reported-by: kernel test robot <rong.a.chen@intel.com>
> > > > > > >Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > > > > >
> > > > > > Thanks for the backport Lorenz. We'll need to wait for it to make it
> > > > > > into Linus's tree before queueing up for the stable trees.
> > > > >
> > > > > Apologies for sending the patch too early (?), I'm still new to this process.
> > > > > I've just hit this on 4.19.127. Do you want me to re-submit the patch somewhere?
> > > >
> > > > Is this patch in Linus's tree yet?  If so, just tell us the git commit
> > > > id.  If not, it needs to go there first before we can take it to any
> > > > stable tree.
> > >
> > > The patch isn't in Linus' tree because the problem doesn't exist
> > > there. It fixes a build problem on
> > > v4.19 which was introduced by the backport of an earlier fix of mine,
> > > commit 634efb750435
> > > ("selftests: bpf: Reset global state between reuseport test runs").
> > >
> > > There is a similar fix from Andrii Nakryiko that went into 5.4 as
> > > commit aee43146cc10
> > > ("selftest/bpf: fix backported test_select_reuseport selftest
> > > changes"), which I hadn't seen
> > > at the time.
> >
> > Ah, ok, that wasn't very obvious, sorry.  I'll queue this up after the
> > next round of kernels are released in a day or so...
> 
> No, it was my bad. What can I do to avoid this next time?

Be _VERY_ explicit as to why this is only a 4.19 patch, and what this
means, and why it is so.  We see hundreds of patches a day, and almost
none of them are this type of "special" case, so it must have to
stand-out as you are doing something not very usual.

thanks,

greg k-h
