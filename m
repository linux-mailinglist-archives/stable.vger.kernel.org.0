Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16891E29B5
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 20:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388845AbgEZSIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728890AbgEZSIu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 14:08:50 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5483C03E96E
        for <stable@vger.kernel.org>; Tue, 26 May 2020 11:08:49 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id 63so17088515oto.8
        for <stable@vger.kernel.org>; Tue, 26 May 2020 11:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yOePJEqzOpldNpBCP7tiQal13VtjOaSKu8Mf0AiyKEI=;
        b=LHerMhrRjDvYSPQcdFKJwGDWO70nXCx2w6vo4xJFPsObj1NbvulOFG+pHyD9nelhm+
         oFhF5Kc1UQ0qk6XEEY9UviM6dksasQ7oeWtIGzXqwTd/m6CIelrPhzxK75SH/FYEzp10
         UNLNtypTCz+DotDxXL4ej6Z6N3tjkwfKcV5JLDaOqWoRIVvr5x9Vu3iMjP+8WXuJoLEb
         +7dhYyiLkAebECLI/eQSvFX1zljc/KNYsd9Rpql7ilm5FM7jGUOnDZfw9ZW3oIVCsa/n
         DwqyfAo4ygntvZiXRLWBnDBAFyJsrX9GJPtm9t2fPTEpORoXe8ZfWfDnFUdL+vddh6Wz
         fOfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yOePJEqzOpldNpBCP7tiQal13VtjOaSKu8Mf0AiyKEI=;
        b=P2HOCDPxUjMYRgTvsOo/IoPFqNkdT+zLDcNqKMhAZqKL7cf/wIkcxzqHdfsqhMKi1u
         G34dBqLvQg7gAIjqz1RujGfW3TrNu8SoOeNdOLCdFOqOsuhwUoNh1TK3znxukhKDp0Do
         6N/0ts6GKaEXfWmBT58F0KHmi8CbG7hEO5CTi9QcEW62beTaZjsHg1UMRzK2JE6Xi22m
         X7rZ2uPVaXbi1YMUlKithR1Pcoh//FiTUHaGDPha2NPMG6jOIjRycS/frf8h/q1vpX5j
         v/VBQRP72ZWYv85qwF3gDFMJODSgtD4aQ3gAxMOIXD9N/UcGifUBhpV3fFm80HUkTZeV
         v8rg==
X-Gm-Message-State: AOAM533feEAw1/REJuYIvw+DIa1wYo9jnX+t8L1/AJs6JSffJxOVQGhm
        3uCyKpgptMAQf2kSUr5LkfpHhkeaBGo/xolGbIminA==
X-Google-Smtp-Source: ABdhPJxcmaAVdh0ujGCGKr1HPyMWjwhEp+FeToSzOp+e8yyxq5YqQRrbEqpSGpnZ5yZPxLPF+Bdrvd+HbqtPIbUOGUk=
X-Received: by 2002:a9d:66d5:: with SMTP id t21mr1907974otm.231.1590516528738;
 Tue, 26 May 2020 11:08:48 -0700 (PDT)
MIME-Version: 1.0
References: <6144404cb26d1f797fd7e87b124bcaf8@walle.cc> <20200526070518.107333-1-saravanak@google.com>
 <CAGETcx-b4+a8U=Qd0mKaB9JUBaj178694QshqZVrAa_x6AgcAg@mail.gmail.com> <dac3da8b373f131e53e18083f6fac5b0@walle.cc>
In-Reply-To: <dac3da8b373f131e53e18083f6fac5b0@walle.cc>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 26 May 2020 11:08:12 -0700
Message-ID: <CAGETcx_iHs5xsXq81k4YRzrFxs2j01u3HzfnSNU9Vxs8ZTGGuA@mail.gmail.com>
Subject: Re: [PATCH v1] driver core: Update device link status correctly for
 SYNC_STATE_ONLY links
To:     Michael Walle <michael@walle.cc>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 26, 2020 at 4:04 AM Michael Walle <michael@walle.cc> wrote:
>
> Hi Saravana,
>
> Am 2020-05-26 09:07, schrieb Saravana Kannan:
> >> Greg,
> >>
> >> I think this is the issue Michael ran into. I'd like him to test the
> >> fix
> >> before it's pulled in.
> >>
> >> Michael,
> >>
> >> If you can test this on the branch you saw the issue in and give a
> >> Tested-by if it works, that'd be great.
>
> Unfortunately, now I'm triggering another WARN_ON() in
> device_links_driver_bound():
>    WARN_ON(link->status != DL_STATE_DORMANT);
>
> I've attached two bootlog one based on linux-next-20200525 with this
> patch applied and another one where your previous debug printfs are
> applied, too.
>
> Let me know, if you need any other debug outputs.

Can you make the same debug changes I did for the other WARN and get
me the logs?

Thanks,
Saravana
