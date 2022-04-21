Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 945E0509D08
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 12:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388037AbiDUKFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 06:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388027AbiDUKFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 06:05:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF62E275E5
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 03:02:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DC8160F6C
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 10:02:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E62C385A1;
        Thu, 21 Apr 2022 10:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650535348;
        bh=bNMqQNF4JfMQceFCtfB5uMbS30GaEWYypjbvC4BRMFo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yTbTlgZVtz0BIRvozBs6rPapuM5l249wgTUJhC8QWiutcWGgKN9cQHq3WDGziPCNA
         rULY1v7GJXeyJCe+aUtChUTvgalb1cGUy2CDLPh6vAa7Idx6ospcAyF4VmnpWdCAwY
         Y249vldMmQR+ibAkPHvZPrs+Ys8HzSkDHGELs9+Y=
Date:   Thu, 21 Apr 2022 12:02:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Khazhismel Kumykov <khazhy@google.com>
Cc:     stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block/compat_ioctl: fix range check in BLKGETSIZE
Message-ID: <YmErsSY45MQu/Ks4@kroah.com>
References: <20220419191239.588421-1-khazhy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419191239.588421-1-khazhy@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 19, 2022 at 12:12:39PM -0700, Khazhismel Kumykov wrote:
> [ Upstream commit ccf16413e520164eb718cf8b22a30438da80ff23 ]
> 
> kernel ulong and compat_ulong_t may not be same width. Use type directly
> to eliminate mismatches.
> 
> This would result in truncation rather than EFBIG for 32bit mode for
> large disks.
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> Link: https://lore.kernel.org/r/20220414224056.2875681-1-khazhy@google.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> [compat_ioctl is it's own file in 5.4-stable and earlier]
> ---
> 
> The original commit should apply to the newer stables

It does not, it only applied to 5.17.y.

Please provide working backports for all of the others.

> this should apply
> to all the older stables.

I'll wait for the 5.10.y and 5.15.y backport first before applying this
one.

thanks,

greg k-h
