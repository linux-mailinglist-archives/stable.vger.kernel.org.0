Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086473C9AEF
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 11:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhGOJEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 05:04:11 -0400
Received: from mail-vs1-f46.google.com ([209.85.217.46]:36772 "EHLO
        mail-vs1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbhGOJEK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 05:04:10 -0400
Received: by mail-vs1-f46.google.com with SMTP id o19so386382vsn.3;
        Thu, 15 Jul 2021 02:01:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wHPy6x4feXL9uDlB10yPqrmcfEqEPnqgR0YupDxTlwk=;
        b=hoGSamOJV/wvLGQnHuvS8w120eUSiiOMa+48JsjwBiO2LWtVEJroEU0vYuORBVpL7b
         C4AIBRE3dRbXb26puVhj0cvvvkxqaBR1CYEa6ct5uHB4SlOnjlnKbo1vXgY38wjotBOy
         w0dkKtK4IiIvV0i2boesXbd331+R8EzLSre4jpjjs66LlPxvPXy7wu9fXvv+RDlRqGTM
         NRG3w6DOZKtJWGl+LMTHfivC4TBEBJzNSGXwpShNZAcmMP0g5Ld/31an82ffc8CWxGpW
         ktcNen/LKYNxFWEX12fcw4LCDRsVGspYZ7CGEpXblN9uPoGkXACoy3gmdQC35RjuTrNS
         RawQ==
X-Gm-Message-State: AOAM532nLE5q3//pQdBv3gef5eFNdrVmjP2hn3oxU8owiU3Nx6yuPwuo
        oK5CuPyDOMhLks0wqUJx25S2yu/UgsExsqgfcmorEAYeIvU=
X-Google-Smtp-Source: ABdhPJyHbu5bKyE9McjVS58P54gR93m9cwPTzGItU00xvW8wNQJ6mPmFugIONz0RDU/lJAyh+7l06tep7NazsZKJYtg=
X-Received: by 2002:a67:3c2:: with SMTP id 185mr5002824vsd.42.1626339676281;
 Thu, 15 Jul 2021 02:01:16 -0700 (PDT)
MIME-Version: 1.0
References: <2b1b798e-8449-11e-e2a1-daf6a341409b@google.com>
 <YO0zXVX9Bx9QZCTs@kroah.com> <20210713182813.2fdd57075a732c229f901140@linux-foundation.org>
 <YO6r1k7CIl16o61z@kroah.com> <YO7sNd+6Vlw+hw3y@sashalap> <YO8EQZF4+iQ13QU/@mit.edu>
 <YO8Gzl2zmg8+R8Uu@kroah.com> <YO8dN9U7J2bi1gkf@mit.edu> <YO8gFgQIRYvCODBT@kroah.com>
In-Reply-To: <YO8gFgQIRYvCODBT@kroah.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 15 Jul 2021 11:01:04 +0200
Message-ID: <CAMuHMdUi+HsApqRwBDBFnfnAOs9EprDh5HCV4UncEL_cnXZasA@mail.gmail.com>
Subject: Re: 5.13.2-rc and others have many not for stable
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg et al,

On Wed, Jul 14, 2021 at 7:36 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Jul 14, 2021 at 01:21:59PM -0400, Theodore Y. Ts'o wrote:
> > On Wed, Jul 14, 2021 at 05:46:22PM +0200, Greg Kroah-Hartman wrote:
> > > The number of valid cases where someone puts a "Fixes:" tag, and that
> > > patch should NOT be backported is really really slim.  Why would you put
> > > that tag and not want to have known-broken kernels fixed?
> > >
> > > If it really is not an issue, just do not put the "Fixes:" tag?
> >
> > I think it really boils down to what the tags are supposed to mean and
> > what do they imply.
> >
> > The argument from the other side is if the Stable maintainers are
> > interpreting the Fixes: tag as an implicit "CC: stable", why should we
> > have the "Cc: stable" tag at all in that case?
>
> I would love to not have to look at the Fixes: tag, but today we have to
> because not all subsystems DO use cc: stable.
>
> We miss loads of real fixes if we only go by cc: stable right now.  If
> you can go and fix those subsystems to actually remember to do this
> "properly", wonderful, we will not have to mess with only Fixes: tags
> again.
>
> But until that happens, we have to live with what we have.  And all we
> have are "hints" like Fixes: to go off of.

IMHO the biggest issues with "Cc: stable" are that (a) in general
it's hard to know if a patch is (not) worthwhile to be backported,
and (b) without a Fixes: tag it doesn't tell you what version(s)
it should be applied to.

Just having a Fixes: tag fixes the latter, and allows you to defer
the decision to backport.

> > We could also have the policy that in the case where you have a fix
> > for a bug, but it's super subtle, and shouldn't be automatically
> > backported, that the this should be explained in the commit, e.g.,
> >
> >    This commit fixes a bug in "1adeadbeef33: lorem ipsum dolor sit
> >    amet" but it is touching code which subtle and quick to anger, the
> >    bug isn't all that serious.  So please don't backport it
> >    automatically; someone should manually do the backport and run the
> >    fooblat test before sumitting it to the stable maintainers.
>
> That's wonderful, I would love to see that more, and we do see that on
> some commits.  And we mostly catch them (I miss them at times, but
> that's my fault, not the developer/maintainers fault.)

In my experience, the hardest cases are the ones where a patch fixes
a real bug, but the fix has an obscure implicit dependency on another
commit in a different subsystem (e.g. driver and DTS interaction).
When backporting, a regression is introduced if the dependency
is not present yet in the stable tree.

> > Andrew seems to be of the opinion that these sorts of cases are very
> > common.  I don't have enough data to have a strong opinion either way.
> > But if you are right that it is a rare case, then sure, simply
> > omitting the Fixes: tag and using text in the commit description would
> > work.  We just need to agree that this is the convention that we all
> > shoulf be using.
> >
> > I still wonder though what's the point of having the "Cc: stable" tag
> > if it's implicitly assumed to be there if there is a Fixes: tagle.
>
> Because cc: stable came first, and for some reason people think that it
> is all that is necessary to get patches committed to the stable tree,
> despite it never being documented or that way.  I have to correct
> someone about this about 2x a month on the stable@vger list.

For a developer, it's much easier to not care about "Cc: stable"
at all, because as soon as you add a "Cc: stable" to a patch, or CC
stable, someone will compain ;-)  Much easier to just add a Fixes: tag,
and know it will be backported to trees that have the "buggy" commit.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
