Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B40942D207
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 07:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhJNF5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 01:57:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55863 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229502AbhJNF5v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Oct 2021 01:57:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634190947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BAJQlUnpJGNYVVkjFBgbYcXUFXkFAM867FKrPwKtnBU=;
        b=NNDQZ+bdSYTRHFAsQEbP6mmTdTKpQq7mcneILI+pWw6nmZ6YtuUZXrMe4PZxiRaxviOtNv
        IPZ/Dt2PDRSR5dRVznFitR6qgtcSviqDTUTgHPBgozuvacAVkd/FSxAh/4R//cU/sTCga+
        NFzJ/7klAQGMVOCU7K3vC2oVPG5FrCM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-9bMlmo4PMQC7F3ZnqiiCVQ-1; Thu, 14 Oct 2021 01:55:46 -0400
X-MC-Unique: 9bMlmo4PMQC7F3ZnqiiCVQ-1
Received: by mail-ed1-f70.google.com with SMTP id v9-20020a50d849000000b003db459aa3f5so4208851edj.15
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 22:55:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BAJQlUnpJGNYVVkjFBgbYcXUFXkFAM867FKrPwKtnBU=;
        b=dYAefP2xxP0NZQ30S3GFgyW4du/XFDAamo6ddv69vvbFvVkSTyhbbmskMzwdWuZGmM
         3Hy8nY7mgjMqF6+OszWWdWP9gqVmFd4trQ1A+yVVj93mywhWa1aavxcup4fHfvJVvGxn
         jS5AuK4fTLBOgxI2fUtomkzwrIFG9c9begHjc+J+Au2O0fqXTvOcoN3YpJbGghsp1EMh
         v+4sZGln3xeFDg/ZSHYhdGHm1bTJCPVcPmVm7/gMSfSr0u0UWl1L2tw9iw0UPfIWyb64
         kIdK2iiiGAS9tlG/l9EjqbQNt5iqI/IKqgd9kyyt3EM+a1srN+ovM90TDL0vPAlZURuk
         YGNA==
X-Gm-Message-State: AOAM5303/9VJlxXCIgOmiIOBcPnuz4cykx24Nd4GV1PSQq5DxXlGAJNc
        cbC9+WmNsbeCQ8LU+uOokJJhbf7peb7/0OG+50OoqbSGN3+02EWd2YnU6tA75pIecLmRKEsvcVZ
        rpWi+8ILs+FcicYpn
X-Received: by 2002:a17:906:fb19:: with SMTP id lz25mr1476008ejb.406.1634190944463;
        Wed, 13 Oct 2021 22:55:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzkfgQIXxK3a8hnf8Yk/1EOBU93PwQ/K7bp1CzcCdKlz/OHkGbWKA2JjGysHrbIwPi9cJl4zA==
X-Received: by 2002:a17:906:fb19:: with SMTP id lz25mr1475987ejb.406.1634190944256;
        Wed, 13 Oct 2021 22:55:44 -0700 (PDT)
Received: from redhat.com ([2.55.16.227])
        by smtp.gmail.com with ESMTPSA id oz11sm1030711ejc.72.2021.10.13.22.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 22:55:43 -0700 (PDT)
Date:   Thu, 14 Oct 2021 01:55:39 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-block@vger.kernel.org
Subject: Re: [PATCH] Revert "virtio-blk: Add validation for block size in
 config space"
Message-ID: <20211014015029-mutt-send-email-mst@kernel.org>
References: <20211013124553.23803-1-mst@redhat.com>
 <CACGkMEvoE8+FxvX_vJEqEuqHptHu1-0TyM4j1P=cnRiBD6-1vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEvoE8+FxvX_vJEqEuqHptHu1-0TyM4j1P=cnRiBD6-1vA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 14, 2021 at 10:45:25AM +0800, Jason Wang wrote:
