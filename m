Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413754D806F
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiCNLOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236122AbiCNLOQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:14:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4775193FC;
        Mon, 14 Mar 2022 04:13:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EE05B80DB2;
        Mon, 14 Mar 2022 11:13:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60781C340EC;
        Mon, 14 Mar 2022 11:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647256382;
        bh=l/hxgotm0hSGY59mDBqokaTQVQapfKciLxrWRyysYwQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cl6/l06IGfQAreUkW/QBqaU+oDXAYZAX8lxdnuA0LdHjUM7JXEa6Tr21++Xflx080
         ks+xW7B5lb3bG//mKfI+YWQIiai0ycu5BF3uIVhiB1G2FVA5rmr1Zma+3PeO6WGiTu
         NN73lPTuQJ78nSmkYlwJBf5YYNamUOoY2drb7PnM=
Date:   Mon, 14 Mar 2022 12:12:59 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Valentin Kleibel <valentin@vrvis.at>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Justin Sanders <justin@coraid.com>, linux-block@vger.kernel.org
Subject: Re: [PATCH] block: aoe: fix page fault in freedev()
Message-ID: <Yi8jO3Q+xbPx0JwF@kroah.com>
References: <c274db07-9c7d-d857-33ad-4a762819bcdd@vrvis.at>
 <YinpIKY0HVlJ+TLR@kroah.com>
 <50ddedf1-5ac3-91c3-0b50-645ceb541071@vrvis.at>
 <YinufgnQtSeTA18w@kroah.com>
 <9dd4a25a-7deb-fcdf-0c05-d37d4c894d86@vrvis.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9dd4a25a-7deb-fcdf-0c05-d37d4c894d86@vrvis.at>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 01:55:25PM +0100, Valentin Kleibel wrote:
> On 10/03/2022 13:26, Greg Kroah-Hartman wrote:
> > On Thu, Mar 10, 2022 at 01:24:38PM +0100, Valentin Kleibel wrote:
> > > On 10/03/2022 13:03, Greg Kroah-Hartman wrote:
> > > > > This patch applies to kernels 5.4 and 5.10.
> > > > 
> > > > We need a fix for Linus's tree first before we can backport anything to
> > > > older kernels.  Does this also work there?
> > > 
> > > It is fixed in Linus' tree starting with 5.14.
> > 
> > What commit fixes it there?  Why not just backport that one only?
> 
> commit 6560ec961a08 (aoe: use blk_mq_alloc_disk and blk_cleanup_disk)
> This commit uses the function blk_cleanup_disk() in freedev() in
> drivers/block/aoe/aoedev.c which fixes the issue.
> The function was introduced in f525464a8000 (block: add blk_alloc_disk and
> blk_cleanup_disk APIs):
> void blk_cleanup_disk(struct gendisk *disk)
> {
> 	blk_cleanup_queue(disk->queue);
> 	put_disk(disk);
> }
> EXPORT_SYMBOL(blk_cleanup_disk);
> 
> I tried to backport the fix to the lts kernels without introducing a new API
> by just adjusting the order of the two function calls.
> Is it preferable to introduce and use the function blk_cleanup_disk()?

I do not know, sorry.  But we prefer the upstream commits as much as
possible as one-off changes like this are almost always buggy and wrong
in the end.

Try doing the backports and see what that looks like please.

thanks,

greg k-h
