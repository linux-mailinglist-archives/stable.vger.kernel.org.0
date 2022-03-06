Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC854CE9F9
	for <lists+stable@lfdr.de>; Sun,  6 Mar 2022 08:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbiCFH7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 02:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiCFH7u (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 02:59:50 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C89275FA;
        Sat,  5 Mar 2022 23:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=78SKL0+f0pC+LXR4ZAh8YHlAxTla1xXyOomfINWoXjU=; b=zYHbichC8z1vWDJpvI8si1yGIw
        7gimxtm/Iyvxb/TnmZGztUToDliWvoKMCe2LJhhNGFH+Dv9Wqh3a9RMd2arc3TdFteEA+vF6YTVpS
        V8opH+PAR3VyF3LimokR0xi1qqkTn+YZuN9wzZu2QwdDDuzgai6NfkdyeCfOJma5UHOg7eVAQ8U88
        XK15g5bvrrZaXw4S2ZMWQ+kFnQJ3dxKvbsbRrcsu2Px1JORL/kxXLd5/ItkPGjIIa2b1uZTg7S1GX
        py6MAqk6HcGXr9+Syny0sKTN+StsYHUncWxFxSkhwdazIXbaTrtHeZsW0NiQ2VPiFOEbC/CUZM4BD
        yqjFmGVw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nQlmy-00EISz-1t; Sun, 06 Mar 2022 07:58:48 +0000
Date:   Sat, 5 Mar 2022 23:58:48 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        stable <stable@vger.kernel.org>,
        Doug Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        iommu <iommu@lists.linux-foundation.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] swiotlb: rework "fix info leak with
 DMA_FROM_DEVICE"
Message-ID: <YiRpuGbjyU2M47pQ@infradead.org>
References: <20220305170714.2043896-1-pasic@linux.ibm.com>
 <CAHk-=wgZ6fNG03pd2pAVw9RtymwPDyHNvTLHr2Q3LX3S0Y1k5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wgZ6fNG03pd2pAVw9RtymwPDyHNvTLHr2Q3LX3S0Y1k5Q@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 05, 2022 at 11:44:51AM -0800, Linus Torvalds wrote:
> Christoph, I am assuming I'll get this from you, but if you have
> nothing else pending, just holler and I can take it directly.

I have nothing else pending, so feel free to take it directly:

Reviewed-by: Christoph Hellwig <hch@lst.de>

> That said, it seems sad to bounce the buffer just in case the device
> doesn't do what we expect it to do. Wouldn't it be better to just
> clear the buffer instead of copying the old data into it?

That unfortunately does not work always work, as we have interfaces
where we expect data that is not written to by the device to remain
unchanged, and there are many cases where the device does not write
the whole buffer.  In various places like SCSI the data transfer
can be smaller, but even more common is the case of no data transfer
at all error cases.

> Also, possibly stupid question - when is swiotlb used in practice
> these days? What are the performance implications of this? Will this
> mean completely unnecessary copies for all normal IO that will be
> overwritten by the DMA? Can't we limit it to just SG_IO (or is it
> already for some reason)?

There are three use case:
 - bounce buffering due to address limitations when no IOMMU is present
 - bounce buffering for not page aligned I/O on IOMMUs if the device
   is considered untrusted (which りight now means thunderbolt attached)
 - unconditional bounce buffering for trusted hypervisor schemes

All of thee apply to all I/O.  SG_IO is just a vector here as a
particularly badly designed userspace interface that happens to get a
decent test coverage.  There unfortuately are plenty of other ways to
expose this issue as well.  We're thinking of building interfaces to
avoid the overhead for well designed interfaces, but it will take some
time.
