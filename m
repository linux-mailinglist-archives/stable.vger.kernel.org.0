Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061064AFC42
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241435AbiBIS53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241573AbiBIS4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:56:03 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C26C0045EC;
        Wed,  9 Feb 2022 10:52:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644432774; x=1675968774;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Br9wOtlVbDwyKcseA9N9oD+UJPcdBFnFt6Hnjc45kcI=;
  b=igjcwNHGXj8IAmaUZIl+P8L42+cKgdpVhjk4Vh9kFZ9NfCOayDlAnUnq
   +lnj3YwE7H3JgZxz7aJtjQkzZFeYwLTGLkZ7VQmc9geZmuwZr0sRgz+ns
   LpVs9d+ppSyiczULcFFbgv7SGcqmPDVkXOFf8vkRi77NkyzEIqPOVfZtc
   y2TQS146aKJXkpzTNMCmIJghWkFOC5pello8EbcIInBCvRvAQh+uwz5KF
   rExQGcSSJmUWbmvO+NwqK/ts25/ubWA6t0slWGqSGo/xDs/Wexciwvb25
   JIHsmo1DRSO8BqwINBqdJC+zyE7KM2GwXEjUxuBne203/22c4nTrdgMC6
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="246887532"
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="246887532"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 10:52:53 -0800
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="585679875"
Received: from iliao-mobl3.amr.corp.intel.com (HELO spandruv-desk1.amr.corp.intel.com) ([10.251.21.205])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 10:52:53 -0800
Message-ID: <9ba46bf0894bdee52bc3ebca4527d115ebf067a6.camel@linux.intel.com>
Subject: Re: [PATCH] HID: intel-ish-hid: Use dma_alloc_coherent for firmware
 update
From:   srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
To:     Gwendal Grignou <gwendal@chromium.org>, jikos@kernel.org
Cc:     linux-input@vger.kernel.org, stable@vger.kernel.org
Date:   Wed, 09 Feb 2022 10:52:52 -0800
In-Reply-To: <20220209050947.2119465-1-gwendal@chromium.org>
References: <20220209050947.2119465-1-gwendal@chromium.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-02-08 at 21:09 -0800, Gwendal Grignou wrote:
> Allocating memory with kmalloc and GPF_DMA32 is not allowed, the
> allocator will ignore the attribute.
> 
Looks like there is new error flow added here for this flag.
Is this just removing GFP_DMA32 not enough?

> Instead, use dma_alloc_coherent() API as we allocate a small amount
> of
> memory to transfer firmware fragment to the ISH.
> 
> On Arcada chromebook, after the patch the warning:
> "Unexpected gfp: 0x4 (GFP_DMA32). Fixing up to gfp: 0xcc0
> (GFP_KERNEL).  Fix your code!"
> is gone. The ISH firmware is loaded properly and we can interact with
> the ISH:
> > ectool  --name cros_ish version
> ...
> Build info:    arcada_ish_v2.0.3661+3c1a1c1ae0 2022-02-08 05:37:47
> @localhost
> Tool version:  v2.0.12300-900b03ec7f 2022-02-08 10:01:48 @localhost
> 
> Fixes: commit 91b228107da3 ("HID: intel-ish-hid: ISH firmware loader
> client driver")
> Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
> Cc: stable@vger.kernel.org
> ---
>  drivers/hid/intel-ish-hid/ishtp-fw-loader.c | 29 +++----------------
> --
>  1 file changed, 3 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
> b/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
> index e24988586710..16aa030af845 100644
> --- a/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
> +++ b/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
> @@ -661,21 +661,12 @@ static int ish_fw_xfer_direct_dma(struct
> ishtp_cl_data *client_data,
>          */
>         payload_max_size &= ~(L1_CACHE_BYTES - 1);
>  
> -       dma_buf = kmalloc(payload_max_size, GFP_KERNEL | GFP_DMA32);
> +       dma_buf = dma_alloc_coherent(devc, payload_max_size,
> &dma_buf_phy, GFP_KERNEL);
>         if (!dma_buf) {
>                 client_data->flag_retry = true;
>                 return -ENOMEM;
>         }
>  
> -       dma_buf_phy = dma_map_single(devc, dma_buf, payload_max_size,
> -                                    DMA_TO_DEVICE);
> -       if (dma_mapping_error(devc, dma_buf_phy)) {
> -               dev_err(cl_data_to_dev(client_data), "DMA map
> failed\n");
> -               client_data->flag_retry = true;
> -               rv = -ENOMEM;
> -               goto end_err_dma_buf_release;
> -       }
> -
>         ldr_xfer_dma_frag.fragment.hdr.command =
> LOADER_CMD_XFER_FRAGMENT;
>         ldr_xfer_dma_frag.fragment.xfer_mode =
> LOADER_XFER_MODE_DIRECT_DMA;
>         ldr_xfer_dma_frag.ddr_phys_addr = (u64)dma_buf_phy;
> @@ -695,14 +686,7 @@ static int ish_fw_xfer_direct_dma(struct
> ishtp_cl_data *client_data,
>                 ldr_xfer_dma_frag.fragment.size = fragment_size;
>                 memcpy(dma_buf, &fw->data[fragment_offset],
> fragment_size);
>  
> -               dma_sync_single_for_device(devc, dma_buf_phy,
> -                                          payload_max_size,
> -                                          DMA_TO_DEVICE);
> -
Any reason for removal of sync?

Thanks,
Srinivas

> -               /*
> -                * Flush cache here because the
> dma_sync_single_for_device()
> -                * does not do for x86.
> -                */
> +               /* Flush cache to be sure the data is in main memory.
> */
>                 clflush_cache_range(dma_buf, payload_max_size);
>  
>                 dev_dbg(cl_data_to_dev(client_data),
> @@ -725,15 +709,8 @@ static int ish_fw_xfer_direct_dma(struct
> ishtp_cl_data *client_data,
>                 fragment_offset += fragment_size;
>         }
>  
> -       dma_unmap_single(devc, dma_buf_phy, payload_max_size,
> DMA_TO_DEVICE);
> -       kfree(dma_buf);
> -       return 0;
> -
>  end_err_resp_buf_release:
> -       /* Free ISH buffer if not done already, in error case */
> -       dma_unmap_single(devc, dma_buf_phy, payload_max_size,
> DMA_TO_DEVICE);
> -end_err_dma_buf_release:
> -       kfree(dma_buf);
> +       dma_free_coherent(devc, payload_max_size, dma_buf,
> dma_buf_phy);
>         return rv;
>  }
>  

