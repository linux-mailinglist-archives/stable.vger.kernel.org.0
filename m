Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D735821D9D0
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 17:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbgGMPK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 11:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729308AbgGMPK0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jul 2020 11:10:26 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD50C061755;
        Mon, 13 Jul 2020 08:10:26 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id h16so11412034ilj.11;
        Mon, 13 Jul 2020 08:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0aLviF1Tp3qA2WKh5TL8kBFDCcYaBAEuv96ryJ3BdEQ=;
        b=D/QxOz4WvIUD4B3lvyIkXS7SAxqk0KrEw76vSE31m21XfLI1cegHHImvvF+qnfZzcd
         JaG5NzQJvqKNc9Dl+lQrD5TNco65lp04gJqJCfVB1t1nPN/3lnzwtk17EhR2ow/XIwhM
         lbwHRGsF+Shk9P3STfL2y6N9Vu6d1qPBjQS8E+rQroQa7fYNBA3uvzdQQ02T3BfAJrlS
         PfhhLQS8IA/tRuFgaNOgoYwN3adcsEAbjJX8AlAz+LO04Am3SqhL69WdkNlICCAx4vAH
         D/pIj3pyS22Q5KDpgUqJF0AKw8J+SILPn0Ga7E2/wLxBae/MWIFCb2r9GG2vivkhw5bl
         Ta/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0aLviF1Tp3qA2WKh5TL8kBFDCcYaBAEuv96ryJ3BdEQ=;
        b=UEF+M/FYf/eXvvjA5W5hhyroySc0DJrxozk3Lg9XJCjq/JDfHAEqtXS5thLpcQw8/9
         tZDUm7TYdDX67tt1RXsh5hZiJ4sq+izjsSwxADV0nXg74IA7CtY7SHfdXRwIpGQKg4lr
         NcR7EV8e1i5BRAFWnmY+LpuGRElzLov/MVGeNp0w01TFOId9YPKLcqSFZt6VK/FN9wX8
         zD79bf94HYoLg0jDY++Xt+mxzUiY/bPp+yHnyW4Q2AZi+yL4JgTMzekbeHHgrx8vNMFP
         o3EwYbjJikZrFRC5CTyuS8M6+CizxwtOai7lg8EZyN8Ce2UP+xl/bPWyjqm4p7GITibu
         cIYg==
X-Gm-Message-State: AOAM5320mnpTrpjlFmYey1cCbKrPz/ly1mPrPOkOlhzgymzIfbViJF8U
        MdpYQaOQFUQa4a/foFPfWsJMb6Y+OQFD9sy82W4Up6Sb
X-Google-Smtp-Source: ABdhPJz7fEoAdjaSgaCNKEkg33tHudeh5sEOS1URoEDTxPr92qH0X2OfEk+7e2oQcfcZ76Rxra0Ar6VviU2oCqYGB8c=
X-Received: by 2002:a92:bd0f:: with SMTP id c15mr113475ile.95.1594653025301;
 Mon, 13 Jul 2020 08:10:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200710113046.421366-1-mst@redhat.com> <CAKgT0UeZN+mOWNhgiT0btZTyki3TPoj7pbqA+__GkCxoifPqeg@mail.gmail.com>
 <20200712105926-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200712105926-mutt-send-email-mst@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 13 Jul 2020 08:10:14 -0700
Message-ID: <CAKgT0UdY1xpEH1Hg4HWJEkGwH5s64sm1y4O_XmHe8P_f=tDhpg@mail.gmail.com>
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

