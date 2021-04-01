Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7CA9351D77
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 20:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238464AbhDAS2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 14:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234229AbhDASRF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Apr 2021 14:17:05 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD68C0610D1
        for <stable@vger.kernel.org>; Thu,  1 Apr 2021 05:33:18 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id v70so1942027qkb.8
        for <stable@vger.kernel.org>; Thu, 01 Apr 2021 05:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p0QqWS0N6IsUJZgRGUR4Cwf5bkhOxI7VHZf3Wl7c1Rc=;
        b=iM/WVNjfmC1XcS0o4fQrwZGkSArUXWThk7HiT4f8r427ae1btK51gMMX0mpOEzUX2i
         Bqi3Hz9DBWASaCC9GG0Kqn3NALRn7D4mfkwlZn1oTWSKOogcFbCygtXY65vOsu+o7o/x
         MHWI9BwMbJS1KARKQvOcqGVtrH9Flb4wr7oB+ul24s+6h1TZ4VZl7tuPdLOhJoDVDDhi
         rqBUH/UP7J+XKuO9NLAIXUEIWeKV7xBivkRObAjZM4+Jivzmvc81UCMXg2rDhlRVNAXI
         uvENrF9OdI1mswADwKLJKWyEefOvEXFrQvdn/RL3N1IdDYjSm4B2xHdz9LyRG2DcI6fn
         1/kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p0QqWS0N6IsUJZgRGUR4Cwf5bkhOxI7VHZf3Wl7c1Rc=;
        b=RyQG60RmyuSVDZynhZSevhvwCcnjmfpYr52a+T2RyigiFg4D0QxVosO6XUEjHO2MeK
         pcsl/HMiNulSzDWIP6T1ajkaMfu57Y25IR78F6L8xRwXlTo0oTANo+HTGqhzS6DAeSaD
         r+vreaGFANRHuQK67bguIKW/p/LtrTjjs1TBQoNXj14G8/stqJW9y/PPy8BflTR88DB5
         KW9phYC6NUGlVSSYB5zRsg166wcTK625mHL8Xl32m+xcBmoww8ty/t+VxzVKsL20r++F
         Mz85KzZSI5Xb0qVxya3uwIwoCWjhq3w7vQCXsLHWdynUL5GclWM2DTP7oPJou7LE+hHd
         z5VQ==
X-Gm-Message-State: AOAM531Vjfoh0GR4KJJa8pCZpcY0z83Fv3J7m+lC3d7qzffykg2964uh
        4aTW/1jMmBksOjdBl3iTJS8WUw==
X-Google-Smtp-Source: ABdhPJz8RR2FBVwxWdXUBMUklh+FsYymZhGFwjnTS0fHHZ2i+1ARHSpFnEmH3vLJyYuUFidgQzmD3Q==
X-Received: by 2002:a37:a81:: with SMTP id 123mr7936857qkk.144.1617280398033;
        Thu, 01 Apr 2021 05:33:18 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id o7sm3831635qki.63.2021.04.01.05.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 05:33:17 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1lRwVh-006jtS-3T; Thu, 01 Apr 2021 09:33:17 -0300
Date:   Thu, 1 Apr 2021 09:33:17 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc:     dledford@redhat.com, linux-rdma@vger.kernel.org,
        Kaike Wan <kaike.wan@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH for-rc 1/4] IB/hfi1: Call xa_destroy before freeing
 dummy_netdev
Message-ID: <20210401123317.GC2710221@ziepe.ca>
References: <1617025700-31865-1-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <1617025700-31865-2-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <20210329140922.GP2710221@ziepe.ca>
 <7da1174e-97a6-3933-ae35-166a9dcbf38e@cornelisnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7da1174e-97a6-3933-ae35-166a9dcbf38e@cornelisnetworks.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 31, 2021 at 03:36:14PM -0400, Dennis Dalessandro wrote:
> On 3/29/2021 10:09 AM, Jason Gunthorpe wrote:
> > On Mon, Mar 29, 2021 at 09:48:17AM -0400, dennis.dalessandro@cornelisnetworks.com wrote:
> > 
> > > diff --git a/drivers/infiniband/hw/hfi1/netdev_rx.c b/drivers/infiniband/hw/hfi1/netdev_rx.c
> > > index 2c8bc02..cec02e8 100644
> > > +++ b/drivers/infiniband/hw/hfi1/netdev_rx.c
> > > @@ -372,7 +372,11 @@ int hfi1_netdev_alloc(struct hfi1_devdata *dd)
> > >   void hfi1_netdev_free(struct hfi1_devdata *dd)
> > >   {
> > >   	if (dd->dummy_netdev) {
> > > +		struct hfi1_netdev_priv *priv =
> > > +			hfi1_netdev_priv(dd->dummy_netdev);
> > > +
> > >   		dd_dev_info(dd, "hfi1 netdev freed\n");
> > > +		xa_destroy(&priv->dev_tbl);
> > >   		kfree(dd->dummy_netdev);
> > >   		dd->dummy_netdev = NULL;
> > 
> > This is doing kfree() on a struct net_device?? Huh?
> > 
> > You should have put this in your own struct and used container_of not
> > co-oped netdev_priv, then free your own struct.
> > 
> > It is a bit weird to see a xa_destroy like this, how did things get ot
> > the point that no concurrent thread can see the xarray but there is
> > still stuff stored in it?
> > 
> > And it is weird this is storing two different types in it too, with no
> > refcounting..
> 
> We do rework this stuff in the other patch series.
> 
> https://patchwork.kernel.org/project/linux-rdma/patch/1617026056-50483-11-git-send-email-dennis.dalessandro@cornelisnetworks.com/
> 
> If we fix it up in the for-next series, what should we do about stable?

Well, if you are fixing bugs then order it bug fixes first, but this
is tagged for rc and you still need to explain what bug it is actually
fixing.

xa_destroy is not required if the xarray is already empty, so the
commit message at least needs to explain how we get to a point where
it still has something in it.

Jason
