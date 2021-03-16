Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C9133D148
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 11:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236061AbhCPKAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 06:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236023AbhCPJ7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 05:59:49 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDB1C061756
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 02:59:49 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id x19so36214277ybe.0
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 02:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oS0wCpVx3xA1BGt0eSk6Ptge/SvVGNTwNTTh7VAehEA=;
        b=P5tAdogxKo5oUR+g0clyfKKbPAZSjFx5bu8+aANk+hLgy1ZbZ9r/rRnb3CT+4kPiHX
         A57WvJ1U+WXI+5jTjXeZpjH4vwCn2byUJDn3dJfgZiH2oIW8nVzf+0oApxu3gA42K/UO
         faPO3vzbVNU+EKKCx10KKmdOGQ2a9eaLJeqHePbaB1P4UIB8115z5QQEx/G8DWMtHZup
         YLF+jg1giJOTBX3byVjAOdvzSPdzUUXlrA58jumni4GUCmPc+XFe4JsfPmqoIXskqlnb
         Pl01BkqTd7A0jLfpeEuEBpnBO/o6V60PRC6zd4u9CmbR1VIctMDwjTLci81wfV2vhX4F
         Ejfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oS0wCpVx3xA1BGt0eSk6Ptge/SvVGNTwNTTh7VAehEA=;
        b=MLnZ2xrfLA754VxkqOJ23fI1PfwIEMGSckTYp6RGaPqQv6HvGjARJlczzTEZ5Imv7o
         m3WXPflSvD2ZZVxISAPo1l/njsyvT/Pr2TdzeBv9uHnKa/2re0D56FAXHUG2zkTJmmF6
         oAGXLVpgrbHv2lfLs8A9KlGtTp+rRhNajZH7g561EyInCgAAuGoC7FqZ7MfYHIzy6D2d
         fQ7Gx9DOju3MkttaeG2qS069eMb7MXThQLKxNbOkM20xixMZ8iAq68yITwHoeZMvxVH5
         yRfDosN6SPhlLLrSm6oj6fvzdIimR/CNIct6HWmn3qJm1G0zAuGwYxBUu0VlAenrbf+c
         IcWw==
X-Gm-Message-State: AOAM531G4Y4XeYFjMF4LonFaNXXfSfZJ3tT0O2Gdb3j9jKk8RCWXNfeh
        ckh/u6AYN5yolNxi2Nc0F6ER1CKCLVEuOo7PQ6lRYA==
X-Google-Smtp-Source: ABdhPJzQwlUG9DF3cXiZmFIOBI6q3ok+eZiH7dHbyOe604LYKHxgf7wqnC4D3+lfJD14cQ//XNjW0SgbhVVdzj4Hyf0=
X-Received: by 2002:a25:b906:: with SMTP id x6mr5362694ybj.504.1615888788020;
 Tue, 16 Mar 2021 02:59:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210315135720.002213995@linuxfoundation.org> <20210315135720.418426545@linuxfoundation.org>
 <20210316095049.GB12946@amd>
In-Reply-To: <20210316095049.GB12946@amd>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 16 Mar 2021 10:59:36 +0100
Message-ID: <CANn89iLnNF0+=dSr9wJFbH+vDene0cnhq4wN0WVBP85Ty3s4AQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 012/120] tcp: annotate tp->write_seq lockless reads
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 16, 2021 at 10:50 AM Pavel Machek <pavel@denx.de> wrote:
>

> > --- a/net/ipv4/tcp_minisocks.c
> > +++ b/net/ipv4/tcp_minisocks.c
> > @@ -510,7 +510,7 @@ struct sock *tcp_create_openreq_child(co
> >       newtp->app_limited = ~0U;
> >
> >       tcp_init_xmit_timers(newsk);
> > -     newtp->write_seq = newtp->pushed_seq = treq->snt_isn + 1;
> > +     WRITE_ONCE(newtp->write_seq, newtp->pushed_seq = treq->snt_isn + 1);
>
> Would it be better to do assignment to pushed_seq outside of
> WRITE_ONCE macro? This is ... "interesting".

You are probably right, this looks odd and was not something I intended.
It happened to just work, but feel free to send a patch to clean it up.

Thanks.
