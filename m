Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F4421F83D
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 19:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728830AbgGNRcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 13:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbgGNRcI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 13:32:08 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F37C061755;
        Tue, 14 Jul 2020 10:32:08 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id i4so18122403iov.11;
        Tue, 14 Jul 2020 10:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fyd1Yem61aBK9j4xH0v8TMCTQl2WFmnBvLzZWnwdnEc=;
        b=tHaFTot19KPHp0MlA0uocYvaOfJzaYZ5AoPy3T9fENTCX/ku/bwFYSdr5A461u5H/B
         xbGJA30Vt6hsgAc6nl3XF22cNxedx4Px4/vwAsBod5/hmk8YP1vE0/hHw7zP03NEGraw
         D/siRebVYWD9N+/1mOlVmPN/7TlJ77LGx7Ynxyi4kBO2svfB7/D8lvqexWnc4oV1x2Bh
         zRs9q+7R218hm3SarF5+KQ8/toBryohiSFcxyv6Ij/7Dt2YZi2KlyEkc430bayEZPYhF
         OhbWsp2jJ2VNZjFuSBvyM6plx4Gq4PtxhHrRtqIatdjHSuqJKUegDO0Sy28+QlYoD6sW
         JPHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fyd1Yem61aBK9j4xH0v8TMCTQl2WFmnBvLzZWnwdnEc=;
        b=b58tivEr64G/fnUz3qPLMZb2kW+SKNbuQgLDavUSNGTVLW746UsGCHIzU3qp7+KKcf
         DwtT0FDUYjNYCPv9hNmOAv0IKMj11yg6tDE/sC+hNSHyxhXn0MyS2udRgnSmwywRfM/Q
         yZ1IebrObNINIfQ15JuahBWzuDviE83haOyqvlIOETZpMyJJdtFwHLyvddXzXc0mhL1c
         gBC9y1W9EUXN4YXLgca2vwdn+kZA/7c/W+yND6vM0vUxc8sMHurzA0pVxGmt9DyzQcx2
         aQFppQQxqTimQP5O9tW/+LVADgDgCP717Xj5SBVCERSchXlKPLtaGTDA0G2NHaQfbixF
         0tiA==
X-Gm-Message-State: AOAM531NcfrDS9Nl0eMjQ+1ZhZBjPHgRKQhF20tzfovAeRU72OA0flqV
        a4hFHPspGA6hwoAt540Ca5tMy4DouYSkYwF12/aEpYGM
X-Google-Smtp-Source: ABdhPJx1N5E0GF7/F0ba6GbZ0mPoX1MKXs80ni9M2TowfvxnnTLsD0VvV0KlxZLoPSUGdtczPlbRSc4bn9Y0Z5hlfSg=
X-Received: by 2002:a6b:2b12:: with SMTP id r18mr5852785ior.88.1594747927418;
 Tue, 14 Jul 2020 10:32:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200710113046.421366-1-mst@redhat.com> <CAKgT0UeZN+mOWNhgiT0btZTyki3TPoj7pbqA+__GkCxoifPqeg@mail.gmail.com>
 <20200712105926-mutt-send-email-mst@kernel.org> <CAKgT0UdY1xpEH1Hg4HWJEkGwH5s64sm1y4O_XmHe8P_f=tDhpg@mail.gmail.com>
 <20200714044017-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200714044017-mutt-send-email-mst@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 14 Jul 2020 10:31:56 -0700
Message-ID: <CAKgT0Ud_AFpB-=uCB_3qY8pFvG9Kj7OFSmFG76LZC9K91oUG2w@mail.gmail.com>
Subject: Re: [PATCH] virtio_balloon: clear modern features under legacy
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 14, 2020 at 1:45 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Jul 13, 2020 at 08:10:14AM -0700, Alexander Duyck wrote:
> > On Sun, Jul 12, 2020 at 8:10 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Fri, Jul 10, 2020 at 09:13:41AM -0700, Alexander Duyck wrote:
> > > > On Fri, Jul 10, 2020 at 4:31 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > >

