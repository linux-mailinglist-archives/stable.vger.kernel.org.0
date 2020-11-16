Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4112B4B0F
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 17:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731920AbgKPQ2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 11:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730905AbgKPQ2A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 11:28:00 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5799AC0613CF;
        Mon, 16 Nov 2020 08:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2NuZ81m6oUC1EPPya6oC4B+RkFMDfbQeS2iAs+KQSc0=; b=E8q5iMAFVmat6FprDTGNvNcVbT
        k+8B2sj5/ay9AYOvJ0+ZU3+/AtbYXbKzR6+hJt3OM6keJIC52UWU2TL9K/nyk5RHJDuuaT0W5MAdY
        ddlK+sv2snw1OeSzsqbr4fJrZKdVFHQTOMbDYI+YKSlQ1eqboE9vxbg7UbYVPCh5NHDkJ8RXrBpN1
        MtdUpG0wmAzPSZOQPJx4Li+dDtxnWBKxM4w5CYiRbARrDeN6QFN9tY65W9PJkZpDp9hSitCwv5sgx
        cuf/51MvUYtHKgz1mChZuvTZv0THl4gDH10EgMyN4YOXaMt6+fng89n9FDpYLnMBlhRFEQYNDl963
        wUNaIQ0g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kehM0-0004PY-2v; Mon, 16 Nov 2020 16:27:44 +0000
Date:   Mon, 16 Nov 2020 16:27:44 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Suman Anna <s-anna@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH virtio] virtio: virtio_console: fix DMA memory allocation
 for rproc serial
Message-ID: <20201116162744.GA16619@infradead.org>
References: <AOKowLclCbOCKxyiJ71WeNyuAAj2q8EUtxrXbyky5E@cp7-web-042.plabs.ch>
 <20201116091950.GA30524@infradead.org>
 <20201116045127-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116045127-mutt-send-email-mst@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 16, 2020 at 04:51:49AM -0500, Michael S. Tsirkin wrote:
> On Mon, Nov 16, 2020 at 09:19:50AM +0000, Christoph Hellwig wrote:
> > I just noticed this showing up in Linus' tree and I'm not happy.
> > 
> > This whole model of the DMA subdevices in remoteproc is simply broken.
> > 
> > We really need to change the virtio code pass an expicit DMA device (
> > similar to what e.g. the USB and RDMA code does),
> 
> Could you point me at an example or two please?

Take a look at the ib_dma_* helper in include/rdma/ib_verbs.h and
dma_device member in struct ib_device for the best example.
