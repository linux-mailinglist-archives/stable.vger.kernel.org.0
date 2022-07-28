Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACD0584207
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 16:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbiG1OnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 10:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbiG1Omy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 10:42:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8496BF5;
        Thu, 28 Jul 2022 07:42:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 228E3618DC;
        Thu, 28 Jul 2022 14:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D919C433D6;
        Thu, 28 Jul 2022 14:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659019358;
        bh=jI8jdbqxX5yMhRSyK3vGY9DhXMKI8GbBoEjw971ho4k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uelhHZVx55YqgdQZHzH6UgIKDYs9JcSvvGK9yLPp0qGONpHKL+XRj92XlOGBf9Ljd
         THnj++NmUMLV4j974+/sPTGAkxoBhKNoyf4QiPnKZZy3FrD3KjoV5GkmIoTdBGG84p
         NERCrYxHPXL9bNqEHyrc+Ca9ot/6A8Dy50O2RVU4=
Date:   Thu, 28 Jul 2022 16:42:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     stable@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
        syzbot+4f441e6ca0fcad141421@syzkaller.appspotmail.com,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.10 1/2] block: split bio_kmalloc from bio_alloc_bioset
Message-ID: <YuKgW9BCNl8ChT/v@kroah.com>
References: <20220718211226.506362-1-tadeusz.struk@linaro.org>
 <YtwM3uHugOOdDQZT@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtwM3uHugOOdDQZT@kroah.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 23, 2022 at 04:59:42PM +0200, Greg KH wrote:
> On Mon, Jul 18, 2022 at 02:12:25PM -0700, Tadeusz Struk wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > Upstream commit: 3175199ab0ac ("block: split bio_kmalloc from bio_alloc_bioset")
> > 
> > This is backport to stable 5.10. It fixes an issue reported by syzbot.
> > Link: https://syzkaller.appspot.com/bug?id=a3416231e37024a75f2b95bd95db0d8ce8132a84
> 
> Both now queued up, thanks.

As was just reported, this breaks things all over the place:
	https://lore.kernel.org/r/219030d8-3408-cc9d-7aec-1fb14ab891ce@roeck-us.net

Note, I also had to add lots of fix-up patches on top of these two that
you missed, so odds are there are other fix-ups that I also missed.

Please go and test this again, and submit ALL patches that are needed
after they pass the proper testing and I will be glad to reconsider them
again.

thanks,

greg k-h