<snip>

> > > As you say correctly the command id is actually assumed native endian:
> > >
> > >
> > > static u32 virtio_balloon_cmd_id_received(struct virtio_balloon *vb)
> > > {
> > >         if (test_and_clear_bit(VIRTIO_BALLOON_CONFIG_READ_CMD_ID,
> > >                                &vb->config_read_bitmap))
> > >                 virtio_cread(vb->vdev, struct virtio_balloon_config,
> > >                              free_page_hint_cmd_id,
> > >                              &vb->cmd_id_received_cache);
> > >
> > >         return vb->cmd_id_received_cache;
> > > }
> > >
> > >
> > > So guest assumes native, host assumes LE.
> >
> > This wasn't even the one I was talking about, but now that you point
> > it out this is definately bug. The command ID I was talking about was
> > the one being passed via the descriptor ring. That one I believe is
> > native on both sides.
>
> Well qemu swaps it for modern devices:
>
>         virtio_tswap32s(vdev, &id);
>
> guest swaps it too:
>         vb->cmd_id_active = cpu_to_virtio32(vb->vdev,
>                                         virtio_balloon_cmd_id_received(vb));
>         sg_init_one(&sg, &vb->cmd_id_active, sizeof(vb->cmd_id_active));
>         err = virtqueue_add_outbuf(vq, &sg, 1, &vb->cmd_id_active, GFP_KERNEL);
>
> So it's native for legacy.

Okay, that makes sense. I just wasn't familiar with the virtio32 type.

I guess that just means we need to fix the original issue you found
where the guest was assuming native for the command ID in the config.
Do you plan to patch that or should I?

> > >
> > >
> > >
> > > > > ---
> > > > >  drivers/virtio/virtio_balloon.c | 9 +++++++++
> > > > >  1 file changed, 9 insertions(+)
> > > > >
> > > > > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > > > > index 5d4b891bf84f..b9bc03345157 100644
> > > > > --- a/drivers/virtio/virtio_balloon.c
> > > > > +++ b/drivers/virtio/virtio_balloon.c
> > > > > @@ -1107,6 +1107,15 @@ static int virtballoon_restore(struct virtio_device *vdev)
> > > > >
> > > > >  static int virtballoon_validate(struct virtio_device *vdev)
> > > > >  {
> > > > > +       /*
> > > > > +        * Legacy devices never specified how modern features should behave.
> > > > > +        * E.g. which endian-ness to use? Better not to assume anything.
> > > > > +        */
> > > > > +       if (!virtio_has_feature(vdev, VIRTIO_F_VERSION_1)) {
> > > > > +               __virtio_clear_bit(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT);
> > > > > +               __virtio_clear_bit(vdev, VIRTIO_BALLOON_F_PAGE_POISON);
> > > > > +               __virtio_clear_bit(vdev, VIRTIO_BALLOON_F_REPORTING);
> > > > > +       }
> > > > >         /*
> > > > >          * Inform the hypervisor that our pages are poisoned or
> > > > >          * initialized. If we cannot do that then we should disable
> > > >
> > > > The patch content itself I am fine with since odds are nobody would
> > > > expect to use these features with a legacy device.
> > > >
> > > > Acked-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > >
> > > Hmm so now you pointed out it's just cmd id, maybe I should just fix it
> > > instead? what do you say?
> >
> > So the config issues are bugs, but I don't think you saw the one I was
> > talking about. In the function send_cmd_id_start the cmd_id_active
> > value which is initialized as a virtio32 is added as a sg entry and
> > then sent as an outbuf to the device. I'm assuming virtio32 is a host
> > native byte ordering.
>
> IIUC it isn't :) virtio32 is guest native if device is legacy, and LE if
> device is modern.

Okay. So I should probably document that for the spec I have been
working on. It looks like there is an example of similar documentation
for the memory statistics so it should be pretty straight forward.

Thanks.

- Alex
