Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3506B2B6668
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729868AbgKQOCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 09:02:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387477AbgKQOCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 09:02:54 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BA5C0613CF;
        Tue, 17 Nov 2020 06:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=m0hk7B27NeOlPrLY9cJvHDlIQhUidBou/7Utsa5IK1g=; b=dmPoiDU8T3nNQ2t/waEeUgrzZI
        k5qNrx2A0lHyPcMXIWNDO0HshkfKPtpOVNdWQJYjkYcYByLttcMxJHgNzVu4a90Z78/r3OezLmBao
        FU3EuqTrqylL4pd0zDJ5wo11G8mxUPs4VesrCfSMlYHNoCE8LZ2KA5caKj2Qe+IaFAGjBLzd9eXX5
        bOQrnE7lBoJmrbAJcCv0y6TXYbj9qmzcmPHMyjfeECuKcA+1f9Yksr1Ij0vg0393q5JhoLioopfN0
        tg4wklF1HbhnUL6sdcamNXOADkGJY5O/Hh8vYDxX9NMdbEV8SIRiV2R/YnhtFWW58o2fpWe2r/FqC
        qMBg9a3w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kf1Z0-00087I-Ri; Tue, 17 Nov 2020 14:02:30 +0000
Date:   Tue, 17 Nov 2020 14:02:30 +0000
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
Message-ID: <20201117140230.GA30567@infradead.org>
References: <AOKowLclCbOCKxyiJ71WeNyuAAj2q8EUtxrXbyky5E@cp7-web-042.plabs.ch>
 <20201116091950.GA30524@infradead.org>
 <ca183081-5a9f-0104-bf79-5fea544c9271@st.com>
 <20201116162844.GB16619@infradead.org>
 <20201116163907.GA19209@infradead.org>
 <79d2eb78-caad-9c0d-e130-51e628cedaaa@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79d2eb78-caad-9c0d-e130-51e628cedaaa@st.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 17, 2020 at 03:00:32PM +0100, Arnaud POULIQUEN wrote:
> The dma_declare_coherent_memory allows to associate vdev0buffer memory region
> to the remoteproc virtio device (vdev parent). This region is used to allocated
> the rpmsg buffers.
> The memory for the rpmsg buffer is allocated by the rpmsg_virtio device in
> rpmsg_virtio_bus[1]. The size depends on the total size needed for the rpmsg
> buffers.
> 
> The vrings are allocated directly by the remoteproc device.

Weird.  I thought virtio was pretty strict in not allowing diret DMA
API usage in drivers to support the legacy no-mapping case.

Either way, the point stands:  if you want these magic buffers handed
out to specific rpmsg instances I think not having to detour through the
DMA API is going to make everyones life easier.
