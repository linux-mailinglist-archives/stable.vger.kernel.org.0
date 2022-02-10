Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF134B0203
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 02:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbiBJBXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 20:23:25 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:43538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbiBJBXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 20:23:24 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923251EC7F
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 17:23:26 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id d3so3181877ilr.10
        for <stable@vger.kernel.org>; Wed, 09 Feb 2022 17:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qz7vyOHI+/9/hEuXbA2H+eEF9viVltP3WNqYokBZz8U=;
        b=e7rr9E4bXY+9zNosU07Yjxva9Oj/XB9dzqOkd+Qh0f8GJpHkBALzmQ95c0InXjwwNw
         XBu/N4xCoWaxq9WwENOIuqqpnwbMF1cHZXivvhRMlVSNqL0cLYKvx9t+R0ZSvX3+JMUx
         vBOr733pGcgdNnd6IODFU+LN0j7T1SCAyEWcM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qz7vyOHI+/9/hEuXbA2H+eEF9viVltP3WNqYokBZz8U=;
        b=nYHZfUD9jhZj9I72jSJP5724YDjxFBvP/cVcgw1buDOabpQSfxoRfTNiJWy7bPgayz
         +UFLFz77/PehQVvIDwCf8gkkIDXjhbQnZBvrdLs3IkJTWwIPpspsDMXvdDVVB7hwfd2o
         DjfUI5/6ASxpb6RGnV2hJCy+vdakEUV1RRZBJR1zJ/4jvqOJzia9/OypjvPBIHkRhWen
         rFtr+upTBKFfflj3dp1v3SN89/TU9jzWnUMG8Aw3wJJnObBKTbBVSV/hHwgGNmRo8+DQ
         w0LmRSGzUTjyREC5xPWBWkWjfEIHFiFMkAT421VBNR1aiIzsXfXG2evlEJQ590/zpqZb
         JThw==
X-Gm-Message-State: AOAM531dNiOjiBpDUXYvxly8Z22/IaCQQP4OE63UD9JRhy0FZfK/qNDH
        oy2+CCXZ+thtWA4mD2XyXx0m6HDyy4mIsTi6pHOdd9H0LfjuKQ==
X-Google-Smtp-Source: ABdhPJyR72shmE/ISTzNkwbuYPS+jEFh0zKYXXjL72fNSzjjleAtmI5SrS8dsY3qE7ItF7z8k2w07dJ1DlDrChGQwAk=
X-Received: by 2002:a05:6e02:1449:: with SMTP id p9mr2575103ilo.289.1644454795832;
 Wed, 09 Feb 2022 16:59:55 -0800 (PST)
MIME-Version: 1.0
References: <20220209050947.2119465-1-gwendal@chromium.org> <9ba46bf0894bdee52bc3ebca4527d115ebf067a6.camel@linux.intel.com>
In-Reply-To: <9ba46bf0894bdee52bc3ebca4527d115ebf067a6.camel@linux.intel.com>
From:   Gwendal Grignou <gwendal@chromium.org>
Date:   Wed, 9 Feb 2022 16:59:42 -0800
Message-ID: <CAPUE2utMOYJobCEj3ZzPfdovRJVXVhNJg3CFHCNt0Jq=w68ovA@mail.gmail.com>
Subject: Re: [PATCH] HID: intel-ish-hid: Use dma_alloc_coherent for firmware update
To:     srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
Cc:     jikos@kernel.org, linux-input@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 9, 2022 at 10:52 AM srinivas pandruvada
<srinivas.pandruvada@linux.intel.com> wrote:
>
> On Tue, 2022-02-08 at 21:09 -0800, Gwendal Grignou wrote:
> > Allocating memory with kmalloc and GPF_DMA32 is not allowed, the
> > allocator will ignore the attribute.
> >
> Looks like there is new error flow added here for this flag.
> Is this just removing GFP_DMA32 not enough?
It was already ignored. It is not enough and I don't know why since
the virtual and physical addresses are in the same range:

With using kmalloc/dma_single_sync:
5.10 (firmware not loading)
[    3.837996] ish-loader {C804D06A-55BD-4EA7-ADED-1E31228C76DC}:
kmalloc/dma_map_single: v:0xffff91531ae88000, phy:0x0000000085afe000
[    3.838003] ish-loader {C804D06A-55BD-4EA7-ADED-1E31228C76DC}:
xfer_mode=dma offset=0x00000000 size=0x4000 is_last=0
ddr_phys_addr=0x0000000085afe000
...

4.19 (firmware loading)
[    3.878300] ish-loader {C804D06A-55BD-4EA7-ADED-1E31228C76DC}:
kmalloc/dma_map_single: v:0xffff88c145480000, phy:0x0000000085480000
[    3.878322] ish-loader {C804D06A-55BD-4EA7-ADED-1E31228C76DC}:
xfer_mode=dma offset=0x00000000 size=0x4000 is_last=0
ddr_phys_addr=0x0000000085480000
...

I also considered flushing the CPU cache before the
dma_sync_single_for_device call, and calling dma_sync_single_for_cpu()
after loader_cl_send() to be allowed to write into the buffer again.
But these did not help either.

But using dma_alloc_coherent() clearly works and its simpler API makes
it more appropriate for the task at hand.

