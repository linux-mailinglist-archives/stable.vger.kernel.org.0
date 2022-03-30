Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77EA4EC083
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344055AbiC3Lvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344116AbiC3LvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:51:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85925270859
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 04:47:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BF9AB81ACC
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 11:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D086C340F3;
        Wed, 30 Mar 2022 11:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648640872;
        bh=T7eIjfs5MwiG4rwJLyrFBY87R5HkjahJL+UfCY/qMBk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GghkEcSIb2JxybrfQUneOvcmxtNQLf12kGLuMO2E6iakIRZkfCY8BkuljEykOQS3M
         Ll+4remEY993kPZGae4ITlHrMFFM0ivY2gDrURwAEqz0K22T5DFbWsHSPiFQKlb1KC
         Mht4bjB8+rnsshpoZAImeQEXeDF/qGNjeqWLqksk=
Date:   Wed, 30 Mar 2022 13:47:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] virtio-blk: Use blk_validate_block_size() to
 validate block size
Message-ID: <YkRDZvkUjXslh1nW@kroah.com>
References: <20220330105841.464954-1-lee.jones@linaro.org>
 <YkQ4yuX+RGPPm1hV@kroah.com>
 <YkQ58V4+NWgDRZ18@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YkQ58V4+NWgDRZ18@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 12:07:29PM +0100, Lee Jones wrote:
> On Wed, 30 Mar 2022, Greg KH wrote:
> 
> > On Wed, Mar 30, 2022 at 11:58:41AM +0100, Lee Jones wrote:
> > > From: Xie Yongji <xieyongji@bytedance.com>
> > > 
> > > [ Upstream commit 57a13a5b8157d9a8606490aaa1b805bafe6c37e1 ]
> > > 
> > > The block layer can't support a block size larger than
> > > page size yet. And a block size that's too small or
> > > not a power of two won't work either. If a misconfigured
> > > device presents an invalid block size in configuration space,
> > > it will result in the kernel crash something like below:
> > > 
> > > [  506.154324] BUG: kernel NULL pointer dereference, address: 0000000000000008
> > > [  506.160416] RIP: 0010:create_empty_buffers+0x24/0x100
> > > [  506.174302] Call Trace:
> > > [  506.174651]  create_page_buffers+0x4d/0x60
> > > [  506.175207]  block_read_full_page+0x50/0x380
> > > [  506.175798]  ? __mod_lruvec_page_state+0x60/0xa0
> > > [  506.176412]  ? __add_to_page_cache_locked+0x1b2/0x390
> > > [  506.177085]  ? blkdev_direct_IO+0x4a0/0x4a0
> > > [  506.177644]  ? scan_shadow_nodes+0x30/0x30
> > > [  506.178206]  ? lru_cache_add+0x42/0x60
> > > [  506.178716]  do_read_cache_page+0x695/0x740
> > > [  506.179278]  ? read_part_sector+0xe0/0xe0
> > > [  506.179821]  read_part_sector+0x36/0xe0
> > > [  506.180337]  adfspart_check_ICS+0x32/0x320
> > > [  506.180890]  ? snprintf+0x45/0x70
> > > [  506.181350]  ? read_part_sector+0xe0/0xe0
> > > [  506.181906]  bdev_disk_changed+0x229/0x5c0
> > > [  506.182483]  blkdev_get_whole+0x6d/0x90
> > > [  506.183013]  blkdev_get_by_dev+0x122/0x2d0
> > > [  506.183562]  device_add_disk+0x39e/0x3c0
> > > [  506.184472]  virtblk_probe+0x3f8/0x79b [virtio_blk]
> > > [  506.185461]  virtio_dev_probe+0x15e/0x1d0 [virtio]
> > > 
> > > So let's use a block layer helper to validate the block size.
> > > 
> > > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > > Link: https://lore.kernel.org/r/20211026144015.188-5-xieyongji@bytedance.com
> > > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  drivers/block/virtio_blk.c | 12 ++++++++++--
> > >  1 file changed, 10 insertions(+), 2 deletions(-)
> > 
> > What stable tree(s) are you wanting this backported to?
> 
> I knew there was something I'd forgotten to do.
> 
> All of them, but I will save you the work and submit separate series'.
> 
> This one is for linux-5.10.y.

Breaks the build:

drivers/block/virtio_blk.c: In function ‘virtblk_probe’:
drivers/block/virtio_blk.c:834:25: error: label ‘out_cleanup_disk’ used but not defined
  834 |                         goto out_cleanup_disk;
      |                         ^~~~

:(
