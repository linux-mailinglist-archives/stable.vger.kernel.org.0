Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C6C2F5AC4
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 07:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbhANGlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 01:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbhANGlp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jan 2021 01:41:45 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F4EC061575;
        Wed, 13 Jan 2021 22:41:04 -0800 (PST)
Date:   Thu, 14 Jan 2021 07:41:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610606462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VB3LT83nvUNrPtVk0ucHr6Pvx44lX5Zq06M2c7g1170=;
        b=1a9gqTj8yNOQRj+3I8iqQHVwK5ueMkNbCXzamDAgWwASRq+MzcGW0m9sNjXuLJsTwpX8kp
        Wpxxb4uZwTSHwdBTPHUZaFkoDfm3dHlEXPL0r/EL7rDfr7PIWjorQUclyz88gzhWWmG+82
        SQ3fwdKxM87m/mfg9booNeXrOgaOTy3qhUfo5r8iKsA6mK9rtUZe5Lixi/tkxRVdVZnods
        Kj879j1RkQ7dsJZ39cuIcBoX9RGj9VgjufQU5dtI9OESP5X9cjO9VtW5PlKCItsVu6/jjF
        VvQQHXmx2EMbLTmlfhLb91GfFs+tZeeU1y1g4OdDgd9b6mRiRmbcM7zdBWmvjw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610606462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VB3LT83nvUNrPtVk0ucHr6Pvx44lX5Zq06M2c7g1170=;
        b=u0PWeUA9ko6hRjuvT4NezRR2RadT00GM1osGA77IrHXHJBlu++h1pi3E2scmQNaYcWGdHg
        OKeoMuhpZqf+s+Dw==
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michal Nazarewicz <mina86@mina86.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: udc: core: Use lock when write to soft_connect
Message-ID: <X//nfLN9bW1K/yVm@lx-t490>
References: <311bc6d30b23427420133602c2833308310b7fcb.1610595364.git.Thinh.Nguyen@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <311bc6d30b23427420133602c2833308310b7fcb.1610595364.git.Thinh.Nguyen@synopsys.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 13, 2021 at 07:38:28PM -0800, Thinh Nguyen wrote:
...
> @@ -1543,10 +1546,12 @@ static ssize_t soft_connect_store(struct device *dev,
>  		usb_gadget_udc_stop(udc);
>  	} else {
>  		dev_err(dev, "unsupported command '%s'\n", buf);
> -		return -EINVAL;
> +		ret = -EINVAL;
>  	}
>
> -	return n;
> +out:
> +	mutex_unlock(&udc_lock);
> +	return ret;
>  }

This is *very* tricky: the return value will be easily broken if someone
adds any code later after the else body and before the "out" label.
