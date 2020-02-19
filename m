Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE6A164321
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 12:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgBSLPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 06:15:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:60436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbgBSLPY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Feb 2020 06:15:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E426F2067D;
        Wed, 19 Feb 2020 11:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582110922;
        bh=AvRb/PmmipD49Co7Ex6q8IW7ShT2DIm81mwAMV5K3Vk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zYg3iJ4Nsu4lS0v5lCBYbeVo3c3VnvtlQBXZrkqILUQz08qlbItCwafIkdGN77Uwt
         541+KEAyYkxvX3GadCpLYKBG9UFMjmv8/4BlvDHmQsEa17cQaJgYViDmhgEp0mHNWg
         CTXu4V4Izi3NZDTk+01HlRSLq26BmYrDCA2fnyok=
Date:   Wed, 19 Feb 2020 12:15:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ronald =?iso-8859-1?Q?Tschal=E4r?= <ronald@innovation.ch>
Cc:     Rob Herring <robh@kernel.org>, Jiri Slaby <jslaby@suse.com>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] serdev: Fix detection of UART devices on Apple machines.
Message-ID: <20200219111519.GB2814125@kroah.com>
References: <20200211194723.486217-1-ronald@innovation.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200211194723.486217-1-ronald@innovation.ch>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 11, 2020 at 11:47:23AM -0800, Ronald Tschalär wrote:
> On Apple devices the _CRS method returns an empty resource template, and
> the resource settings are instead provided by the _DSM method. But
> commit 33364d63c75d6182fa369cea80315cf1bb0ee38e (serdev: Add ACPI
> devices by ResourceSource field) changed the search for serdev devices
> to require valid, non-empty resource template, thereby breaking Apple
> devices and causing bluetooth devices to not be found.
> 
> This expands the check so that if we don't find a valid template, and
> we're on an Apple machine, then just check for the device being an
> immediate child of the controller and having a "baud" property.
> 
> Cc: <stable@vger.kernel.org> # 5.5
> Signed-off-by: Ronald Tschalär <ronald@innovation.ch>
> ---
>  drivers/tty/serdev/core.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
> index ce5309d00280..0f64a10ba51f 100644
> --- a/drivers/tty/serdev/core.c
> +++ b/drivers/tty/serdev/core.c
> @@ -18,6 +18,7 @@
>  #include <linux/sched.h>
>  #include <linux/serdev.h>
>  #include <linux/slab.h>
> +#include <linux/platform_data/x86/apple.h>

Why is this needed?  Just for the x86_apple_machine variable?

Why do we still have platform_data for new systems anymore?  Can't this
go into a much more generic location?  Like as an inline function?

thanks,

greg k-h
