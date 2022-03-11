Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64BD4D6AA2
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 00:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiCKWxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 17:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiCKWwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 17:52:54 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC851E5A78;
        Fri, 11 Mar 2022 14:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647037809; x=1678573809;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vCX4Tq+5vgwzmrQISBpCllic9QrJEJFaWH+I9HyERkQ=;
  b=T1Z/zE7AZjLPFkcAAbDxP4DJ/rMCdnn7xZbSzRP5hzuMExSowHZFHz9y
   UIJwjFCmdhMXcMy+j1ArMTBmqbiGBLuoVAJh/zsXIoumne516ZD7+JnMw
   hQHOHDI11f9SOWITQcZ9mfZqnYk0NHCCagEgtN4tD1joVasUSbG5SsFLT
   2WV8f8yeeW5JMFyu+8V9jGHc4+Jht+M8kawsDKXXvW7LITrw+hkQZO5VB
   2P6WBOfoM8jOsRA0dKp3ezKExjHlK41s5eNWSTHoe5qjdWR7nSWTgPD0C
   s805ofdnUoo/0AKdjTg1dVAaFBFu3sq67vLFT0/bDHJeZM2w6Va6fy3bC
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10283"; a="235609086"
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="235609086"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 13:22:42 -0800
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="645060179"
Received: from spandruv-desk.jf.intel.com ([10.54.75.8])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 13:22:42 -0800
Message-ID: <99f75c8b2a127ead50a4a264bf1387cbc64970a8.camel@linux.intel.com>
Subject: Re: [PATCH] HID: intel-ish-hid: Use dma_alloc_coherent for firmware
 update
From:   srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
To:     Gwendal Grignou <gwendal@chromium.org>, jikos@kernel.org
Cc:     linux-input@vger.kernel.org, stable@vger.kernel.org
Date:   Fri, 11 Mar 2022 13:22:42 -0800
In-Reply-To: <20220209050947.2119465-1-gwendal@chromium.org>
References: <20220209050947.2119465-1-gwendal@chromium.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-02-08 at 21:09 -0800, Gwendal Grignou wrote:
> Allocating memory with kmalloc and GPF_DMA32 is not allowed, the
> allocator will ignore the attribute.
> 
> Instead, use dma_alloc_coherent() API as we allocate a small amount of
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
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

> ---
>  drivers/hid/intel-ish-hid/ishtp-fw-loader.c | 29 +++------------------
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


