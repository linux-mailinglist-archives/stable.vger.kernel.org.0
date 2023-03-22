Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF596C4E2E
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 15:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbjCVOn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 10:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbjCVOnC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 10:43:02 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEF067020;
        Wed, 22 Mar 2023 07:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679496137; x=1711032137;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4dNwE5FJr+nWoKSv7RD6J1C8VOtw+7FZ0Yaooy1wXCU=;
  b=Lj8V2d4Ldp8auhXeHLX+V1UEAVMjc283scQMbTT6jFCySplDIvaR/UCL
   E6otq21B0OT+PAxgwDxHyYhTlGsWolbxi8TwAtcsV3OksTo5s6FPYWZFj
   ojiyrGl51JcdHPUjcWSX3OTf7HG9cCthmLT4dcOuFCT69Z16sxqGtN5p5
   KEtXqMQjXVrMYBtczBHgFnrjYd7fEOst2ZenxIyOen0We0KcwelFCR/pR
   L1vJsX/0ePKkp4Lwfu/VDaQ/kGEXVDrFiiY8PfnYqSGwxcZULs03Z/thg
   ynlnVKmSJuhuTvCqXo2O10/UBWJV0psPBTvmj6xEEiIgB1Q3FjeKIe/SS
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="318875104"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="318875104"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 07:42:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="825424479"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="825424479"
Received: from ahajda-mobl.ger.corp.intel.com (HELO [10.213.22.233]) ([10.213.22.233])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 07:42:13 -0700
Message-ID: <4211eac2-5310-e343-2d3a-ccea908e9262@intel.com>
Date:   Wed, 22 Mar 2023 15:42:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH v2] drm/bridge: lt8912b: return EPROBE_DEFER if bridge is
 not found
Content-Language: en-US
To:     Francesco Dolcini <francesco@dolcini.it>,
        Adrien Grassein <adrien.grassein@gmail.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <rfoss@kernel.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org
Cc:     Matheus Castello <matheus.castello@toradex.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>
References: <20230322143821.109744-1-francesco@dolcini.it>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <20230322143821.109744-1-francesco@dolcini.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 22.03.2023 15:38, Francesco Dolcini wrote:
> From: Matheus Castello <matheus.castello@toradex.com>
>
> Returns EPROBE_DEFER when of_drm_find_bridge() fails, this is consistent
> with what all the other DRM bridge drivers are doing and this is
> required since the bridge might not be there when the driver is probed
> and this should not be a fatal failure.
>
> Cc: <stable@vger.kernel.org>
> Fixes: 30e2ae943c26 ("drm/bridge: Introduce LT8912B DSI to HDMI bridge")
> Signed-off-by: Matheus Castello <matheus.castello@toradex.com>
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>

Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>

Regards
Andrzej

> ---
> v2: use dev_err_probe() instead of dev_dbg() (Laurent)
> ---
>   drivers/gpu/drm/bridge/lontium-lt8912b.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/bridge/lontium-lt8912b.c b/drivers/gpu/drm/bridge/lontium-lt8912b.c
> index 2019a8167d69..b40baced1331 100644
> --- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
> +++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
> @@ -676,8 +676,8 @@ static int lt8912_parse_dt(struct lt8912 *lt)
>   
>   	lt->hdmi_port = of_drm_find_bridge(port_node);
>   	if (!lt->hdmi_port) {
> -		dev_err(lt->dev, "%s: Failed to get hdmi port\n", __func__);
> -		ret = -ENODEV;
> +		ret = -EPROBE_DEFER;
> +		dev_err_probe(lt->dev, ret, "%s: Failed to get hdmi port\n", __func__);
>   		goto err_free_host_node;
>   	}
>   

