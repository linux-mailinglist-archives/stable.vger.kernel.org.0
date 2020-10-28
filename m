Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9686B29DE5D
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 01:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731839AbgJ1WTR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:19:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731699AbgJ1WRl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83D5224199;
        Wed, 28 Oct 2020 09:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603877855;
        bh=sl8v2BFNHxcpAXXq1hJ+1ojVtDDnXULzneP2VWqs1K0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R1e5ywetkw4Tmz53gQK9cJarNjZ1NqHPD2Wbhx9G9SHwxyqmqcQ70WDcyii3wOhEc
         7Xd7o1NQMjojiExneY5VQkfBfS2XZYC6P9EtcaZab7Tsi3ByHoDxVkZpCOTgLYA6Di
         r4czooYMju1xPdxwJZxb6tqe27HYnu/4FTAzVcqw=
Date:   Wed, 28 Oct 2020 10:38:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: serial: cyberjack: fix write-URB completion race
Message-ID: <20201028093827.GC1953863@kroah.com>
References: <20201026082548.17970-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026082548.17970-1-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 26, 2020 at 09:25:48AM +0100, Johan Hovold wrote:
> The write-URB busy flag was being cleared before the completion handler
> was done with the URB, something which could lead to corrupt transfers
> due to a racing write request if the URB is resubmitted.
> 
> Fixes: 507ca9bc0476 ("[PATCH] USB: add ability for usb-serial drivers to determine if their write urb is currently being used.")
> Cc: stable <stable@vger.kernel.org>     # 2.6.13
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/usb/serial/cyberjack.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
