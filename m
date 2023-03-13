Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57AE6B7CE8
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 16:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjCMP6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 11:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCMP6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 11:58:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B4C1CBCB
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 08:58:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71BC8B80E40
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 15:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF7DC4339E;
        Mon, 13 Mar 2023 15:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678723117;
        bh=FpyHGt/+swCReTPRwlFXQ4II2iWH1HWOsENTOeGRqh8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hbUMbduEvvtKo870QUlosPs0inWU1WpgpFUmAQw83pNCZxOLj/L9R21q9cwVD8H29
         0k7iAG7zqELLOClKY2H2chF08/Ny8etF2b/07ZxAmaIdcVs4JXTY7BgDQ/jsaEzj1Z
         DALXyAUa8YO/A6CibJircwRaMggIHBIHq7+c/wQc=
Date:   Mon, 13 Mar 2023 16:58:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, sashal@kernel.org
Subject: Re: [PATCH for 4.19] Revert "spi: mt7621: Fix an error message in
 mt7621_spi_probe()"
Message-ID: <ZA9IKhN6aSg+PtHr@kroah.com>
References: <20230301212350.4182867-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301212350.4182867-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 02, 2023 at 06:23:50AM +0900, Nobuhiro Iwamatsu wrote:
> This reverts commit 269f650a0b26067092873308117e0bf0c6ec8289 which is
> commit 2b2bf6b7faa9010fae10dc7de76627a3fdb525b3 upstream.
> 
> dev_err_probe() does not suppot in 4.19.y. So this driver will fail to
> build.
> 
> ```
>   CC      drivers/staging/mt7621-spi/spi-mt7621.o
> drivers/staging/mt7621-spi/spi-mt7621.c: In function 'mt7621_spi_probe':
> drivers/staging/mt7621-spi/spi-mt7621.c:446:24: error: implicit declaration of function 'dev_err_probe'; did you mean 'device_reprobe'? [-Werror=implicit-function-declaration]
>   446 |                 return dev_err_probe(&pdev->dev, PTR_ERR(clk),
>       |                        ^~~~~~~~~~~~~
>       |                        device_reprobe
> ```
> 
> Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  drivers/staging/mt7621-spi/spi-mt7621.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/mt7621-spi/spi-mt7621.c b/drivers/staging/mt7621-spi/spi-mt7621.c
> index b73823830e3a73..75ed48f60c8c7f 100644
> --- a/drivers/staging/mt7621-spi/spi-mt7621.c
> +++ b/drivers/staging/mt7621-spi/spi-mt7621.c
> @@ -442,9 +442,11 @@ static int mt7621_spi_probe(struct platform_device *pdev)
>  		return PTR_ERR(base);
>  
>  	clk = devm_clk_get(&pdev->dev, NULL);
> -	if (IS_ERR(clk))
> -		return dev_err_probe(&pdev->dev, PTR_ERR(clk),
> -				     "unable to get SYS clock\n");
> +	if (IS_ERR(clk)) {
> +		dev_err(&pdev->dev, "unable to get SYS clock, err=%d\n",
> +			status);
> +		return PTR_ERR(clk);
> +	}
>  
>  	status = clk_prepare_enable(clk);
>  	if (status)
> -- 
> 2.36.1
> 
> 

Nice fix, thanks for finding this, now queued up.

greg k-h
