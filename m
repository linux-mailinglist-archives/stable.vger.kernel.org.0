Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A37471A5B
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 14:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhLLNTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 08:19:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37554 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhLLNTS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 08:19:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3707EB80CA9
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 13:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE1CC341C5;
        Sun, 12 Dec 2021 13:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639315156;
        bh=Xx8xHH19iIcSzjQk5+6UIGK3QKkZ90ALbpOWb0yVgmY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LKnppm1f9ZIz22F8DW/daqnBBk1u6bY950Rb8XbppRwCGOOIjODNpXpHYNGXVOxvV
         VqmtL6CuYRp9smv+3zLLbcIok6ICpuufaf66d2XGfChGf5rMxT3txeDQ/EcCLfzjLu
         o34XAteZ14knqat+vWGYLPKqpCr50kCQz6RTLwcw=
Date:   Sun, 12 Dec 2021 14:19:12 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     stable@vger.kernel.org,
        Brian Silverman <brian.silverman@bluerivertech.com>
Subject: Re: [PATCH] can: m_can: Disable and ignore ELO interrupt
Message-ID: <YbX20AXH1F0qb4uO@kroah.com>
References: <20211211213011.813419-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211211213011.813419-1-mkl@pengutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 11, 2021 at 10:30:11PM +0100, Marc Kleine-Budde wrote:
> From: Brian Silverman <brian.silverman@bluerivertech.com>
> 
> Commit f58ac1adc76b5beda43c64ef359056077df4d93a upstream.
> 
> With the design of this driver, this condition is often triggered.
> However, the counter that this interrupt indicates an overflow is never
> read either, so overflowing is harmless.
> 
> On my system, when a CAN bus starts flapping up and down, this locks up
> the whole system with lots of interrupts and printks.
> 
> Specifically, this interrupt indicates the CEL field of ECR has
> overflowed. All reads of ECR mask out CEL.
> 
> Fixes: e0d1f4816f2a ("can: m_can: add Bosch M_CAN controller support")
> Link: https://lore.kernel.org/all/20211129222628.7490-1-brian.silverman@bluerivertech.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Brian Silverman <brian.silverman@bluerivertech.com>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
> Hey Greg,
> 
> this is
> | f58ac1adc76b ("can: m_can: Disable and ignore ELO interrupt")
> checrry picked onto v5.10. The patch applied without any problems,
> won't know why it didn't work in your side.

This worked, thanks.

Can I get a working backport for 4.4.y and 4.9.y as well?

thanks,

greg k-h
