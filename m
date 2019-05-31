Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2828A315E2
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 22:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbfEaUKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 16:10:08 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37172 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727282AbfEaUKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 16:10:07 -0400
Received: by mail-lj1-f194.google.com with SMTP id h19so10776797ljj.4
        for <stable@vger.kernel.org>; Fri, 31 May 2019 13:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U8p1Z/mVvVUCYGX27JcK7H6LmbYMTqNaVA5w/CCnNLk=;
        b=sa7mjaFMM4n/dTglqX+oxN3SHWWyP5GaTg+tUXiXpYJ03cE35GtAG5sWy8MtDE4oN7
         fI9eDLVLDV9AkAZ98BlH8psH58XwDR/7IdQ8wRk0RVnhHXGyvKSZBvixtx0J8ni8v4/i
         35HMu+7Se8MOANCqc+dPzaI1Rvl2UediTy1OhXxHeXLgbFhvnWnENQqDmVJt6YnBsxR0
         OppiqJQ324Z6yNnzPdK7APmy/N/phMUvftV0DLqwrTeMPHLpAVTjr8uSPmX28pv4zAfX
         kTyfaKabxyf5A3QopbtAZlMwYuJBm8hyYxP+6BH6zC3MZHEaH/O2fpBokUy2hiBhbWFX
         x37A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U8p1Z/mVvVUCYGX27JcK7H6LmbYMTqNaVA5w/CCnNLk=;
        b=IOmdc/2FlTMJyMRe2One3xWb6IysN7opvNA/9VyIKjFoyfefgpzbHhS26r7nxiz7kU
         aCsKa4vbVOZDFPjqJokzYeTEvw2szDbxNAojzDls/99SBK/FeCZwWXnDulMy6UuNScwW
         zt2jMWwXdn7FOPt0yaRD65eFneqQurIp4Qhpcy6dvaBotcLg/qWT4CTyqESXZ1QLZiQx
         +xrqkJnLpbgghpBpLMpRQo+E3rh50WhZ4gEP6ZuLwm6jIp/EgO0DNk9Ip+oKZ5lQB3lK
         /Dl1vEFX0rXMOg2bdAWawWQXa5M5YtMJb+GNXQQ+mfH+oJRoaICqI6uFt+pw1mgjoT5w
         zMdw==
X-Gm-Message-State: APjAAAWtLhvyGR8usMiWvZOaB3Un+zxPaLL13q57pgvpJlys++uKILqR
        TTaEKeY8dTIVq344FxnkgsNZQMJNLHDyd88D7QgtUA==
X-Google-Smtp-Source: APXvYqz/NgaOVyOmc4at24azJF/naYRbFPHAK3bCfonuZ49gS/4WCNDHrU8cihjGotDISFtaUUDTPwSDtkLITPhqA6o=
X-Received: by 2002:a2e:9a1a:: with SMTP id o26mr7133092lji.174.1559333404830;
 Fri, 31 May 2019 13:10:04 -0700 (PDT)
MIME-Version: 1.0
References: <1558991372.2631.10.camel@codethink.co.uk> <20190528065131.GA2623@kroah.com>
 <CAHRSSEzopAbeAv4ap9xTrC1nCbpw1ZPrEYEMZOc5W_EcLZaktQ@mail.gmail.com>
In-Reply-To: <CAHRSSEzopAbeAv4ap9xTrC1nCbpw1ZPrEYEMZOc5W_EcLZaktQ@mail.gmail.com>
From:   Todd Kjos <tkjos@google.com>
Date:   Fri, 31 May 2019 13:09:53 -0700
Message-ID: <CAHRSSEw=z4hyHMZV=WYAs_hy6Wp2qRk2mWGRSiXUO49d1SDVfQ@mail.gmail.com>
Subject: Re: [stable] binder: fix race between munmap() and direct reclaim
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Todd Kjos <tkjos@android.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg,

I'm really confused. [1] was my submittal to stable for "binder: fix
race between munmap() and direct reclaim" which I think looks correct.

For "binder: fix handling of misaligned binder object", I only
submitted to LKML [2]. But then I see [3] for 4.14 (that looks
incorrect as Ben pointed out).

So the result is that fix is present in the LTS trees where it is
needed, but it has the wrong commit message and headline.

I agree with Ben that the cleanest approach is to revert and apply the
correct version (to 4.14, 4.19, 5.0). I think the correct version is
the one I sent [1], but please let me know if you see something I
screwed up or if you need me to do something.

[1] https://www.spinics.net/lists/stable/msg299033.html
[2] https://lkml.org/lkml/2019/2/14/1235
[3] https://lkml.org/lkml/2019/4/30/650

-Todd


On Tue, May 28, 2019 at 9:34 AM Todd Kjos <tkjos@google.com> wrote:
>
> Probably my screw-up. I was working on both of those bug fixes at about the same time. I'll investigate what happened.
>
> On Mon, May 27, 2019 at 11:51 PM Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>
>> On Mon, May 27, 2019 at 10:09:32PM +0100, Ben Hutchings wrote:
>> > There are commits in the 4.14, 4.19 and 5.0 stable branches that claim
>> > to be backports of:
>> >
>> > commit 26528be6720bb40bc8844e97ee73a37e530e9c5e
>> > Author: Todd Kjos <tkjos@android.com>
>> > Date:   Thu Feb 14 15:22:57 2019 -0800
>> >
>> >     binder: fix handling of misaligned binder object
>> >
>> > However the source changes actually match:
>> >
>> > commit 5cec2d2e5839f9c0fec319c523a911e0a7fd299f
>> > Author: Todd Kjos <tkjos@android.com>
>> > Date:   Fri Mar 1 15:06:06 2019 -0800
>> >
>> >     binder: fix race between munmap() and direct reclaim
>> >
>> > So far as I can see, the former fixes a bug only introduced in 5.1 and
>> > the latter fixes an older bug, so the changes are correct and only the
>> > metadata is not.
>> >
>> > Similar mix-ups have happened before and I'm a little disturbed that
>> > this keeps happening.  In any case, you may want to revert and re-apply
>> > with correct metadata.
>>
>> Note, these backports came directly from Todd, so he can provide more
>> information about them.  Todd, did something get messed up on your end
>> and do we need to include another patch to fix this up?
>>
>> thanks,
>>
>> greg k-h