> On Wed, Oct 13, 2021 at 8:46 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > It turns out that access to config space before completing the feature
> > negotiation is broken for big endian guests at least with QEMU hosts up
> > to 6.1 inclusive.  This affects any device that accesses config space in
> > the validate callback: at the moment that is virtio-net with
> > VIRTIO_NET_F_MTU but since 82e89ea077b9 ("virtio-blk: Add validation for
> > block size in config space") that also started affecting virtio-blk with
> > VIRTIO_BLK_F_BLK_SIZE.
> 
> Ok, so it looks like I need to do something similar in my series to
> validate max_nr_ports in probe() instead of validate()? (multi port is
> not enabled by default).

I think what we should do is fix upstream QEMU first. With that, plus
Halil's work-around writing out the version 1 feature, we should be
good reading config in validate.

> 
> I wonder if we need to document this and rename the validate to
> validate_features() (since we can do very little thing if we can't
> read config in .validate()).

That's not a bad idea anyway - any validation that does not
need to clear features can be done in probe in any case.


> > Further, unlike VIRTIO_NET_F_MTU which is off by
> > default on QEMU, VIRTIO_BLK_F_BLK_SIZE is on by default, which resulted
> > in lots of people not being able to boot VMs on BE.
> >
> > The spec is very clear that what we are doing is legal so QEMU needs to
> > be fixed, but given it's been broken for so many years and no one
> > noticed, we need to give QEMU a bit more time before applying this.
> >
> > Further, this patch is incomplete (does not check blk size is a power
> > of two) and it duplicates the logic from nbd.
> >
> > Revert for now, and we'll reapply a cleaner logic in the next release.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 82e89ea077b9 ("virtio-blk: Add validation for block size in config space")
> > Cc: Xie Yongji <xieyongji@bytedance.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Acked-by: jason Wang <jasowang@redhat.com>
> 
> > ---
> >  drivers/block/virtio_blk.c | 37 ++++++-------------------------------
> >  1 file changed, 6 insertions(+), 31 deletions(-)
> >
> > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > index 9b3bd083b411..303caf2d17d0 100644
> > --- a/drivers/block/virtio_blk.c
> > +++ b/drivers/block/virtio_blk.c
> > @@ -689,28 +689,6 @@ static const struct blk_mq_ops virtio_mq_ops = {
> >  static unsigned int virtblk_queue_depth;
> >  module_param_named(queue_depth, virtblk_queue_depth, uint, 0444);
> >
> > -static int virtblk_validate(struct virtio_device *vdev)
> > -{
> > -       u32 blk_size;
> > -
> > -       if (!vdev->config->get) {
> > -               dev_err(&vdev->dev, "%s failure: config access disabled\n",
> > -                       __func__);
> > -               return -EINVAL;
> > -       }
> > -
> > -       if (!virtio_has_feature(vdev, VIRTIO_BLK_F_BLK_SIZE))
> > -               return 0;
> > -
> > -       blk_size = virtio_cread32(vdev,
> > -                       offsetof(struct virtio_blk_config, blk_size));
> > -
> > -       if (blk_size < SECTOR_SIZE || blk_size > PAGE_SIZE)
> > -               __virtio_clear_bit(vdev, VIRTIO_BLK_F_BLK_SIZE);
> > -
> > -       return 0;
> > -}
> > -
> >  static int virtblk_probe(struct virtio_device *vdev)
> >  {
> >         struct virtio_blk *vblk;
> > @@ -722,6 +700,12 @@ static int virtblk_probe(struct virtio_device *vdev)
> >         u8 physical_block_exp, alignment_offset;
> >         unsigned int queue_depth;
> >
> > +       if (!vdev->config->get) {
> > +               dev_err(&vdev->dev, "%s failure: config access disabled\n",
> > +                       __func__);
> > +               return -EINVAL;
> > +       }
> > +
> >         err = ida_simple_get(&vd_index_ida, 0, minor_to_index(1 << MINORBITS),
> >                              GFP_KERNEL);
> >         if (err < 0)
> > @@ -836,14 +820,6 @@ static int virtblk_probe(struct virtio_device *vdev)
> >         else
> >                 blk_size = queue_logical_block_size(q);
> >
> > -       if (blk_size < SECTOR_SIZE || blk_size > PAGE_SIZE) {
> > -               dev_err(&vdev->dev,
> > -                       "block size is changed unexpectedly, now is %u\n",
> > -                       blk_size);
> > -               err = -EINVAL;
> > -               goto out_cleanup_disk;
> > -       }
> > -
> >         /* Use topology information if available */
> >         err = virtio_cread_feature(vdev, VIRTIO_BLK_F_TOPOLOGY,
> >                                    struct virtio_blk_config, physical_block_exp,
> > @@ -1009,7 +985,6 @@ static struct virtio_driver virtio_blk = {
> >         .driver.name                    = KBUILD_MODNAME,
> >         .driver.owner                   = THIS_MODULE,
> >         .id_table                       = id_table,
> > -       .validate                       = virtblk_validate,
> >         .probe                          = virtblk_probe,
> >         .remove                         = virtblk_remove,
> >         .config_changed                 = virtblk_config_changed,
> > --
> > MST
> >

