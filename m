Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DEF1EF4B7
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 11:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgFEJym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 05:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgFEJyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 05:54:41 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9D7C08C5C3
        for <stable@vger.kernel.org>; Fri,  5 Jun 2020 02:54:40 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id g9so6945536edw.10
        for <stable@vger.kernel.org>; Fri, 05 Jun 2020 02:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kQ16o+qUwgYcoh0hZifP35qFFRDEvSaPDsLpEh1ikCk=;
        b=rCaoirU7A0HN6aBgr2LdE3yr5g17a+UroWILMuXJVVtYCBdmWed1GS8GwUni1Mn4bs
         WiCixcK2FEbDfiqcT5aI8OwT4CDrGCx8TZ3kDHlnVgJ+ErAZ6buF8PeNt5p6EhEJTg76
         RwBhpNX0IUheJeDrz936ea+31jUlqJ1kNQaSM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kQ16o+qUwgYcoh0hZifP35qFFRDEvSaPDsLpEh1ikCk=;
        b=tDLDZ/uSRdf4VAWx8XMr7qvRkcFAqgSys95SrP7Dg2a5keKBg02t/9MIrPDHYz7otp
         w7LvBlAmmrLFOrKG2dihCools0plTwoLzSaXbSNk9/OUmwav67VZ+O3mkog0K6vjn5DC
         P92HJ2mILY1zcKSJ2aWRhhfOhrlHBDwuMTibbG2E0+ozzUXtZtFkMWelx7FeGpdDa9zj
         b4NsGIi7s/pOlgzCKrojBAI64PWsgqM99uGzYTUy9q7GPthISdzyJkwRQfcERE1rmEtl
         js7IuGZu+MJLKReUpO6EHidfqGvzIYbp80kxBrXB699p66HPFv872RnGXpM5wTbl1zCR
         c4bw==
X-Gm-Message-State: AOAM53262CnsuP+2fTFpk1m1Ac1eVL/xp6ZikbiYgDBIM7keZvDDu84L
        3RFrhK5hnwFVsNGHB12JjJy4bnXQLP+TNdWlH77Uog==
X-Google-Smtp-Source: ABdhPJxPXhJVSPka5expBk13ruYWdBASBt1uTHiBSxAcue4V3qBGXozjJwtdDHlzLpa3GAZtoYQwqOkGqSuOZOhiOKI=
X-Received: by 2002:aa7:d785:: with SMTP id s5mr8857980edq.17.1591350879015;
 Fri, 05 Jun 2020 02:54:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200604084245.161480-1-glider@google.com> <202006040844.C50B47699@keescook>
In-Reply-To: <202006040844.C50B47699@keescook>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 5 Jun 2020 11:54:27 +0200
Message-ID: <CAJfpegsNL17k+Yv1-4bmogqjzq-rO9H1xT-+DM2m7qq7oH25MQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: explicitly initialize error in ovl_copy_xattr()
To:     Kees Cook <keescook@chromium.org>
Cc:     Alexander Potapenko <glider@google.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org, royyang@google.com,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 4, 2020 at 5:57 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Jun 04, 2020 at 10:42:45AM +0200, glider@google.com wrote:
> > Under certain circumstances (we found this out running Docker on a
> > Clang-built kernel with CONFIG_INIT_STACK_ALL) ovl_copy_xattr() may
> > return uninitialized value of |error| from ovl_copy_xattr().
> > It is then returned by ovl_create() to lookup_open(), which casts it to
> > an invalid dentry pointer, that can be further read or written by the
> > lookup_open() callers.
> >
> > The uninitialized value is returned when all the xattr on the file
> > are ovl_is_private_xattr(), which is actually a successful case,
> > therefore we initialize |error| with 0.
> >
> > Signed-off-by: Alexander Potapenko <glider@google.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Roy Yang <royyang@google.com>
> > Cc: <stable@vger.kernel.org> # 4.1
>
> Please include a Fixes (more below) and Link tags for details to help
> guide backporting, then you don't need to bother with with "# 4.1",
> the -stable tools will figure it out with a "Fixes" tag.
>
> Thanks for the v2!
>
> Link: https://bugs.chromium.org/p/chromium/issues/detail?id=1050405
> Reviewed-by: Kees Cook <keescook@chromium.org>
>
> > The bug seem to date back to at least v4.1 where the annotation has been
> > introduced (i.e. the compilers started noticing error could be used
> > before being initialized). I hovever didn't try to prove that the
> > problem is actually reproducible on such ancient kernels. We've seen it
> > on a real machine running v4.4 as well.
>
> It seems like it came from this, but that's v4.5:
>
> Fixes: e4ad29fa0d22 ("ovl: use a minimal buffer in ovl_copy_xattr")


I believe it's actually:

Fixes: 0956254a2d5b ("ovl: don't copy up opaqueness")

That patch added the ovl_is_private_xattr() check in ovl_copy_xattr(),
without which 'error' was always initilalized.

Thanks,
Miklos
