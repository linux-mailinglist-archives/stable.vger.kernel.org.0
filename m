Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D7433D120
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 10:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235463AbhCPJtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 05:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235556AbhCPJt0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 05:49:26 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F704C061756
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 02:49:26 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id 133so36159215ybd.5
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 02:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CEiUqhCHKWemSRXXRMGc1PRoqQAnoH+WZsZjki4JAqI=;
        b=NHK/rhQxZ/cljjp3wVFPcva9hjHqNJiZA5dHjILVBL3+C/kw6Z7VDlGY4bcIqPQoXm
         rAB0M6L47b7z22HazZ/jsZg1Ptl/K4W+AGnhzEg2tEDnV/tEq15hrTJhkPeFnzG+M8o+
         TM2C5x3ki58OT0QtmUV6Wu/IYIR/w2ipokYjBOuGet3djfoooZEvyGuj+CM0Xf39BH+w
         67dveel6DQSfZyNmmdnfXZgJuYUp5YTjDPDQ+NCXt8pHYHDp+mJOFX7kFVM9JhHHHmpx
         hZpK0tSfhiL0WaH6d0YOS2EjW0jtzNPnDmbq01wDRTu/WBvER0iz1usEGBStPUyO0nAp
         u1/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CEiUqhCHKWemSRXXRMGc1PRoqQAnoH+WZsZjki4JAqI=;
        b=GyPX6dkt9DXxBDbnXNhdIkazsF3b83iEODlmFf+m0KR1sHkxAzwpDn5xS5LLIyXiaI
         9u3fFlZzKawiFj/5oO9/LdypXDDKdyEViADjPbMeiBVcVw9Zzj2JkUFU2ZUOa3aQYnoS
         uh8TWY7pg3hJiGkuFPMsG3ljJxg6oCuI+vkBLdrEO7rxQuz7hp0PDGeBrGQv3MlfrBhJ
         +rt6ThTk3JnK6sIWvyEqxw2WyMRNGc6R3lPD94hCHGAmEi7OKIXxzc4qE6pvHr+yeURy
         p59pB141roD+vDZuFm8zm0GLxOtjjKFqPUgGxOQxHvUJgcSA1GU4Q/GNz0DiH700bGpX
         HNPg==
X-Gm-Message-State: AOAM533pM8Sq54A/xRjRkS/iLRD3yihsmxPlUpuhwHZa/L5LcNy2NpP3
        cSFv83XLRyhwjZSWvZlp40YzgZ2Ob72SRCZIABh8Ug==
X-Google-Smtp-Source: ABdhPJzWhviGTVvrOXx+L664OkbxTzBgdj1XLLnuYYuP99gEuYR+TFsQKeztLfISeQ2CxU/STkYZp2IJFbRHLPvjBBI=
X-Received: by 2002:a25:2307:: with SMTP id j7mr5810152ybj.518.1615888165108;
 Tue, 16 Mar 2021 02:49:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210315135720.002213995@linuxfoundation.org> <20210315135720.384809636@linuxfoundation.org>
 <20210316094137.GA12946@amd>
In-Reply-To: <20210316094137.GA12946@amd>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 16 Mar 2021 10:49:13 +0100
Message-ID: <CANn89iKvhq3Bpu5eaZ5mrmRNBqNm9OwoGzCSg3-OaBL8CrAPfA@mail.gmail.com>
Subject: Re: [PATCH 4.19 011/120] tcp: annotate tp->copied_seq lockless reads
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 16, 2021 at 10:41 AM Pavel Machek <pavel@denx.de> wrote:
>
> Hi!
>
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > From: Eric Dumazet <edumazet@google.com>
>
> Two From: fields here.
>
> > [ Upstream commit 7db48e983930285b765743ebd665aecf9850582b ]
> >
> > There are few places where we fetch tp->copied_seq while
> > this field can change from IRQ or other cpu.
>
> And there are few such places even after the patch is applied; I
> quoted them below.
>
> Doing addition to variable without locking... is kind of
> interesting. Are you sure it is okay?

We are holding the socket lock here.

The WRITE_ONCE() here is paired with sides doing READ_ONCE() while
socket lock is _not_ held.

We want to make sure compiler won't write into this variable one byte at a time,
or using stupid things.




>
> > @@ -2112,7 +2112,7 @@ int tcp_recvmsg(struct sock *sk, struct
> >                       if (urg_offset < used) {
> >                               if (!urg_offset) {
> >                                       if (!sock_flag(sk, SOCK_URGINLINE)) {
> > -                                             ++*seq;
> > +                                             WRITE_ONCE(*seq, *seq + 1);
> >                                               urg_hole++;
> >                                               offset++;
> >                                               used--;
> > @@ -2134,7 +2134,7 @@ int tcp_recvmsg(struct sock *sk, struct
> >                       }
> >               }
> >
> > -             *seq += used;
> > +             WRITE_ONCE(*seq, *seq + used);
> >               copied += used;
> >               len -= used;
> >
> > @@ -2163,7 +2163,7 @@ skip_copy:
> >
> >       found_fin_ok:
> >               /* Process the FIN. */
> > -             ++*seq;
> > +             WRITE_ONCE(*seq, *seq + 1);
> >               if (!(flags & MSG_PEEK))
> >                       sk_eat_skb(sk, skb);
> >               break;
>
> Best regards,
>                                                                 Pavel
> --
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
