Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4770955371F
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 18:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351787AbiFUP6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 11:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353251AbiFUP5i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 11:57:38 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9262E0A9
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 08:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1655826941;
        bh=BzU42V0H1h+U6Qhi9dvKHtFP5wA0p3BIum94gm8Uw2E=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=kB/SHK4V/zfgfM0/+1ULy3TNO7gCnglfoeEhdAz61fbKaF4OYIYUhb7rLvn/fiWTD
         u8CQALzw2Ut5iS9h8kBydFQ0o6V+GVXYUXorsJ4gP5M0ncuXSiq9XuLPwpU1Rc6AN8
         F+40EdHBNZNQ6LKVqVsBAZK/uF1D70dKS0zpUO1E=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.60] ([92.116.178.187]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MgeoI-1nTG0P1m7o-00h2fN; Tue, 21
 Jun 2022 17:55:41 +0200
Message-ID: <c9d168fe-cb68-f6a6-8f1f-9a6162a61e6a@gmx.de>
Date:   Tue, 21 Jun 2022 17:55:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] drm/fb-helper: Make set_var validation stricter
Content-Language: en-US
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>
Cc:     security@kernel.org, Daniel Stone <daniels@collabora.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        openeuler-security@openeuler.org, guodaxing@huawei.com,
        Weigang <weigang12@huawei.com>,
        Daniel Vetter <daniel.vetter@intel.com>
References: <20220621092319.379049-1-daniel.vetter@ffwll.ch>
 <8701b28a-fb86-c95f-6a3e-ddea9cd10b97@gmx.de>
 <CAKMK7uG3DxXx067oxHTphRjoi34AA=C9YenV3gJT_T+Vo9MOFA@mail.gmail.com>
 <CAKMK7uEOBb2ebFAvAvTk2bJdAHw07bQxezSdVOJS1=odg+zbDg@mail.gmail.com>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <CAKMK7uEOBb2ebFAvAvTk2bJdAHw07bQxezSdVOJS1=odg+zbDg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:uIXvC9qB4NNiHLSVv6tNfRMNc105Jez0GTH2abXlp+8qcwGqVzT
 zhF4hVsWFDYh4wNDtvWK7De7tD0hGxF9KxiyFWQdhuHpbM29rXTxY6wwvsQbT5yz4wvzkUz
 qLiBtMzoYo/pd+EOkun3oQEPzJZSehi6ZayQ6aw3CyhmUqvROb80et+v483baFdqBy0yaMT
 U+03ZYSDf0OpXGCsXov0Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:UvhCYurQG1U=:+eGyUejN1riRzg4L6Lh9Du
 X0xNzuvShipi5pxcao3eLB3mjg5khtry+/myfldyBtenrT/Q9q4Qcr+GQ4YY7iLIsRcROb1rJ
 RBw8zGowpQ8MIOd6/93gsgExJR4EPRgGjAIDQB5uRdy4nd9TIKaA1hUSRIqh2klHaa4EoaSxY
 95k18+90ePnBlGrOI0BmD7xj4bw40YnqBLH2hXSweGJSlscPLzItXoFhXfZgX8xqoW+BK8kAZ
 ePEGvQlVnAH3z1fnhLwMBsO4FcXW6E9L8n+k+jRbokKbjChEbIlijyjE7J0C6Ea1W4o64AN/o
 3pQot6fb3m0uSZGVUMR+kEF1ZsRa6fXR1r7Gk6OqVKdYs8kWoc6dJdZlfOHk+5m8BHcxpcCbd
 T9h+XK6VJt0jcAq15o6VUeo2jtrVOiLDAD31c73X5wz/PptDKmBy6fJ2qSmKcyVGwQYRReCXM
 C1kqBfTIErIAidTZaq6oxwAkMmfUhwvtbH6OxOMdq74pk47ay/IQtM9T6ifeshNFgfsGYFYfk
 LQh55RDIXi1UdMR5xhyuXrPKnDpAr4qZlsYbN9aOHGpx6o3XnhMN55YtdMMB/hbaru2H/ytkN
 FMoRMiSuHsMiFUoKQvst/TKK+1ozVVrrP/tAcWcn6SH5a1e10ww7cTeCLBcJpg771RbQkr0L2
 0b8Gigkzd1O8cPs7Q6vkP9p2EY/D1i6iHiivYSiv95vWVWjb7IGBblXr0MBNIGheHNQVVU3Kq
 WO/7cWSGTwpzK0slIrrfHAub5b12ppjCIdp74GoCuj+xwCo8xjhvp2upoCyXESyfFjQRgDzPg
 oeySAF/aYzBzAKWZotIwz5tcYdzi557nWumxTELkcaHC39T/tnvBsK+GTxywVBsQuvLVHJPae
 v6KKiQ2NZUPb1S52ZJNP5LJccCodn248vYktrf2RPM03XLXt6WiutUSLKD2nGQyvEuLI1Indq
 lNNfn4a2igY87aEPf82+KMHDnG2QHcy605RNovlJnmm7mJb75JHjH9vZGPEEyi2G7gCi4P9vN
 bklsGjUDJWbOTBiPooYkrDaJevkbE97zT2Fswe2kbbLZKftuRjVVY3Z81PFsS4m1oJsnXBo0L
 +YOSKjqQ6goP53AsTp/F2neSZ9oT71JDo99gmIIgGt0hTUtru/Ij/kTLA==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/21/22 17:40, Daniel Vetter wrote:
