Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC68288323
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 09:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731698AbgJIHA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 03:00:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51100 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731044AbgJIHA0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 03:00:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602226824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GXty0grP7iFnbUH+QMsyFwyfvHHZk16B0G0LGpkyhew=;
        b=Jh4QLuDT+d708Ktozc4Hl0oWImTjsds8dqwWgwo4cq8xW15bfoZqhG90X45aTZh87dy3KD
        i73ovSNfwWEcHecg09uzRapIz7mbQy4TuKYMkZxQh3F2i061M9cAPJzaiQFMAZFLe6OQhl
        7A17i5VQiGaI610NVX7DJEM6x08UErA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-d6T4dgr8MV6RrU7FCpuBFA-1; Fri, 09 Oct 2020 03:00:23 -0400
X-MC-Unique: d6T4dgr8MV6RrU7FCpuBFA-1
Received: by mail-wm1-f69.google.com with SMTP id d197so3802441wmd.4
        for <stable@vger.kernel.org>; Fri, 09 Oct 2020 00:00:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=GXty0grP7iFnbUH+QMsyFwyfvHHZk16B0G0LGpkyhew=;
        b=h4tmW4guF60N/nllQo9w2ynyu1sfRg1IrorB6qkkGXS7hG9CbD0IBD1lVAHZiaVD0j
         0q8BU2jzLZvHUABd4sebkyDHbA+yvzOPn6LY2V5JGaFhpfXP0l08mzXkCNNd+H7APX9D
         hMTG7vzD74y2e6+aV4Z49HZ66+4mlZVeaPSXdDjlWeNZvUl8X7Q+mWtl9uxfKDRJswAX
         sOi+rGJC4iVgTfJj06bn8ZxXsGEy7O2VSChYsUWm53s770pJGmPPk7Bcau8ATWluIWiM
         BA5H/wfwuIhU1TbGDmI8cLGmRgoIPGc4wHd+p1fFLIt0VF3+XWe6bo44zPo2ZNtwoZE7
         cfqA==
X-Gm-Message-State: AOAM533aiUsPhGeJakjotwJQgMtrwZkmUBDVjlZTIt2WGKVlvjROYcn4
        9oRRhytzXmM7Z5Xx7XJPoI43F+g/5DPBk++hffoc0ibm4hBH1G2Q8oMC3khTlmc9Ol+aoQazFD+
        7oEERHijiTVCsgbfs
X-Received: by 2002:a05:600c:21c3:: with SMTP id x3mr12206030wmj.81.1602226820729;
        Fri, 09 Oct 2020 00:00:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxp7Lu/KmOA3fdiMHtLHOVmduGD0Yzn7NZXzdIik47vcv/WVxJcCv5AZmkOtGRqoqzzsmlj5Q==
X-Received: by 2002:a05:600c:21c3:: with SMTP id x3mr12205994wmj.81.1602226820381;
        Fri, 09 Oct 2020 00:00:20 -0700 (PDT)
Received: from steredhat (host-79-27-201-176.retail.telecomitalia.it. [79.27.201.176])
        by smtp.gmail.com with ESMTPSA id k8sm10070788wrl.42.2020.10.09.00.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 00:00:19 -0700 (PDT)
Date:   Fri, 9 Oct 2020 09:00:17 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v2] vringh: fix __vringh_iov() when riov and wiov are
 different
Message-ID: <20201009070017.shdcumaifllakfrb@steredhat>
References: <20201008204256.162292-1-sgarzare@redhat.com>
 <8d84abcb-2f2e-8f24-039f-447e8686b878@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8d84abcb-2f2e-8f24-039f-447e8686b878@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 09, 2020 at 12:05:15PM +0800, Jason Wang wrote:
> 
> On 2020/10/9 上午4:42, Stefano Garzarella wrote:
> > If riov and wiov are both defined and they point to different
> > objects, only riov is initialized. If the wiov is not initialized
> > by the caller, the function fails returning -EINVAL and printing
> > "Readable desc 0x... after writable" error message.
> > 
> > This issue happens when descriptors have both readable and writable
> > buffers (eg. virtio-blk devices has virtio_blk_outhdr in the readable
> > buffer and status as last byte of writable buffer) and we call
> > __vringh_iov() to get both type of buffers in two different iovecs.
> > 
> > Let's replace the 'else if' clause with 'if' to initialize both
> > riov and wiov if they are not NULL.
> > 
> > As checkpatch pointed out, we also avoid crashing the kernel
> > when riov and wiov are both NULL, replacing BUG() with WARN_ON()
> > and returning -EINVAL.
> 
> 
> It looks like I met the exact similar issue when developing ctrl vq support
> (which requires both READ and WRITE descriptor).
> 
> While I was trying to fix the issue I found the following comment:
> 
>  * Note that you may need to clean up riov and wiov, even on error!
>  */
> int vringh_getdesc_iotlb(struct vringh *vrh,

Thank you for pointing that out, I didn't see it!

> 
> I saw some driver call vringh_kiov_cleanup().
> 
> So I just follow to use that.
> 
> I'm not quite sure which one is better.

Me too, but in both cases the 'else if' is wrong.

Either we completely remove the reset in the function or we merge this patch.
In the first case, we should also fix drivers that don't call
vringh_kiov_cleanup() (e.g. vdpa_sim).

I'm fine with both.

Thanks,
Stefano

> 
> Thanks
> 
> 
> > 
> > Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > ---
> >   drivers/vhost/vringh.c | 9 +++++----
> >   1 file changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > index e059a9a47cdf..8bd8b403f087 100644
> > --- a/drivers/vhost/vringh.c
> > +++ b/drivers/vhost/vringh.c
> > @@ -284,13 +284,14 @@ __vringh_iov(struct vringh *vrh, u16 i,
> >   	desc_max = vrh->vring.num;
> >   	up_next = -1;
> > +	/* You must want something! */
> > +	if (WARN_ON(!riov && !wiov))
> > +		return -EINVAL;
> > +
> >   	if (riov)
> >   		riov->i = riov->used = 0;
> > -	else if (wiov)
> > +	if (wiov)
> >   		wiov->i = wiov->used = 0;
> > -	else
> > -		/* You must want something! */
> > -		BUG();
> >   	for (;;) {
> >   		void *addr;
> 

