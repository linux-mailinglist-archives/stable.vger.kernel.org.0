Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A6F579528
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 10:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbiGSIV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 04:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiGSIV5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 04:21:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2BB2AC72;
        Tue, 19 Jul 2022 01:21:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 748F06172D;
        Tue, 19 Jul 2022 08:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F235AC341C6;
        Tue, 19 Jul 2022 08:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658218915;
        bh=uFWv6V41ZhYFK+dcq+m81Z2Uo7jjsf77bW8D4oEYjOM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HTFlMJqKVdA7gXCwGP8dmr2tTTP2BFnBQgMaHXsXj3RvJzZjKzFoCz4KNCY1s0/KD
         GX6jW2Rg3JxJ/JooOC+LSTFe20hB2xgRvuTyJ281cusR9ckkf6eepEaEVxz2AaqqdT
         vmMykyjDc63lWahlNQgg+11oxD1Egx4iNFIcOxgrRzvjQfF+zhrse2VMVL9RcM+Cgl
         m6A3sdx5OjdcjU+PuUabRJ3UeNy6Zm2QNIBykIAN+kS6XqPy8NuBEmb8C30KNfwcQQ
         kXLeiyeb7Crw3ByRo/rxw1xlzypS6Hp/mEOfOMS8zef3siuNBXKNJ2yAvT6G7LUEZ/
         NBZ/6et/VqR+Q==
Date:   Tue, 19 Jul 2022 09:31:52 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
Cc:     lars@metafoo.de, linux-iio@vger.kernel.org, stable@vger.kernel.org,
        Fawzi Khaber <fawzi.khaber@tdk.com>,
        Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Subject: Re: [PATCH v2] iio: fix iio_format_avail_range() printing for none
 IIO_VAL_INT
Message-ID: <20220719093152.5d3ac7d6@jic23-huawei>
In-Reply-To: <20220718130706.32571-1-jmaneyrol@invensense.com>
References: <20220718130706.32571-1-jmaneyrol@invensense.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Jul 2022 15:07:06 +0200
Jean-Baptiste Maneyrol <jmaneyrol@invensense.com> wrote:

> From: Fawzi Khaber <fawzi.khaber@tdk.com>
> 
> iio_format_avail_range() should print range as follow [min, step, max], so
> the function was previously calling iio_format_list() with length = 3,
> length variable refers to the array size of values not the number of
> elements. In case of non IIO_VAL_INT values each element has integer part
> and decimal part. With length = 3 this would cause premature end of loop
> and result in printing only one element.
> 
> Signed-off-by: Fawzi Khaber <fawzi.khaber@tdk.com>
> Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
> Fixes: eda20ba1e25e ("iio: core: Consolidate iio_format_avail_{list,range}()")
As I'm hoping to sneak in a late pull request for the coming merge window
(as the cycle has been delayed), I've picked this on up on the togreg branch of iio.git.
+ marked for stable.

Thanks,

Jonathan

> ---
>  drivers/iio/industrialio-core.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> index 358b909298c0..0f4dbda3b9d3 100644
> --- a/drivers/iio/industrialio-core.c
> +++ b/drivers/iio/industrialio-core.c
> @@ -812,7 +812,23 @@ static ssize_t iio_format_avail_list(char *buf, const int *vals,
>  
>  static ssize_t iio_format_avail_range(char *buf, const int *vals, int type)
>  {
> -	return iio_format_list(buf, vals, type, 3, "[", "]");
> +	int length;
> +
> +	/*
> +	 * length refers to the array size , not the number of elements.
> +	 * The purpose is to print the range [min , step ,max] so length should
> +	 * be 3 in case of int, and 6 for other types.
> +	 */
> +	switch (type) {
> +	case IIO_VAL_INT:
> +		length = 3;
> +		break;
> +	default:
> +		length = 6;
> +		break;
> +	}
> +
> +	return iio_format_list(buf, vals, type, length, "[", "]");
>  }
>  
>  static ssize_t iio_read_channel_info_avail(struct device *dev,

