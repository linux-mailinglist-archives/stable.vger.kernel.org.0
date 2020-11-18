Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE21C2B7B0A
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 11:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725772AbgKRKQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 05:16:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55003 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725613AbgKRKQ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 05:16:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605694584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Yed5/d7vK7YdqC5lhdZVNcPCr3eQRtrjIPPe/s03Tno=;
        b=GswmCO5fFCyhwJqg5yIO+mnYY5WCzFMAeurmgZjWbb7lb46Q0vPhAU7bhV9g8CqkeMOoPM
        lxq1c1hbJLPglUXz/D+jHMlm+X51NFiQAY6yxeMkV6G3Fm/AM8djAc4Tapv42XAXVFgJrk
        lc3Av2VAeQxQW8knr7fMeF5GKsYnzrE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-m8aWPb5fMVWFYSSX3s6g3A-1; Wed, 18 Nov 2020 05:16:22 -0500
X-MC-Unique: m8aWPb5fMVWFYSSX3s6g3A-1
Received: by mail-wr1-f69.google.com with SMTP id w5so708634wrm.22
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 02:16:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yed5/d7vK7YdqC5lhdZVNcPCr3eQRtrjIPPe/s03Tno=;
        b=tfMbdKWm/rCARjfduKJNhFpQJ1MjPKPMs+gZyp0jD4ujMXU87XzBBFn/NCzElqyrG9
         xWC+ekB63y0eB0zSOpButYcTGz7q4C24n0es1l7UbeUkh1qcBoF22mqSWEvwHgXSqIwL
         SceV2FuRLl8fWoMXSs+VHHo3nMNc4LP38oegZ5i6LymT/Rk6oH+89ZYZ9UjUQtbpbRJF
         SxX1EjrEZWGYNsE9vKUDSoXRPbIfuQNQFkK12KSMzzT+LiSPhJXluaQ0FVJWYfrYScwW
         H3hRFYaHSk17QVIgO2q+AiY4zKOBglxGVelEGHssX4U93DKKaNI4bpXudueQNXNEweaX
         0ahw==
X-Gm-Message-State: AOAM530wU95h7VdO9pBWggyfiSLJcKUPz3J67W6M7SijJRUbR7kyCiUU
        LMMo2RLbdVoIDf0Cg9KosnZ7I9scRikh8MV6dQyUTiEAc847V1CAP4OGADEk3u6UluLziQ+5d0F
        CnrsxnXu1DNG5wZ8R
X-Received: by 2002:a1c:3c04:: with SMTP id j4mr3793820wma.105.1605694581817;
        Wed, 18 Nov 2020 02:16:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz8gTvwJsFF5o43oH2YetHhRlLDl2RZsi15AIAqwyAVp6G3xTEHw8/0j0DSSSEDTs/utrvImA==
X-Received: by 2002:a1c:3c04:: with SMTP id j4mr3793798wma.105.1605694581613;
        Wed, 18 Nov 2020 02:16:21 -0800 (PST)
Received: from redhat.com (bzq-109-67-54-78.red.bezeqint.net. [109.67.54.78])
        by smtp.gmail.com with ESMTPSA id b4sm2360517wmc.1.2020.11.18.02.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 02:16:20 -0800 (PST)
Date:   Wed, 18 Nov 2020 05:16:15 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Arnaud POULIQUEN <arnaud.pouliquen@st.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Suman Anna <s-anna@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Jason Wang <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH virtio] virtio: virtio_console: fix DMA memory allocation
 for rproc serial
Message-ID: <20201118042039-mutt-send-email-mst@kernel.org>
References: <AOKowLclCbOCKxyiJ71WeNyuAAj2q8EUtxrXbyky5E@cp7-web-042.plabs.ch>
 <20201116091950.GA30524@infradead.org>
 <ca183081-5a9f-0104-bf79-5fea544c9271@st.com>
 <20201116162844.GB16619@infradead.org>
 <20201116163907.GA19209@infradead.org>
 <79d2eb78-caad-9c0d-e130-51e628cedaaa@st.com>
 <20201117140230.GA30567@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117140230.GA30567@infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 17, 2020 at 02:02:30PM +0000, Christoph Hellwig wrote:
> On Tue, Nov 17, 2020 at 03:00:32PM +0100, Arnaud POULIQUEN wrote:
> > The dma_declare_coherent_memory allows to associate vdev0buffer memory region
> > to the remoteproc virtio device (vdev parent). This region is used to allocated
> > the rpmsg buffers.
> > The memory for the rpmsg buffer is allocated by the rpmsg_virtio device in
> > rpmsg_virtio_bus[1]. The size depends on the total size needed for the rpmsg
> > buffers.
> > 
> > The vrings are allocated directly by the remoteproc device.
> 
> Weird.  I thought virtio was pretty strict in not allowing diret DMA
> API usage in drivers to support the legacy no-mapping case.

Well remoteproc is weird in that it's use of DMA API precedes
standartization efforts, and it was never standardized in the virtio
spec ..

> Either way, the point stands:  if you want these magic buffers handed
> out to specific rpmsg instances I think not having to detour through the
> DMA API is going to make everyones life easier.

