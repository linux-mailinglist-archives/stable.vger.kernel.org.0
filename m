Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D09630C66
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 07:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbiKSGVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Nov 2022 01:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbiKSGVI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Nov 2022 01:21:08 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BCF7FC18;
        Fri, 18 Nov 2022 22:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=G3xskPM8jfoABNGxzLyHhOV5euslpnXfadNrBV38bOM=; b=vgTPs9MPdLO/2sOYbSYE5NT2xV
        4dUrBIno+9FrSsJivU8/Z452+TVMrCOLZmmYWocPEobawvvMX51y6gXmU1Ndoo4wVJnotdpEfG7eD
        9poYwjXUKNoWLaUSzj3wLTMwCMDSj/w9Y97BNjJi6s6AKvDR7DRnKO0n0iuZ9qSbML8qgpJf3nRfa
        A4baTIPsjgIVkZlRXaSwXz9j6FEl0POcxD+BfiVPFQdaYDAI5RRIPrd5RfRVNwaRoO71UsgV166CF
        7YhWe0E77ZbfAaSX3mkOEFiCoYqHKHG5xEbf1rW3ovVY4GSd5JnGTY5bXaqtVStFYk+Bh4Fpm29W/
        /pWdPIXA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1owHDz-0031wA-Es; Sat, 19 Nov 2022 06:21:11 +0000
Date:   Sat, 19 Nov 2022 06:21:11 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Jorropo <jorropo.pgm@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        nborisov@suse.com, regressions@lists.linux.dev,
        stable@vger.kernel.org
Subject: Re: [REGRESSION] XArray commit prevents booting with 6.0-rc1 or later
Message-ID: <Y3h118oIDsvclZHM@casper.infradead.org>
References: <CAHWihb_EYWKXOqdN0iDBDygk+EGbhaxWHTKVRhtpm_TihbCjtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHWihb_EYWKXOqdN0iDBDygk+EGbhaxWHTKVRhtpm_TihbCjtw@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 19, 2022 at 05:07:45AM +0100, Jorropo wrote:
> #regzbot introduced v5.19-rc6..1dd685c414a7b9fdb3d23aca3aedae84f0b998ae
> 
> Hi, I recently tried to upgrade to linux v6.0.x but when trying to
> boot it fails with "error: out of memory" when or after loading
> initramfs (which then kpanics because the vfs root is missing).
> The latest releases I tested are v6.0.9 and v6.1-rc5 and it's broken there too.
> 
> I bisected the error to this patch:
> 1dd685c414a7b9fdb3d23aca3aedae84f0b998ae "XArray: Add calls to
> might_alloc()" is the first bad commit.
> I've confirmed this is not a side effect of a poor bitsect because
> 1dd685c414a7b9fdb3d23aca3aedae84f0b998ae~1 (v5.19-rc6) works.

That makes no sense.  I can't look into this until Wednesday, but I
suggest that what you have is an intermittent failure to boot, and
the bisect has led you down the wrong path.

> I've tried reverting the failing commit on top of v6.0.9 and it didn't fixed it.
> 
> My system is:
> CPU: Ryzen 3600
> Motherboard: B550 AORUS ELITE V2
> Ram: 48GB (16+32) of unmatched DDR4
> GPU: AMD rx580
> Various ssds, hdds and network cards plugged with various buses.
> 
> You can find a folder with my .config, bisect logs and screenshots of
> the error messages there:
> https://jorropo.net/ipfs/QmaWH84UPEen4E9n69KZiLjPDaTi2aJvizv3JYiL7Gfmnr/
> https://ipfs.io/ipfs/QmaWH84UPEen4E9n69KZiLjPDaTi2aJvizv3JYiL7Gfmnr/
> 
> I'll be happy to assist you if you need help reproducing this issue
> and or testing fixes.
> 
> Thx, Jorropo
