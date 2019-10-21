Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF06DF14C
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 17:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfJUP1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 11:27:24 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34633 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbfJUP1X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 11:27:23 -0400
Received: by mail-qt1-f195.google.com with SMTP id e14so1834042qto.1
        for <stable@vger.kernel.org>; Mon, 21 Oct 2019 08:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CfdX6KgVu1GO29wuXLMQqfYjKwGUO5xi0b10xgYfC54=;
        b=OxmR7mrFlGLt1ejENrHZD8ZVv5yhbbKQnRDpN74qWnE+4CQPr1w6svUY1xhONMTU3T
         S7ZcYT4NlCParvwKHgDh9U5bqZd9Dsm7HeAFZ3sqI7mGN8BFPaHzVLO2KEREzSkJoKSo
         eyEA9l63ocV7iQn+FeXIZyuzO2cFEk+jHeTo9YC2Puwopd8VMkD2aX2tyX4aVCOWLddy
         nNS0/ndpNQz6/O0oU4RHJEN4qsfAkeajHikwUGumyLWQKk2Nurv4aoDSSl3su1OeAycu
         cVTTjb6bHMQorMRMSkQOOwjBb4Fddeg4eUMkYbfIFdIZ270+81I8gPISIBHzYuCh0vUp
         kfLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CfdX6KgVu1GO29wuXLMQqfYjKwGUO5xi0b10xgYfC54=;
        b=Mhkihx/ImtHNRc2jqM+NCO8pC61oaURIM0ambalWu5RzQ2FQjoslSKwGYv2vYGK5aX
         10uam8rEXaPEwbICerg77mwemizPQH44rRJpfOTKbNslUl8TLXQ/duOJGxQB09eKUl80
         hKaRdSc4HqCXmy+hylE7uCJp5MD8pzk+QR2ftNBpGZvbMaVFC52Ik0Gwof/+Ujt3aKBc
         hKbwxtze43t3FjJ/IDsrj7wOsv9h0by/w4+OcX1R80gzDY6H4zKooRFW6/We9QogyvfU
         kpBxHyCJkeQ/jVA8qnqWSZQ8gSjRfRpVrKpUEurcA0ua5DaKYsnIFO48MlEs+110QQyi
         AXrg==
X-Gm-Message-State: APjAAAW/J30BDA7d/0luz841KQjAQv/xWjxzAgBLEGA+aUrOk8wLnBrP
        kXtWn2YLpazSrefWxTErehE5MjFWKv8=
X-Google-Smtp-Source: APXvYqwvayeFzyH/0DCFjnJXOgGiVxwckas5GW4OHOSwgcraaC84uXW5fg1P/pIOXeujvCFvoHjywg==
X-Received: by 2002:a0c:b719:: with SMTP id t25mr7871917qvd.32.1571671642708;
        Mon, 21 Oct 2019 08:27:22 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id d23sm8410524qkc.127.2019.10.21.08.27.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 21 Oct 2019 08:27:21 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iMZab-0000gq-Eu; Mon, 21 Oct 2019 12:27:21 -0300
Date:   Mon, 21 Oct 2019 12:27:21 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] RDMA/core: Fix ib_dma_max_seg_size()
Message-ID: <20191021152721.GE25178@ziepe.ca>
References: <20191021021030.1037-1-bvanassche@acm.org>
 <20191021021030.1037-2-bvanassche@acm.org>
 <20191021140917.GB25178@ziepe.ca>
 <bf742476-89cd-51ef-0047-da813ab318fb@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf742476-89cd-51ef-0047-da813ab318fb@acm.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 21, 2019 at 08:03:32AM -0700, Bart Van Assche wrote:
> On 10/21/19 7:09 AM, Jason Gunthorpe wrote:
> > On Sun, Oct 20, 2019 at 07:10:27PM -0700, Bart Van Assche wrote:
> > > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> > > index 6a47ba85c54c..e6c167d03aae 100644
> > > +++ b/include/rdma/ib_verbs.h
> > > @@ -4043,9 +4043,7 @@ static inline void ib_dma_unmap_sg_attrs(struct ib_device *dev,
> > >    */
> > >   static inline unsigned int ib_dma_max_seg_size(struct ib_device *dev)
> > >   {
> > > -	struct device_dma_parameters *p = dev->dma_device->dma_parms;
> > > -
> > > -	return p ? p->max_segment_size : UINT_MAX;
> > > +	return dma_get_max_seg_size(dev->dma_device);
> > >   }
> > 
> > Should we get rid of this wrapper?
> 
> Hi Jason,
> 
> In general I agree that getting rid of single line inline functions is good.
> In this case however I'd like to keep the wrapper such that RDMA ULP code
> does not have to deal with the choice between dev->dma_device and &dev->dev.
> From struct ib_device:
>  /* Do not access @dma_device directly from ULP nor from HW drivers. */
> struct device                *dma_device;

Do you think it is a mistake we have dma_device at all?

Can the modern dma framework let us make the 'struct ib_device' into a
full dma_device that is still connected to some PCI device?

Jason
