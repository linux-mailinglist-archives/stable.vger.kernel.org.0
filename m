Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529FC2D5EAD
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 15:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389750AbgLJOyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732597AbgLJOyC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 09:54:02 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C061AC0613CF
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 06:53:21 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id r17so5527764ilo.11
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 06:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yeZ8gIpFQsdSytGiB9IK+Ej4WbbINVDqeD0QoV2QEwU=;
        b=sGOYKdxnXRmFw5udWeVygXWbrL6g3yiJyReDFX9DIaEv628Z7gfbmlTa3kV3ns0RN8
         Fm1hmLyYbAWmRyjVWy1rtzvy+vmE+/IoPOU8IUz2xIJ32sQpMaA30H1dd54Mm7Ol0gg8
         6sSUPrSmgh7z+8FJdBa/K1wFx8EyO+GQm7RYE/KH7XMgatjcsoOh4+TAIZ4xALtUTYaH
         bz6lY8HFcaHavaP4r2F4f86sSAHml6Xod2/I4wsTr7vG44Xw43bNUwmtTET4hhN/QlhU
         uVav9FGOugP1h0qX4VYIsasf6cflBksuVHCvM7JSx3Ui7OMiuAb/eK73JOrd9L8gVkW3
         Vogw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yeZ8gIpFQsdSytGiB9IK+Ej4WbbINVDqeD0QoV2QEwU=;
        b=C/gn3fOzUaZaeTTbaPXClmKqYeQUSkAPii5yfICfAw84lFCEFdqYULzXw5Gi9gSXNe
         IhOdfUTe97uTF0EZStyWjY571zyha/lVVIuNLZIYFxxdLAac85IiZRfgqEh2DaDQP8a+
         JabFHS9rExNFW7olT42rDUQgMjJkyU73i/I4VNJT+RMwp2bqi5L6LhbrTwsIHNxn/S/M
         srJI6keZR5Ow9ACWN/me2V4hjmjScZuAZHkfyr83tEzHrAvz6V5P2LS7luV5S+iynika
         8n0fl3Un+LqwrfaILCcGeDQuI7y6Q6YmdOdQYwPxTtgm67rNlLgTg6rRZNs1Jl01JnBF
         gtgA==
X-Gm-Message-State: AOAM530yzlrnA27TS8arYnTsqtki1qSdmPWBg220YTUyQfVW6wa/dESt
        Xwho84M+e/1YPqb+0YDtHc6DACGZI29DgsAhe31L7A==
X-Google-Smtp-Source: ABdhPJy5mH//MsFyk06EpBitTVKJlWGMGAVTvIaoL59lVVaI5t7OU/A4NxGApzRE+TNC3wIGYeMn8E98UVXCaEeO3bI=
X-Received: by 2002:a92:da82:: with SMTP id u2mr9289009iln.137.1607612001021;
 Thu, 10 Dec 2020 06:53:21 -0800 (PST)
MIME-Version: 1.0
References: <20201210142600.887734129@linuxfoundation.org> <20201210142601.652963609@linuxfoundation.org>
 <CANn89iK=kMSkT771iL0dybnWisXr9FWW-bffa5KB+McBYrxx4g@mail.gmail.com>
 <X9Iy9EDh2gZgth+R@kroah.com> <X9IzaHjsIjcn3XNX@kroah.com>
In-Reply-To: <X9IzaHjsIjcn3XNX@kroah.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 10 Dec 2020 15:53:09 +0100
Message-ID: <CANn89iLFCBVOzPhwSxmAnT6dx8fnRD4TYRSJaX2ni7AxvXKEGg@mail.gmail.com>
Subject: Re: [PATCH 4.4 15/39] geneve: pull IP header before ECN decapsulation
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 3:40 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Dec 10, 2020 at 03:38:44PM +0100, Greg Kroah-Hartman wrote:
> > On Thu, Dec 10, 2020 at 03:32:12PM +0100, Eric Dumazet wrote:
> > > On Thu, Dec 10, 2020 at 3:26 PM Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > From: Eric Dumazet <edumazet@google.com>
> > > >
> > > > IP_ECN_decapsulate() and IP6_ECN_decapsulate() assume
> > > > IP header is already pulled.
> > > >
> > > > geneve does not ensure this yet.
> > > >
> > > > Fixing this generically in IP_ECN_decapsulate() and
> > > > IP6_ECN_decapsulate() is not possible, since callers
> > > > pass a pointer that might be freed by pskb_may_pull()
> > > >
> > > > syzbot reported :
> > > >
> > >
> > > Note that we had to revert this patch, so you can either scratp this
> > > backport, or make sure to backport the revert.
> >
> > I'll drop it thanks.  Odd I lost the upstream git id on this patch, let
> > me check what went wrong...
>
> What is the git id of the revert?  This ended up already in 4.19.y,
> 5.4.y, and 5.9.y so needs to be reverted there.
>

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=c02bd115b1d25931159f89c7d9bf47a30f5d4b41

Thanks !

> thanks,
>
> greg k-h
