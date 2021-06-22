Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478603B0DF3
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 21:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbhFVUAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 16:00:54 -0400
Received: from netrider.rowland.org ([192.131.102.5]:33689 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S231726AbhFVUAx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Jun 2021 16:00:53 -0400
Received: (qmail 468382 invoked by uid 1000); 22 Jun 2021 15:58:36 -0400
Date:   Tue, 22 Jun 2021 15:58:36 -0400
From:   'Alan Stern' <stern@rowland.harvard.edu>
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
Message-ID: <20210622195836.GA468074@rowland.harvard.edu>
References: <6832dffafd54a6a95b287c4a1ef30250d6b9237a.1624282817.git.mchehab+huawei@kernel.org>
 <d33c39aa824044ad8cacc93234f1e1cd@AcuMS.aculab.com>
 <20210622132922.GB452785@rowland.harvard.edu>
 <c5dd6d33cb844025bc8451b46980d96b@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5dd6d33cb844025bc8451b46980d96b@AcuMS.aculab.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 22, 2021 at 02:21:27PM +0000, David Laight wrote:
> From: Alan Stern
> > Sent: 22 June 2021 14:29
> ...
> > > Thought...
> > >
> > > Is kmalloc(1, GFP_KERNEL) guaranteed to return a pointer into
> > > a cache line that will not be accessed by any other code?
> > > (This is slightly weaker than requiring a cache-line aligned
> > > pointer - but very similar.)
> > 
> > As I understand it, on architectures that do not have cache-coherent
> > I/O, kmalloc is guaranteed to return a buffer that is
> > cacheline-aligned and whose length is a multiple of the cacheline
> > size.
> > 
> > Now, whether that buffer ends up being accessed by any other code
> > depends on what your driver does with the pointer it gets from
> > kmalloc.  :-)
> 
> Thanks for the clarification.
> 
> Most of the small allocates in the usb stack are for transmits
> where it is only necessary to ensure a cache write-back.
> 
> I know there has been some confusion because one of the
> allocators can add a small header to every allocation.
> This can lead to unexpectedly inadequately aligned pointers.
> If it is updated when the preceding block is freed (as some
> user-space mallocs do) then it would need to be in a
> completely separate cache line.

If you really want to find out what the true story is, you should ask 
on the linux-mm mailing list.  The rest of us are not experts on this 
stuff.

Alan Stern
