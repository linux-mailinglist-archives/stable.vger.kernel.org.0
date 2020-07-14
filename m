Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92FE21EBB1
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 10:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgGNIpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 04:45:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59387 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725820AbgGNIp3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 04:45:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594716327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n8A2G5vizF7CgtfiIlPSYJUsYEYYmtXCXf3/59UQTo8=;
        b=EaMLpP3bjE55uQfKI5jvkpGfWVJ6z6dA/5weLfgcykjAbLSkBdXj0J5zjIcts7KWfzUYnc
        s1ffbm/reOkdbXo8iA/SWJyKOuYRZo30zp6cD1aWrEYgsrQ4seqcAVuA9s/NYX8Qr55zz3
        itltdjbWXYi3Q+A7h7mVGPw0vUIlOU8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-4zJY8ipnOKOYCzZdj8YzBg-1; Tue, 14 Jul 2020 04:45:26 -0400
X-MC-Unique: 4zJY8ipnOKOYCzZdj8YzBg-1
Received: by mail-wm1-f69.google.com with SMTP id b13so2905134wme.9
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 01:45:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n8A2G5vizF7CgtfiIlPSYJUsYEYYmtXCXf3/59UQTo8=;
        b=o9C3iVkxsMSciw4edTIb8hUcY5YF1bkO5+byKDoQRCXZ1oTEpzzT96r3olz/NlGmP/
         6oGYFAwDd4nOMpq2rWsMvdYf1yta2Q+85Hi7Mmloo2idq153QeFmPkLziF8wVk1d/KaL
         JXtrbMOj314FuavjEpjMwZRT7MPb2IrxeULVIRYZvmmZ2+K/SWtAl8JLl2Mw/JGMCpwS
         vLrZwXTte8Me1WVtyENDJTYZ6y+TX8oQw+3cGamd79ObP+X+g+wgWxsf7lv26QVk4IZa
         WAuiy6f7d0OuOEGWq8NNm6j7bq/eOcYludPoI6ySVdOuk3rN6njUk2DssPtSiwxScZ7g
         AARQ==
X-Gm-Message-State: AOAM5330b/KC4jUcIXFGXgAbMQFB+ckzAXvS2QVfp6Zp70depcJ/X/L9
        rkeD0UeZNBkEBCInfYcdDi27GI3FE9318jzmgn3X0QklY6AxuXxspvcnZmxbYHfBu7CWFdk0QUY
        sQGBu5NEzA6KKwTiE
X-Received: by 2002:a5d:55c9:: with SMTP id i9mr3810341wrw.404.1594716324857;
        Tue, 14 Jul 2020 01:45:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw+aHKVdbP2Oys421PgxREy4EGx+JNbt1AzTEV/jQbfdeekPWnshfuJL9hywzi3Xa6CYgcomw==
X-Received: by 2002:a5d:55c9:: with SMTP id i9mr3810320wrw.404.1594716324605;
        Tue, 14 Jul 2020 01:45:24 -0700 (PDT)
Received: from redhat.com (bzq-79-180-10-140.red.bezeqint.net. [79.180.10.140])
        by smtp.gmail.com with ESMTPSA id z10sm28691186wrm.21.2020.07.14.01.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 01:45:23 -0700 (PDT)
Date:   Tue, 14 Jul 2020 04:45:21 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio_balloon: clear modern features under legacy
Message-ID: <20200714044017-mutt-send-email-mst@kernel.org>
References: <20200710113046.421366-1-mst@redhat.com>
 <CAKgT0UeZN+mOWNhgiT0btZTyki3TPoj7pbqA+__GkCxoifPqeg@mail.gmail.com>
 <20200712105926-mutt-send-email-mst@kernel.org>
 <CAKgT0UdY1xpEH1Hg4HWJEkGwH5s64sm1y4O_XmHe8P_f=tDhpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UdY1xpEH1Hg4HWJEkGwH5s64sm1y4O_XmHe8P_f=tDhpg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 13, 2020 at 08:10:14AM -0700, Alexander Duyck wrote:
