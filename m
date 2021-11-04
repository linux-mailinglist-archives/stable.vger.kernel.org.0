Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD5D44508B
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 09:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhKDIr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 04:47:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231160AbhKDIr1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 04:47:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 292056121E;
        Thu,  4 Nov 2021 08:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636015489;
        bh=kwiMbVSFUNrWxc9I+E615tdE1kmkiFiM6b1Af4OjufA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0YPm3BSITEzrUrHl4UtOiIRtRAZ462IMRYImpfOPmPOFL0cVUoVRJfWmIemS63AxK
         G3bwKQWOT1/UKTv4Istd3WbOGRZZ9zMpGKaqb0Hg8DG58cfsgTRi/CANIwNNXvd/0N
         ACNYT+DMITJKiLMPkB5wtYfQZu/f78hCFhMSsxB0=
Date:   Thu, 4 Nov 2021 09:44:47 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc:     Karol Herbst <kherbst@redhat.com>, Sven Joachim <svenjoac@gmx.de>,
        "Erhard F." <erhard_f@mailbox.org>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Huang Rui <ray.huang@amd.com>
Subject: Re: [Nouveau] [PATCH 5.10 32/77] drm/ttm: fix memleak in
 ttm_transfered_destroy
Message-ID: <YYOdfzrgpD2LST88@kroah.com>
References: <20211101082511.254155853@linuxfoundation.org>
 <20211101082518.624936309@linuxfoundation.org>
 <871r3x2f0y.fsf@turtle.gmx.de>
 <CACO55tsq6DOZnyCZrg+N3m_hseJfN_6+YhjDyxVBAGq9PFJmGA@mail.gmail.com>
 <CACO55tsQVcUHNWAkWcbJ8i-S5pgKhrin-Nb3JYswcBPDd3Wj4w@mail.gmail.com>
 <87tugt0xx6.fsf@turtle.gmx.de>
 <CACO55tsNKKTW6X_+Ym0oySX-iNtikyV6rgHGu01Co7_mDWkxhg@mail.gmail.com>
 <1a1cc125-9314-f569-a6c4-40fc4509a377@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a1cc125-9314-f569-a6c4-40fc4509a377@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 08:39:18AM +0100, Christian König wrote:
> Am 03.11.21 um 22:25 schrieb Karol Herbst:
> > On Wed, Nov 3, 2021 at 9:47 PM Sven Joachim <svenjoac@gmx.de> wrote:
> > > On 2021-11-03 21:32 +0100, Karol Herbst wrote:
> > > 
> > > > On Wed, Nov 3, 2021 at 9:29 PM Karol Herbst <kherbst@redhat.com> wrote:
> > > > > On Wed, Nov 3, 2021 at 8:52 PM Sven Joachim <svenjoac@gmx.de> wrote:
> > > > > > On 2021-11-01 10:17 +0100, Greg Kroah-Hartman wrote:
> > > > > > 
> > > > > > > From: Christian König <christian.koenig@amd.com>
> > > > > > > 
> > > > > > > commit 0db55f9a1bafbe3dac750ea669de9134922389b5 upstream.
> > > > > > > 
> > > > > > > We need to cleanup the fences for ghost objects as well.
> > > > > > > 
> > > > > > > Signed-off-by: Christian König <christian.koenig@amd.com>
> > > > > > > Reported-by: Erhard F. <erhard_f@mailbox.org>
> > > > > > > Tested-by: Erhard F. <erhard_f@mailbox.org>
> > > > > > > Reviewed-by: Huang Rui <ray.huang@amd.com>
> > > > > > > Bug: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D214029&amp;data=04%7C01%7Cchristian.koenig%40amd.com%7C9b70f83c53c74b35fee808d99f1091b3%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637715715806624439%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=UIo0hw0OHeLlGL%2Bcj%2Fjt%2FgTwniaJoNmhgDHSFvymhCc%3D&amp;reserved=0
> > > > > > > Bug: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D214447&amp;data=04%7C01%7Cchristian.koenig%40amd.com%7C9b70f83c53c74b35fee808d99f1091b3%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637715715806634433%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=TIAUb6AdYm2Bo0%2BvFZUFPS8yu55orjnfxMLCmUgC%2FDk%3D&amp;reserved=0
> > > > > > > CC: <stable@vger.kernel.org>
> > > > > > > Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpatchwork.freedesktop.org%2Fpatch%2Fmsgid%2F20211020173211.2247-1-christian.koenig%40amd.com&amp;data=04%7C01%7Cchristian.koenig%40amd.com%7C9b70f83c53c74b35fee808d99f1091b3%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637715715806634433%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=c9i7AR44MVUyZuXHZkLOCBx2%2BZeetq8alGtbz0Wgqzk%3D&amp;reserved=0
> > > > > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > > > ---
> > > > > > >   drivers/gpu/drm/ttm/ttm_bo_util.c |    1 +
> > > > > > >   1 file changed, 1 insertion(+)
> > > > > > > 
> > > > > > > --- a/drivers/gpu/drm/ttm/ttm_bo_util.c
> > > > > > > +++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
> > > > > > > @@ -322,6 +322,7 @@ static void ttm_transfered_destroy(struc
> > > > > > >        struct ttm_transfer_obj *fbo;
> > > > > > > 
> > > > > > >        fbo = container_of(bo, struct ttm_transfer_obj, base);
> > > > > > > +     dma_resv_fini(&fbo->base.base._resv);
> > > > > > >        ttm_bo_put(fbo->bo);
> > > > > > >        kfree(fbo);
> > > > > > >   }
> > > > > > Alas, this innocuous looking commit causes one of my systems to lock up
> > > > > > as soon as run startx.  This happens with the nouveau driver, two other
> > > > > > systems with radeon and intel graphics are not affected.  Also I only
> > > > > > noticed it in 5.10.77.  Kernels 5.15 and 5.14.16 are not affected, and I
> > > > > > do not use 5.4 anymore.
> > > > > > 
> > > > > > I am not familiar with nouveau's ttm management and what has changed
> > > > > > there between 5.10 and 5.14, but maybe one of their developers can shed
> > > > > > a light on this.
> > > > > > 
> > > > > > Cheers,
> > > > > >         Sven
> > > > > > 
> > > > > could be related to 265ec0dd1a0d18f4114f62c0d4a794bb4e729bc1
> > > > maybe not.. but I did remember there being a few tmm related patches
> > > > which only hurt nouveau :/  I guess one could do a git bisect to
> > > > figure out what change "fixes" it.
> > > Maybe, but since the memory leaks reported by Erhard only started to
> > > show up in 5.14 (if I read the bugzilla reports correctly), perhaps the
> > > patch should simply be reverted on earlier kernels?
> > > 
> > Yeah, I think this is probably the right approach.
> 
> I agree. The problem is this memory leak could potentially happen with 5.10
> as wel, just much much much less likely.
> 
> But my guess is that 5.10 is so buggy that when the leak does NOT happen we
> double free and obviously causing a crash.
> 
> So for the sake of stability please don't apply this patch to 5.10. I'm
> going to comment on the original bug report as well.

Now reverted from 5.10 and 5.4 kernels, thanks,

greg k-h
