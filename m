Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A674449E657
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 16:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242899AbiA0PmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 10:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238286AbiA0PmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 10:42:05 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D0AC061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 07:42:05 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id z19so6073872lfq.13
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 07:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MfyhRIJpExvB5oLC8bK80nt6dS7pKQKJ+WzxTeqwLMk=;
        b=mzVnI9hpBJqoZJb51BXe/CTWQy7ox1o88fNB47TS3//euJpqZI/oivu1J7IB1UFWJP
         43TYlpPyn5VyOdkq010nfXCa3bNGsn0wh1gCCszlkBJCAVZ3ubVFoOpt3E+r7rn+auaK
         2w5MnvjQLTtDjGio6q1lBH/9U+4XSff3eG3Pr6MewWoza3mxSjrM8r+e8NvxLKVs7o5a
         a0Yf3wcXOiUR0rxGU5yqKXXON8ovGUsQhYzKPTuEidVeUKN0/+tQRbr4ELQpUHcqdrVI
         RFcS7tS0Ezsvz/NHfuBCLFx8X5gUpNhK+yDzqpB2CKAeq8DygU/WUuogLlY0qnnZDNR2
         eqfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MfyhRIJpExvB5oLC8bK80nt6dS7pKQKJ+WzxTeqwLMk=;
        b=RJEIoDqGHE8o68bKEI0BXSy94q4h7m4mMw4Wm4YaDpSSxvgkB697u6hiu3yMNNbxBf
         2Zkx/39DZv85UExa7bXg1rzq54ZNq9vunNJwocytYWs5PR5qmn9wZEBWl++D3Ryv6fxX
         nU/GLZC2oLwZXq8Hyu3X/IT1SRXsokRqijd0s925fQVKU0sq2s8IYQ0VSLt7HD/NTvw0
         25DM56ycvFdokOudsIsRUomPhtsYkJGt9FXiWoGkBXABrTpEz5QKUCmvyr+BKmAxMzQd
         Gg/KEFhaFqonVABnRGrsi2QX8C+ovpfY+TWbonpVX3bLnNbQ6P291qVRMJbMeygVLFeJ
         fy3g==
X-Gm-Message-State: AOAM531pu2hDZAd/05ajRq676y3gQxJnpsIYjFl5hIBCb14sv8BA1tDH
        TTT+B0Qdj4W3lwJC8BZ18+wd7HVAoygAiZT5QExZNg==
X-Google-Smtp-Source: ABdhPJyHf+Jl4G149KcLmKjH0/4FJlFN3TGPnzzUNBugVy4tA4FH9JO8/yGxeymhQL/z3i9e+IhExPFRJaBplGbFCII=
X-Received: by 2002:ac2:4e66:: with SMTP id y6mr3106759lfs.184.1643298123642;
 Thu, 27 Jan 2022 07:42:03 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi28yMU2YbJGKvPb91HR7yYAEyq3Zg6QeeBUk3KwjiyTMg@mail.gmail.com>
 <YfK6gfXZZGNqsnyr@kroah.com>
In-Reply-To: <YfK6gfXZZGNqsnyr@kroah.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Thu, 27 Jan 2022 07:41:52 -0800
Message-ID: <CALvZod76vX94jG0W9f-RJGu9pSYi_uMw5BE6xfL9p30pgLShUQ@mail.gmail.com>
Subject: Re: Backport memcg flush improvements into 5.15
To:     Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>
Cc:     Ivan Babrou <ivan@cloudflare.com>, stable <stable@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+Andrew & linux-mm

On Thu, Jan 27, 2022 at 7:30 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Jan 19, 2022 at 04:15:34PM -0800, Ivan Babrou wrote:
> > Hello,
> >
> > We've seen a significant perf degradation when reading a tmpfs file
> > swapped into zram between 5.10 and 5.15. The source of the issue is:
> >
> > * aa48e47e3906: memcg: infrastructure to flush memcg stats
> >
> > There's a couple of commits that helps to bridge the gap in 5.16:
> >
> > * 11192d9c124d: memcg: flush stats only if updated
> > * fd25a9e0e23b: memcg: unify memcg stat flushing
> >
> > Both of these apply cleanly and Shakeel (the author) has okayed the
> > backport from his end. He also suggested backporting the following:
> >
> > * 5b3be698a872: memcg: better bounds on the memcg stats updates
> >
> > I personally did not test this one, but it applies cleanly, so there's
> > probably no harm. I cc'd Shakeel in case you want confirmation on
> > that. It's not a part of any tag yet.
> >
> > Please backport all three (or at least the first two) to 5.15 LTS.
>
> All now queued up, thanks!

Thanks Greg.

Adding Andrew (and linux-mm) in CC to let him know the reason for
backporting these patches to 5.15 stable tree.

>
> greg k-h
