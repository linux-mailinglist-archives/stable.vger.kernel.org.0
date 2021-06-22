Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027763B05D3
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 15:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbhFVNbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 09:31:41 -0400
Received: from netrider.rowland.org ([192.131.102.5]:59673 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S230143AbhFVNbi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Jun 2021 09:31:38 -0400
Received: (qmail 453302 invoked by uid 1000); 22 Jun 2021 09:29:22 -0400
Date:   Tue, 22 Jun 2021 09:29:22 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Mauro Carvalho Chehab' <mchehab+huawei@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "mauro.chehab@huawei.com" <mauro.chehab@huawei.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3] media: uvc: don't do DMA on stack
Message-ID: <20210622132922.GB452785@rowland.harvard.edu>
References: <6832dffafd54a6a95b287c4a1ef30250d6b9237a.1624282817.git.mchehab+huawei@kernel.org>
 <d33c39aa824044ad8cacc93234f1e1cd@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d33c39aa824044ad8cacc93234f1e1cd@AcuMS.aculab.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 22, 2021 at 08:07:12AM +0000, David Laight wrote:
> From: Mauro Carvalho Chehab
> > Sent: 21 June 2021 14:40
> > 
> > As warned by smatch:
> > 	drivers/media/usb/uvc/uvc_v4l2.c:911 uvc_ioctl_g_input() error: doing dma on the stack (&i)
> > 	drivers/media/usb/uvc/uvc_v4l2.c:943 uvc_ioctl_s_input() error: doing dma on the stack (&i)
> > 
> > those two functions call uvc_query_ctrl passing a pointer to
> > a data at the DMA stack. those are used to send URBs via
> > usb_control_msg(). Using DMA stack is not supported and should
> > not work anymore on modern Linux versions.
> > 
> > So, use a kmalloc'ed buffer.
> ...
> > +	buf = kmalloc(1, GFP_KERNEL);
> > +	if (!buf)
> > +		return -ENOMEM;
> > +
> >  	ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR, chain->selector->id,
> >  			     chain->dev->intfnum,  UVC_SU_INPUT_SELECT_CONTROL,
> > -			     &i, 1);
> > +			     buf, 1);
> 
> Thought...
> 
> Is kmalloc(1, GFP_KERNEL) guaranteed to return a pointer into
> a cache line that will not be accessed by any other code?
> (This is slightly weaker than requiring a cache-line aligned
> pointer - but very similar.)

As I understand it, on architectures that do not have cache-coherent 
I/O, kmalloc is guaranteed to return a buffer that is 
cacheline-aligned and whose length is a multiple of the cacheline 
size.

Now, whether that buffer ends up being accessed by any other code 
depends on what your driver does with the pointer it gets from 
kmalloc.  :-)

Alan Stern

> Without that guarantee you can't use the returned buffer for
> read dma unless the memory accesses are coherent.
> 
> 	David
