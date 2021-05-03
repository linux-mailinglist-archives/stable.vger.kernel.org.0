Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1E6371435
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 13:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbhECLXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 07:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229811AbhECLXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 07:23:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 410D161175;
        Mon,  3 May 2021 11:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620040964;
        bh=ykcRK+jXo5ay6GUs0RS3BJSmv/DKJvnmah0JJ3/98Tk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uOcgNgRZliNhDZu8hFfrZicH4AZgOCIv7ZKM5R6e1Ee5USiQeI4nZ1EetFQ3J+HSO
         2ji76SscbKI/A9R9ILYA7hFL+419qNYmab20QeIHUL0b6+JEDMVbmTPgxxqEulLhBH
         74mWVJc0hkyNIG4JdbZPP12iMVzLNMtToUT3uCM4NMFWvmvwi0nelwh1IE2vcecgW/
         vBb4QRLobzhKkEr+7YDiyEC52gWatMvNKombtqN0nWP0Qr1zFcFIGA11Ha9w8Vk7AV
         AtPy1DZpwNuB19sZeDbiufJWFQuG9gOmHGJHWmFOhcYcbE+CJuAzKuOqp5YD94PlNv
         /qx3VT6TVfrBA==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1ldWf9-00085g-7D; Mon, 03 May 2021 13:22:55 +0200
Date:   Mon, 3 May 2021 13:22:55 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Rocky Liao <rjliao@codeaurora.org>
Subject: Re: [PATCH v2] bluetooth: hci_qca: fix potential GPF
Message-ID: <YI/dDxosAwxtySqx@hovoldconsulting.com>
References: <YI+s2Hms/56Pvatu@hovoldconsulting.com>
 <20210503100605.5223-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210503100605.5223-1-paskripkin@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 03, 2021 at 01:06:05PM +0300, Pavel Skripkin wrote:
> In qca_power_shutdown() qcadev local variable is
> initialized by hu->serdev.dev private data, but
> hu->serdev can be NULL and there is a check for it.
> 
> Since, qcadev is not used before
> 
> 	if (!hu->serdev)
> 		return;
> 
> we can move its initialization after this "if" to
> prevent GPF.
> 
> Fixes: 5559904ccc08 ("Bluetooth: hci_qca: Add QCA Rome power off support to the qca_power_shutdown()")
> Cc: stable@vger.kernel.org # v5.6+
> Cc: Rocky Liao <rjliao@codeaurora.org>
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---

Next time, put a changelog here so we know what changed since earlier
version(s).

Reviewed-by: Johan Hovold <johan@kernel.org>

>  drivers/bluetooth/hci_qca.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
> index de36af63e182..9589ef6c0c26 100644
> --- a/drivers/bluetooth/hci_qca.c
> +++ b/drivers/bluetooth/hci_qca.c
> @@ -1820,8 +1820,6 @@ static void qca_power_shutdown(struct hci_uart *hu)
>  	unsigned long flags;
>  	enum qca_btsoc_type soc_type = qca_soc_type(hu);
>  
> -	qcadev = serdev_device_get_drvdata(hu->serdev);
> -
>  	/* From this point we go into power off state. But serial port is
>  	 * still open, stop queueing the IBS data and flush all the buffered
>  	 * data in skb's.
> @@ -1837,6 +1835,8 @@ static void qca_power_shutdown(struct hci_uart *hu)
>  	if (!hu->serdev)
>  		return;
>  
> +	qcadev = serdev_device_get_drvdata(hu->serdev);
> +
>  	if (qca_is_wcn399x(soc_type)) {
>  		host_set_baudrate(hu, 2400);
>  		qca_send_power_pulse(hu, false);
