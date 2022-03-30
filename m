Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7244EBF93
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343526AbiC3LJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343525AbiC3LJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:09:18 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6696B10FEF
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 04:07:33 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id m30so28762616wrb.1
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 04:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=dlIkZk9tc5vq8Dt8x93oQB0aKV+y1HJBYhSqwKSesqk=;
        b=MBKfTm6JOCD1FL9yXG5o6Zo90d6Ndte1eQA9pmRyQ5aTxhQ87MUEWSQ8Ol24pmFk9n
         1f4La7oOVpSjKJFc3BOM6vUNZNnKZPW+RK9BFon+Uz9zQbl+Z84pVw7O4V0T40BI47iI
         lluuHr0l7KHgCk779v+ACfOvTwMNhkB7McqOUYszW2rbp8Twrz+2VI89brs2tussGcEj
         Ifbv+ttOv7oiENHnaUA1A2esoq3BQbUIU3er21mpl8yKJsOOZz77swtwC7Ih+k0AY2P5
         8jEBGsQ1XvqC8q000ciBYLDBZdPaaNOA7MO7d+EXDwiE1QaRspCSLxa9CVAOlUvbGglL
         b6WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=dlIkZk9tc5vq8Dt8x93oQB0aKV+y1HJBYhSqwKSesqk=;
        b=KRAPBmFs5pBWfMTcsxM2yZEdhSPQ81oeUzvmSAwBR00IrYf7EtS1QEjwGTv0k//Uby
         PS/TxfwgEAhl455rLcSF5eoUBio01MEwPMcEl9rgaDT3uvwKSQMBeUnmDja1Tras44Es
         d9rnKh8AzjXXNKE1Z9MwqQVu885yGvqsnc4mMIsf2dMOdRhObM2MXg5M3+u0I32o7dct
         VdynkZmxHvQhZwYRUHCWVVdMZipviivu1mzhdF4JbnrxVuDSaHWtcAlkIbfXsT6OX1wv
         Sc4eGxwNC5gYSitKoyvVCl11CXehUUHLwhK1hB22dPxkxR+am01+L4b3MxgM555wM7me
         Hnmg==
X-Gm-Message-State: AOAM532xdHA0isYERbR/XnuWizSNIRaFjgNeX2VpCouSbDL5vbOZ3Z4r
        cQNNBvNMqh7pIEgQmk7hB9bmtg==
X-Google-Smtp-Source: ABdhPJxYeODGE64KBYkC6MebtMMNbjkNY/tHtraWAivgL2GN5/Fjyyojgsd/z69xGtUEgc7ZX/Ahew==
X-Received: by 2002:a05:6000:18a2:b0:203:d2f5:28a0 with SMTP id b2-20020a05600018a200b00203d2f528a0mr36218867wri.355.1648638451811;
        Wed, 30 Mar 2022 04:07:31 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id f13-20020a05600c4e8d00b0038c949ef0d5sm4947810wmq.8.2022.03.30.04.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 04:07:31 -0700 (PDT)
Date:   Wed, 30 Mar 2022 12:07:29 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] virtio-blk: Use blk_validate_block_size() to
 validate block size
Message-ID: <YkQ58V4+NWgDRZ18@google.com>
References: <20220330105841.464954-1-lee.jones@linaro.org>
 <YkQ4yuX+RGPPm1hV@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YkQ4yuX+RGPPm1hV@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 30 Mar 2022, Greg KH wrote:

> On Wed, Mar 30, 2022 at 11:58:41AM +0100, Lee Jones wrote:
> > From: Xie Yongji <xieyongji@bytedance.com>
> > 
> > [ Upstream commit 57a13a5b8157d9a8606490aaa1b805bafe6c37e1 ]
> > 
> > The block layer can't support a block size larger than
> > page size yet. And a block size that's too small or
> > not a power of two won't work either. If a misconfigured
> > device presents an invalid block size in configuration space,
> > it will result in the kernel crash something like below:
> > 
> > [  506.154324] BUG: kernel NULL pointer dereference, address: 0000000000000008
> > [  506.160416] RIP: 0010:create_empty_buffers+0x24/0x100
> > [  506.174302] Call Trace:
> > [  506.174651]  create_page_buffers+0x4d/0x60
> > [  506.175207]  block_read_full_page+0x50/0x380
> > [  506.175798]  ? __mod_lruvec_page_state+0x60/0xa0
> > [  506.176412]  ? __add_to_page_cache_locked+0x1b2/0x390
> > [  506.177085]  ? blkdev_direct_IO+0x4a0/0x4a0
> > [  506.177644]  ? scan_shadow_nodes+0x30/0x30
> > [  506.178206]  ? lru_cache_add+0x42/0x60
> > [  506.178716]  do_read_cache_page+0x695/0x740
> > [  506.179278]  ? read_part_sector+0xe0/0xe0
> > [  506.179821]  read_part_sector+0x36/0xe0
> > [  506.180337]  adfspart_check_ICS+0x32/0x320
> > [  506.180890]  ? snprintf+0x45/0x70
> > [  506.181350]  ? read_part_sector+0xe0/0xe0
> > [  506.181906]  bdev_disk_changed+0x229/0x5c0
> > [  506.182483]  blkdev_get_whole+0x6d/0x90
> > [  506.183013]  blkdev_get_by_dev+0x122/0x2d0
> > [  506.183562]  device_add_disk+0x39e/0x3c0
> > [  506.184472]  virtblk_probe+0x3f8/0x79b [virtio_blk]
> > [  506.185461]  virtio_dev_probe+0x15e/0x1d0 [virtio]
> > 
> > So let's use a block layer helper to validate the block size.
> > 
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > Link: https://lore.kernel.org/r/20211026144015.188-5-xieyongji@bytedance.com
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/block/virtio_blk.c | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> What stable tree(s) are you wanting this backported to?

I knew there was something I'd forgotten to do.

All of them, but I will save you the work and submit separate series'.

This one is for linux-5.10.y.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
