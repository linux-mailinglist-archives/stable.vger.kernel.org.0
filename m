Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395E82B4B1D
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 17:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731423AbgKPQ27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 11:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730795AbgKPQ27 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 11:28:59 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D966CC0613CF;
        Mon, 16 Nov 2020 08:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=e6BIfEgLkkUxsF4JnpPb8DQA1qDtb10rWlavNgMcshc=; b=TkwDO8qI70+8k28fwxwWYA22+F
        oyOJIZthD5i8Uiq5L/C85fjaQ4tukb00LfGvBmcAXcG9RfCXGguc3eUTXTKn8SlLGxAfoKXnP1FsB
        08H/JpHSTfRTfjg3knsT+dV7hws49LNcp2145KJM6C9fBxaTytcj9KzZIjUgFio8RhHcSf5ZPuzgf
        +VjTYMxfzdzZnUVfuWVgS+qSG16pktxVQm1re3xtPqHxIHZvX6j41u80C4EjY/PDhon+DdpmVb3cP
        wI292BEj9Fegqi6XCXXT1PJ9/SpS8vy7ldK4JrXTqrfIcwp5iAeBk/GrgxxFz6F3mdOuHV3fgb5Jc
        X8CdcWsA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kehMy-0004U3-Jx; Mon, 16 Nov 2020 16:28:44 +0000
Date:   Mon, 16 Nov 2020 16:28:44 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Arnaud POULIQUEN <arnaud.pouliquen@st.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Suman Anna <s-anna@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH virtio] virtio: virtio_console: fix DMA memory allocation
 for rproc serial
Message-ID: <20201116162844.GB16619@infradead.org>
References: <AOKowLclCbOCKxyiJ71WeNyuAAj2q8EUtxrXbyky5E@cp7-web-042.plabs.ch>
 <20201116091950.GA30524@infradead.org>
 <ca183081-5a9f-0104-bf79-5fea544c9271@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca183081-5a9f-0104-bf79-5fea544c9271@st.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 16, 2020 at 11:46:59AM +0100, Arnaud POULIQUEN wrote:
> Hi all,
> 
> On 11/16/20 10:19 AM, Christoph Hellwig wrote:
> > I just noticed this showing up in Linus' tree and I'm not happy.
> > 
> > This whole model of the DMA subdevices in remoteproc is simply broken.
> > 
> > We really need to change the virtio code pass an expicit DMA device (
> > similar to what e.g. the USB and RDMA code does), instead of faking up
> > devices with broken adhoc inheritance of DMA properties and magic poking
> > into device parent relationships.
> 
> For your formation I started some stuff on my side to be able to declare the
> virtio device in DT as a remoteproc child node.
> 
> https://lkml.org/lkml/2020/4/16/1817
> 
> Quite big refactoring, but could be a way to answer...

Yes, that series is exactly what we need to do conceptually (can't
comment on all the nitty grity details as I'm not too familiar with
the remoteproc code).
