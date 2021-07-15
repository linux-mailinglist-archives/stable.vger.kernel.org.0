Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE71C3CAEE3
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 00:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbhGOWFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 18:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbhGOWFN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 18:05:13 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF313C06175F;
        Thu, 15 Jul 2021 15:02:19 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 37so7999181pgq.0;
        Thu, 15 Jul 2021 15:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mosenkovs.lv; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dsjmWnzuwCKGDNv5+cF7xjYKlGjPfXn52Osxyj1z9Rs=;
        b=A5bDKok4gx7w4KSjPEcW44Mfrh2i0OWHbT02mTojgrqchFjbJCg9/ueipOB70lW7/V
         ZWT2TI0LbAmhRi6o4/YGoJOXAKnXzNzhu4TvHrmECiMyVQ/6sMCjf1QTwuLq08acl+Ke
         AthwqxrWVTu9haH1ZGpBke7Y+127fu/0O5MgM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dsjmWnzuwCKGDNv5+cF7xjYKlGjPfXn52Osxyj1z9Rs=;
        b=E//v29KTLVWVLKk7nel7+jMzUbsXMbADVpvWhmIgpZD2nUP0dUuIN69++/vzEqy8bk
         3hGGkxir6fkLzH8Vw4JFn5UoyQjbpYZ2LJH18g9AM/6KSfkrdM+xmfvBgYiKyv6YaECk
         xp9BWV/0XyqAazcKX/F+BrSKlHEENI/5vDnuWZ6voyWn/4o7hqfSY0Xa9eJB+XY5nfH/
         KMoi+Q1aQL5YVjksgblw75PW4J5Fea6pNM0wx6auGRL3FfWuz+lvsN0PevC+nr1diX0N
         4dmP2FnEMn4XeZUPKpiFOwzkZv9KMlzLlKp1v70/HfWczlngpma5srzWdW69ZJXGxHAr
         6/tw==
X-Gm-Message-State: AOAM5306wPnELcLOIOs70FvY2XBw1dI4kPP+ebdrYXuvvreRleiwb3hE
        54GEjpL5tnZfFEnYuAVGq2qhmgVCAXhhGr7KY1Ku1QA8bsw=
X-Google-Smtp-Source: ABdhPJwMxVzfAcdMooIhZigmCBvhy7+BSQCLwGxU1lHdDPFymYEr3Zc3L+1RGdkNOY5WASGXSiRd5N94aMSBgHAhRdg=
X-Received: by 2002:a63:e43:: with SMTP id 3mr6499099pgo.61.1626386539364;
 Thu, 15 Jul 2021 15:02:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210710183710.5687-1-davis@mosenkovs.lv> <YPAiFsEncZ95Oomx@kroah.com>
In-Reply-To: <YPAiFsEncZ95Oomx@kroah.com>
From:   Davis <davis@mosenkovs.lv>
Date:   Fri, 16 Jul 2021 01:02:06 +0300
Message-ID: <CAHQn7p+dA3-FS+DGPqCvXJGtTZfWqg9hy1GUbtWFwtQFvKcnfg@mail.gmail.com>
Subject: Re: [PATCH 4.4] mac80211: fix memory corruption in EAPOL handling
To:     Greg KH <greg@kroah.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-07-15 at 15:36 Greg KH (<greg@kroah.com>) wrote:
>
> On Sat, Jul 10, 2021 at 09:37:10PM +0300, Davis Mosenkovs wrote:
> > Commit e3d4030498c3 ("mac80211: do not accept/forward invalid EAPOL
> > frames") uses skb_mac_header() before eth_type_trans() is called
> > leading to incorrect pointer, the pointer gets written to. This issue
> > has appeared during backporting to 4.4, 4.9 and 4.14.
>
> So this is also needed in 4.9 and 4.14, right?  If so, now queued up
> everywhere.  If not, please let me know so I can drop it from the other
> trees.
>
> thanks,
>
> greg k-h

Thank you! Yes - this is needed in 4.4, 4.9 and 4.14.
Only line offsets and commit messages (they contain references to
backport commits introducing the issue) differ between kernel versions
and I see the patches are queued with correct line offsets.
Patches for 4.9
(https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-4.9/mac80211-fix-memory-corruption-in-eapol-handling.patch)
and 4.14 (https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-4.14/mac80211-fix-memory-corruption-in-eapol-handling.patch)
still contain 4.4 in the cc line in sign-off section. Also these
patches contain reference to commit e3d4030498c3 that is from 4.4
branch. Is this OK?

Br,
Davis
