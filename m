Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2AEDA9DB2
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 11:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731760AbfIEJBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 05:01:40 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33129 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfIEJBk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 05:01:40 -0400
Received: by mail-lf1-f67.google.com with SMTP id d10so1364276lfi.0;
        Thu, 05 Sep 2019 02:01:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fHVuqCr/OyW5JaHz1Q69QLOGPQ2rkaR3lF0yBK4M8Ag=;
        b=hiP1gVSOjoIKsZgTTcB3iL9nI7syDMYFdbnzOdTh5Yr0bWkAgW1eQu7h4eksrVhSAj
         IBZMAMFMjEiZhOWkFuK5Z3riVLpHTs4OJPPM8gYVkRFq9n/tZN8eZj0hyUoKJdT3N6Fu
         i3ElVsPsEtDtsOudGRhBt8eA3b+0wk+rJ5aYm8Sl8kMgE7Zk+i7bC/6jkT9BARNPKlfG
         fhDYbIM2umfL+TnJ0lNPuENBvNfgNvcuGVvaZJosx5kOUhyp6dsd6qoHelPKjueDLBS2
         G+i3qTZHX7dRQBQg413cZ+afNdLoJDVczKJIcPvCXvz6CiDY/qaqPBS7jFkvP60lX/HR
         oTJA==
X-Gm-Message-State: APjAAAV3+K8Ghg3F+okHT88gU16AJGzsAwE++iHNVopuVqFWkoOIV6tc
        Y1kd8tZWID2p9pbH+FnJIpw=
X-Google-Smtp-Source: APXvYqwj7nV8uxnkZA0b7EF5NQVK+3un63x7J4qHgIRz6fvwJEQkUYzHXuJ9KaJvNOIBahy32bWMjg==
X-Received: by 2002:ac2:41ca:: with SMTP id d10mr1521472lfi.11.1567674098011;
        Thu, 05 Sep 2019 02:01:38 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id m10sm314041lfo.69.2019.09.05.02.01.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Sep 2019 02:01:37 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92)
        (envelope-from <johan@kernel.org>)
        id 1i5ndz-0008L3-0O; Thu, 05 Sep 2019 11:01:31 +0200
Date:   Thu, 5 Sep 2019 11:01:30 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Baolin Wang <baolin.wang@linaro.org>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        lanqing.liu@unisoc.com, linux-serial@vger.kernel.org,
        arnd@arndb.de, orsonzhai@gmail.com, vincent.guittot@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BACKPORT 4.14.y v2 6/6] serial: sprd: Modify the baud rate
 calculation formula
Message-ID: <20190905090130.GF1701@localhost>
References: <cover.1567649728.git.baolin.wang@linaro.org>
 <4fe6ec82960301126b9f4be52dd6083c30e17420.1567649729.git.baolin.wang@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fe6ec82960301126b9f4be52dd6083c30e17420.1567649729.git.baolin.wang@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 05, 2019 at 11:11:26AM +0800, Baolin Wang wrote:
> From: Lanqing Liu <lanqing.liu@unisoc.com>
> 
> [Upstream commit 5b9cea15a3de5d65000d49f626b71b00d42a0577]
> 
> When the source clock is not divisible by the expected baud rate and
> the remainder is not less than half of the expected baud rate, the old
> formular will round up the frequency division coefficient. This will
> make the actual baud rate less than the expected value and can not meet
> the external transmission requirements.
> 
> Thus this patch modifies the baud rate calculation formula to support
> the serial controller output the maximum baud rate.
> 
> Signed-off-by: Lanqing Liu <lanqing.liu@unisoc.com>
> Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
> ---
>  drivers/tty/serial/sprd_serial.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/serial/sprd_serial.c b/drivers/tty/serial/sprd_serial.c
> index e902494..72e96ab8 100644
> --- a/drivers/tty/serial/sprd_serial.c
> +++ b/drivers/tty/serial/sprd_serial.c
> @@ -380,7 +380,7 @@ static void sprd_set_termios(struct uart_port *port,
>  	/* ask the core to calculate the divisor for us */
>  	baud = uart_get_baud_rate(port, termios, old, 0, SPRD_BAUD_IO_LIMIT);
>  
> -	quot = (unsigned int)((port->uartclk + baud / 2) / baud);
> +	quot = port->uartclk / baud;

Are you sure the original patch is even correct?

By replacing the divisor rounding with truncation you are introducing
larger errors for some baud rates, something which could possibly even
break working systems.

Perhaps the original patch should even be reverted, but in any case
backporting this to stable looks questionable.

>  
>  	/* set data length */
>  	switch (termios->c_cflag & CSIZE) {

Johan
