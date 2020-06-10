Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296931F5448
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 14:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbgFJMKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 08:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728595AbgFJMK2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 08:10:28 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC6BC03E96B
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 05:10:26 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id k15so1492927otp.8
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 05:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WUrCAPWVudAwx0nKcvHlsR94Nf0WTN78Z81RgKK/xJQ=;
        b=Lkgv/n03Kdayoux/BM5N1oDg0Fwq2x2Ikuz+HqY9q3DNDYw6teqhfrUn/9pMz+uw8T
         xz30wUYA2bouM7e+AMxH0vBRm89LdqJKKYrxO3UZnpdQh52yEK6SN7ZMjKfmR2C/uK91
         MNtvSRnHCogKo0Xoa370KZMD0BQVzQFnZKwsU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WUrCAPWVudAwx0nKcvHlsR94Nf0WTN78Z81RgKK/xJQ=;
        b=O4iVp0P2cba5n42h+Tru7gcCTa8DKBHB9NpfBNiK5cBVTMbH4RzgbPwCq+Ylt4+yVy
         gbTioQy1IOA1xvaH/cY9diHj7DELvsqhEg2qsaG/1RbP1/hRA2/SKHFfcdH85hNVCmHP
         nNOdudkjcO1Xkhuo18UEmiW9bmf//dWQ4dfY4Uk0SXZVm/KjchHHcb20v5zVKH8dP0TT
         EE1nwSQQZTgDVVFsPwBRHS5rch7r1LJ9oSAzzRrG0wE4hCsWYbM9SsPzLjksTdVkiMbe
         GryPbX2OvMiudyfDc9lv2VGjLKbWSq6HJMYAhdzOETR516kgxepieQTfG6G2lhYMsRRA
         hVIA==
X-Gm-Message-State: AOAM531Vu8LtvfjeSQzSaiLQ+LVBcHkmVw/Enr75KBw9baM80a8iO9C2
        wOxrMSxidqF5Uf1wcnioJ/Rb8XmtdAK4QUhBIUvERA==
X-Google-Smtp-Source: ABdhPJwq9ABWlnGp9eYgDC9+qrTB7wgRtlv7QyTD3+zMGOILFZ6YYtsKHXwETSQEmzQjbeyUIZGlRCypDHnxg6bMXyg=
X-Received: by 2002:a9d:7f06:: with SMTP id j6mr2301899otq.132.1591791025788;
 Wed, 10 Jun 2020 05:10:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200521144841.7074-1-lmb@cloudflare.com> <20200522000934.GM33628@sasha-vm>
 <CACAyw9-FH7e5fXAU923xSN9ENtyBo+FkqHnd7WAbpyhnz=X9MA@mail.gmail.com> <20200610114956.GA1896587@kroah.com>
In-Reply-To: <20200610114956.GA1896587@kroah.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 10 Jun 2020 13:10:14 +0100
Message-ID: <CACAyw98w=hQX+ZKc-wdGfUN_XmvrRJJ9y=1TB5=XuYSgUUnffA@mail.gmail.com>
Subject: Re: [PATCH 4.19.y] selftests: bpf: fix use of undeclared RET_IF macro
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>,
        kernel test robot <rong.a.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Jun 2020 at 12:50, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Jun 10, 2020 at 11:16:16AM +0100, Lorenz Bauer wrote:
> > On Fri, 22 May 2020 at 01:09, Sasha Levin <sashal@kernel.org> wrote:
> > >
> > > On Thu, May 21, 2020 at 03:48:41PM +0100, Lorenz Bauer wrote:
> > > >commit 634efb750435 ("selftests: bpf: Reset global state between
> > > >reuseport test runs") uses a macro RET_IF which doesn't exist in
> > > >the v4.19 tree. It is defined as follows:
> > > >
> > > >        #define RET_IF(condition, tag, format...) ({
> > > >                if (CHECK_FAIL(condition)) {
> > > >                        printf(tag " " format);
> > > >                        return;
> > > >                }
> > > >        })
> > > >
> > > >CHECK_FAIL in turn is defined as:
> > > >
> > > >        #define CHECK_FAIL(condition) ({
> > > >                int __ret = !!(condition);
> > > >                int __save_errno = errno;
> > > >                if (__ret) {
> > > >                        test__fail();
> > > >                        fprintf(stdout, "%s:FAIL:%d\n", __func__, __LINE__);
> > > >                }
> > > >                errno = __save_errno;
> > > >                __ret;
> > > >        })
> > > >
> > > >Replace occurences of RET_IF with CHECK. This will abort the test binary
> > > >if clearing the intermediate state fails.
> > > >
> > > >Fixes: 634efb750435 ("selftests: bpf: Reset global state between reuseport test runs")
> > > >Reported-by: kernel test robot <rong.a.chen@intel.com>
> > > >Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > >
> > > Thanks for the backport Lorenz. We'll need to wait for it to make it
> > > into Linus's tree before queueing up for the stable trees.
> >
> > Apologies for sending the patch too early (?), I'm still new to this process.
> > I've just hit this on 4.19.127. Do you want me to re-submit the patch somewhere?
>
> Is this patch in Linus's tree yet?  If so, just tell us the git commit
> id.  If not, it needs to go there first before we can take it to any
> stable tree.

The patch isn't in Linus' tree because the problem doesn't exist
there. It fixes a build problem on
v4.19 which was introduced by the backport of an earlier fix of mine,
commit 634efb750435
("selftests: bpf: Reset global state between reuseport test runs").

There is a similar fix from Andrii Nakryiko that went into 5.4 as
commit aee43146cc10
("selftest/bpf: fix backported test_select_reuseport selftest
changes"), which I hadn't seen
at the time.

Lorenz

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
