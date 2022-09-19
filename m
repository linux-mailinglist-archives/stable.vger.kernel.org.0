Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4094B5BD3D4
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 19:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiISRfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 13:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbiISRfW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 13:35:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B9B32D93;
        Mon, 19 Sep 2022 10:35:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4036461C2C;
        Mon, 19 Sep 2022 17:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6AE3C433C1;
        Mon, 19 Sep 2022 17:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663608912;
        bh=Qn6lr5IB3mFwwVXJMM+ZIl3PLXb1MwJ4yPUQA0hFbmM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M8/FKIAiuBZAp10nMBMVg2zTLKneDQZrw9lgelOHFRDdgy732FgfhrjZKhcwdyYA1
         G/TCJjptG4/uYRAt0oauQE7zpHbC0LZvAz0aPx/23soZNCQf5KBA0+AXak/laXnrZP
         fa7Z2Rnqn9lAV0tS+HvIYF/8bTSxG+RpbYn3JVn6refrGDAlbxN1bIzsFQktiUSA4g
         tb1RwHs0TnnxJrkofLCFP9R4cZMaC+DTwAugizfGt4Wn/O205zFQx+lF0ny+oBSH0W
         4zPLeP87aa3Z3g1iSJUVP3DqybE1JxvgtVvCUaLIAZi27VfxLO3dIhlCh/RRuNATHv
         jmdtOKdwUS75A==
Date:   Mon, 19 Sep 2022 11:35:09 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Mohamed Khalfella <mkhalfella@purestorage.com>
Cc:     stable@vger.kernel.org, Eric Badger <ebadger@purestorage.com>,
        Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Tao Chiu <taochiu@synology.com>,
        Leon Chien <leonchien@synology.com>,
        Cody Wong <codywong@synology.com>,
        "open list:NVM EXPRESS DRIVER" <linux-nvme@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nvme-pci: Make sure to ring doorbell when last request
 is short-circuited
Message-ID: <YyioTUV/Td+yf0Z6@kbusch-mbp>
References: <20220918054816.936669-1-mkhalfella@purestorage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220918054816.936669-1-mkhalfella@purestorage.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 18, 2022 at 05:48:16AM +0000, Mohamed Khalfella wrote:
> When processing a batch of requests, it is possible that nvme_queue_rq()
> misses to ring nvme queue doorbell if the last request fails because the
> controller is not ready. As a result of that, previously queued requests
> will timeout because the device had not chance to know about the commands
> existence. This failure can cause nvme controller reset to timeout if
> there was another App using adminq while nvme reset was taking place.
> 
> Consider this case:
> - App is hammering adminq with NVME_ADMIN_IDENTIFY commands
> - Controller reset triggered by "echo 1 > /sys/.../nvme0/reset_controller"
> 
> nvme_reset_ctrl() will change controller state to NVME_CTRL_RESETTING.
> From that point on all requests from App will be forced to fail because
> the controller is no longer ready. More importantly these requests will
> not make it to adminq and will be short-circuited in nvme_queue_rq().
> Unlike App requests, requests issued by reset code path will be allowed
> to go through adminq in order to carry out the reset process. The problem
> happens when blk-mq decides to mix requests from reset code path and App
> in one batch, in particular when the last request in such batch happens
> to be from App.
> 
> In this case the last request will have bd->last set to true telling the
> driver to ring doorbell after queuing this request. However, since the
> controller is not ready, this App request will be completed without going
> through adminq, and nvme_queue_rq() will miss the opportunity to ring
> adminq doorbell leaving earlier queued requests unknown to the device.
> 
> Fixes: d4060d2be1132 ("nvme-pci: fix controller reset hang when racing with nvme_timeout")

I revisted that commit, and it doesn't sound correct. Specifically this part:

    5) reset_work() continues to setup_io_queues() as it observes no error
       in init_identify(). However, the admin queue has already been
       quiesced in dev_disable(). Thus, any following commands would be
       blocked forever in blk_execute_rq().

When a timeout occurs in the CONNECTING state, the timeout handler unquiesces
the queue specifically to flush out any blocked requests. Is that commit really
necessary? I'd rather just revert it to save the extra per-IO checks if not.
