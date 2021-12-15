Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC535475A00
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 14:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhLONyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 08:54:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37196 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbhLONyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 08:54:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6293661880
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 13:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B829C34604;
        Wed, 15 Dec 2021 13:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639576483;
        bh=k64sKItS9WSTcw0mB8fKjMINCqoOTk8F77nBezvogxc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rB78fPwhEcS6B0dXzBJyu6hJ4dn/p3AozAjrl+FVkm9XuSwcyXO0CeeZu2cER/Swt
         XzJua8LXSjOY31EpXeIvfK3W6BB91yf7C6UFcy72GeYwJRhPvzzaekFb6ML5afwOOn
         /amqKuiP79oApgJH4lNAkgGj5BcTYpCSqhuDBF2A=
Date:   Wed, 15 Dec 2021 14:54:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Armin Wolf <W_Armin@gmx.de>
Cc:     pali@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] hwmon: (dell-smm) Fix warning on /proc/i8k creation error
Message-ID: <YbnzoesmSK4ETHho@kroah.com>
References: <20211214210047.33489-1-W_Armin@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214210047.33489-1-W_Armin@gmx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 14, 2021 at 10:00:47PM +0100, Armin Wolf wrote:
> commit dbd3e6eaf3d813939b28e8a66e29d81cdc836445 upstream.
> 
> The removal function is called regardless of whether
> /proc/i8k was created successfully or not, the later
> causing a WARN() on module removal.
> Fix that by only calling the removal function
> if /proc/i8k was created successfully.
> 
> Since the original patch depends on the driver
> registering a platform device, the backported patch
> stores the return value of proc_create() and only
> calls proc_remove_entry() on exit if proc_create()
> was successful.
> 
> Tested on a Inspiron 3505 for kernel 5.10.
> 
> Cc: <stable@vger.kernel.org> # 5.10.x
> Signed-off-by: Armin Wolf <W_Armin@gmx.de>
> ---
>  drivers/hwmon/dell-smm-hwmon.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

All now queued up, thanks.

greg k-h