For reference, the same log when using dma_alloc_coherent().
[    3.779723] ish-loader {C804D06A-55BD-4EA7-ADED-1E31228C76DC}:
dma_alloc_coherent: v:0xffff9beb81048000, phy:0x0000000001048000
[    3.779731] ish-loader {C804D06A-55BD-4EA7-ADED-1E31228C76DC}:
xfer_mode=dma offset=0x00000000 size=0x4000 is_last=0
ddr_phys_addr=0x0000000001048000
...

>
> > Instead, use dma_alloc_coherent() API as we allocate a small amount
> > of
> > memory to transfer firmware fragment to the ISH.
> >
> > On Arcada chromebook, after the patch the warning:
> > "Unexpected gfp: 0x4 (GFP_DMA32). Fixing up to gfp: 0xcc0
> > (GFP_KERNEL).  Fix your code!"
> > is gone. The ISH firmware is loaded properly and we can interact with
> > the ISH:
> > > ectool  --name cros_ish version
> > ...
> > Build info:    arcada_ish_v2.0.3661+3c1a1c1ae0 2022-02-08 05:37:47
> > @localhost
> > Tool version:  v2.0.12300-900b03ec7f 2022-02-08 10:01:48 @localhost
> >
> > Fixes: commit 91b228107da3 ("HID: intel-ish-hid: ISH firmware loader
> > client driver")
> > Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/hid/intel-ish-hid/ishtp-fw-loader.c | 29 +++----------------
> > --
> >  1 file changed, 3 insertions(+), 26 deletions(-)
> >
> > diff --git a/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
> > b/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
> > index e24988586710..16aa030af845 100644
> > --- a/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
> > +++ b/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
> > @@ -661,21 +661,12 @@ static int ish_fw_xfer_direct_dma(struct
> > ishtp_cl_data *client_data,
> >          */
> >         payload_max_size &= ~(L1_CACHE_BYTES - 1);
> >
> > -       dma_buf = kmalloc(payload_max_size, GFP_KERNEL | GFP_DMA32);
> > +       dma_buf = dma_alloc_coherent(devc, payload_max_size,
> > &dma_buf_phy, GFP_KERNEL);
> >         if (!dma_buf) {
> >                 client_data->flag_retry = true;
> >                 return -ENOMEM;
> >         }
> >
> > -       dma_buf_phy = dma_map_single(devc, dma_buf, payload_max_size,
> > -                                    DMA_TO_DEVICE);
> > -       if (dma_mapping_error(devc, dma_buf_phy)) {
> > -               dev_err(cl_data_to_dev(client_data), "DMA map
> > failed\n");
> > -               client_data->flag_retry = true;
> > -               rv = -ENOMEM;
> > -               goto end_err_dma_buf_release;
> > -       }
> > -
> >         ldr_xfer_dma_frag.fragment.hdr.command =
> > LOADER_CMD_XFER_FRAGMENT;
> >         ldr_xfer_dma_frag.fragment.xfer_mode =
> > LOADER_XFER_MODE_DIRECT_DMA;
> >         ldr_xfer_dma_frag.ddr_phys_addr = (u64)dma_buf_phy;
> > @@ -695,14 +686,7 @@ static int ish_fw_xfer_direct_dma(struct
> > ishtp_cl_data *client_data,
> >                 ldr_xfer_dma_frag.fragment.size = fragment_size;
> >                 memcpy(dma_buf, &fw->data[fragment_offset],
> > fragment_size);
> >
> > -               dma_sync_single_for_device(devc, dma_buf_phy,
> > -                                          payload_max_size,
> > -                                          DMA_TO_DEVICE);
> > -
> Any reason for removal of sync?
It is not needed since we are using dma_alloc_coherent(). From [1]:
"""
void *
dma_alloc_coherent(struct device *dev, size_t size,
   dma_addr_t *dma_handle, gfp_t flag)

Consistent memory is memory for which a write by either the device or
the processor can immediately be read by the processor or device
without having to worry about caching effects.  (You may however need
to make sure to flush the processor's write buffers before telling
devices to read that memory.)

This routine allocates a region of <size> bytes of consistent memory.
"""'
>
> Thanks,
> Srinivas
>
> > -               /*
> > -                * Flush cache here because the
> > dma_sync_single_for_device()
> > -                * does not do for x86.
> > -                */
> > +               /* Flush cache to be sure the data is in main memory.
> > */
> >                 clflush_cache_range(dma_buf, payload_max_size);
> >
> >                 dev_dbg(cl_data_to_dev(client_data),
> > @@ -725,15 +709,8 @@ static int ish_fw_xfer_direct_dma(struct
> > ishtp_cl_data *client_data,
> >                 fragment_offset += fragment_size;
> >         }
> >
> > -       dma_unmap_single(devc, dma_buf_phy, payload_max_size,
> > DMA_TO_DEVICE);
> > -       kfree(dma_buf);
> > -       return 0;
> > -
> >  end_err_resp_buf_release:
> > -       /* Free ISH buffer if not done already, in error case */
> > -       dma_unmap_single(devc, dma_buf_phy, payload_max_size,
> > DMA_TO_DEVICE);
> > -end_err_dma_buf_release:
> > -       kfree(dma_buf);
> > +       dma_free_coherent(devc, payload_max_size, dma_buf,
> > dma_buf_phy);
> >         return rv;
> >  }
> >
>

[1]https://www.kernel.org/doc/Documentation/DMA-API.txt
