Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAE240B68A
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 20:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbhINSKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 14:10:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230008AbhINSKY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 14:10:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 291C5610A6;
        Tue, 14 Sep 2021 18:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631642946;
        bh=BryRExVRKCqOA/tX555f+e42Bm/gyRNTNA9l2npvr8A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m51NhrNm21hXcfh67w6h1CFHXHdycub+QjfX2+kknq4BjYeZYqvtsdLanQ8Tn3nHt
         DgEF1gNTngI0aQ0wacCnmSDtCCQ1a+GQ0RriiYR/J292pqqMK2ClGP9vkrJVTehytb
         a0m396IaFRaGaZudIo3pGN4yJ+6QcNyUCgD9Sn2c=
Date:   Tue, 14 Sep 2021 20:09:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: ppc crashes in v4.14.y-queue and v4.19.y-queue
Message-ID: <YUDlQAGwVCDJgylW@kroah.com>
References: <87cbd9ce-161e-7c15-fbf4-66abd2540bed@roeck-us.net>
 <YUDKnfT6RJJDXs94@kroah.com>
 <20210914180307.GA567043@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210914180307.GA567043@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 14, 2021 at 11:03:07AM -0700, Guenter Roeck wrote:
> On Tue, Sep 14, 2021 at 06:15:25PM +0200, Greg Kroah-Hartman wrote:
> > On Tue, Sep 14, 2021 at 09:03:38AM -0700, Guenter Roeck wrote:
> > > Hi,
> > > 
> > > I see the following crashes in v4.14.y-queue and v4.19.y-queue.
> > > Please let me know if I need to bisect.
> > > 
> [ ... ]
> 
> > 
> > Bisection would be great to track this down if at all possible.
> > 
> Attached. Reverting the offending patch fixes the problem in both v4.14.y-queue
> and v4.19.y-queue.
> 
> Guenter
> 
> ---
> # bad: [d73a5c7790019b70d9454ee9797c223198ad8ff0] Linux 4.14.247-rc1
> # good: [f96eb53cbd76415edfba99c2cfa88567a885a428] Linux 4.14.246
> git bisect start 'HEAD' 'v4.14.246'
> # bad: [33a419b7cde2a3b8a0932319b6d54914717797f0] block: nbd: add sanity check for first_minor
> git bisect bad 33a419b7cde2a3b8a0932319b6d54914717797f0
> # good: [69f55eceb19466d9b20f926dbd16a4a0ad22ddbb] Revert "btrfs: compression: don't try to compress if we don't have enough pages"
> git bisect good 69f55eceb19466d9b20f926dbd16a4a0ad22ddbb
> # good: [f749b828e2bd070a33c3e8a1eda0e5e2de15ae81] power: supply: max17042_battery: fix typo in MAx17042_TOFF
> git bisect good f749b828e2bd070a33c3e8a1eda0e5e2de15ae81
> # good: [adccd339c64fbcd7098cf58a57acc3b7db3488d5] crypto: qat - fix naming for init/shutdown VF to PF notifications
> git bisect good adccd339c64fbcd7098cf58a57acc3b7db3488d5
> # good: [fe223807816e23234dc25460fabbe8957fec14e4] m68k: emu: Fix invalid free in nfeth_cleanup()
> git bisect good fe223807816e23234dc25460fabbe8957fec14e4
> # good: [17c695dab8970f9c7396bb7ccb25cc204b685f0b] spi: spi-pic32: Fix issue with uninitialized dma_slave_config
> git bisect good 17c695dab8970f9c7396bb7ccb25cc204b685f0b
> # good: [e2ff046bc5c21120d29085f33d3c56e3cf024ec3] clocksource/drivers/sh_cmt: Fix wrong setting if don't request IRQ for clock source channel
> git bisect good e2ff046bc5c21120d29085f33d3c56e3cf024ec3
> # first bad commit: [33a419b7cde2a3b8a0932319b6d54914717797f0] block: nbd: add sanity check for first_minor

Odd, but thanks for letting me know, I'll go drop this patch from 4.14.y
and 4.19.y queues.

greg k-h
