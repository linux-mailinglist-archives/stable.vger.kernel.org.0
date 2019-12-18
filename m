Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8800912411C
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 09:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbfLRIKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 03:10:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:47752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725797AbfLRIKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 03:10:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CC43218AC;
        Wed, 18 Dec 2019 08:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576656624;
        bh=U/8TqUzAxcIc+qf1l+OtBYMcKlgSCegbO9PGNei3WeI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VKDfzirQOjpeHWk5eF3cWwSWFLR3cL9yGD4gaGtlYPSz8A17HM3uxkm4Mvlabygoi
         CUBl4QJq/nGE9OgZpCANpxnWU2wBFmq2txfaV+f2CFOx3ZaJA9WfaMb3DQyxhocyma
         P2Nwe8dXfis9xyBpoZFv7Ry3ODg38Bj5lP0gDdYo=
Date:   Wed, 18 Dec 2019 09:10:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Punit Agrawal <punit1.agrawal@toshiba.co.jp>
Cc:     linux-serial@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, nobuhiro1.iwamatsu@toshiba.co.jp,
        shrirang.bagul@canonical.com, stable@vger.kernel.org,
        Rob Herring <robh@kernel.org>, Johan Hovold <johan@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] serdev: Don't claim unsupported serial devices
Message-ID: <20191218081022.GA1553073@kroah.com>
References: <20191218065646.817493-1-punit1.agrawal@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218065646.817493-1-punit1.agrawal@toshiba.co.jp>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 18, 2019 at 03:56:46PM +0900, Punit Agrawal wrote:
> Serdev sub-system claims all serial devices that are not already
> enumerated.

All ACPI serial devices, right?  Surely not all other types of serial
devices in the system.

And what do you mean by "not already enumerated"?

> As a result, no device node is created for serial port on
> certain boards such as the Apollo Lake based UP2. This has the
> unintended consequence of not being able to raise the login prompt via
> serial connection.
> 
> Introduce a blacklist to reject devices that should not be treated as

"reject ACPI serial devices"

> a serdev device. Add the Intel HS UART peripheral ids to the blacklist
> to bring back serial port on SoCs carrying them.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Johan Hovold <johan@kernel.org>
> Cc: Hans de Goede <hdegoede@redhat.com>
> ---
> 
> Hi,
> 
> The patch has been updated based on feedback recieved on the RFC[0].
> 
> Please consider merging if there are no objections.
> 
> Thanks,
> Punit
> 
> [0] https://www.spinics.net/lists/linux-serial/msg36646.html
> 
>  drivers/tty/serdev/core.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
> index 226adeec2aed..0d64fb7d4f36 100644
> --- a/drivers/tty/serdev/core.c
> +++ b/drivers/tty/serdev/core.c
> @@ -663,6 +663,12 @@ static acpi_status acpi_serdev_register_device(struct serdev_controller *ctrl,
>  	return AE_OK;
>  }
>  
> +static const struct acpi_device_id serdev_blacklist_devices[] = {

s/serdev_blacklist_devices/serdev_blacklist/acpi_devices/  ?

This is an acpi-specific thing, not a generic tty thing.

thanks,

greg k-h
