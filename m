Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C911F666D
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 13:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgFKLS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 07:18:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727973AbgFKLS3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 07:18:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 879852063A;
        Thu, 11 Jun 2020 11:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591874307;
        bh=u/ZlCVT4Qx9a6DnjKeW8PwPc4At2OeLBS8LztOanwJA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2D9UqhsOgj0plexSgeDKm4ci+JHy67vyEkz1ySN/W6tx09wPGf11LU2vEyxYh0A2x
         wew1hii/5rPGYa2FtNkkNAp5ja1CC/tY9/LfZWuVFwq6GdPPurxw7czLbb00YB+H5i
         Pg9W1PhzbuuKDQf7K2S/4tAF7fQWTpI4PmkN1pLk=
Date:   Thu, 11 Jun 2020 13:18:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Schrempf Frieder <frieder.schrempf@kontron.de>
Cc:     Fabio Estevam <festevam@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH v2] serial: imx: Fix handling of TC irq in combination
 with DMA
Message-ID: <20200611111820.GI3802953@kroah.com>
References: <20200609072259.8259-1-frieder.schrempf@kontron.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200609072259.8259-1-frieder.schrempf@kontron.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 09, 2020 at 07:23:40AM +0000, Schrempf Frieder wrote:
> From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> commit 1866541492641c02874bf51f9d8712b5510f2c64 upstream
> 
> When using RS485 half duplex the Transmitter Complete irq is needed to
> determine the moment when the transmitter can be disabled. When using
> DMA this irq must only be enabled when DMA has completed to transfer all
> data. Otherwise the CPU might busily trigger this irq which is not
> properly handled and so the also pending irq for the DMA transfer cannot
> trigger.
> 
> Cc: <stable@vger.kernel.org> # v4.14.x
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [Backport to v4.14]
> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> ---
> When using RS485 with DMA enabled simply transmitting some data on our
> i.MX6ULL based boards often freezes the system completely. The higher
> the baudrate, the easier it is to reproduce the issue. To test this I
> simply used:
> 
> stty -F /dev/ttymxc1 speed 115200
> while true; do echo TEST > /dev/ttymxc1; done
> 
> Without the patch this leads to an almost immediate system freeze,
> with the patch applied, everything keeps working as expected. 
> ---
>  drivers/tty/serial/imx.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)

Now queued up, thanks.

greg k-h
