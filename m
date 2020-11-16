Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A17A2B4B2B
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 17:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730795AbgKPQad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 11:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgKPQad (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 11:30:33 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37ADBC0613CF;
        Mon, 16 Nov 2020 08:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yUFvC+ZrK6PRN0rtQL0QXcTBGoDM4oX8Dm71BpkV+wM=; b=rQ5Eb0gDl+z8/n2Td6rzDkxACs
        BemXonCnVeay50Gy70B/PnPwg3sUEpjhTPG9l6RdYa8NsvnUeTuEM50tGQmceYj2UfAmnVGOHJUTb
        U4rLn2oHqfeleNJYBC9GOy+AURtdfNM4/y2n3o6Bqz1zXjUETpuQRwZ+krsSb+58qKfDqSJyCbkGu
        qok1Sg6MsvhYZMhLsJ0gr4bk6BX4wiokcauSf4Zu/ePCaMTsqE2ulpMN5zBFVf2ryn3u2LRGU9Qwh
        awIzRsXoX9qbb61KX3yGdHqiqFX7Po5HNzcSYYug3yWnnaaLLL5+EWCERNDEoaLxxYKJY36/1MnZc
        UMUS094Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kehOY-0004dX-T1; Mon, 16 Nov 2020 16:30:22 +0000
Date:   Mon, 16 Nov 2020 16:30:22 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Amit Shah <amit@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-remoteproc@vger.kernel.org, Suman Anna <s-anna@ti.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH virtio] virtio: virtio_console: fix DMA memory allocation
 for rproc serial
Message-ID: <20201116163022.GC16619@infradead.org>
References: <AOKowLclCbOCKxyiJ71WeNyuAAj2q8EUtxrXbyky5E@cp7-web-042.plabs.ch>
 <20201116091950.GA30524@infradead.org>
 <20201116071910-mutt-send-email-mst@kernel.org>
 <u9RJBckNwnezQttAPrOyEqDYKu0rnhedUZYGpaS83qg@cp3-web-024.plabs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <u9RJBckNwnezQttAPrOyEqDYKu0rnhedUZYGpaS83qg@cp3-web-024.plabs.ch>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 16, 2020 at 01:07:28PM +0000, Alexander Lobakin wrote:
> But lots of subsystems like netdev for example uses dev->parent for
> DMA operations. I know that their pointers go directly to the
> platform/PCI/etc. device, but still.

Oh, every drivers is perfectly fine to use ->parent as it suits.  The
problem is when we have layered architectures, where this pokes a
massive hole into the layering.

> The only reason behind "fake" DMA devices for rproc is to be able to
> reserve DMA memory through the Device Tree exclusively for only one
> virtio dev like virtio_console or virtio_rpmsg_bus. That's why
> they are present, are coercing DMA caps from physical dev
> representor, and why questinable dma_declare_coherent_memory()
> is still here and doesn't allow to build rproc core as a module.
> I agree that this is not the best model obviously, and we should take
> a look at it.

As far as I can tell the series from Arnaud does the right thing here.
