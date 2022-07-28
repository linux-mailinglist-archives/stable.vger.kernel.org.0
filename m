Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C16584280
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 17:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiG1PBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 11:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbiG1PAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 11:00:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B40220E6;
        Thu, 28 Jul 2022 08:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E0D16CE25DA;
        Thu, 28 Jul 2022 15:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F19C433C1;
        Thu, 28 Jul 2022 15:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659020418;
        bh=3Bv7PBO7tYcJ2FdBrpLgWT13ggXJXcmgaj13OSwoHsE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EwvcqV+5j2b7nJ8R2vIwLIDvJ/AFENHwyXGVdOr7g3pyPNWuLrdXr8b0nfM1VDJXQ
         RHV0nemUlxCBsTVN5G1i1x66Xg42GYsM09eOdUoey5lVPzkvHdbk2GNkRkwwgeey9P
         MuEhRRRflO3qnEXJzm/17GHrlmAwBWIZKtmQom4A=
Date:   Thu, 28 Jul 2022 17:00:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>, stable@vger.kernel.org,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        syzbot+4f441e6ca0fcad141421@syzkaller.appspotmail.com,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.10 1/2] block: split bio_kmalloc from bio_alloc_bioset
Message-ID: <YuKkgPx2XF6rQnLq@kroah.com>
References: <20220718211226.506362-1-tadeusz.struk@linaro.org>
 <YtwM3uHugOOdDQZT@kroah.com>
 <YuKgW9BCNl8ChT/v@kroah.com>
 <20220728144520.GA18285@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728144520.GA18285@lst.de>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 28, 2022 at 04:45:20PM +0200, Christoph Hellwig wrote:
> On Thu, Jul 28, 2022 at 04:42:35PM +0200, Greg KH wrote:
> > > > Link: https://syzkaller.appspot.com/bug?id=a3416231e37024a75f2b95bd95db0d8ce8132a84
> > > 
> > > Both now queued up, thanks.
> > 
> > As was just reported, this breaks things all over the place:
> > 	https://lore.kernel.org/r/219030d8-3408-cc9d-7aec-1fb14ab891ce@roeck-us.net
> > 
> > Note, I also had to add lots of fix-up patches on top of these two that
> > you missed, so odds are there are other fix-ups that I also missed.
> > 
> > Please go and test this again, and submit ALL patches that are needed
> > after they pass the proper testing and I will be glad to reconsider them
> > again.
> 
> Why did this even get backported?  It was a cleanup that required a lot
> of prep work, and should not by itself fix anything.

Looks like syzkaller is reporting something odd...

Tadeusz, how was this tested?

thanks,

greg k-h