On Sun, Jul 12, 2020 at 8:10 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Fri, Jul 10, 2020 at 09:13:41AM -0700, Alexander Duyck wrote:
> > On Fri, Jul 10, 2020 at 4:31 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > Page reporting features were never supported by legacy hypervisors.
> > > Supporting them poses a problem: should we use native endian-ness (like
> > > current code assumes)? Or little endian-ness like the virtio spec says?
> > > Rather than try to figure out, and since results of
> > > incorrect endian-ness are dire, let's just block this configuration.
> > >
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >
> > So I am not sure about the patch description. In the case of page
> > poison and free page reporting I don't think we are defining anything
> > that doesn't already have a definition of how to use in legacy.
> > Specifically the virtio_balloon_config is already defined as having
> > all fields as little endian in legacy mode, and there is a definition
> > for all of the fields in a virtqueue and how they behave in legacy
> > mode.
> >
> > As far as I can see the only item that may be an issue is the command
> > ID being supplied via the virtqueue for free page hinting, which
> > appears to be in native endian-ness. Otherwise it would have fallen
> > into the same category since it is making use of virtio_balloon_config
> > and a virtqueue for supplying the page location and length.
>
>
>
> So as you point out correctly balloon spec says all fields are little
> endian.  Fair enough.
> Problem is when virtio 1 is not negotiated, then this is not what the
> driver assumes for any except a handlful of fields.
>
> But yes it mostly works out.
>
> For example:
>
>
> static void update_balloon_size(struct virtio_balloon *vb)
> {
>         u32 actual = vb->num_pages;
>
>         /* Legacy balloon config space is LE, unlike all other devices. */
>         if (!virtio_has_feature(vb->vdev, VIRTIO_F_VERSION_1))
>                 actual = (__force u32)cpu_to_le32(actual);
>
>         virtio_cwrite(vb->vdev, struct virtio_balloon_config, actual,
>                       &actual);
> }
>
>
> this is LE even without VIRTIO_F_VERSION_1, so matches spec.
>
>                 /* Start with poison val of 0 representing general init */
>                 __u32 poison_val = 0;
>
>                 /*
>                  * Let the hypervisor know that we are expecting a
>                  * specific value to be written back in balloon pages.
>                  */
>                 if (!want_init_on_free())
>                         memset(&poison_val, PAGE_POISON, sizeof(poison_val));
>
>                 virtio_cwrite(vb->vdev, struct virtio_balloon_config,
>                               poison_val, &poison_val);
>
>
> actually this writes a native endian-ness value. All bytes happen to be
> the same though, and host only cares about 0 or non 0 ATM.

So we are safe assuming it is a repeating value, but for correctness
maybe we should make certain to cast this as a le32 value. I can
submit a patch to do that.

> As you say correctly the command id is actually assumed native endian:
>
>
> static u32 virtio_balloon_cmd_id_received(struct virtio_balloon *vb)
> {
>         if (test_and_clear_bit(VIRTIO_BALLOON_CONFIG_READ_CMD_ID,
>                                &vb->config_read_bitmap))
>                 virtio_cread(vb->vdev, struct virtio_balloon_config,
>                              free_page_hint_cmd_id,
>                              &vb->cmd_id_received_cache);
>
>         return vb->cmd_id_received_cache;
> }
>
>
> So guest assumes native, host assumes LE.

This wasn't even the one I was talking about, but now that you point
it out this is definately bug. The command ID I was talking about was
the one being passed via the descriptor ring. That one I believe is
native on both sides.

>
>
>
> > > ---
> > >  drivers/virtio/virtio_balloon.c | 9 +++++++++
> > >  1 file changed, 9 insertions(+)
> > >
> > > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > > index 5d4b891bf84f..b9bc03345157 100644
> > > --- a/drivers/virtio/virtio_balloon.c
> > > +++ b/drivers/virtio/virtio_balloon.c
> > > @@ -1107,6 +1107,15 @@ static int virtballoon_restore(struct virtio_device *vdev)
> > >
> > >  static int virtballoon_validate(struct virtio_device *vdev)
> > >  {
> > > +       /*
> > > +        * Legacy devices never specified how modern features should behave.
> > > +        * E.g. which endian-ness to use? Better not to assume anything.
> > > +        */
> > > +       if (!virtio_has_feature(vdev, VIRTIO_F_VERSION_1)) {
> > > +               __virtio_clear_bit(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT);
> > > +               __virtio_clear_bit(vdev, VIRTIO_BALLOON_F_PAGE_POISON);
> > > +               __virtio_clear_bit(vdev, VIRTIO_BALLOON_F_REPORTING);
> > > +       }
> > >         /*
> > >          * Inform the hypervisor that our pages are poisoned or
> > >          * initialized. If we cannot do that then we should disable
> >
> > The patch content itself I am fine with since odds are nobody would
> > expect to use these features with a legacy device.
> >
> > Acked-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>
> Hmm so now you pointed out it's just cmd id, maybe I should just fix it
> instead? what do you say?

So the config issues are bugs, but I don't think you saw the one I was
talking about. In the function send_cmd_id_start the cmd_id_active
value which is initialized as a virtio32 is added as a sg entry and
then sent as an outbuf to the device. I'm assuming virtio32 is a host
native byte ordering.