> On Tue, 21 Jun 2022 at 17:37, Daniel Vetter <daniel.vetter@ffwll.ch> wro=
te:
>>
>> On Tue, 21 Jun 2022 at 16:57, Helge Deller <deller@gmx.de> wrote:
>>>
>>> On 6/21/22 11:23, Daniel Vetter wrote:
>>>> The drm fbdev emulation does not forward mode changes to the driver,
>>>> and hence all changes where rejected in 865afb11949e ("drm/fb-helper:
>>>> reject any changes to the fbdev").
>>>>
>>>> Unfortunately this resulted in bugs on multiple monitor systems with
>>>> different resolutions. In that case the fbdev emulation code sizes th=
e
>>>> underlying framebuffer for the largest screen (which dictates
>>>> x/yres_virtual), but adjust the fbdev x/yres to match the smallest
>>>> resolution. The above mentioned patch failed to realize that, and
>>>> errornously validated x/yres against the fb dimensions.
>>>>
>>>> This was fixed by just dropping the validation for too small sizes,
>>>> which restored vt switching with 12ffed96d436 ("drm/fb-helper: Allow
>>>> var->x/yres(_virtual) < fb->width/height again").
>>>>
>>>> But this also restored all kinds of validation issues and their
>>>> fallout in the notoriously buggy fbcon code for too small sizes. Sinc=
e
>>>> no one is volunteering to really make fbcon and vc/vt fully robust
>>>> against these math issues make sure this barn door is closed for good
>>>> again.
>>>
>>> I don't understand why you are blaming fbcon here (again)...
>>>
>>> The real problem is that user-provided input (virt/physical screen siz=
es)
>>> isn't correctly validated.
>>> And that's even what your patch below does.
>>
>> I don't want to play whack-a-mole in here. And what I tried to do here
>> (but oh well, too many things would break) is outright disallow any
>> changes, not just try to validate (and probably in vain) that the
>> changes look decent. Because making stuff invariant also solves all
>> the locking fun. And sure even then we could have bugs that break
>> stuff, but since everything would be invariant people would notice
>> when booting, instead of trying to hit corner cases using syzkaller
>> for stuff that mostly only syzkaller exercises.
>>
>> And I'm pretty sure syzkaller isn't good enough to really hit
>> concurrency issues, it has a pretty hard time just finding basic
>> validation bugs like this.
>
> Like I'm pretty sure if you make the font big enough and yres small
> enough this can all blow up right away again, but I also really don't
> want to find out.

Yes, the font thing is something which came to my mind as well.
But that's probably another patch...

> And once you fix that you get to fix the races of changing fonts
> through vt against changing resolution through fbdev ioctls, and at
> that point you have a neat locking problem to solve.

Yes, maybe.
But people need/want to be able to change screen resolutions and fonts, so
it has to be made working somehow, e.g. by returning -EAGAIN temporarily.

Helge


> -Daniel
>
>>> Helge
>>>
>>>> Since it's a bit tricky to remember the x/yres we picked across both
>>>> the newer generic fbdev emulation and the older code with more driver
>>>> involvement, we simply check that it doesn't change. This relies on
>>>> drm_fb_helper_fill_var() having done things correctly, and nothing
>>>> having trampled it yet.
>>>>
>>>> Note that this leaves all the other fbdev drivers out in the rain.
>>>> Given that distros have finally started to move away from those
>>>> completely for real I think that's good enough. The code it spaghetti
>>>> enough that I do not feel confident to even review fixes for it.
>>>>
>>>> What might help fbdev is doing something similar to what was done in
>>>> a49145acfb97 ("fbmem: add margin check to fb_check_caps()") and ensur=
e
>>>> x/yres_virtual aren't too small, for some value of "too small". Maybe
>>>> checking that they're at least x/yres makes sense?
>>>>
>>>> Fixes: 12ffed96d436 ("drm/fb-helper: Allow var->x/yres(_virtual) < fb=
->width/height again")
>>>> Cc: Michel D=C3=A4nzer <michel.daenzer@amd.com>
>>>> Cc: Daniel Stone <daniels@collabora.com>
>>>> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
>>>> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
>>>> Cc: Maxime Ripard <mripard@kernel.org>
>>>> Cc: Thomas Zimmermann <tzimmermann@suse.de>
>>>> Cc: <stable@vger.kernel.org> # v4.11+
>>>> Cc: Helge Deller <deller@gmx.de>
>>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>> Cc: openeuler-security@openeuler.org
>>>> Cc: guodaxing@huawei.com
>>>> Cc: Weigang (Jimmy) <weigang12@huawei.com>
>>>> Reported-by: Weigang (Jimmy) <weigang12@huawei.com>
>>>> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
>>>> ---
>>>> Note: Weigang asked for this to stay under embargo until it's all
>>>> review and tested.
>>>> -Daniel
>>>> ---
>>>>  drivers/gpu/drm/drm_fb_helper.c | 4 ++--
>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb=
_helper.c
>>>> index 695997ae2a7c..5664a177a404 100644
>>>> --- a/drivers/gpu/drm/drm_fb_helper.c
>>>> +++ b/drivers/gpu/drm/drm_fb_helper.c
>>>> @@ -1355,8 +1355,8 @@ int drm_fb_helper_check_var(struct fb_var_scree=
ninfo *var,
>>>>        * to KMS, hence fail if different settings are requested.
>>>>        */
>>>>       if (var->bits_per_pixel > fb->format->cpp[0] * 8 ||
>>>> -         var->xres > fb->width || var->yres > fb->height ||
>>>> -         var->xres_virtual > fb->width || var->yres_virtual > fb->he=
ight) {
>>>> +         var->xres !=3D info->var.xres || var->yres !=3D info->var.y=
res ||
>>>> +         var->xres_virtual !=3D fb->width || var->yres_virtual !=3D =
fb->height) {
>>>>               drm_dbg_kms(dev, "fb requested width/height/bpp can't f=
it in current fb "
>>>>                         "request %dx%d-%d (virtual %dx%d) > %dx%d-%d\=
n",
>>>>                         var->xres, var->yres, var->bits_per_pixel,
>>>
>>
>>
>> --
>> Daniel Vetter
>> Software Engineer, Intel Corporation
>> http://blog.ffwll.ch
>
>
>

