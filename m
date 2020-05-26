Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18A81E1B9F
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 08:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgEZG7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 02:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbgEZG7e (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 26 May 2020 02:59:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B933920776;
        Tue, 26 May 2020 06:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590476374;
        bh=mx2RsX+GiWP1tdIk5Q+o9Hj9Jgnspz9e6NQss4KWcp8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2S6GFWofN59X3wmEj27HQBWMHZD7jAj+mYJm9Fw87YhAEXClyshSfivrHAfa9go+V
         Rg2J5pRALyhvX5Toiz3Qjs5qFjYYKAK+U0FfdEnK0FYoeMJHRy212JEyS4WtA75TVc
         CqaE8cMGED82xAPhAc9i/HdKyCZKXyycVmXJvgEo=
Date:   Tue, 26 May 2020 08:59:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     fabrice.gasnier@st.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: adc: stm32-adc: fix device used to
 request dma" failed to apply to 5.4-stable tree
Message-ID: <20200526065930.GA2624088@kroah.com>
References: <15904148129183@kroah.com>
 <20200525205201.GZ33628@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525205201.GZ33628@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 25, 2020 at 04:52:01PM -0400, Sasha Levin wrote:
> On Mon, May 25, 2020 at 03:53:32PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > > From 52cd91c27f3908b88e8b25aed4a4d20660abcc45 Mon Sep 17 00:00:00 2001
> > From: Fabrice Gasnier <fabrice.gasnier@st.com>
> > Date: Thu, 30 Apr 2020 11:28:45 +0200
> > Subject: [PATCH] iio: adc: stm32-adc: fix device used to request dma
> > 
> > DMA channel request should use device struct from platform device struct.
> > Currently it's using iio device struct. But at this stage when probing,
> > device struct isn't yet registered (e.g. device_register is done in
> > iio_device_register). Since commit 71723a96b8b1 ("dmaengine: Create
> > symlinks between DMA channels and slaves"), a warning message is printed
> > as the links in sysfs can't be created, due to device isn't yet registered:
> > - Cannot create DMA slave symlink
> > - Cannot create DMA dma:rx symlink
> > 
> > Fix this by using device struct from platform device to request dma chan.
> > 
> > Fixes: 2763ea0585c99 ("iio: adc: stm32: add optional dma support")
> > 
> > Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
> > Cc: <Stable@vger.kernel.org>
> > Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> I've also grabbed 735404b846df ("iio: adc: stm32-adc: Use
> dma_request_chan() instead dma_request_slave_channel()") and queued both
> for 5.4, 4.19, and 4.14.

Thanks for this, and all of the other fixups you added to the queue.

greg k-h
