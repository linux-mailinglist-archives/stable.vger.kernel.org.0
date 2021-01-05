Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7038A2EA8BB
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 11:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbhAEKan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 05:30:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:60722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727907AbhAEKan (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 05:30:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A48D22510;
        Tue,  5 Jan 2021 10:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609842602;
        bh=Ve58RhCIGBGeJSrbiHVRwgxeMiy3n8zal5AfaGr+164=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BpgKFnEaCBbN/PyAOhR+vyRdCyhqBM/YwkpUwYo51RT1MahZ1GA7rVBQQ/3Q2dTXm
         MyTjq0UAi1cwR0gjKapPwOAl5qF6cmqfiDO5DagwcO07onBDBeXbIIGavzMxMlhua8
         R3N4I3CpxS654FxOyW7OQdzBfw9jB/oXzDxqIvds=
Date:   Tue, 5 Jan 2021 11:31:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: Re: [PATCH] Revert "mtd: spinand: Fix OOB read"
Message-ID: <X/Q//pErSOfQj/Gd@kroah.com>
References: <20210105101821.47138-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105101821.47138-1-nbd@nbd.name>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 05, 2021 at 11:18:21AM +0100, Felix Fietkau wrote:
> This reverts stable commit baad618d078c857f99cc286ea249e9629159901f.
> 
> This commit is adding lines to spinand_write_to_cache_op, wheras the upstream
> commit 868cbe2a6dcee451bd8f87cbbb2a73cf463b57e5 that this was supposed to
> backport was touching spinand_read_from_cache_op.
> It causes a crash on writing OOB data by attempting to write to read-only
> kernel memory.
> 
> Cc: Miquel Raynal <miquel.raynal@bootlin.com>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  drivers/mtd/nand/spi/core.c | 4 ----
>  1 file changed, 4 deletions(-)

So the backport to 5.10.y broke, but not the backport to 4.19.y or
5.4.y?  Can you provide a "correct" backport for this instead of just
removing this fix?

thanks,

greg k-h
