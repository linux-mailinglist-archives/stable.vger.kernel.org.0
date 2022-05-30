Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE1B5374D5
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 09:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbiE3HRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 03:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233363AbiE3HRN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 03:17:13 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090CA4F9C4
        for <stable@vger.kernel.org>; Mon, 30 May 2022 00:17:12 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-300628e76f3so99922717b3.12
        for <stable@vger.kernel.org>; Mon, 30 May 2022 00:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ak1D+ugJ6qTkmKZrpOC7+3+y3lRcWmSH3V55J3uAaB8=;
        b=T2Xg4swJ5iaYFC2iVHH0G2EPFgzo6f4tPoAE6C2AmURNLcfHvoeW7o3dj3DndOK8As
         aIXrCGaHo9FThfNzUnhyzNI1ebWkUSrb3CrL4Pdxr8DF/FaKI6FeTaE+hYeVnJ/0zwSl
         t4RhyXJbq+7FrXzacwD5m+jU8mv7gq5tbTGzNiHIKowW4JNvWO7Q8BVw5OJiew2gDaVc
         9Xndca96mgVvhtlX4xhqb8CEUgcgB1bGEPDMknElskEZ6WUkfrYXI6u/AHcad2MaizGY
         XG+5+mAGQsJ8jlX8Hs+sveCRhH9LCZ/6FrOqrLTj2IthQB0uXicZhdFVKUSYqOTALS4I
         z0JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ak1D+ugJ6qTkmKZrpOC7+3+y3lRcWmSH3V55J3uAaB8=;
        b=CojmfEyup5nSUSCOSVWZAaBBdgZWiw5xNEM44wx6hcFGlMxCwm38YQEMF/kxzSNC3q
         /VNQZiABWvSwsNWL/jMdbxIGgKilg3vUgmWHgn/8ditRZA/p1t3iHM4Y7Smkg2NtjonR
         RBjJg4ChazOasY3bffPgYjiuwOvn32eIZ1cXf0FR2yskK/Bwc0PmBJ3VipM4yh8VZq3G
         lyxtX4L1O+cH0cMeEjH/2yJ8lNPmmRFPF4d5vLU0MeiDI6MHZ92GFZNFL6o5fRgY8YZA
         QnVSoNHKumc5w9trMLh3GMrl7LtWA87d8YfutjErQuZ98V6gAujdEmsNqbT5hGENUM5H
         KxRQ==
X-Gm-Message-State: AOAM530kHtl8OT+zWIeq8ftysfeMq2WGiay2oOd6FRrNTVRuWqqs39mV
        K6yt6efWTh2g+ZvgBOp6it+w5x6LdPh6LMvXO55sdg==
X-Google-Smtp-Source: ABdhPJzFAdQxNtSotndeMAwvEUZLvfLjFFsu3KDucCLSPD3yriQIyCXnU+eD654awmTZG588EHs1z3CTqrHZXSSRj7g=
X-Received: by 2002:a81:4c8e:0:b0:300:37ba:2c1e with SMTP id
 z136-20020a814c8e000000b0030037ba2c1emr31212087ywa.141.1653895031253; Mon, 30
 May 2022 00:17:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220530053326.41682-1-songmuchun@bytedance.com>
 <0563a019-09e3-a176-d4c1-c240f3cf62d0@redhat.com> <CAMZfGtUMfNjOGJ3j4tgha6SxFymNGDo3CW5NO73ZsMby42BPjg@mail.gmail.com>
 <1bbbe572-5aa3-18d1-35f0-3e089942b4cf@redhat.com>
In-Reply-To: <1bbbe572-5aa3-18d1-35f0-3e089942b4cf@redhat.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Mon, 30 May 2022 15:16:34 +0800
Message-ID: <CAMZfGtUFFbBO-1kwgCRFKyasS+BUoGcRwd-E6-iOng-kiNrVGg@mail.gmail.com>
Subject: Re: [PATCH] mm: memory_hotplug: fix memory error handling
To:     David Hildenbrand <david@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        cheloha@linux.vnet.ibm.com, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nathan Lynch <nathanl@linux.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 30, 2022 at 3:10 PM David Hildenbrand <david@redhat.com> wrote:
>
> On 30.05.22 09:08, Muchun Song wrote:
> > On Mon, May 30, 2022 at 2:56 PM David Hildenbrand <david@redhat.com> wrote:
> >>
> >> On 30.05.22 07:33, Muchun Song wrote:
> >>> The device_unregister() is supposed to be used to unregister devices if
> >>> device_register() has succeed.  And device_unregister() will put device.
> >>> The caller should not do it again, otherwise, the first call of
> >>> put_device() will drop the last reference count, then the next call
> >>> of device_unregister() will UAF on device.
> >>>
> >>> Fixes: 4fb6eabf1037 ("drivers/base/memory.c: cache memory blocks in xarray to accelerate lookup")
> >>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> >>> Cc: <stable@vger.kernel.org>
> >>> ---
> >>>  drivers/base/memory.c | 5 ++---
> >>>  1 file changed, 2 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> >>> index 7222ff9b5e05..084d67fd55cc 100644
> >>> --- a/drivers/base/memory.c
> >>> +++ b/drivers/base/memory.c
> >>> @@ -636,10 +636,9 @@ static int __add_memory_block(struct memory_block *memory)
> >>>       }
> >>>       ret = xa_err(xa_store(&memory_blocks, memory->dev.id, memory,
> >>>                             GFP_KERNEL));
> >>> -     if (ret) {
> >>> -             put_device(&memory->dev);
> >>> +     if (ret)
> >>>               device_unregister(&memory->dev);
> >>> -     }
> >>> +
> >>>       return ret;
> >>>  }
> >>>
> >>
> >> See
> >>
> >> https://lkml.kernel.org/r/d44c63d78affe844f020dc02ad6af29abc448fc4.1650611702.git.christophe.jaillet@wanadoo.fr
> >>
> >
> > I see. Good job by Christophe. Thanks David.
> >
>
> I'm curious how both of you found that issue? Just by staring at that
> code? :)
>

I am reading the code here today, then I saw it by chance.
No tricks :-).

THanks.
