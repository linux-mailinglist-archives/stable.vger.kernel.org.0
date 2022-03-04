Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142774CDBBF
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 19:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241526AbiCDSFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 13:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241495AbiCDSFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 13:05:44 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F871C4B07;
        Fri,  4 Mar 2022 10:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646417096; x=1677953096;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=19rMmk4BxkjjXth3zxKnLHokLNSzgmc3OuMKbnnibxU=;
  b=ZET83XFvgoQxomUG2bdIjEuAX8ZURWOYf/unG8JFzeFXXCuQfCnMzRCa
   Gnemht2H6lmmZmWsav2l39+cS3nctzXsqAuD0k276rA8qGrip8mS1X8ZB
   SfuVEiPYHVFSHJKA0cJJ0uDADXdl0RPvSmQYQfwASy5Mdor2IebJ5yKtw
   ax0BmqtLEMOOTFJeDYVv6BcRi9uKheV6UdvmeC2zTUN04XtXEtTnI9hZx
   PUA7r0i1E7xVJuqd8WpxFLVyAbLTnzSEMsvV0RK7ra/b+FRz4jKzG6wDU
   I4TIhTpIA2qTRQ4uAl/OdATc0iI8A5Ebs1PtKbMsKuGKs1QqRWKd8Ke5w
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="252856785"
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="252856785"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 10:04:54 -0800
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="552308832"
Received: from qiantong-mobl1.amr.corp.intel.com (HELO spandruv-desk1.amr.corp.intel.com) ([10.212.225.201])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 10:04:54 -0800
Message-ID: <64bc4222d1a1b8129c889f63f57eaeb2cca52770.camel@linux.intel.com>
Subject: Re: [PATCH] HID: intel-ish-hid: Use dma_alloc_coherent for firmware
 update
From:   srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
To:     Gwendal Grignou <gwendal@chromium.org>
Cc:     jikos@kernel.org, linux-input@vger.kernel.org,
        stable@vger.kernel.org
Date:   Fri, 04 Mar 2022 10:04:54 -0800
In-Reply-To: <CAPUE2uubb6Xbdx9qUSdm3P9ZGmaVcG+6wCgJ_hQ2OEZSYKcJag@mail.gmail.com>
References: <20220209050947.2119465-1-gwendal@chromium.org>
         <9ba46bf0894bdee52bc3ebca4527d115ebf067a6.camel@linux.intel.com>
         <CAPUE2utMOYJobCEj3ZzPfdovRJVXVhNJg3CFHCNt0Jq=w68ovA@mail.gmail.com>
         <80a7df19f77246450a1a89693d095035881f42b7.camel@linux.intel.com>
         <CAPUE2uubb6Xbdx9qUSdm3P9ZGmaVcG+6wCgJ_hQ2OEZSYKcJag@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2022-02-10 at 10:34 -0800, Gwendal Grignou wrote:
