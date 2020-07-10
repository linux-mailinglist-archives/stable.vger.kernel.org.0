Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764D421BA7F
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 18:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgGJQNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 12:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728003AbgGJQNx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 12:13:53 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA04C08C5CE;
        Fri, 10 Jul 2020 09:13:53 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id i4so6552481iov.11;
        Fri, 10 Jul 2020 09:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WOhf446wJmxhSKkuBEXjNKDj0Wuq9FxTK5pl2IxYUo0=;
        b=sJa06UKM1+tO3r4eAbDLBv9bXXClhzFRxkegCiDxEJbmtUDvZCW1uUBnLLBTTyh/zE
         Rl4lVOU7+/193Vtc2nkutgU1WNoQNrWRQ1BLALf9HGy9QVIz35TE8CCK7kXeo9MPDKDT
         cneX9FInNfpziwB1+LUUnQLf3xcRcg5c4SJLy0ry0FkHQ4eGPGAk4LsWP9+3NygdQ16E
         wLOF36w3+SB6lGY5/3A4szmcBXDkxDj0roU0fLgByOM7hXUM9cQWdVVsRBgViNGwj84E
         Mzgx8Yj9J+nEtAmDmuXcNr9UvGHp3yecuKNDfCyfyJpT4j4QItLMjNx6dnZgsetZEl9i
         mKRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WOhf446wJmxhSKkuBEXjNKDj0Wuq9FxTK5pl2IxYUo0=;
        b=KB8DTyVpHF4u1zd969BMbmm6Vs08hSrimb06SmB7JrcxQG7mdtv90Ca8BzNcgTdJbb
         QamWZcaBHabcZ3w1T43dJXnMbtcxcStVtZvkQOkuTA2cgiPvDaMT5FqDICH5oGi8uqHG
         phj3OAgIOTOTNKtTvPUDWFbxNPKmu5MGnPhZQDtQa2vLkDwjKmEoCeFxPMP3QqBU8QcS
         PsZLQJzVc7cySNywZ55t0F8FgysDv7PKgw89nCMSD75mCBXj1xkJl1+gnOvXtRDiwDBT
         bK7Zc2VheSbt0oNAHjxr/fv1kJDf9etGs44ijgLJoI0+Q1u2LsJCmlmnXT3wkAKVPq4Z
         ANlQ==
X-Gm-Message-State: AOAM533KnANl+uZjcYNN88AoX75QXHxQZShpkGG3/3tqhmbEbeX1ng1C
        GsZhEha7d5ovyQ8x7leLpeqrLHVSqINjKBmbp9I=
X-Google-Smtp-Source: ABdhPJzxzpeui/g+zr/T9LgsOLWJ4FhpwovVifV20h0MRkNFwN7pWOffL2KkOwb/4uyQusMd/fNH2vaqb4pS7pGVbgw=
X-Received: by 2002:a05:6638:771:: with SMTP id y17mr40786162jad.96.1594397632555;
 Fri, 10 Jul 2020 09:13:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200710113046.421366-1-mst@redhat.com>
In-Reply-To: <20200710113046.421366-1-mst@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 10 Jul 2020 09:13:41 -0700
Message-ID: <CAKgT0UeZN+mOWNhgiT0btZTyki3TPoj7pbqA+__GkCxoifPqeg@mail.gmail.com>
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

On Fri, Jul 10, 2020 at 4:31 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> Page reporting features were never supported by legacy hypervisors.
> Supporting them poses a problem: should we use native endian-ness (like
> current code assumes)? Or little endian-ness like the virtio spec says?
> Rather than try to figure out, and since results of
> incorrect endian-ness are dire, let's just block this configuration.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

So I am not sure about the patch description. In the case of page
poison and free page reporting I don't think we are defining anything
that doesn't already have a definition of how to use in legacy.
Specifically the virtio_balloon_config is already defined as having
all fields as little endian in legacy mode, and there is a definition
for all of the fields in a virtqueue and how they behave in legacy
mode.

As far as I can see the only item that may be an issue is the command
ID being supplied via the virtqueue for free page hinting, which
appears to be in native endian-ness. Otherwise it would have fallen
into the same category since it is making use of virtio_balloon_config
and a virtqueue for supplying the page location and length.

> ---
>  drivers/virtio/virtio_balloon.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 5d4b891bf84f..b9bc03345157 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -1107,6 +1107,15 @@ static int virtballoon_restore(struct virtio_device *vdev)
>
>  static int virtballoon_validate(struct virtio_device *vdev)
>  {
> +       /*
> +        * Legacy devices never specified how modern features should behave.
> +        * E.g. which endian-ness to use? Better not to assume anything.
> +        */
> +       if (!virtio_has_feature(vdev, VIRTIO_F_VERSION_1)) {
> +               __virtio_clear_bit(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT);
> +               __virtio_clear_bit(vdev, VIRTIO_BALLOON_F_PAGE_POISON);
> +               __virtio_clear_bit(vdev, VIRTIO_BALLOON_F_REPORTING);
> +       }
>         /*
>          * Inform the hypervisor that our pages are poisoned or
>          * initialized. If we cannot do that then we should disable

The patch content itself I am fine with since odds are nobody would
expect to use these features with a legacy device.

Acked-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
