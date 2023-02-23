Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF436A052C
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 10:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbjBWJqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 04:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234125AbjBWJpv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 04:45:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08BF4FC99
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 01:45:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4504561161
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 09:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7184CC4339B;
        Thu, 23 Feb 2023 09:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677145543;
        bh=P+KHmswDCrDL66VsjZyTjoxGkjNmxY1oGuvn/grubzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IR/hu4Ovov/WlGG1SFBumldl54P14Wju/4uJMezuwdpdj4EKE9a65HhTlNngMJslE
         aIIvDMWRnQIkURook4DH+IKTtikr+IEMmBwMUZpjSfB40E9Uoohx+Ib6KuZnbOQPp7
         sq2+wEQhFzdf93ukpiEE1OeBKpR/mbu8kIIFYJuw=
Date:   Thu, 23 Feb 2023 10:45:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     wenyang.linux@foxmail.com
Cc:     Sasha Levin <sashal@kernel.org>,
        Zhang Wensheng <zhangwensheng5@huawei.com>,
        Yu Kuai <yukuai3@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 4/4] nbd: fix possible overflow on 'first_minor' in
 nbd_dev_add()
Message-ID: <Y/c1xfH2kGtXdO3x@kroah.com>
References: <20230220180449.36425-1-wenyang.linux@foxmail.com>
 <tencent_78F37DD503B56650D624427A3CB3879FDB06@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_78F37DD503B56650D624427A3CB3879FDB06@qq.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 21, 2023 at 02:04:49AM +0800, wenyang.linux@foxmail.com wrote:
> From: Zhang Wensheng <zhangwensheng5@huawei.com>
> 
> commit 858f1bf65d3d9c00b5e2d8ca87dc79ed88267c98 upstream.
> 
> When 'index' is a big numbers, it may become negative which forced
> to 'int'. then 'index << part_shift' might overflow to a positive
> value that is not greater than '0xfffff', then sysfs might complains
> about duplicate creation. Because of this, move the 'index' judgment
> to the front will fix it and be better.
> 
> Fixes: b0d9111a2d53 ("nbd: use an idr to keep track of nbd devices")
> Fixes: 940c264984fd ("nbd: fix possible overflow for 'first_minor' in nbd_dev_add()")
> Signed-off-by: Zhang Wensheng <zhangwensheng5@huawei.com>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
> Link: https://lore.kernel.org/r/20220521073749.3146892-6-yukuai3@huawei.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Cc: stable@vger.kernel.org # v5.10+
> Signed-off-by: Wen Yang <wenyang.linux@foxmail.com>
> ---
>  drivers/block/nbd.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)

This is also needed in 5.15.y, please be more careful, you do not want
to have a regression when moving to a newer kernel version.

I've queued it up there as well.

thanks,

greg k-h
