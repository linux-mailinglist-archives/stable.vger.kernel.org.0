Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE0B338DE
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 21:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbfFCTFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 15:05:44 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40457 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfFCTFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 15:05:44 -0400
Received: by mail-io1-f68.google.com with SMTP id n5so15243727ioc.7
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 12:05:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=M9x4q7kQodOcQ+0HR2ctxAwI/7C0bNG43/9QNU/UJu4=;
        b=IIuFrb3/FYiG0ktqzXQMM71h1eyeFyRxd0hJL++eT3qTxEMo08EX6LABIhiRnHsLpr
         znLsc5kX8y1tu4/V7/6ARZbHyUHxITrkEmw3W5GuFXDE3hg/47oLP9G0FaLg6Env0enk
         GRhfsVXy/v8f3eX8sdMa+X6Xqz+3nu5rtQdgsf9rYaczonkKeB4bl4OYUiaIv9frvCUq
         t4fBvovf7Sk+d97lc/xGAMsiKvfn7pCwN6LpSKWm5HoPsyfwWHUNpeMPbCEI2XNu7sRg
         rVV8pvl3DRKRhcAjFIxtBdMg/jKMPchs+O6stvQeuy1U4cetjJdpvVEp7uSiLMp4xiT/
         kKJw==
X-Gm-Message-State: APjAAAV7VrjOhHsfk8Yb7ucy7eHW6QSOrWMHpeN1735jDqTIIMK3vJi6
        OqokQfHK6yRblW5Do0DkFNMGiSvXpeI=
X-Google-Smtp-Source: APXvYqyQmXdt6gSfwi9HitsPjfHvxPMDizNH7n9a8M0OhU9uT1SAtPe21I4KulormlJm6jL0lqC5Dw==
X-Received: by 2002:a5e:8618:: with SMTP id z24mr17325460ioj.174.1559588743249;
        Mon, 03 Jun 2019 12:05:43 -0700 (PDT)
Received: from google.com ([2620:15c:183:0:20b8:dee7:5447:d05])
        by smtp.gmail.com with ESMTPSA id v190sm7431796ita.14.2019.06.03.12.05.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 03 Jun 2019 12:05:42 -0700 (PDT)
Date:   Mon, 3 Jun 2019 13:05:38 -0600
From:   Raul Rangel <rrangel@chromium.org>
To:     mathias.nyman@linux.intel.com
Cc:     andrew.smirnov@gmail.com, mathias.nyman@linux.intel.com,
        stable@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: patch "xhci: Convert xhci_handshake() to use
 readl_poll_timeout_atomic()" added to usb-linus
Message-ID: <20190603190538.GA164323@google.com>
References: <155852804916633@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155852804916633@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Mathias,
Are there any plans to backport this to the other kernels?

Looks like it landed upstream as f7fac17ca925faa03fc5eb854c081a24075f8bad

Thanks,
Raul
On Wed, May 22, 2019 at 02:27:29PM +0200, gregkh@linuxfoundation.org wrote:
> 
> This is a note to let you know that I've just added the patch titled
> 
>     xhci: Convert xhci_handshake() to use readl_poll_timeout_atomic()
> 
> to my usb git tree which can be found at
>     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
> in the usb-linus branch.
> 
> The patch will show up in the next release of the linux-next tree
> (usually sometime within the next 24 hours during the week.)
> 
> The patch will hopefully also be merged in Linus's tree for the
> next -rc kernel release.
> 
> If you have any questions about this process, please let me know.
> 
> 
> From f7fac17ca925faa03fc5eb854c081a24075f8bad Mon Sep 17 00:00:00 2001
> From: Andrey Smirnov <andrew.smirnov@gmail.com>
> Date: Wed, 22 May 2019 14:34:01 +0300
> Subject: xhci: Convert xhci_handshake() to use readl_poll_timeout_atomic()
> 
> Xhci_handshake() implements the algorithm already captured by
> readl_poll_timeout_atomic(). Convert the former to use the latter to
> avoid repetition.
> 
> Turned out this patch also fixes a bug on the AMD Stoneyridge platform
> where usleep(1) sometimes takes over 10ms.
> This means a 5 second timeout can easily take over 15 seconds which will
> trigger the watchdog and reboot the system.
> 
> [Add info about patch fixing a bug to commit message -Mathias]
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> Tested-by: Raul E Rangel <rrangel@chromium.org>
> Reviewed-by: Raul E Rangel <rrangel@chromium.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/usb/host/xhci.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index 048a675bbc52..20db378a6012 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -9,6 +9,7 @@
>   */
>  
>  #include <linux/pci.h>
> +#include <linux/iopoll.h>
>  #include <linux/irq.h>
>  #include <linux/log2.h>
>  #include <linux/module.h>
> @@ -52,7 +53,6 @@ static bool td_on_ring(struct xhci_td *td, struct xhci_ring *ring)
>  	return false;
>  }
>  
> -/* TODO: copied from ehci-hcd.c - can this be refactored? */
>  /*
>   * xhci_handshake - spin reading hc until handshake completes or fails
>   * @ptr: address of hc register to be read
> @@ -69,18 +69,16 @@ static bool td_on_ring(struct xhci_td *td, struct xhci_ring *ring)
>  int xhci_handshake(void __iomem *ptr, u32 mask, u32 done, int usec)
>  {
>  	u32	result;
> +	int	ret;
>  
> -	do {
> -		result = readl(ptr);
> -		if (result == ~(u32)0)		/* card removed */
> -			return -ENODEV;
> -		result &= mask;
> -		if (result == done)
> -			return 0;
> -		udelay(1);
> -		usec--;
> -	} while (usec > 0);
> -	return -ETIMEDOUT;
> +	ret = readl_poll_timeout_atomic(ptr, result,
> +					(result & mask) == done ||
> +					result == U32_MAX,
> +					1, usec);
> +	if (result == U32_MAX)		/* card removed */
> +		return -ENODEV;
> +
> +	return ret;
>  }
>  
>  /*
> -- 
> 2.21.0
> 
> 
