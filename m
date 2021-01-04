Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D682E93B4
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 11:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbhADKvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 05:51:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726737AbhADKvj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 05:51:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D12A22211;
        Mon,  4 Jan 2021 10:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609757458;
        bh=TcgRaa1ZLaRJ30cuhsBRpxP+My/U4/3cTwgOq33NOCY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b9IZtiIAQAnhj+oHHZAznT+csvF1pd7+3kx+5b4Y7dfAc8auzQiotzymLbys2jKsZ
         58f+R2xdIAzfVjDrfPORC3lBjSZea81/98FSA7pYRL9QCyj1KEaafxJDd/kfxYp5qm
         YiEXGCYFvoc3vh8oIGOwcgRmsLZfaeGf4AZZvCFA=
Date:   Mon, 4 Jan 2021 11:52:24 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "hch@lst.de" <hch@lst.de>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Naohiro Aota <Naohiro.Aota@wdc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] null_blk: Fix zone size initialization"
 failed to apply to 4.19-stable tree
Message-ID: <X/LzaLYN3k0JFJw3@kroah.com>
References: <160915617556175@kroah.com>
 <02237e37253bfffdc9f88dd72a7eccaf301a5b02.camel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <02237e37253bfffdc9f88dd72a7eccaf301a5b02.camel@wdc.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 06:14:41AM +0000, Damien Le Moal wrote:
> On Mon, 2020-12-28 at 12:49 +0100, gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hi Greg,
> 
> I sent a backported patch for 4.19-stable in reply to your email. The backport
> is identical to the one I sent separately for the 5.4-stable tree.

It breaks the build:

drivers/block/null_blk_zoned.c: In function ‘null_zone_init’:
drivers/block/null_blk_zoned.c:5:42: error: ‘SZ_1M’ undeclared (first use in this function)
    5 | #define MB_TO_SECTS(mb) (((sector_t)mb * SZ_1M) >> SECTOR_SHIFT)
      |                                          ^~~~~
drivers/block/null_blk_zoned.c:27:23: note: in expansion of macro ‘MB_TO_SECTS’
   27 |  dev_capacity_sects = MB_TO_SECTS(dev->size);
      |                       ^~~~~~~~~~~
drivers/block/null_blk_zoned.c:5:42: note: each undeclared identifier is reported only once for each function it appears in
    5 | #define MB_TO_SECTS(mb) (((sector_t)mb * SZ_1M) >> SECTOR_SHIFT)
      |                                          ^~~~~
drivers/block/null_blk_zoned.c:27:23: note: in expansion of macro ‘MB_TO_SECTS’
   27 |  dev_capacity_sects = MB_TO_SECTS(dev->size);
      |                       ^~~~~~~~~~~

:(