> On Sun, Jul 12, 2020 at 8:10 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Fri, Jul 10, 2020 at 09:13:41AM -0700, Alexander Duyck wrote:
> > > On Fri, Jul 10, 2020 at 4:31 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > Page reporting features were never supported by legacy hypervisors.
> > > > Supporting them poses a problem: should we use native endian-ness (like
> > > > current code assumes)? Or little endian-ness like the virtio spec says?
> > > > Rather than try to figure out, and since results of
> > > > incorrect endian-ness are dire, let's just block this configuration.
> > > >
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > >
> > > So I am not sure about the patch description. In the case of page
> > > poison and free page reporting I don't think we are defining anything
> > > that doesn't already have a definition of how to use in legacy.
> > > Specifically the virtio_balloon_config is already defined as having
> > > all fields as little endian in legacy mode, and there is a definition
> > > for all of the fields in a virtqueue and how they behave in legacy
> > > mode.
> > >
> > > As far as I can see the only item that may be an issue is the command
> > > ID being supplied via the virtqueue for free page hinting, which
> > > appears to be in native endian-ness. Otherwise it would have fallen
> > > into the same category since it is making use of virtio_balloon_config
> > > and a virtqueue for supplying the page location and length.
> >
> >
> >
> > So as you point out correctly balloon spec says all fields are little
> > endian.  Fair enough.
> > Problem is when virtio 1 is not negotiated, then this is not what the
> > driver assumes for any except a handlful of fields.
> >
> > But yes it mostly works out.
> >
> > For example:
> >
> >
> > static void update_balloon_size(struct virtio_balloon *vb)
> > {
> >         u32 actual = vb->num_pages;
> >
> >         /* Legacy balloon config space is LE, unlike all other devices. */
> >         if (!virtio_has_feature(vb->vdev, VIRTIO_F_VERSION_1))
> >                 actual = (__force u32)cpu_to_le32(actual);
> >
> >         virtio_cwrite(vb->vdev, struct virtio_balloon_config, actual,
> >                       &actual);
> > }
> >
> >
> > this is LE even without VIRTIO_F_VERSION_1, so matches spec.
> >
> >                 /* Start with poison val of 0 representing general init */
> >                 __u32 poison_val = 0;
> >
> >                 /*
> >                  * Let the hypervisor know that we are expecting a
> >                  * specific value to be written back in balloon pages.
> >                  */
> >                 if (!want_init_on_free())
> >                         memset(&poison_val, PAGE_POISON, sizeof(poison_val));
> >
> >                 virtio_cwrite(vb->vdev, struct virtio_balloon_config,
> >                               poison_val, &poison_val);
> >
> >
> > actually this writes a native endian-ness value. All bytes happen to be
> > the same though, and host only cares about 0 or non 0 ATM.
> 
> So we are safe assuming it is a repeating value, but for correctness
> maybe we should make certain to cast this as a le32 value. I can
> submit a patch to do that.

Thanks! But not yet - I am poking at the endian-ness things right now!

> > As you say correctly the command id is actually assumed native endian:
> >
> >
> > static u32 virtio_balloon_cmd_id_received(struct virtio_balloon *vb)
> > {
> >         if (test_and_clear_bit(VIRTIO_BALLOON_CONFIG_READ_CMD_ID,
> >                                &vb->config_read_bitmap))
> >                 virtio_cread(vb->vdev, struct virtio_balloon_config,
> >                              free_page_hint_cmd_id,
> >                              &vb->cmd_id_received_cache);
> >
> >         return vb->cmd_id_received_cache;
> > }
> >
> >
> > So guest assumes native, host assumes LE.
> 
> This wasn't even the one I was talking about, but now that you point
> it out this is definately bug. The command ID I was talking about was
> the one being passed via the descriptor ring. That one I believe is
> native on both sides.

Well qemu swaps it for modern devices:

        virtio_tswap32s(vdev, &id);

guest swaps it too:
        vb->cmd_id_active = cpu_to_virtio32(vb->vdev,
                                        virtio_balloon_cmd_id_received(vb));
        sg_init_one(&sg, &vb->cmd_id_active, sizeof(vb->cmd_id_active));
        err = virtqueue_add_outbuf(vq, &sg, 1, &vb->cmd_id_active, GFP_KERNEL);

So it's native for legacy.



> >
> >
> >
> > > > ---
> > > >  drivers/virtio/virtio_balloon.c | 9 +++++++++
> > > >  1 file changed, 9 insertions(+)
> > > >
> > > > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > > > index 5d4b891bf84f..b9bc03345157 100644
> > > > --- a/drivers/virtio/virtio_balloon.c
> > > > +++ b/drivers/virtio/virtio_balloon.c
> > > > @@ -1107,6 +1107,15 @@ static int virtballoon_restore(struct virtio_device *vdev)
> > > >
> > > >  static int virtballoon_validate(struct virtio_device *vdev)
> > > >  {
> > > > +       /*
> > > > +        * Legacy devices never specified how modern features should behave.
> > > > +        * E.g. which endian-ness to use? Better not to assume anything.
> > > > +        */
> > > > +       if (!virtio_has_feature(vdev, VIRTIO_F_VERSION_1)) {
> > > > +               __virtio_clear_bit(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT);
> > > > +               __virtio_clear_bit(vdev, VIRTIO_BALLOON_F_PAGE_POISON);
> > > > +               __virtio_clear_bit(vdev, VIRTIO_BALLOON_F_REPORTING);
> > > > +       }
> > > >         /*
> > > >          * Inform the hypervisor that our pages are poisoned or
> > > >          * initialized. If we cannot do that then we should disable
> > >
> > > The patch content itself I am fine with since odds are nobody would
> > > expect to use these features with a legacy device.
> > >
> > > Acked-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> >
> > Hmm so now you pointed out it's just cmd id, maybe I should just fix it
> > instead? what do you say?
> 
> So the config issues are bugs, but I don't think you saw the one I was
> talking about. In the function send_cmd_id_start the cmd_id_active
> value which is initialized as a virtio32 is added as a sg entry and
> then sent as an outbuf to the device. I'm assuming virtio32 is a host
> native byte ordering.

IIUC it isn't :) virtio32 is guest native if device is legacy, and LE if
device is modern.

-- 
MST

