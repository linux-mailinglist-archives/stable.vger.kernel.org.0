Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1B4584CED
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 09:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235123AbiG2HtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 03:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235141AbiG2Hsu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 03:48:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D161FCC9;
        Fri, 29 Jul 2022 00:48:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 459D061BA2;
        Fri, 29 Jul 2022 07:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23791C433C1;
        Fri, 29 Jul 2022 07:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659080928;
        bh=I5F1Y/po8lkj1uLMAhaSQTOoxM0phFGL6HARqZ3pz1o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y76aBwmE6XAjF+ZDNOAqF2jCv+varqBhWVkhgjWRpw0btSOzYmPkhbC3cwuRV2Gu4
         vqRoWcsTM+VsyngethuhgnMsUizBoFDnaUqfbr3vq3wyKYmSCKjfAN+detX2zD/Yd/
         gxAmX5JtMcY+JR0N6A9Pzb1b+rPSpUGYcUmOSJEI=
Date:   Fri, 29 Jul 2022 09:48:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zhang Wensheng <zhangwensheng@huaweicloud.com>
Cc:     stable@vger.kernel.org, axboe@kernel.dk, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhangwensheng5@huawei.com,
        yukuai3@huawei.com
Subject: Re: [PATCH 5.10] block: fix null-deref in percpu_ref_put
Message-ID: <YuOQ3mzvtDyQHeLB@kroah.com>
References: <20220729065243.1786222-1-zhangwensheng@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729065243.1786222-1-zhangwensheng@huaweicloud.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 29, 2022 at 02:52:43PM +0800, Zhang Wensheng wrote:
> From: Zhang Wensheng <zhangwensheng5@huawei.com>
> 
> In the use of q_usage_counter of request_queue, blk_cleanup_queue using
> "wait_event(q->mq_freeze_wq, percpu_ref_is_zero(&q->q_usage_counter))"
> to wait q_usage_counter becoming zero. however, if the q_usage_counter
> becoming zero quickly, and percpu_ref_exit will execute and ref->data
> will be freed, maybe another process will cause a null-defef problem
> like below:
> 
> 	CPU0                             CPU1
> blk_cleanup_queue
>  blk_freeze_queue
>   blk_mq_freeze_queue_wait
> 				scsi_end_request
> 				 percpu_ref_get
> 				 ...
> 				 percpu_ref_put
> 				  atomic_long_sub_and_test
>   percpu_ref_exit
>    ref->data -> NULL
>    				   ref->data->release(ref) -> null-deref
> 
> Fix it by setting flag(QUEUE_FLAG_USAGE_COUNT_SYNC) to add synchronization
> mechanism, when ref->data->release is called, the flag will be setted,
> and the "wait_event" in blk_mq_freeze_queue_wait must wait flag becoming
> true as well, which will limit percpu_ref_exit to execute ahead of time.
> 
> Signed-off-by: Zhang Wensheng <zhangwensheng5@huawei.com>
> ---
>  block/blk-core.c       | 4 +++-
>  block/blk-mq.c         | 7 +++++++
>  include/linux/blk-mq.h | 1 +
>  include/linux/blkdev.h | 2 ++
>  4 files changed, 13 insertions(+), 1 deletion(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
