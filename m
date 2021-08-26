Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D423F8F1A
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 21:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243499AbhHZTr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 15:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243496AbhHZTr0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 15:47:26 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E0AC0613C1
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 12:46:38 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id n24so5197210ion.10
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 12:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W8kFVRLQYAesDVBxw8WdPC0As1KdCG134iI/ODY2Y1Y=;
        b=nKi+TXGJ7ujecbEHxzXU7dV0s9QVYGm3fq19pyC76e7VF80u0pqHzxFWXNGXd7Q0W6
         q+KkLjUzofYGedVr9f4tCicjHYbo6TKFaabPsSk3ZF29izDbmCcBkS0H3q3QHctKgMTy
         /Zn+PvwsDS4mrbz36eTZRZs199Pqibc3QDGDCWbcYu57cU3F3NNCjz35WwM3pw+GFTVc
         HpliF9G1dtalQe47kZy2kG9svB11c7EtcF7xZQVkCZ2TjFi5lNnxrYJnN6h6IA00IJ8z
         BHTQ6bMNNU+ueTlRgkxgeBGM5pNFAyBvBnmFJHOAb0xaRvklgXfc8ocs6X7pR2N1w67H
         kbHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W8kFVRLQYAesDVBxw8WdPC0As1KdCG134iI/ODY2Y1Y=;
        b=iqClS8k4rlwML08yAzA/RgR3hR0k/2lWBarhpzTx5z6Y3G1snm8tKvLSp3Z1y4oMdx
         55NlnZIP/UEfVXvV5pWj7lpW3l/9upd2W5S7f7I+Rk26lsWHEBbbndtFceacHcG5D84p
         DpiSNHLdf1oAKoMzG7Qg4iLN4S5DXrZodTyJmINTeHlZo+EvKB1pXWr5qSjLH5B5Qcyo
         CkiTh4WZm3XLDxvxI+oK1dURUbL6NjMwK4JIx24ieuDRvbxFOnKpfb0isW16MU3af6kJ
         o3BEuqnUHLeZFQ+TNARJnpndW6+nMFthwEXFd47gF8TcSbasDl5YQAqeO/JjgTKd/h/K
         cI5A==
X-Gm-Message-State: AOAM5321NkuKcFG1jFC1zE2oDwnBeXGC1fZo0+E0Kod0SpJsfQmf8/+/
        9cNckKnaAD0hleLkqra92w33PQdonMuP2r/lF6Btig==
X-Google-Smtp-Source: ABdhPJwdOThufTbwmrsrSHbN9TM7Lh/yHgwXnAtct0tgQ1dnf0UERIoytNbfjVlu0wHDov2HMm2WPHkKEh44DQcwOxE=
X-Received: by 2002:a05:6602:2ac7:: with SMTP id m7mr4404288iov.66.1630007197520;
 Thu, 26 Aug 2021 12:46:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210826012722.3210359-1-pcc@google.com> <11f72b27c12f46eb8bef1d1773980c54@AcuMS.aculab.com>
In-Reply-To: <11f72b27c12f46eb8bef1d1773980c54@AcuMS.aculab.com>
From:   Peter Collingbourne <pcc@google.com>
Date:   Thu, 26 Aug 2021 12:46:26 -0700
Message-ID: <CAMn1gO5eT=S-BcbhDDM9=s5r1zspO==nbJjYV-p9JFq-U5U+eA@mail.gmail.com>
Subject: Re: [PATCH] net: don't unconditionally copy_from_user a struct ifreq
 for socket ioctls
To:     David Laight <David.Laight@aculab.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 26, 2021 at 1:12 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Peter Collingbourne
> > Sent: 26 August 2021 02:27
> >
> > A common implementation of isatty(3) involves calling a ioctl passing
> > a dummy struct argument and checking whether the syscall failed --
> > bionic and glibc use TCGETS (passing a struct termios), and musl uses
> > TIOCGWINSZ (passing a struct winsize). If the FD is a socket, we will
> > copy sizeof(struct ifreq) bytes of data from the argument and return
> > -EFAULT if that fails. The result is that the isatty implementations
> > may return a non-POSIX-compliant value in errno in the case where part
> > of the dummy struct argument is inaccessible, as both struct termios
> > and struct winsize are smaller than struct ifreq (at least on arm64).
> >
> > Although there is usually enough stack space following the argument
> > on the stack that this did not present a practical problem up to now,
> > with MTE stack instrumentation it's more likely for the copy to fail,
> > as the memory following the struct may have a different tag.
> >
> > Fix the problem by adding an early check for whether the ioctl is a
> > valid socket ioctl, and return -ENOTTY if it isn't.
> ..
> > +bool is_dev_ioctl_cmd(unsigned int cmd)
> > +{
> > +     switch (cmd) {
> > +     case SIOCGIFNAME:
> > +     case SIOCGIFHWADDR:
> > +     case SIOCGIFFLAGS:
> > +     case SIOCGIFMETRIC:
> > +     case SIOCGIFMTU:
> > +     case SIOCGIFSLAVE:
> > +     case SIOCGIFMAP:
> > +     case SIOCGIFINDEX:
> > +     case SIOCGIFTXQLEN:
> > +     case SIOCETHTOOL:
> > +     case SIOCGMIIPHY:
> > +     case SIOCGMIIREG:
> > +     case SIOCSIFNAME:
> > +     case SIOCSIFMAP:
> > +     case SIOCSIFTXQLEN:
> > +     case SIOCSIFFLAGS:
> > +     case SIOCSIFMETRIC:
> > +     case SIOCSIFMTU:
> > +     case SIOCSIFHWADDR:
> > +     case SIOCSIFSLAVE:
> > +     case SIOCADDMULTI:
> > +     case SIOCDELMULTI:
> > +     case SIOCSIFHWBROADCAST:
> > +     case SIOCSMIIREG:
> > +     case SIOCBONDENSLAVE:
> > +     case SIOCBONDRELEASE:
> > +     case SIOCBONDSETHWADDR:
> > +     case SIOCBONDCHANGEACTIVE:
> > +     case SIOCBRADDIF:
> > +     case SIOCBRDELIF:
> > +     case SIOCSHWTSTAMP:
> > +     case SIOCBONDSLAVEINFOQUERY:
> > +     case SIOCBONDINFOQUERY:
> > +     case SIOCGIFMEM:
> > +     case SIOCSIFMEM:
> > +     case SIOCSIFLINK:
> > +     case SIOCWANDEV:
> > +     case SIOCGHWTSTAMP:
> > +             return true;
>
> That is horrid.
> Can't you at least use _IOC_TYPE() to check for socket ioctls.
> Clearly it can succeed for 'random' driver ioctls, but will fail
> for the tty ones.

Yes, that works, since all of the ioctls listed above are in the range
where the _IOC_TYPE() check would succeed. It now also makes sense to
move the check inline into the header. I've done all of that in v2.

> The other sane thing is to check _IOC_SIZE().
> Since all the SIOCxxxx have a correct _IOC_SIZE() that can be
> used to check the user copy length.
> (Unlike socket options the correct length is always supplied.

FWIW, it doesn't look like any of them have the _IOC_SIZE() bits set,
so that won't work. _IOC_TYPE() seems better anyway.

Peter
