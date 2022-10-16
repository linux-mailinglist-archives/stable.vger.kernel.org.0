Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7F05FFEC0
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 12:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiJPKxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 06:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiJPKxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 06:53:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863812DA81
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 03:53:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EAACB80B48
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 10:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE9FC433D7;
        Sun, 16 Oct 2022 10:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665917597;
        bh=k4j31yZChgfHAKzWArd240uw2UmEmXgnqKjanDtaeEs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zzpbXyA6pfTzuXJ3fhqCYjLtAete0lvkaI3vSnC4isHy77s1xmZyLF/rkBMFNbm5H
         ktDyNHnLSBr5UcESMfuxp+2PNsrkZm0djgyE5+T4FrWOiPHoZYfZXlkKE3xkmu1ZrA
         UD8UPTQD9+G+NS0qqjIaoBxhLPUBgEV4cA7QLLrc=
Date:   Sun, 16 Oct 2022 12:53:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Khazhismel Kumykov <khazhy@chromium.org>
Cc:     stable@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Khazhismel Kumykov <khazhy@google.com>
Subject: Re: [PATCH v5.10] block: fix inflight statistics of part0
Message-ID: <Y0viuMAaGVdR3hTW@kroah.com>
References: <20221013215603.2841286-1-khazhy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221013215603.2841286-1-khazhy@google.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 02:56:03PM -0700, Khazhismel Kumykov wrote:
> From: Jeffle Xu <jefflexu@linux.alibaba.com>
> 
> [ Upstream commit b0d97557ebfc9d5ba5f2939339a9fdd267abafeb ]
> 
> The inflight of partition 0 doesn't include inflight IOs to all
> sub-partitions, since currently mq calculates inflight of specific
> partition by simply camparing the value of the partition pointer.
> 
> Thus the following case is possible:
> 
> $ cat /sys/block/vda/inflight
>        0        0
> $ cat /sys/block/vda/vda1/inflight
>        0      128
> 
> While single queue device (on a previous version, e.g. v3.10) has no
> this issue:
> 
> $cat /sys/block/sda/sda3/inflight
>        0       33
> $cat /sys/block/sda/inflight
>        0       33
> 
> Partition 0 should be specially handled since it represents the whole
> disk. This issue is introduced since commit bf0ddaba65dd ("blk-mq: fix
> sysfs inflight counter").
> 
> Besides, this patch can also fix the inflight statistics of part 0 in
> /proc/diskstats. Before this patch, the inflight statistics of part 0
> doesn't include that of sub partitions. (I have marked the 'inflight'
> field with asterisk.)
> 
> $cat /proc/diskstats
>  259       0 nvme0n1 45974469 0 367814768 6445794 1 0 1 0 *0* 111062 6445794 0 0 0 0 0 0
>  259       2 nvme0n1p1 45974058 0 367797952 6445727 0 0 0 0 *33* 111001 6445727 0 0 0 0 0 0
> 
> This is introduced since commit f299b7c7a9de ("blk-mq: provide internal
> in-flight variant").
> 
> Fixes: bf0ddaba65dd ("blk-mq: fix sysfs inflight counter")
> Fixes: f299b7c7a9de ("blk-mq: provide internal in-flight variant")
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> [axboe: adapt for 5.11 partition change]
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> [khazhy: adapt for 5.10 partition]
> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
> ---
>  block/blk-mq.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Now queued up, thanks.

greg k-h
