Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4AD2A4F4E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 19:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbgKCSs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 13:48:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:51520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgKCSs1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 13:48:27 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 845362074B;
        Tue,  3 Nov 2020 18:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604429307;
        bh=mhnhjXYnoZRjTVV0+BmHHD9GHzPNnQ++V5jc3nsiVgw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nw8/KJ50ac5pXyiV+6vpXfx7qtzyacV1FEI41Ff0mKAJuHD718TmhcplbJVk1DDv3
         G6jZvkh0YZXcdKZnlR/mniyvY4h9hoQ22S3tVAK1IcbV5uVrsxCKaCQqfC7p1nwysI
         iqwwspF1Ri2XTuMLkTE1mF0HvrLrCu51I5rfiMRM=
Date:   Tue, 3 Nov 2020 19:48:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v4.9..v4.19] rtc: rx8010: don't modify the global rtc ops
Message-ID: <20201103184823.GA173459@kroah.com>
References: <20201103172901.18231-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103172901.18231-1-brgl@bgdev.pl>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 06:29:01PM +0100, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> The way the driver is implemented is buggy for the (admittedly unlikely)
> use case where there are two RTCs with one having an interrupt configured
> and the second not. This is caused by the fact that we use a global
> rtc_class_ops struct which we modify depending on whether the irq number
> is present or not.
> 
> Fix it by using two const ops structs with and without alarm operations.
> While at it: not being able to request a configured interrupt is an error
> so don't ignore it and bail out of probe().
> 
> Fixes: ed13d89b08e3 ("rtc: Add Epson RX8010SJ RTC driver")
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/20200914154601.32245-2-brgl@bgdev.pl
> ---
>  drivers/rtc/rtc-rx8010.c | 24 +++++++++++++++++-------
>  1 file changed, 17 insertions(+), 7 deletions(-)

Now queued up, thanks!

greg k-h
