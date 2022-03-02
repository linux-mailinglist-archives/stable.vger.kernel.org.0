Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714124CA8A0
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 15:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243304AbiCBO6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 09:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243292AbiCBO6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 09:58:18 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE7313D74
        for <stable@vger.kernel.org>; Wed,  2 Mar 2022 06:57:33 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id k29-20020a05600c1c9d00b003817fdc0f00so1407435wms.4
        for <stable@vger.kernel.org>; Wed, 02 Mar 2022 06:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=wGGyr8F/4yesRnDkleDkSeBi9/XbD7YGJTcIBLykmxo=;
        b=YAWW5HKlB7Eey/hbn/tEyKoY+Ej9P8bjmKwFJpG4WIH2K/pus2hP+RvzIjDv6V3z5p
         k6x5v3LHFzzK0yNYVc3/6rqsj7QQzSFP9PqTvboq8Gd2h2U5akBPL3gjR8Gis5rXW7a5
         f5Wj0QWjydNWVbiao3cyHkss6w5fRltrK3+kbwT6yAe/CdOFs42vPOp9Mksavp1FhfDg
         b+8kmdCZBXU7N1sbqbnIx9h7JeO+bMDEWXRboAhQXSO6FrQS9Y2kIONVMIQBVPZeWrO0
         GsIgMsxoTCsl6Mtqj6TTCwunX0DqqFgLwCazwzkBeT0HF1oYRmofMt0ZOyXz8dF5vh/a
         nxAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wGGyr8F/4yesRnDkleDkSeBi9/XbD7YGJTcIBLykmxo=;
        b=2sL9Jv8OtfIhbVOebcoggJDHDVLrJCzmzs+crlht29G3ejRLFm+/BZ3Qd9ROpnxYDx
         PWs13mA5Hj8Wrw4FYIXEHf4vezSzaIgLAZca7wgaI/jA8p+xb9d/0XC3QXHAa3E9TgPm
         oOWIkfVCwDYL0Z7Y2DlRroPhfyUhaWQUoeYwrD9OSE1SlzOCQvuIVetNRUZmBUALJ/mp
         ymMn0lQKmCACw3Ps+PL3OIMk2uG30yBvUau1sE9p5+9niEuI4kxa6NT/Y4MIXnN9k5I2
         DV0qSu1Pbky0YZFMBoKnJ79sNSGD8meqyaCJqjD8sx5wNVYGxeCJY0z0ZM37up/e8yfP
         0vuQ==
X-Gm-Message-State: AOAM532a1ORGC5l/1QExoZbTOvPIMFJOmWyvrIf0vFyT8tvIZbUttM3s
        6lRihFNYVjeNFiyDrCJfMmzADA==
X-Google-Smtp-Source: ABdhPJxDjgY35zlNFNM4bX0OTXrJd0JfiswPqCzf7heVkctOxPWyBqq7cmIrMgVAjnLfYiYdzW+RlQ==
X-Received: by 2002:a05:600c:40cf:b0:381:1f87:84c4 with SMTP id m15-20020a05600c40cf00b003811f8784c4mr102404wmh.181.1646233051757;
        Wed, 02 Mar 2022 06:57:31 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id o204-20020a1ca5d5000000b0038331f2f951sm4751221wme.0.2022.03.02.06.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 06:57:31 -0800 (PST)
Date:   Wed, 2 Mar 2022 14:57:26 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <Yh+F1gkCGoYF2lMV@google.com>
References: <20220302075421.2131221-1-lee.jones@linaro.org>
 <20220302082021-mutt-send-email-mst@kernel.org>
 <Yh93k2ZKJBIYQJjp@google.com>
 <20220302095045-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220302095045-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 02 Mar 2022, Michael S. Tsirkin wrote:

> On Wed, Mar 02, 2022 at 01:56:35PM +0000, Lee Jones wrote:
> > On Wed, 02 Mar 2022, Michael S. Tsirkin wrote:
> > 
> > > On Wed, Mar 02, 2022 at 07:54:21AM +0000, Lee Jones wrote:
> > > > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > > > to vhost_get_vq_desc().  All we have to do is take the same lock
> > > > during virtqueue clean-up and we mitigate the reported issues.
> > > > 
> > > > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > > > 
> > > > Cc: <stable@vger.kernel.org>
> > > > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > ---
> > > >  drivers/vhost/vhost.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > > 
> > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > > index 59edb5a1ffe28..bbaff6a5e21b8 100644
> > > > --- a/drivers/vhost/vhost.c
> > > > +++ b/drivers/vhost/vhost.c
> > > > @@ -693,6 +693,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > > >  	int i;
> > > >  
> > > >  	for (i = 0; i < dev->nvqs; ++i) {
> > > > +		mutex_lock(&dev->vqs[i]->mutex);
> > > >  		if (dev->vqs[i]->error_ctx)
> > > >  			eventfd_ctx_put(dev->vqs[i]->error_ctx);
> > > >  		if (dev->vqs[i]->kick)
> > > > @@ -700,6 +701,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > > >  		if (dev->vqs[i]->call_ctx.ctx)
> > > >  			eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
> > > >  		vhost_vq_reset(dev, dev->vqs[i]);
> > > > +		mutex_unlock(&dev->vqs[i]->mutex);
> > > >  	}
> > > 
> > > So this is a mitigation plan but the bug is still there though
> > > we don't know exactly what it is.  I would prefer adding something like
> > > WARN_ON(mutex_is_locked(vqs[i]->mutex) here - does this make sense?
> > 
> > As a rework to this, or as a subsequent patch?
> 
> Can be a separate patch.
> 
> > Just before the first lock I assume?
> 
> I guess so, yes.

No problem.  Patch to follow.

I'm also going to attempt to debug the root cause, but I'm new to this
subsystem to it might take a while for me to get my head around.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
