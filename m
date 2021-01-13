Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A052F45F5
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 09:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbhAMIJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 03:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbhAMIJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 03:09:58 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFB7C0617BF;
        Wed, 13 Jan 2021 00:08:22 -0800 (PST)
Date:   Wed, 13 Jan 2021 09:08:18 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610525300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZXympUrY6VvpFfFp7c+mb48BtYZ6A3/P+Hw2ElLOUcU=;
        b=EpO/5jkxyyb3LcWaDBv8s1iLOLDPd1R54zg6pDUBsT5YSOgH1Aq9Mdf0S+OQwbncaV9H0i
        W9akON4XzdaaVfcB6pO2MN4TlUuCY9T8Iz0WK6iLcx9qiD3RH4qxjrPRASerwLp+cnhLJL
        +UAAHk6rZ9QVEOXhTPMbWxnsgZYslZyPu20lqWjGiU53WjIiYJGb1EFrCyXIlw+lkuHSGr
        IrbltMLmvf1+5uAZwr3J6gH/8YQyxe9UXJEO7XP70WkvIsaBROn4JQ8ozIBbxFc5W96hpH
        45kcZWmp0oq5Dg205tdIWQTpJcITuk+x3y7Xd1/dZP7DeP0owvR8AhpQm/ZCEw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610525300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZXympUrY6VvpFfFp7c+mb48BtYZ6A3/P+Hw2ElLOUcU=;
        b=yn09QM3n5FTDBPPIBJp94SrARhARRcRwmjB/uzXu66d+cQg/zsIEkNf57fyBMPtU/pHH6P
        iRwWSYh/ZMsUecDw==
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, stable@vger.kernel.org
Subject: Re: [PATCH] usb: udc: core: Use lock for soft_connect
Message-ID: <X/6qctJ6eVcPHO/m@lx-t490>
References: <8262fabe3aa7c02981f3b9d302461804c451ea5a.1610493934.git.Thinh.Nguyen@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8262fabe3aa7c02981f3b9d302461804c451ea5a.1610493934.git.Thinh.Nguyen@synopsys.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 12, 2021 at 03:26:21PM -0800, Thinh Nguyen wrote:
...
>
> +	mutex_lock(&udc_lock);
>  	if (!udc->driver) {
> +		mutex_unlock(&udc_lock);
>  		dev_err(dev, "soft-connect without a gadget driver\n");
>  		return -EOPNOTSUPP;
>  	}
> @@ -1542,10 +1544,12 @@ static ssize_t soft_connect_store(struct device *dev,
>  		usb_gadget_disconnect(udc->gadget);
>  		usb_gadget_udc_stop(udc);
>  	} else {
> +		mutex_unlock(&udc_lock);
>  		dev_err(dev, "unsupported command '%s'\n", buf);
>  		return -EINVAL;
>  	}
>
> +	mutex_unlock(&udc_lock);
>  	return n;
>  }

Please use "goto out" instead of repeating the mutex unlock line three
times.

Thanks,

--
Ahmed S. Darwish
Linutronix GmbH