> On Wed, Feb 9, 2022 at 6:51 PM srinivas pandruvada
> <srinivas.pandruvada@linux.intel.com> wrote:
> > 
> > On Wed, 2022-02-09 at 16:59 -0800, Gwendal Grignou wrote:
> > > On Wed, Feb 9, 2022 at 10:52 AM srinivas pandruvada
> > > <srinivas.pandruvada@linux.intel.com> wrote:
> > > > 
> > > > On Tue, 2022-02-08 at 21:09 -0800, Gwendal Grignou wrote:
> > > > > Allocating memory with kmalloc and GPF_DMA32 is not allowed,
> > > > > the
> > > > > allocator will ignore the attribute.
> > > > > 
> > > > Looks like there is new error flow added here for this flag.
> > > > Is this just removing GFP_DMA32 not enough?
> > > It was already ignored. It is not enough and I don't know why
> > > since
> > > the virtual and physical addresses are in the same range:
> > > 
> > > With using kmalloc/dma_single_sync:
> > > 5.10 (firmware not loading)
> > > [    3.837996] ish-loader {C804D06A-55BD-4EA7-ADED-1E31228C76DC}:
> > > kmalloc/dma_map_single: v:0xffff91531ae88000,
> > > phy:0x0000000085afe000
> > > [    3.838003] ish-loader {C804D06A-55BD-4EA7-ADED-1E31228C76DC}:
> > > xfer_mode=dma offset=0x00000000 size=0x4000 is_last=0
> > > ddr_phys_addr=0x0000000085afe000
> > > ...
> > > 
> > > 4.19 (firmware loading)
> > > [    3.878300] ish-loader {C804D06A-55BD-4EA7-ADED-1E31228C76DC}:
> > > kmalloc/dma_map_single: v:0xffff88c145480000,
> > > phy:0x0000000085480000
> > > [    3.878322] ish-loader {C804D06A-55BD-4EA7-ADED-1E31228C76DC}:
> > > xfer_mode=dma offset=0x00000000 size=0x4000 is_last=0
> > > ddr_phys_addr=0x0000000085480000
> > > ...
> > > 
> > > I also considered flushing the CPU cache before the
> > > dma_sync_single_for_device call, and calling
> > > dma_sync_single_for_cpu()
> > > after loader_cl_send() to be allowed to write into the buffer
> > > again.
> > > But these did not help either.
> > > 
> > > But using dma_alloc_coherent() clearly works and its simpler API
> > > makes
> > That is OK.
> > 
> > > it more appropriate for the task at hand.
> > > 
> > > For reference, the same log when using dma_alloc_coherent().
> > > [    3.779723] ish-loader {C804D06A-55BD-4EA7-ADED-1E31228C76DC}:
> > > dma_alloc_coherent: v:0xffff9beb81048000, phy:0x0000000001048000
> > > [    3.779731] ish-loader {C804D06A-55BD-4EA7-ADED-1E31228C76DC}:
> > > xfer_mode=dma offset=0x00000000 size=0x4000 is_last=0
> > > ddr_phys_addr=0x0000000001048000
> > > ...
> > > 
> > > > 
> > > > > Instead, use dma_alloc_coherent() API as we allocate a small
> > > > > amount
> > > > > of
> > > > > memory to transfer firmware fragment to the ISH.
> > > > > 
> > > > > On Arcada chromebook, after the patch the warning:
> > > > > "Unexpected gfp: 0x4 (GFP_DMA32). Fixing up to gfp: 0xcc0
> > > > > (GFP_KERNEL).  Fix your code!"
> > > > > is gone. The ISH firmware is loaded properly and we can
> > > > > interact
> > > > > with
> > > > > the ISH:
> > > > > > ectool  --name cros_ish version
> > > > > ...
> > > > > Build info:    arcada_ish_v2.0.3661+3c1a1c1ae0 2022-02-08
> > > > > 05:37:47
> > > > > @localhost
> > > > > Tool version:  v2.0.12300-900b03ec7f 2022-02-08 10:01:48
> > > > > @localhost
> > > > > 
> > > > > Fixes: commit 91b228107da3 ("HID: intel-ish-hid: ISH firmware
> > > > > loader
> > > > > client driver")
> > > > > Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
> > > > > Cc: stable@vger.kernel.org
> > > > > ---
> > > > >  drivers/hid/intel-ish-hid/ishtp-fw-loader.c | 29 +++--------
> > > > > ----
> > > > > ----
> > > > > --
> > > > >  1 file changed, 3 insertions(+), 26 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
> > > > > b/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
> > > > > index e24988586710..16aa030af845 100644
> > > > > --- a/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
> > > > > +++ b/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
> > > > > @@ -661,21 +661,12 @@ static int
> > > > > ish_fw_xfer_direct_dma(struct
> > > > > ishtp_cl_data *client_data,
> > > > >          */
> > > > >         payload_max_size &= ~(L1_CACHE_BYTES - 1);
> > > > > 
> > > > > -       dma_buf = kmalloc(payload_max_size, GFP_KERNEL |
> > > > > GFP_DMA32);
> > > > > +       dma_buf = dma_alloc_coherent(devc, payload_max_size,
> > > > > &dma_buf_phy, GFP_KERNEL);
> > > > >         if (!dma_buf) {
> > > > >                 client_data->flag_retry = true;
> > > > >                 return -ENOMEM;
> > > > >         }
> > > > > 
> > > > > -       dma_buf_phy = dma_map_single(devc, dma_buf,
> > > > > payload_max_size,
> > > > > -                                    DMA_TO_DEVICE);
> > > > > -       if (dma_mapping_error(devc, dma_buf_phy)) {
> > > > > -               dev_err(cl_data_to_dev(client_data), "DMA map
> > > > > failed\n");
> > > > > -               client_data->flag_retry = true;
> > > > > -               rv = -ENOMEM;
> > > > > -               goto end_err_dma_buf_release;
> > > > > -       }
> > > > > -
> > > > >         ldr_xfer_dma_frag.fragment.hdr.command =
> > > > > LOADER_CMD_XFER_FRAGMENT;
> > > > >         ldr_xfer_dma_frag.fragment.xfer_mode =
> > > > > LOADER_XFER_MODE_DIRECT_DMA;
> > > > >         ldr_xfer_dma_frag.ddr_phys_addr = (u64)dma_buf_phy;
> > > > > @@ -695,14 +686,7 @@ static int ish_fw_xfer_direct_dma(struct
> > > > > ishtp_cl_data *client_data,
> > > > >                 ldr_xfer_dma_frag.fragment.size =
> > > > > fragment_size;
> > > > >                 memcpy(dma_buf, &fw->data[fragment_offset],
> > > > > fragment_size);
> > > > > 
> > > > > -               dma_sync_single_for_device(devc, dma_buf_phy,
> > > > > -                                          payload_max_size,
> > > > > -                                          DMA_TO_DEVICE);
> > > > > -
> > > > Any reason for removal of sync?
> > > It is not needed since we are using dma_alloc_coherent(). From
> > > [1]:
> > > """
> > > void *
> > > dma_alloc_coherent(struct device *dev, size_t size,
> > >    dma_addr_t *dma_handle, gfp_t flag)
> > > 
> > > Consistent memory is memory for which a write by either the
> > > device or
> > > the processor can immediately be read by the processor or device
> > > without having to worry about caching effects.  (You may however
> > > need
> > > to make sure to flush the processor's write buffers before
> > > telling
> > > devices to read that memory.)
> > > 
> > > This routine allocates a region of <size> bytes of consistent
> > > memory.
> > > """'
> > > 
> >  I checked with some dma folks. This call may still be required for
> > some device. Most likely not as this is on chip device.
> > What happens if you leave this call? I worry for regression on some
> > old
> > systems.
I couldn't find any Chrome device to experiment.
Please try with "swiotlb=force" and if it works, then this if fine to
take the patch as is.

Thanks,
Srinivas

> I truly believe this call is unnecessary: From the docs, dma_sync_...
> is only for streaming DMA mappings, not for coherent memory. Another
> link here:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2015-May/341712.html
> Looking at older drivers, for instance exec_drive_command() in
> driver/block/mtip32xx/mtip32xx.c, there are no dma_sync_ between
> dma_alloc_ and dma_free_.
> In a simple driver - drivers/scsi/advansys.c - that only uses
> coherent
> DMA memory, no dma_sync calls are used.
> As long as we have a memory barrier before sending the packet
> downstream, we are covered. I rebooted my machine in a loop without
> error overnight.
> 
> Gwendal.
> 
> > 
> > Thanks,
> > Srinivas
> > 
> > 
> > 
> > > > Thanks,
> > > > Srinivas
> > > > 
> > > > > -               /*
> > > > > -                * Flush cache here because the
> > > > > dma_sync_single_for_device()
> > > > > -                * does not do for x86.
> > > > > -                */
> > > > > +               /* Flush cache to be sure the data is in main
> > > > > memory.
> > > > > */
> > > > >                 clflush_cache_range(dma_buf,
> > > > > payload_max_size);
> > > > > 
> > > > >                 dev_dbg(cl_data_to_dev(client_data),
> > > > > @@ -725,15 +709,8 @@ static int ish_fw_xfer_direct_dma(struct
> > > > > ishtp_cl_data *client_data,
> > > > >                 fragment_offset += fragment_size;
> > > > >         }
> > > > > 
> > > > > -       dma_unmap_single(devc, dma_buf_phy, payload_max_size,
> > > > > DMA_TO_DEVICE);
> > > > > -       kfree(dma_buf);
> > > > > -       return 0;
> > > > > -
> > > > >  end_err_resp_buf_release:
> > > > > -       /* Free ISH buffer if not done already, in error case
> > > > > */
> > > > > -       dma_unmap_single(devc, dma_buf_phy, payload_max_size,
> > > > > DMA_TO_DEVICE);
> > > > > -end_err_dma_buf_release:
> > > > > -       kfree(dma_buf);
> > > > > +       dma_free_coherent(devc, payload_max_size, dma_buf,
> > > > > dma_buf_phy);
> > > > >         return rv;
> > > > >  }
> > > > > 
> > > > 
> > > 
> > > [1]https://www.kernel.org/doc/Documentation/DMA-API.txt
> > 

