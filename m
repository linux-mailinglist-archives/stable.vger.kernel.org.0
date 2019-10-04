Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5D2ACBB75
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 15:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388217AbfJDNRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 09:17:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388149AbfJDNRA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 09:17:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBF8D215EA;
        Fri,  4 Oct 2019 13:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570195019;
        bh=JhC4q3xQd1BuHOAbskODkPKUuTj7CTnwNuwebrzeljI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GnefFeSdOLNAo25NzwCIS2oDkpTO5ngijHOLf6DtdkxA6RLo//Ab/4PS3f14/JcMK
         /1pmZ3dS8n/GuoZlyAL03kcZllwSmcwIMya6GMsvw8FDoMBfD8TqH8keYW4u4xKN87
         FcZwl01OScs31EXVQExe76jyycGeanL53X+i9vJg=
Date:   Fri, 4 Oct 2019 15:16:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tomas Winkler <tomas.winkler@intel.com>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: [char-misc for v4.5-rc2 2/2] mei: avoid FW version request on
 Ibex Peak and earlier
Message-ID: <20191004131656.GA703365@kroah.com>
References: <20191001235958.19979-1-tomas.winkler@intel.com>
 <20191001235958.19979-2-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191001235958.19979-2-tomas.winkler@intel.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 02, 2019 at 02:59:58AM +0300, Tomas Winkler wrote:
> From: Alexander Usyskin <alexander.usyskin@intel.com>
> 
> The fixed MKHI client on PCH 6 gen platforms
> does not support fw version retrieval.
> The error is not fatal, but it fills up the kernel logs and
> slows down the driver start.
> This patch disables requesting FW version on GEN6 and earlier platforms.
> 
> Fixes warning:
> [   15.964298] mei mei::55213584-9a29-4916-badf-0fb7ed682aeb:01: Could not read FW version
> [   15.964301] mei mei::55213584-9a29-4916-badf-0fb7ed682aeb:01: version command failed -5
> 
> Cc: <stable@vger.kernel.org> +v4.18
> Cc: Paul Menzel <pmenzel@molgen.mpg.de>
> Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/misc/mei/bus-fixup.c | 16 +++++++++++++---
>  drivers/misc/mei/hw-me.c     | 21 ++++++++++++++++++---
>  drivers/misc/mei/hw-me.h     |  8 ++++++--
>  drivers/misc/mei/mei_dev.h   |  4 ++++
>  drivers/misc/mei/pci-me.c    | 10 +++++-----
>  5 files changed, 46 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/misc/mei/bus-fixup.c b/drivers/misc/mei/bus-fixup.c
> index 32e9b1aed2ca..5ac679ac9b19 100644
> --- a/drivers/misc/mei/bus-fixup.c
> +++ b/drivers/misc/mei/bus-fixup.c
> @@ -218,13 +218,23 @@ static void mei_mkhi_fix(struct mei_cl_device *cldev)
>  {
>  	int ret;
>  
> +	dev_dbg(&cldev->dev, "running hook %s\n", __func__);

That is what ftrace is for, don't sprinkle that all over the kernel for
no reason :(

thanks,

greg k-h
