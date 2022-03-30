Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F194EC3E5
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 14:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238626AbiC3ML2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 08:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346105AbiC3MEb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 08:04:31 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E61E396BA
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 04:58:54 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id r13so28895779wrr.9
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 04:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=wfUgoAUln8fBcjbz3YHFYmmrojTPUio4osfqW5jeNmg=;
        b=rfpduUqAoK+FsAhjPNHH4IcRdLFoZX5sW1wIblvMhIARgry7k4IyFZb2UFDcABszqF
         oQEdqDu9FkOGls380iwrJKkytjpBZB1GtkLalXnxw3oBwVBwO0kWKpd8V6cyWJ8T/35R
         EZSwcwy7nhtDzp5CigQROw/N1GZV/PLCnDIQ/woawXGeA24C55GihODQbkS7856+W3v8
         SAwYC+e24kRJWew9CzBHYcFFXR7ZbqXEX4lDZoPCXH4lddEyE/yg2t2t6bL0Uh3lBAL6
         U5CNKWxhi1vehd428pvXXOm4Ob+AyvkyDY91rDXKJyqVd9RLDxXnSMqUoolCeZ2Fhnye
         CJmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wfUgoAUln8fBcjbz3YHFYmmrojTPUio4osfqW5jeNmg=;
        b=ZdHPBpF93csEO8jNUjRtDOQAsVlmE3KJnN4n+DFXtfLxOab3e0Fh11/stL0iTRRgVf
         vAn4A1Yddpe01CVJLrYo+JqIIBAKSVzHNDG9Ku2qjG2gsW+dTqh0APvDO5FjdiCL+ZMy
         sZCQ61moPpaePfDUGD7ZWdu+nTlJ3UhCOKPdq8L0jCdyKRhAI/3ThohlMmylvoZARTyy
         QleRDZGTqWz/HlKi59zo17zPz0wBYIWoWV/Nc8UiyHaRgSrX2o/i8VKplW1bD5tHvmyM
         Q+XPWqlH7y1hcupMg9v/9NeKZMBnqvLn1JFwK+qENITQBTK0P3iyhWKQGT4+BKVjtxDa
         hCIQ==
X-Gm-Message-State: AOAM532MaSJOfgXw0YfZSWcI5jClxYArYPvxegJouufiT95CdPGojAdx
        zzXh/okPTPP1R9Q4+D5J4/t2dQ==
X-Google-Smtp-Source: ABdhPJxI0mBQAyXmrlAhPoC+Yy9uwKKtr5Gi4pz5mJs3ofP3kBUhp66ZoiYwLj0Z+BiuXO7yJq/sWg==
X-Received: by 2002:adf:f4c7:0:b0:203:fb33:332f with SMTP id h7-20020adff4c7000000b00203fb33332fmr34862084wrp.280.1648641532999;
        Wed, 30 Mar 2022 04:58:52 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id l19-20020a05600c4f1300b0038cb924c3d7sm4934725wmq.45.2022.03.30.04.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 04:58:52 -0700 (PDT)
Date:   Wed, 30 Mar 2022 12:58:50 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] virtio-blk: Use blk_validate_block_size() to
 validate block size
Message-ID: <YkRF+rl/d3kyjnWi@google.com>
References: <20220330110107.465728-1-lee.jones@linaro.org>
 <20220330110107.465728-2-lee.jones@linaro.org>
 <YkRDkvAlGAeOeS4t@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YkRDkvAlGAeOeS4t@kroah.com>
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

> On Wed, Mar 30, 2022 at 12:01:07PM +0100, Lee Jones wrote:
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
> > 
> > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > index 4b3645e648ee9..2af9d7c7d45cd 100644
> > --- a/drivers/block/virtio_blk.c
> > +++ b/drivers/block/virtio_blk.c
> > @@ -936,9 +936,17 @@ static int virtblk_probe(struct virtio_device *vdev)
> >  	err = virtio_cread_feature(vdev, VIRTIO_BLK_F_BLK_SIZE,
> >  				   struct virtio_blk_config, blk_size,
> >  				   &blk_size);
> > -	if (!err)
> > +	if (!err) {
> > +		err = blk_validate_block_size(blk_size);
> > +		if (err) {
> > +			dev_err(&vdev->dev,
> > +				"virtio_blk: invalid block size: 0x%x\n",
> > +				blk_size);
> > +			goto out_cleanup_disk;
> > +		}
> > +
> >  		blk_queue_logical_block_size(q, blk_size);
> > -	else
> > +	} else
> >  		blk_size = queue_logical_block_size(q);
> >  
> >  	/* Use topology information if available */
> 
> You didn't build this one either :(
> 
> {sigh}
> 
> Care to start over?

Yes, I think that's a good idea!  :|

</reset>

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
