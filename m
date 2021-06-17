Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16343AAE9D
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 10:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhFQIWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 04:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhFQIWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Jun 2021 04:22:19 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA5AC061574;
        Thu, 17 Jun 2021 01:20:10 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id g20so8477308ejt.0;
        Thu, 17 Jun 2021 01:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cbx+euKbC7pUOUFJX8fVnmfL9og6wRNSoZ+8uoVLuNc=;
        b=vSu2TqRQlWulfmJEHmuSF8Cib4kDDcimF6HRxu6MrcUZjzVcRTPlhxPATXSsSOqjA+
         sIL8ssPR7NhnrBsjvYAPjn2cBJs9JAkGwJ3sbreR8J0hXO4zHbkRMKu8LPPQfkM2WLpr
         SGBoGdQBFsL0CFqCDWaCs1ixQBVu/dIiGgfGoJsrZGfplHKrqLW4hQziPw8DUTFgLriT
         03DILPl5dd08ZM6b9+TtemW8ziSMgC8diEQ4Rc255QlmDVs8mEKXpgTkMEGLarblvcwB
         gBWaM18olnHiRF95smz0bw1n9WJAeR4UYkQ1svp0+u0MHDDqyHlTq5mbElln7Ycl+B+l
         SAEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cbx+euKbC7pUOUFJX8fVnmfL9og6wRNSoZ+8uoVLuNc=;
        b=hMM3xJT0u79AhsBjKIQ6Z3Doe9QkJodg4ATIwDy9aNHJ0JtCMUWFkduJM545gIFAbp
         okikQEcLqBUUdDYrUQ3OQzxSvdJbUzHZsvysIwuIaXAk4CWQXe3LSbb/LQuYWEQlO3oq
         VdWmkQEJbUobXiV9izj1HSLMXGlNsUD3fMgR31allGRQRR1oT7nsGa8xT8Cl0soBOwbM
         1LjfCZsbJrC8TeoilhUW+lnYp06iehiENKEeCLYp6yzgRHILVVrBGSlZOdvhrnltyFXz
         kamEQNp/EsGV4HU434JOZtpvEceOc/4DZoXF0H/+/E6XpHHiv0SB0NQBdUGVe0quMfLd
         q0rQ==
X-Gm-Message-State: AOAM5314KCJ7XaZm/gUTsWS1fESZzknwdYo51iZx13w0xBnyu6OBxN5h
        CleOkfzup8LyP9bheb7eTKAaTb5+kEnfsOfUrPY=
X-Google-Smtp-Source: ABdhPJxfviJNanv9BtjCASk5zipdYe9YHYnZ47Rz2RV+RCT5gY2DbPpAUbOjQKhWs2GpxjoEt9jV3dqsfT90O9ISWww=
X-Received: by 2002:a17:907:1b1b:: with SMTP id mp27mr3901941ejc.538.1623918009568;
 Thu, 17 Jun 2021 01:20:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210512144743.039977287@linuxfoundation.org> <20210512144748.600206118@linuxfoundation.org>
 <CANEQ_++O0XVVdvynGtf37YCHSBT8CYHnUkK+VsFkOTqeqwOUtA@mail.gmail.com>
 <YMmlPHMn/+EPdbvm@kroah.com> <YMoRZDBIua3ionOW@kroah.com>
In-Reply-To: <YMoRZDBIua3ionOW@kroah.com>
From:   Amit Klein <aksecurity@gmail.com>
Date:   Thu, 17 Jun 2021 11:19:58 +0300
Message-ID: <CANEQ_+LOxmCJGT3Y+EMT=BtX9-5miNpHdhsZ3Lp8NvMq_EDqBw@mail.gmail.com>
Subject: Re: [PATCH 5.4 175/244] inet: use bigger hash table for IP ID generation
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I just sent a revised patch for 4.19.

On Wed, Jun 16, 2021 at 5:57 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Jun 16, 2021 at 09:16:12AM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Jun 16, 2021 at 10:02:44AM +0300, Amit Klein wrote:
> > >  Hi Greg et al.
> > >
> > > I see that you backported this patch (increasing the IP ID hash table size)
> > > to the newer LTS branches more than a month ago. But I don't see that it
> > > was backported to older LTS branches (4.19, 4.14, 4.9, 4.4). Is this
> > > intentional?
> >
> > It applies cleanly to 4.19, but not the older ones.  If you think it is
> > needed there for those kernels, please provide a working backport that
> > we can apply.
>
> It breaks the build on 4.19, which is why I didn't apply it there, so I
> would need a working version for that tree as well.
>
> thanks,
>
> greg k-h
