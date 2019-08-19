Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08175927BB
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 16:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfHSO5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 10:57:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbfHSO5s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Aug 2019 10:57:48 -0400
Received: from [192.168.0.101] (unknown [180.111.132.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 435172082A;
        Mon, 19 Aug 2019 14:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566226667;
        bh=iRcx/O1rt67I+bSqDqzSPYqUMMvn9C25iDR30t7jQdk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=PTKQOnEO344zI2hda1QYiTrhurpmTkc+j7HQEkCB7cel1Ed+7sbtRI6wLlV2SdIcj
         DmyH5g3WB7ab7jLg0Mg/yfnldrIcKSk6xzEplSDfCWMmmyW4l3OnWRZndCXyn2k7su
         7Uwqj2wfqwti8gePVk9dVTzUTCDl8kJwCF85YU/o=
Subject: Re: [PATCH 5/6] staging: erofs: detect potential multiref due to
 corrupted images
To:     Gao Xiang <gaoxiang25@huawei.com>, Chao Yu <yuchao0@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-fsdevel@vger.kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
        Miao Xie <miaoxie@huawei.com>, weidu.du@huawei.com,
        Fang Wei <fangwei1@huawei.com>, stable@vger.kernel.org
References: <20190819080218.GA42231@138>
 <20190819103426.87579-1-gaoxiang25@huawei.com>
 <20190819103426.87579-6-gaoxiang25@huawei.com>
From:   Chao Yu <chao@kernel.org>
Message-ID: <f302710e-0c7f-8695-d692-be0c01c431ea@kernel.org>
Date:   Mon, 19 Aug 2019 22:57:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190819103426.87579-6-gaoxiang25@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-8-19 18:34, Gao Xiang wrote:
> As reported by erofs-utils fuzzer, currently, multiref
> (ondisk deduplication) hasn't been supported for now,
> we should forbid it properly.
> 
> Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
> Cc: <stable@vger.kernel.org> # 4.19+
> Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
> ---
>  drivers/staging/erofs/zdata.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/erofs/zdata.c b/drivers/staging/erofs/zdata.c
> index aae2f2b8353f..5b6fef5181af 100644
> --- a/drivers/staging/erofs/zdata.c
> +++ b/drivers/staging/erofs/zdata.c
> @@ -816,8 +816,16 @@ static int z_erofs_decompress_pcluster(struct super_block *sb,
>  			pagenr = z_erofs_onlinepage_index(page);
>  
>  		DBG_BUGON(pagenr >= nr_pages);
> -		DBG_BUGON(pages[pagenr]);
>  
> +		/*
> +		 * currently EROFS doesn't support multiref(dedup),
> +		 * so here erroring out one multiref page.
> +		 */
> +		if (unlikely(pages[pagenr])) {
> +			DBG_BUGON(1);
> +			SetPageError(pages[pagenr]);
> +			z_erofs_onlinepage_endio(pages[pagenr]);

Should set err meanwhile?

> +		}
>  		pages[pagenr] = page;
>  	}
>  	z_erofs_pagevec_ctor_exit(&ctor, true);
> @@ -849,7 +857,11 @@ static int z_erofs_decompress_pcluster(struct super_block *sb,
>  			pagenr = z_erofs_onlinepage_index(page);
>  
>  			DBG_BUGON(pagenr >= nr_pages);
> -			DBG_BUGON(pages[pagenr]);
> +			if (unlikely(pages[pagenr])) {
> +				DBG_BUGON(1);
> +				SetPageError(pages[pagenr]);
> +				z_erofs_onlinepage_endio(pages[pagenr]);
> +			}
>  			pages[pagenr] = page;
>  
>  			overlapped = true;
> 
