Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 979E0333714
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 09:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhCJINR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 03:13:17 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:59210 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbhCJIM4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 03:12:56 -0500
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id A9743F3;
        Wed, 10 Mar 2021 09:12:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1615363974;
        bh=p4o+P+DQ74y4yqjC73QioWWOWOlWjgSrnbi5iNTpD28=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TpnC23MxTmNMaLkZ3tij641VlgTTGnCgUNjbOiCc7L+sNkIAPGVxUwhGTFkIdyN8Q
         Rw0Dow8jOSx0h9HL3nSrHhnF1a/AGlvn4plGxD+9n0tj6htyFIQQktnOy1GcfTj9zV
         vTEwR7Ezm/GZKPYRYr+SidWcBQ5ATtOSmVkhPPZ4=
Date:   Wed, 10 Mar 2021 10:12:22 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     Tomasz Figa <tfiga@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] media: videobuf2: Fix integer overrun in allocation
Message-ID: <YEh/ZsfC34+aGI0Q@pendragon.ideasonboard.com>
References: <20210309234317.1021588-1-ribalda@chromium.org>
 <YEh6AIQPa75MzP+8@pendragon.ideasonboard.com>
 <CANiDSCuz76q0Ukq5UfrgeRH_JFWKQ9hCpMqZTHUtiwHxpEd4oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANiDSCuz76q0Ukq5UfrgeRH_JFWKQ9hCpMqZTHUtiwHxpEd4oQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ricardo,

On Wed, Mar 10, 2021 at 08:58:39AM +0100, Ricardo Ribalda wrote:
> On Wed, Mar 10, 2021 at 8:49 AM Laurent Pinchart wrote:
> > On Wed, Mar 10, 2021 at 12:43:17AM +0100, Ricardo Ribalda wrote:
> > > The plane_length is an unsigned integer. So, if we have a size of
> > > 0xffffffff bytes we incorrectly allocate 0 bytes instead of 1 << 32.
> > >
> > > Cc: stable@vger.kernel.org
> > > Fixes: 7f8414594e47 ("[media] media: videobuf2: fix the length check for mmap")
> > > Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> > > ---
> > >  drivers/media/common/videobuf2/videobuf2-core.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> > > index 02281d13505f..543da515c761 100644
> > > --- a/drivers/media/common/videobuf2/videobuf2-core.c
> > > +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> > > @@ -223,8 +223,10 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
> > >        * NOTE: mmapped areas should be page aligned
> > >        */
> > >       for (plane = 0; plane < vb->num_planes; ++plane) {
> > > +             unsigned long size = vb->planes[plane].length;
> >
> > unsigned long is still 32-bit on 32-bit platforms.
> >
> > > +
> > >               /* Memops alloc requires size to be page aligned. */
> > > -             unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
> > > +             size = PAGE_ALIGN(size);
> > >
> > >               /* Did it wrap around? */
> > >               if (size < vb->planes[plane].length)
> >
> > Doesn't this address the issue already ?
> 
> Yes and no. If you need to allocate 0xffffffff you are still affected
> by the underrun. The core will return an error instead of doing the
> allocation.
> 
> (yes, I know it is a lot of memory for a buffer)

That's my point, I don't think there's a need for this :-) Especially
with v4l2_buffer.m.offset being a __u32, we are limited to 4GB for *all*
buffers.

-- 
Regards,

Laurent Pinchart
