Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB6C4449B3
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 21:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhKCUtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 16:49:49 -0400
Received: from mout.gmx.net ([212.227.17.21]:58661 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229893AbhKCUts (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 16:49:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1635972423;
        bh=WOBdEGwwrN4GRQ7dSuVQwrPjh3u25/zRfRLX3CIFDPo=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:References:Date:In-Reply-To;
        b=NG/+fnPP0wRfudjUHCOeACDLcQW2bMxCcNXrU71bkK5NLQBWDxo61NihvgU+HYpEa
         ktxLYU191TXk4p5bAxqYGbgy04te7E/H6UtgNYNmP2VCBhcg6bQByNfZ7VptLfzLk2
         GQZZXY2bRiBWhSdMyx4zK6o2H+yt5RvC0X71L6do=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.223.42.226]) by mail.gmx.net
 (mrgmx105 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1M72oB-1mpmkj3pQV-008cbU; Wed, 03 Nov 2021 21:47:02 +0100
Received: by localhost.localdomain (Postfix, from userid 1000)
        id EE8DA8009A; Wed,  3 Nov 2021 21:47:01 +0100 (CET)
From:   Sven Joachim <svenjoac@gmx.de>
To:     Karol Herbst <kherbst@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Erhard F." <erhard_f@mailbox.org>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Huang Rui <ray.huang@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [Nouveau] [PATCH 5.10 32/77] drm/ttm: fix memleak in
 ttm_transfered_destroy
References: <20211101082511.254155853@linuxfoundation.org>
        <20211101082518.624936309@linuxfoundation.org>
        <871r3x2f0y.fsf@turtle.gmx.de>
        <CACO55tsq6DOZnyCZrg+N3m_hseJfN_6+YhjDyxVBAGq9PFJmGA@mail.gmail.com>
        <CACO55tsQVcUHNWAkWcbJ8i-S5pgKhrin-Nb3JYswcBPDd3Wj4w@mail.gmail.com>
Date:   Wed, 03 Nov 2021 21:47:01 +0100
In-Reply-To: <CACO55tsQVcUHNWAkWcbJ8i-S5pgKhrin-Nb3JYswcBPDd3Wj4w@mail.gmail.com>
        (Karol Herbst's message of "Wed, 3 Nov 2021 21:32:43 +0100")
Message-ID: <87tugt0xx6.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:XAluwjzMfZfmdXvp4wQQxSAIvachPCef1CQ8R4ACrlRujjgA2qT
 5El/VRyr75du07dX/FgDPXWz6QG/tJZScgi20ZPTkZv9G0FISRCOZUEf2lc3Su2yrtG+0g9
 DNrX61TUB89XkPtV1t1coc1p9dxzRK44w06p4u7o+Rrt5PULPZRKHViXVAIdiuo7sii8l3B
 MRUjOXi5kADf1kvwtHSLg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:aFNoQfnGbkQ=:0jTkXTi4D06SqxY9Ax5SH/
 4C/f6XjDs/XYvIPq7ACtHsM5H/S531O8h3vNYSmlpB/rrArow1xzVQNmN0sK8bFSr61rr3IPk
 0OPLCTjGoDLYpGaD33p2jDsXMC7mPJWU3TsLyYBoZCzccnabVrq/8/ISHTm2IL1a23y2Dyknt
 +9w22KrvIuFapBMau+mIWOCD0mMjc2xRsackE/Uz7UPxDTHFM/AKvNmc8jnGDAb2DDHf+bjYV
 mScNObGQodesYWeIHvTxxRjWgLWaYqpp7r0NrdJgjmrVId93vA9UT+g0iJwm7J4AoiifIV56D
 0valvNVu7oroOBxuP8pf5sp5kpC/wSxZN3ZoU1j04jSeeLVqX0ouD6gb50DmFmBYlRDa2DTSj
 NqOr8WHauKwPBfmqhrWG8prQoRhMhZFRkiGIhqUlEB/FKa2hCh6AsXxin2okQNVLUHt3OTjQw
 Kki827ufHI2wYAareYwDzBnY+LtLaCU65PUmyIguXTAR6QyQ+0RVRHZu140Xb/vv1NYmBO0DO
 boOLtJPRk2+l4bKMTap0LgFy0HreUxwMemvE7eypHjtw5ntfyWLj5HT9C7sYkmC6OdOou7NU5
 4xr6TQZYo79QZrruq3uBc/yBYW5dX6xjKC0wHv+V3OpLdALKwrnNxPnMbbPJDasSrnlrn6x11
 QBXPUQbc8uOJnRloAuciqoTrhzqJUSYn7vuur5ymYmt2+RjP7MHns3q3TBCmM36WkeLmdaZFr
 PCayAzBlMhcoQxVbTJ/VS8AZ/BOacLGD02veBCa6x3+mCbo58NRAD522u2R0tDlhvRQL6duNS
 8T4Qg9zPNGKCNlr3HVli17z1YY7tAzXCPk0F9Iwxv2iE0mwZSK0VICpMf+FtL5NSOsJVOmT3j
 qqKf7Vu5SG67kDcUZFVGDbsCkmewxWomxMS6K7FdTdvE5OCTeadHCbeg2+V+HVHxAvOmDEDiE
 BInb1yuyvRjyqaEyinkmcSd1nTvQ8K8NnmuiyTHf9L+5HCWTyQdf/pqztmuZzOYbXfYNo9hje
 tpvNclqn5ZYfMmCXt8dfMrXtBff0SUipyHmyI+oLEUnMJ6vgOw7xnijiZ/4mt+v3v38pvWc5r
 C08IC8LKL9Wdl8aKwxvgpK9czMO0edk2Z2r4PDpvTu0uE6hKT74JxUIoriHbCQDKevN7Mhn1I
 advggC6wI4Iu2fKEGbPcuy5Hbz+vXxKrNXSVLPGhwDUgjc5UaSjRoqP/wUcj0Kjw5miEE659j
 tw4HoQ/PNrREAXFIkHJzi0gxr51VUFO88SYLKrQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-11-03 21:32 +0100, Karol Herbst wrote:

> On Wed, Nov 3, 2021 at 9:29 PM Karol Herbst <kherbst@redhat.com> wrote:
>>
>> On Wed, Nov 3, 2021 at 8:52 PM Sven Joachim <svenjoac@gmx.de> wrote:
>> >
>> > On 2021-11-01 10:17 +0100, Greg Kroah-Hartman wrote:
>> >
>> > > From: Christian K=F6nig <christian.koenig@amd.com>
>> > >
>> > > commit 0db55f9a1bafbe3dac750ea669de9134922389b5 upstream.
>> > >
>> > > We need to cleanup the fences for ghost objects as well.
>> > >
>> > > Signed-off-by: Christian K=F6nig <christian.koenig@amd.com>
>> > > Reported-by: Erhard F. <erhard_f@mailbox.org>
>> > > Tested-by: Erhard F. <erhard_f@mailbox.org>
>> > > Reviewed-by: Huang Rui <ray.huang@amd.com>
>> > > Bug: https://bugzilla.kernel.org/show_bug.cgi?id=3D214029
>> > > Bug: https://bugzilla.kernel.org/show_bug.cgi?id=3D214447
>> > > CC: <stable@vger.kernel.org>
>> > > Link: https://patchwork.freedesktop.org/patch/msgid/20211020173211.2=
247-1-christian.koenig@amd.com
>> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> > > ---
>> > >  drivers/gpu/drm/ttm/ttm_bo_util.c |    1 +
>> > >  1 file changed, 1 insertion(+)
>> > >
>> > > --- a/drivers/gpu/drm/ttm/ttm_bo_util.c
>> > > +++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
>> > > @@ -322,6 +322,7 @@ static void ttm_transfered_destroy(struc
>> > >       struct ttm_transfer_obj *fbo;
>> > >
>> > >       fbo =3D container_of(bo, struct ttm_transfer_obj, base);
>> > > +     dma_resv_fini(&fbo->base.base._resv);
>> > >       ttm_bo_put(fbo->bo);
>> > >       kfree(fbo);
>> > >  }
>> >
>> > Alas, this innocuous looking commit causes one of my systems to lock up
>> > as soon as run startx.  This happens with the nouveau driver, two other
>> > systems with radeon and intel graphics are not affected.  Also I only
>> > noticed it in 5.10.77.  Kernels 5.15 and 5.14.16 are not affected, and=
 I
>> > do not use 5.4 anymore.
>> >
>> > I am not familiar with nouveau's ttm management and what has changed
>> > there between 5.10 and 5.14, but maybe one of their developers can shed
>> > a light on this.
>> >
>> > Cheers,
>> >        Sven
>> >
>>
>> could be related to 265ec0dd1a0d18f4114f62c0d4a794bb4e729bc1
>
> maybe not.. but I did remember there being a few tmm related patches
> which only hurt nouveau :/  I guess one could do a git bisect to
> figure out what change "fixes" it.

Maybe, but since the memory leaks reported by Erhard only started to
show up in 5.14 (if I read the bugzilla reports correctly), perhaps the
patch should simply be reverted on earlier kernels?

> On which GPU do you see this problem?

On an old GeForce 8500 GT, the whole PC is rather ancient.

Cheers,
       Sven
