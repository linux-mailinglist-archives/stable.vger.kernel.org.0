Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A2C6A5ED6
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 19:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjB1ShO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 13:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjB1ShN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 13:37:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A2221282;
        Tue, 28 Feb 2023 10:37:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06DFE6118E;
        Tue, 28 Feb 2023 18:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13068C433D2;
        Tue, 28 Feb 2023 18:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677609431;
        bh=/2ELY2OZYoU6WOXq1kS0fZXyn+tWm/ZcDfrOXIJDgRg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WCHgwVcNNRLclKgc6e18ePCpDWuRoICzi5Y/ibXo19Kw6K9yQ+FGjNYHqt0U9817I
         kgJ/DrNhiLt2ZD4cUdiiK4cK4YQTILtzaklgJdF/PlLdNIXaMi0loroltuq18hXvNW
         tvwUup6G52ya53hsBC4OhWdYblbIKFDoXfkFGwAM=
Date:   Tue, 28 Feb 2023 19:37:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hou Tao <houtao@huaweicloud.com>
Cc:     stable@vger.kernel.org, linux-raid@vger.kernel.org,
        David Sloan <david.sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, houtao1@huawei.com
Subject: Re: [PATCH 5.10] md: Flush workqueue md_rdev_misc_wq in md_alloc()
Message-ID: <Y/5J1KXCvSPuJs4C@kroah.com>
References: <20230224065209.3170104-1-houtao@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224065209.3170104-1-houtao@huaweicloud.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 24, 2023 at 02:52:09PM +0800, Hou Tao wrote:
> From: David Sloan <david.sloan@eideticom.com>
> 
> commit 5e8daf906f890560df430d30617c692a794acb73 upstream.
> 
> A race condition still exists when removing and re-creating md devices
> in test cases. However, it is only seen on some setups.
> 
> The race condition was tracked down to a reference still being held
> to the kobject by the rdev in the md_rdev_misc_wq which will be released
> in rdev_delayed_delete().
> 
> md_alloc() waits for previous deletions by waiting on the md_misc_wq,
> but the md_rdev_misc_wq may still be holding a reference to a recently
> removed device.
> 
> To fix this, also flush the md_rdev_misc_wq in md_alloc().
> 
> Signed-off-by: David Sloan <david.sloan@eideticom.com>
> [logang@deltatee.com: rewrote commit message]
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Signed-off-by: Song Liu <song@kernel.org>
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
> Hi Greg,
> 
> We found the problem also exists on v5.10, so could you please pick it up
> for v5.10 ?

Now queued up, thanks.

greg k-h
