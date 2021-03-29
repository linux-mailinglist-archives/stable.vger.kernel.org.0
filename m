Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27AED34D222
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 16:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhC2OJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 10:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbhC2OJ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 10:09:26 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8BBC061574
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 07:09:24 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id h7so9372033qtx.3
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 07:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/hnmbU+RjM/bbEUsRkHSKqw2QhWHJBMXcgwEM7vWVEA=;
        b=ATvolDhaJuXJ3recYTFDLUuLLB/pcXlqlfEejmyzO6m7F5N49kpbvPdJ+CjYf3Zf37
         E3T+pBDllzX5egjh8bn6mWqWiUvhn5UPNR1z5zEFf9s4iVDtf+Mh1sxvOulTJh+zk/V5
         wqJIa3Cuix9ahbeIMwEkfPRU3VOi98LNG0x7omtUATNnwFg8z/CZU3ugeXZ29o7PWxbD
         df8smR110A7MhCSdlP52iUDFmIpVNAHodvsE3t3rkvzXmD+UiwgIZinbwu6LyaJRQgMz
         ZSz0YTCtqBGxiIlQLn02mRjTZ/xoBwDBmk3SOueGdcT4lREJKGfIv5ErcsuxrE4oFMZl
         2oCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/hnmbU+RjM/bbEUsRkHSKqw2QhWHJBMXcgwEM7vWVEA=;
        b=edZu4X3Kzv7EdZjzKf/56CfDdGudVjsiEqE7SuDhj4FaMhLWeva4evOdQl+b/lMuMz
         AYoFy3Vn0lbH2bwSslyR9K85njAdOzghWnDusYB3DWlLemL8AOBXHIC0YXo3ziF82Dms
         TZ+uwq/iiLPPskoFvGM2A6Ud8TcmyZcBj2mJnoIj+1ZHa0+aFT0wmpRq85O0vJyhseJV
         83BiUW6gVaa8s1Z3KYKP2AuUC+dHMKLd5sHD0tNKzuAiw/NaA744EnJfBmsGm8Z8yXCf
         H3ya5kUnAbGfJ57BcfMLF4AXgmZIrNjHQ7xc8RspTCDB0yJV7vzo2gDdpUW1pP+kdOg9
         wlKQ==
X-Gm-Message-State: AOAM533E3DDJCYc2XmKRmtGXYMpub0a4Kyzi0kF1BC8+CEdthp+eWpkU
        17VypUx8iwNzvosI6SNucN6c2Q==
X-Google-Smtp-Source: ABdhPJzKeVQ5VACGPapEAjHZTBp8ncI/66Je4qUZlgpyffMd1mcBHXwrQHJ3MP7DmfrucPDXa6KLFw==
X-Received: by 2002:a05:622a:13cb:: with SMTP id p11mr22462568qtk.349.1617026964193;
        Mon, 29 Mar 2021 07:09:24 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id j3sm13625186qki.84.2021.03.29.07.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 07:09:23 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1lQsa2-0054bt-WA; Mon, 29 Mar 2021 11:09:23 -0300
Date:   Mon, 29 Mar 2021 11:09:22 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     dennis.dalessandro@cornelisnetworks.com
Cc:     dledford@redhat.com, linux-rdma@vger.kernel.org,
        Kaike Wan <kaike.wan@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH for-rc 1/4] IB/hfi1: Call xa_destroy before freeing
 dummy_netdev
Message-ID: <20210329140922.GP2710221@ziepe.ca>
References: <1617025700-31865-1-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <1617025700-31865-2-git-send-email-dennis.dalessandro@cornelisnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1617025700-31865-2-git-send-email-dennis.dalessandro@cornelisnetworks.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 09:48:17AM -0400, dennis.dalessandro@cornelisnetworks.com wrote:

> diff --git a/drivers/infiniband/hw/hfi1/netdev_rx.c b/drivers/infiniband/hw/hfi1/netdev_rx.c
> index 2c8bc02..cec02e8 100644
> +++ b/drivers/infiniband/hw/hfi1/netdev_rx.c
> @@ -372,7 +372,11 @@ int hfi1_netdev_alloc(struct hfi1_devdata *dd)
>  void hfi1_netdev_free(struct hfi1_devdata *dd)
>  {
>  	if (dd->dummy_netdev) {
> +		struct hfi1_netdev_priv *priv =
> +			hfi1_netdev_priv(dd->dummy_netdev);
> +
>  		dd_dev_info(dd, "hfi1 netdev freed\n");
> +		xa_destroy(&priv->dev_tbl);
>  		kfree(dd->dummy_netdev);
>  		dd->dummy_netdev = NULL;

This is doing kfree() on a struct net_device?? Huh?

You should have put this in your own struct and used container_of not
co-oped netdev_priv, then free your own struct.

It is a bit weird to see a xa_destroy like this, how did things get ot
the point that no concurrent thread can see the xarray but there is
still stuff stored in it?

And it is weird this is storing two different types in it too, with no
refcounting..

Jason
