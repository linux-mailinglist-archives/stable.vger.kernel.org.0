Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0205052B981
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 14:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236073AbiERMBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 08:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236358AbiERMB1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 08:01:27 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [46.235.227.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AECB23177;
        Wed, 18 May 2022 05:01:25 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: kholk11)
        with ESMTPSA id 593BF1F44F9A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1652875283;
        bh=eWMO+9i9voS89Q+F8+40P0pUsammpGTwWoyawgM0xNg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Lhm/J/hXfAJ9BJFEvYcRwETBoCLYtJjqJQQ0KCGtbdsJBYbfPgAYbZjaq8Cktb2GQ
         jnnvBMRi1Fp5XaQ2ARbA3DD3le7L828QOMEJVDVoyrihhnf3NecPbVjmBhdIfXSwql
         xlrpC5xyXxPJaYxbqz6mrtWM0QPP/VKPqKdlpvmF2aF4rgAA0/w4E0Tb3TBlaavlV6
         b/IMu1+Fp88Ur8Z3WPojwmmsa1Sv4FPuY0E0DTUVifvIHLCXJLW04LoD2492ptn0xp
         lUjkeb67qxETH++3Y3SNfRaTNO+0MSwXP/bF2VPqbwUUuRB31FyZCtYBkXOvolkJCf
         4gz0tsNkszGug==
Message-ID: <7781eaaf-ad09-7283-dbb8-69d0fb3f1d14@collabora.com>
Date:   Wed, 18 May 2022 14:01:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 1/2] usb: xhci-mtk: fix fs isoc's transfer error
Content-Language: en-US
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Mathias Nyman <mathias.nyman@intel.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eddie Hung <eddie.hung@mediatek.com>,
        Tianping Fang <tianping.fang@mediatek.com>,
        stable@vger.kernel.org
References: <20220512064931.31670-1-chunfeng.yun@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20220512064931.31670-1-chunfeng.yun@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Il 12/05/22 08:49, Chunfeng Yun ha scritto:
> Due to the scheduler allocates the optimal bandwidth for FS ISOC endpoints,
> this may be not enough actually and causes data transfer error, so come up
> with an estimate that is no less than the worst case bandwidth used for
> any one mframe, but may be an over-estimate.
> 
> Fixes: 451d3912586a ("usb: xhci-mtk: update fs bus bandwidth by bw_budget_table")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>

Hello Chunfeng,
I agree this is "a fix"... but is it the best fix?

Shooting the bandwidth very high will have power consumption consequences, are
those measurable?
And if they are, what is the expected power consumption increase in percentage
(and/or microamperes)? Also, out of the expected increase, have you got any
measurement for that?

Assuming that the measurement is done for one SoC, it's possible to make some
assumption about a different part.

Regards,
Angelo

> ---
>   drivers/usb/host/xhci-mtk-sch.c | 16 +++++++---------
>   1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-mtk-sch.c b/drivers/usb/host/xhci-mtk-sch.c
> index f3139ce7b0a9..953d2cd1d4cc 100644
> --- a/drivers/usb/host/xhci-mtk-sch.c
> +++ b/drivers/usb/host/xhci-mtk-sch.c
