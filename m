Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F83A130846
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 14:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgAENZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jan 2020 08:25:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22233 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726143AbgAENZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jan 2020 08:25:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578230727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IUzornvqkmVq3TU6TUpDqp8GmeEXj2T7/4D1zEB7uv4=;
        b=i/3Fd6PE5WNf7GzqxDaxnDBjzfPXx7GRAyU6RvUj0/dxjrqe/JGjsr6U57S9A7UTG3FWP/
        j2Mwzonm+xNHaSRWyxBrEWNa1AxJ5KHT1lFemhoL881lyMRMqllUgyb3ocq9B59kIlf1u5
        gGHjSaCaXY6cgR80S7CBWa8l2/bXPz8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-hK1ZDZO8Nt-A9_JgL9dU2w-1; Sun, 05 Jan 2020 08:25:22 -0500
X-MC-Unique: hK1ZDZO8Nt-A9_JgL9dU2w-1
Received: by mail-qk1-f198.google.com with SMTP id 65so4108911qkl.23
        for <stable@vger.kernel.org>; Sun, 05 Jan 2020 05:25:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IUzornvqkmVq3TU6TUpDqp8GmeEXj2T7/4D1zEB7uv4=;
        b=CdD/+ZD6tSF3qnxfunMi5MW9e5PTZU5HNqebqVQhQLyuqy5G/W5JBq5zb5YFBIIa5I
         shV4dkor0muEdZeax0r5yuGejLfrn992bbe7qdeMtBnHq0pjDFCna/nbnbSEPBxEyqKt
         2NZMJhoDBec65gbFfo7kxvoI/O1SoJJTXiI49GsO5aVvz9+/s5bPVxVthTnYiOd8hA1l
         34Dknv06lmXCPICLbNi1Orjm/AuD/mNwSdrDpTmM0ohSBqq0o93UIbuaU5zZrXUPTAIX
         DYVSYVMKF005ZWZO1+bopoMlWifpwuezJhWpPb9UGmbXNidorOBpweW20NZXTrbYGTAt
         O9AQ==
X-Gm-Message-State: APjAAAUDNMMSCkpjHHLvjV7E9BrrelGa88dvRjD78IB6haWl9cigHnXM
        YRZwVdir0mHZxat/tMmKOBhHGoavIJtRuJCozZbKvkS90YKg/e+RabXIZrVBLe/xh5bFyXMJjjH
        qmgefQCsl4NDjB+89
X-Received: by 2002:aed:3eee:: with SMTP id o43mr72578152qtf.33.1578230721717;
        Sun, 05 Jan 2020 05:25:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqz7Lmxx2CQn5FOma0XrsHfKFcPO4ESb1prSTfS3DioXdE7Wrzk7bagWu6gnry8JVIqyRY75VA==
X-Received: by 2002:aed:3eee:: with SMTP id o43mr72578138qtf.33.1578230721437;
        Sun, 05 Jan 2020 05:25:21 -0800 (PST)
Received: from redhat.com (bzq-79-183-34-164.red.bezeqint.net. [79.183.34.164])
        by smtp.gmail.com with ESMTPSA id o9sm19304486qko.16.2020.01.05.05.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2020 05:25:20 -0800 (PST)
Date:   Sun, 5 Jan 2020 08:25:16 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     Daniel Verkamp <dverkamp@chromium.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v2 1/2] virtio-balloon: initialize all vq callbacks
Message-ID: <20200105082433-mutt-send-email-mst@kernel.org>
References: <20200103184044.73568-1-dverkamp@chromium.org>
 <286AC319A985734F985F78AFA26841F73E39205A@shsmsx102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <286AC319A985734F985F78AFA26841F73E39205A@shsmsx102.ccr.corp.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 05, 2020 at 12:24:11PM +0000, Wang, Wei W wrote:
> On Saturday, January 4, 2020 2:41 AM, Daniel Verkamp wrote:
> > Subject: [PATCH v2 1/2] virtio-balloon: initialize all vq callbacks
> > 
> > Ensure that elements of the callbacks array that correspond to unavailable
> > features are set to NULL; previously, they would be left uninitialized.
> > 
> > Since the corresponding names array elements were explicitly set to NULL,
> > the uninitialized callback pointers would not actually be dereferenced;
> > however, the uninitialized callbacks elements would still be read in 
> > vp_find_vqs_msix() and used to calculate the number of MSI-X vectors
> > required.
> 
> The above description doesn't seem true after your second patch gets applied.
>  
> > Cc: stable@vger.kernel.org
> > Fixes: 86a559787e6f ("virtio-balloon:
> > VIRTIO_BALLOON_F_FREE_PAGE_HINT")
> > Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> > Signed-off-by: Daniel Verkamp <dverkamp@chromium.org>
> > ---
> > 
> > v1:
> > https://lists.linuxfoundation.org/pipermail/virtualization/2019-December/04
> > 4829.html
> > 
> > Changes from v1:
> > - Clarified "array" in commit message to "callbacks array"
> > 
> >  drivers/virtio/virtio_balloon.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > index 93f995f6cf36..8e400ece9273 100644
> > --- a/drivers/virtio/virtio_balloon.c
> > +++ b/drivers/virtio/virtio_balloon.c
> > @@ -475,7 +475,9 @@ static int init_vqs(struct virtio_balloon *vb)
> >  	names[VIRTIO_BALLOON_VQ_INFLATE] = "inflate";
> >  	callbacks[VIRTIO_BALLOON_VQ_DEFLATE] = balloon_ack;
> >  	names[VIRTIO_BALLOON_VQ_DEFLATE] = "deflate";
> > +	callbacks[VIRTIO_BALLOON_VQ_STATS] = NULL;
> >  	names[VIRTIO_BALLOON_VQ_STATS] = NULL;
> > +	callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
> 
> Could you remove other redundant NULL initialization well?
> https://lists.linuxfoundation.org/pipermail/virtualization/2019-December/044837.html
> 
> Best,
> Wei

I queued as is, can be tweaked by a patch on top.

-- 
MST

