Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD707123011
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 16:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbfLQPU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 10:20:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:56470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728276AbfLQPU3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 10:20:29 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 927A82146E;
        Tue, 17 Dec 2019 15:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576596029;
        bh=vQ/2Y+RGdZ5UonD6kZewB56CrR9lah1YrWL4h7Pxm+4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=wo1qqZbQYTGDvoz5/c1hl0BzEkyD8GhwOZSZVF5rypSxAuUbYoJLC9LKVmzHdsq4L
         MhDuHDdUsNRhwNFc6SAbQPWc2HRwHgJbw0AcAsTfUYhL8j1MpEO/CruEe5aD8pOBll
         1gztnWUHMWB8i4Gp9q/ZKGpaxN0MuNjUwyJma7SA=
Subject: Re: [PATCH v2 1/2] usbip: Fix receive error in vhci-hcd when using
 scatter-gather
To:     Suwan Kim <suwan.kim027@gmail.com>, valentina.manea.m@gmail.com,
        gregkh@linuxfoundation.org, marmarek@invisiblethingslab.com
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu,
        Shuah Khan <skhan@linuxfoundation.org>,
        shuah <shuah@kernel.org>
References: <20191213023055.19933-1-suwan.kim027@gmail.com>
 <20191213023055.19933-2-suwan.kim027@gmail.com>
From:   shuah <shuah@kernel.org>
Message-ID: <51515368-52e9-7d72-959c-b1f1dd5333f4@kernel.org>
Date:   Tue, 17 Dec 2019 08:20:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191213023055.19933-2-suwan.kim027@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/12/19 7:30 PM, Suwan Kim wrote:
> When vhci uses SG and receives data whose size is smaller than SG
> buffer size, it tries to receive more data even if it acutally
> receives all the data from the server. If then, it erroneously adds
> error event and triggers connection shutdown.
> 
> vhci-hcd should check if it received all the data even if there are
> more SG entries left. So, check if it receivces all the data from
> the server in for_each_sg() loop.
> 
> Fixes: ea44d190764b ("usbip: Implement SG support to vhci-hcd and stub driver")
> Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
> Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
> Signed-off-by: Suwan Kim <suwan.kim027@gmail.com>
> ---
>   drivers/usb/usbip/usbip_common.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/usb/usbip/usbip_common.c b/drivers/usb/usbip/usbip_common.c
> index 6532d68e8808..e4b96674c405 100644
> --- a/drivers/usb/usbip/usbip_common.c
> +++ b/drivers/usb/usbip/usbip_common.c
> @@ -727,6 +727,9 @@ int usbip_recv_xbuff(struct usbip_device *ud, struct urb *urb)
>   
>   			copy -= recv;
>   			ret += recv;
> +
> +			if (!copy)
> +				break;
>   		}
>   
>   		if (ret != size)
> 

Thanks Marek and Suwan for taking care of this.

Acked-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
