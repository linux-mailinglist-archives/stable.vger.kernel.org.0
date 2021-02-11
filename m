Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3423B3196C9
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 00:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhBKXkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 18:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhBKXku (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 18:40:50 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBB7C061574;
        Thu, 11 Feb 2021 15:40:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=qvd/SYs4ftUzQOlcTaLsI7FkmKupYPRFZDx2eUjfsCw=; b=GWnoubWY02Y5IeNq9dITHyobTG
        Vyn3ktpWXoGVR83LB32R2mOuDRTluYGYmIKrpMBPGFILGSHmc38j365nB+/3gYkEDdBqdW+dIenzF
        j89N2p2/Ylvc1rzcaanrvb9tiY/9fduNJuJcMAOlrPNfZqr5U25QfkcWshDtulmiGTvWa0S0vWEDr
        W/6qZE9Xk+BgC7qT6jbe7jrzWu45RAibAW5FS+eAzFKpIMk/bHE5YmdEbqTM52/487ljkQiPLpVDB
        BVD2UUfE1gBgDp896VuWiK5SQVR4hwMWDuSqfb9AWNmMxuKHfhfcwK5rTGsFh+xzSZtYDweN2nQJz
        5RJTS5+w==;
Received: from [2601:1c0:6280:3f0::cf3b]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1lALZ9-0003hi-0u; Thu, 11 Feb 2021 23:40:07 +0000
Subject: Re: [PATCH] misc: fastrpc: restrict user apps from sending kernel RPC
 messages
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Jonathan Marek <jonathan@marek.ca>, stable@vger.kernel.org
References: <20210211233744.3348384-1-dmitry.baryshkov@linaro.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <a11cdbfa-142e-57ae-cd5b-5e8aebd5f4cf@infradead.org>
Date:   Thu, 11 Feb 2021 15:40:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210211233744.3348384-1-dmitry.baryshkov@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/11/21 3:37 PM, Dmitry Baryshkov wrote:
> Verify that user applications are not using the kernel RPC message
> handle to restrict them from directly attaching to guest OS on the
> remote subsystem. This is a port of CVE-2019-2308 fix.
> 
> Fixes: c68cfb718c8f ("misc: fastrpc: Add support for context Invoke method")
> Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Cc: Jonathan Marek <jonathan@marek.ca>
> Cc: stable@vger.kernel.org
> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> ---
>  drivers/misc/fastrpc.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
> index 815d01f785df..e7f3a22fdaa3 100644
> --- a/drivers/misc/fastrpc.c
> +++ b/drivers/misc/fastrpc.c
> @@ -948,6 +948,11 @@ static int fastrpc_internal_invoke(struct fastrpc_user *fl,  u32 kernel,
>  	if (!fl->cctx->rpdev)
>  		return -EPIPE;
>  
> +	if (handle == FASTRPC_INIT_HANDLE && !kernel) {
> +		dev_warn(fl->sctx->dev, "user app trying to send a kernel RPC message (%d)\n",  handle);

rate limit so that userspace cannot flood kernel log?

> +		return -EPERM;
> +	}
> +
>  	ctx = fastrpc_context_alloc(fl, kernel, sc, args);
>  	if (IS_ERR(ctx))
>  		return PTR_ERR(ctx);
> 


-- 
~Randy

