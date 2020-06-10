Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241BA1F53CF
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 13:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgFJLuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 07:50:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728468AbgFJLuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jun 2020 07:50:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E463D2072E;
        Wed, 10 Jun 2020 11:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591789802;
        bh=NKotJy6EffETX1HAp16Y4hYtAVr+/sFNjg7AlDwxC88=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ggawG37+nOkNqvN+gLxO8WDGCsMQn8CmZQsiDA7pRgK+UDZeroasLTY//jCjIS9gX
         7QpXWuQS899kefbUlg92n2/bNQtUGLjCmGzvNK8UIrLVAp9XF5Uo6C+CIQrrR8/2sn
         UQcRteZ6NFxg3yBv9TY3oUjRToXGY/DyhwTmcmO0=
Date:   Wed, 10 Jun 2020 13:49:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>,
        kernel test robot <rong.a.chen@intel.com>
Subject: Re: [PATCH 4.19.y] selftests: bpf: fix use of undeclared RET_IF macro
Message-ID: <20200610114956.GA1896587@kroah.com>
References: <20200521144841.7074-1-lmb@cloudflare.com>
 <20200522000934.GM33628@sasha-vm>
 <CACAyw9-FH7e5fXAU923xSN9ENtyBo+FkqHnd7WAbpyhnz=X9MA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw9-FH7e5fXAU923xSN9ENtyBo+FkqHnd7WAbpyhnz=X9MA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 10, 2020 at 11:16:16AM +0100, Lorenz Bauer wrote:
> On Fri, 22 May 2020 at 01:09, Sasha Levin <sashal@kernel.org> wrote:
> >
> > On Thu, May 21, 2020 at 03:48:41PM +0100, Lorenz Bauer wrote:
> > >commit 634efb750435 ("selftests: bpf: Reset global state between
> > >reuseport test runs") uses a macro RET_IF which doesn't exist in
> > >the v4.19 tree. It is defined as follows:
> > >
> > >        #define RET_IF(condition, tag, format...) ({
> > >                if (CHECK_FAIL(condition)) {
> > >                        printf(tag " " format);
> > >                        return;
> > >                }
> > >        })
> > >
> > >CHECK_FAIL in turn is defined as:
> > >
> > >        #define CHECK_FAIL(condition) ({
> > >                int __ret = !!(condition);
> > >                int __save_errno = errno;
> > >                if (__ret) {
> > >                        test__fail();
> > >                        fprintf(stdout, "%s:FAIL:%d\n", __func__, __LINE__);
> > >                }
> > >                errno = __save_errno;
> > >                __ret;
> > >        })
> > >
> > >Replace occurences of RET_IF with CHECK. This will abort the test binary
> > >if clearing the intermediate state fails.
> > >
> > >Fixes: 634efb750435 ("selftests: bpf: Reset global state between reuseport test runs")
> > >Reported-by: kernel test robot <rong.a.chen@intel.com>
> > >Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> >
> > Thanks for the backport Lorenz. We'll need to wait for it to make it
> > into Linus's tree before queueing up for the stable trees.
> 
> Apologies for sending the patch too early (?), I'm still new to this process.
> I've just hit this on 4.19.127. Do you want me to re-submit the patch somewhere?

Is this patch in Linus's tree yet?  If so, just tell us the git commit
id.  If not, it needs to go there first before we can take it to any
stable tree.

thanks,

greg k-h
