Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE05343B437
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 16:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbhJZOey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 10:34:54 -0400
Received: from smtp120.ord1c.emailsrvr.com ([108.166.43.120]:33882 "EHLO
        smtp120.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234446AbhJZOey (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 10:34:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1635258750;
        bh=kyHbTTBR89/y1zbVw4a8imERHnNxgrB7fX9rUfytHHs=;
        h=Subject:To:From:Date:From;
        b=HioLFGLnR10LHJ7VdGfLvfFKk5YG1eOhpvWE6TKCjgUK/6qzBthXJcMm11HwnFike
         NmopkcjSPIqs9XOFNRYlU1lBwcQEBBC1yx3xxrrqvEGzOaPYni1yipqQ88Qtb7QHuE
         MtyMIxALsSqSUcSRh3hWljty5Jo4W6c6v9aGpME4=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp24.relay.ord1c.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 3562A60196;
        Tue, 26 Oct 2021 10:32:29 -0400 (EDT)
Subject: Re: [PATCH 3/5] comedi: vmk80xx: fix transfer-buffer overflows
To:     Johan Hovold <johan@kernel.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20211025114532.4599-1-johan@kernel.org>
 <20211025114532.4599-4-johan@kernel.org>
From:   Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd.
Message-ID: <e750ac3f-af11-7950-2619-9fedebf2fb11@mev.co.uk>
Date:   Tue, 26 Oct 2021 15:32:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211025114532.4599-4-johan@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Classification-ID: ae72fbfa-5e41-4d86-8fff-d3f3be659ee3-1-1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/10/2021 12:45, Johan Hovold wrote:
> The driver uses endpoint-sized USB transfer buffers but up until
> recently had no sanity checks on the sizes.
> 
> Commit e1f13c879a7c ("staging: comedi: check validity of wMaxPacketSize
> of usb endpoints found") inadvertently fixed NULL-pointer dereferences
> when accessing the transfer buffers in case a malicious device has a
> zero wMaxPacketSize.
> 
> Make sure to allocate buffers large enough to handle also the other
> accesses that are done without a size check (e.g. byte 18 in
> vmk80xx_cnt_insn_read() for the VMK8061_MODEL) to avoid writing beyond
> the buffers, for example, when doing descriptor fuzzing.
> 
> The original driver was for a low-speed device with 8-byte buffers.
> Support was later added for a device that uses bulk transfers and is
> presumably a full-speed device with a maximum 64-byte wMaxPacketSize.
> 
> Fixes: 985cafccbf9b ("Staging: Comedi: vmk80xx: Add k8061 support")
> Cc: stable@vger.kernel.org      # 2.6.31
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>   drivers/comedi/drivers/vmk80xx.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/comedi/drivers/vmk80xx.c b/drivers/comedi/drivers/vmk80xx.c
> index 9f920819cd74..f2c1572d0cd7 100644
> --- a/drivers/comedi/drivers/vmk80xx.c
> +++ b/drivers/comedi/drivers/vmk80xx.c
> @@ -90,6 +90,8 @@ enum {
>   #define IC3_VERSION		BIT(0)
>   #define IC6_VERSION		BIT(1)
>   
> +#define MIN_BUF_SIZE		64
> +
>   enum vmk80xx_model {
>   	VMK8055_MODEL,
>   	VMK8061_MODEL
> @@ -678,12 +680,12 @@ static int vmk80xx_alloc_usb_buffers(struct comedi_device *dev)
>   	struct vmk80xx_private *devpriv = dev->private;
>   	size_t size;
>   
> -	size = usb_endpoint_maxp(devpriv->ep_rx);
> +	size = max(usb_endpoint_maxp(devpriv->ep_rx), MIN_BUF_SIZE);
>   	devpriv->usb_rx_buf = kzalloc(size, GFP_KERNEL);
>   	if (!devpriv->usb_rx_buf)
>   		return -ENOMEM;
>   
> -	size = usb_endpoint_maxp(devpriv->ep_tx);
> +	size = max(usb_endpoint_maxp(devpriv->ep_rx), MIN_BUF_SIZE);
>   	devpriv->usb_tx_buf = kzalloc(size, GFP_KERNEL);
>   	if (!devpriv->usb_tx_buf)
>   		return -ENOMEM;
> 

Looks good, thanks!

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott <abbotti@mev.co.uk> || MEV Ltd. is a company  )=-
-=( registered in England & Wales.  Regd. number: 02862268.  )=-
-=( Regd. addr.: S11 & 12 Building 67, Europa Business Park, )=-
-=( Bird Hall Lane, STOCKPORT, SK3 0XA, UK. || www.mev.co.uk )=-
