Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C1F4CF30F
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 08:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235972AbiCGH7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 02:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234793AbiCGH7D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 02:59:03 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187A51BE84;
        Sun,  6 Mar 2022 23:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SBkufQbkk7WS7cnTX6Fdy468qPhDhtk/GXWCSTup/Tk=; b=xQj49Z6kmfBylR8KA/UdSDpvUz
        2HQJ0OZ3qRoMv5IeF0IQ/68p+VdqWxJ4qG7BGTzd6ru4qeiILLEFi3OuVN/MqLS00YT/OG4KJeJoO
        AR5oik0TyTpTYSTCXokA78CHsVWLIlAqCXVOaWPhQeYx6wJbIlkUdS9Z55Pjkp6PtzDsZSs8kVtK+
        f3UYXsB7Hh3XGQqWr+QeIfKuvwVJA3e2H772HR57Q1DJV/B0QAWzzH2zpoTs0n4YeNJZodhYXs6HO
        mcnivCjVE2R+/Rm+XSDVmJXDdzi/GD1D1SRLhS/wLNhnxtg4wFtY44x2Ts8nxKQOiWN5qBNNXIyzp
        TAAlsP9Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nR8Fo-00GMXh-RF; Mon, 07 Mar 2022 07:58:04 +0000
Date:   Sun, 6 Mar 2022 23:58:04 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        iommu <iommu@lists.linux-foundation.org>,
        Doug Gilbert <dgilbert@interlog.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>
Subject: Re: [PATCH v2 1/1] swiotlb: rework "fix info leak with
 DMA_FROM_DEVICE"
Message-ID: <YiW7DMRymTV/zvDb@infradead.org>
References: <20220305170714.2043896-1-pasic@linux.ibm.com>
 <CAHk-=wgZ6fNG03pd2pAVw9RtymwPDyHNvTLHr2Q3LX3S0Y1k5Q@mail.gmail.com>
 <YiRpuGbjyU2M47pQ@infradead.org>
 <CAHk-=wgQGLgqqgsKXUCykiK9B1UwdCj2-NvDkBAuYhSgdtAmkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgQGLgqqgsKXUCykiK9B1UwdCj2-NvDkBAuYhSgdtAmkQ@mail.gmail.com>
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

On Sun, Mar 06, 2022 at 12:30:55PM -0800, Linus Torvalds wrote:
> So I would expect that
> 
>  (a) READ/WRITE actually fills the whole buffer
> 
>  (b) READ/WRITE are the only ones where we care about performance at a
> bounce-buffer level
> 
> so it boils down to "do we still do this horrible memcpy even for
> regular IO commands"? Because that would, in my opinion, just be
> stupid.

For one thing this is not just for block I/O, but for all DMA.
Second, "normal" I/O might always fail, including after partial
transfers.  SCSI even considers that normal.  Network devices consider
it normal to not fill the entiret receive buffers, etc.

In short:  anything that operates directly on user memory is a trivial
reproducer here.  The CVE uses SG_IO, but staying in block land direct
I/O will work just the same because swiotlb will copy back the
uninitialized data to user memory after an I/O failure.

What we've been thinking of is a version of the dma map calls where
the unmap gets passed how much data actually was transferred and only
copies that out.  But that seems like the only sane interface.

Now IFF we known that the buffer is never looked at on I/O failure
or short I/O we could do away with all this.  But without adding new
interfaces where the caller guarantees that we can't know that.  For
userspace memory it is guaranteed to be not true.  For kernel memory
is most likely is true, but there's some amazingly awful pieces of
code that probably still get it wrong.
