Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C92634E3C88
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 11:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbiCVKiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 06:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbiCVKiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 06:38:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C38E80201
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 03:36:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC595B81C9F
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 10:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B826C340EC;
        Tue, 22 Mar 2022 10:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647945403;
        bh=9FlUOa6c/6ctwJzxuWy3CYkGOEzYmVIe5ZW+N3SWjck=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qg153dk18A3pn+FQoiluJzTyuT6NG4tLvgSQ5sL245tC6hj6Zm3PUwcvsI7zj7sTZ
         cgVJUqZlNmK4m9STDyLWVkVlij/zsFNKWYeGKaZ8Qc4AE0HlU+9591gXY9q9n66kUq
         fHhjk92vCLeCDpXF8lgnUfZLzGDJfbVvRxIREzy4=
Date:   Tue, 22 Mar 2022 11:36:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Christoph Hellwig <hch@infradead.org>,
        Doug Gilbert <dgilbert@interlog.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH for 5.10.x 1/2] swiotlb: fix info leak with
 DMA_FROM_DEVICE
Message-ID: <YjmmuOVCT98xK/PR@kroah.com>
References: <20220322100218.2158138-1-pasic@linux.ibm.com>
 <20220322100218.2158138-2-pasic@linux.ibm.com>
 <YjmgeVPQxzvpV6m6@kroah.com>
 <20220322112834.6103451e.pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322112834.6103451e.pasic@linux.ibm.com>
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 22, 2022 at 11:28:34AM +0100, Halil Pasic wrote:
> On Tue, 22 Mar 2022 11:10:01 +0100
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Tue, Mar 22, 2022 at 11:02:17AM +0100, Halil Pasic wrote:
> > > The problem I'm addressing was discovered by the LTP test covering
> > > cve-2018-1000204.
> > > 
> > > A short description of what happens follows:
> > > 1) The test case issues a command code 00 (TEST UNIT READY) via the SG_IO
> > >    interface with: dxfer_len == 524288, dxdfer_dir == SG_DXFER_FROM_DEV
> > >    and a corresponding dxferp. The peculiar thing about this is that TUR
> > >    is not reading from the device.
> > > 2) In sg_start_req() the invocation of blk_rq_map_user() effectively
> > >    bounces the user-space buffer. As if the device was to transfer into
> > >    it. Since commit a45b599ad808 ("scsi: sg: allocate with __GFP_ZERO in
> > >    sg_build_indirect()") we make sure this first bounce buffer is
> > >    allocated with GFP_ZERO.
> > > 3) For the rest of the story we keep ignoring that we have a TUR, so the
> > >    device won't touch the buffer we prepare as if the we had a
> > >    DMA_FROM_DEVICE type of situation. My setup uses a virtio-scsi device
> > >    and the  buffer allocated by SG is mapped by the function
> > >    virtqueue_add_split() which uses DMA_FROM_DEVICE for the "in" sgs (here
> > >    scatter-gather and not scsi generics). This mapping involves bouncing
> > >    via the swiotlb (we need swiotlb to do virtio in protected guest like
> > >    s390 Secure Execution, or AMD SEV).
> > > 4) When the SCSI TUR is done, we first copy back the content of the second
> > >    (that is swiotlb) bounce buffer (which most likely contains some
> > >    previous IO data), to the first bounce buffer, which contains all
> > >    zeros.  Then we copy back the content of the first bounce buffer to
> > >    the user-space buffer.
> > > 5) The test case detects that the buffer, which it zero-initialized,
> > >   ain't all zeros and fails.
> > > 
> > > One can argue that this is an swiotlb problem, because without swiotlb
> > > we leak all zeros, and the swiotlb should be transparent in a sense that
> > > it does not affect the outcome (if all other participants are well
> > > behaved).
> > > 
> > > Copying the content of the original buffer into the swiotlb buffer is
> > > the only way I can think of to make swiotlb transparent in such
> > > scenarios. So let's do just that if in doubt, but allow the driver
> > > to tell us that the whole mapped buffer is going to be overwritten,
> > > in which case we can preserve the old behavior and avoid the performance
> > > impact of the extra bounce.
> > > 
> > > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > Cc: stable@vger.kernel.org
> > > [pasic@linux.ibm.com: resolved merge conflicts]
> > > ---
> > >  Documentation/core-api/dma-attributes.rst | 8 ++++++++
> > >  include/linux/dma-mapping.h               | 8 ++++++++
> > >  kernel/dma/swiotlb.c                      | 3 ++-
> > >  3 files changed, 18 insertions(+), 1 deletion(-)  
> > 
> > What is the git commit id of this patch in Linus's tree?
> 
> ddbd89deb7d3 ("swiotlb: fix info leak with DMA_FROM_DEVICE")
> 
> What is the best way to state the original commit id for backports? I
> used the cover letter this time, but it does not seem to be the right
> choice.

Below the --- line is fine, or somewhere that I can see it in the patch,
much like we do for the commits in the stable trees is even better.

Trying to dig it out of a cover letter is hard, for obvious reasons.

thanks,

greg k-h
