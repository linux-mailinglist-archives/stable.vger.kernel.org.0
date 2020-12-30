Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5AE2E79D3
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgL3Nxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:53:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:34560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726656AbgL3Nxe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:53:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D97AB2220B;
        Wed, 30 Dec 2020 13:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609336368;
        bh=30jsp5BVA2f3TpS9tI7rc6XDWizumbT6G0NirNSQCM0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z0X4u5NxQXa/UWDGn5WU0vLZb3yjh//GXGo1yr1804TRXWhr9FEmvWo5KmzMikYi3
         c79KVsuzTGNFPQUDhpBIYRmIRqXCHp3Kyz4uwV8Y3dgCilDbJKVAWo8GI3HZRZdE3B
         9Hf8ighHKx0dxL77RpzXUlp+GQZFa+t0nFOvoa20=
Date:   Wed, 30 Dec 2020 14:54:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 154/346] crypto: omap-aes - Fix PM disable depth
 imbalance in omap_aes_probe
Message-ID: <X+yGhmU3xW/fXgmz@kroah.com>
References: <20201228124919.745526410@linuxfoundation.org>
 <20201228124927.229346776@linuxfoundation.org>
 <20201230131635.GA15217@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201230131635.GA15217@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 30, 2020 at 02:16:35PM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Zhang Qilong <zhangqilong3@huawei.com>
> > 
> > [ Upstream commit ff8107200367f4abe0e5bce66a245e8d0f2d229e ]
> > 
> > The pm_runtime_enable will increase power disable depth.
> > Thus a pairing decrement is needed on the error handling
> > path to keep it balanced according to context.
> 
> Oops, this is complex.
> 
> First, same bug exist in 4.4, but is not fixed there, and there is
> missing pm_runtime_put() there and elsewhere.
> 
> 4.4 needs these two fixes + backport of ff81072003.
> 
> 4.19 needs fixes similar to these, at three places.
> 
> mainline is okay, afaict.
> 
> Best regards,
> 								Pavel
> 
> diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
> index eba23147c0ee..48370711c794 100644
> --- a/drivers/crypto/omap-aes.c
> +++ b/drivers/crypto/omap-aes.c
> @@ -801,6 +801,7 @@ static int omap_aes_cra_init(struct crypto_tfm *tfm)
>  
>  	err = pm_runtime_get_sync(dd->dev);
>  	if (err < 0) {
> +		pm_runtime_put_sync(dd->dev);
>  		dev_err(dd->dev, "%s: failed to get_sync(%d)\n",
>  			__func__, err);
>  		return err;
> @@ -1195,6 +1196,7 @@ static int omap_aes_probe(struct platform_device *pdev)
>  	pm_runtime_enable(dev);
>  	err = pm_runtime_get_sync(dev);
>  	if (err < 0) {
> +		pm_runtime_put_sync(dev);	  
>  		dev_err(dev, "%s: failed to get_sync(%d)\n",
>  			__func__, err);
>  		goto err_res;
> 
> 

Can you submit all of this in a format that I can apply it in?

thanks,

greg k-h
