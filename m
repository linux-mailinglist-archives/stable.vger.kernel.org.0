Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6889D607C5C
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 18:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiJUQhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 12:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiJUQhI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 12:37:08 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D43B3B70D;
        Fri, 21 Oct 2022 09:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666370227; x=1697906227;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1WmcIR8LQUdwWI92mwL+lEDUUMAxr+M2w9pm5h8V3XA=;
  b=lQeYNqKA6P92j3/KUIjlwVRQLJxK0GC/3SLoUTmFhfmMOmbaAQt+nM+v
   b3QyrnHWjTJUnOGhaQzEXnTlpC0yi9mei1GZL6TS/4XA+s31ThJR0Ehe8
   EBzKPy2MaCOm8mC+RmD6/hPkrUajZ9rCXFhDWZH4zxsNs4v+oNcPmxrCs
   NNsCkjqxBYaLP3b4cgG9a9qfkS5vDwcju4APbAPpCtKr2WtXrIPkes9K+
   Gq9S267qUdAaxBu2/VkX8o7PNxmIzoAjf4odsTDIvEjKesGIzbi0sgaf5
   4UUcYI0cGWblJD9S9k1gQ3ndHct+W2QZ+/PF06mCiEJ8bbqppjxi6byE4
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="287447750"
X-IronPort-AV: E=Sophos;i="5.95,202,1661842800"; 
   d="scan'208";a="287447750"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 09:37:07 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="755874415"
X-IronPort-AV: E=Sophos;i="5.95,202,1661842800"; 
   d="scan'208";a="755874415"
Received: from legomezl-mobl1.amr.corp.intel.com (HELO [10.213.170.111]) ([10.213.170.111])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 09:37:06 -0700
Message-ID: <ad0a158f-6311-4da9-ee78-68e72decb056@linux.intel.com>
Date:   Fri, 21 Oct 2022 11:37:05 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.2
Subject: Re: [PATCH] soundwire: intel: Initialize clock stop timeout
Content-Language: en-US
To:     Bard Liao <yung-chuan.liao@linux.intel.com>,
        alsa-devel@alsa-project.org, vkoul@kernel.org
Cc:     stable@vger.kernel.org, vinod.koul@linaro.org, bard.liao@intel.com,
        linux-kernel@vger.kernel.org
References: <20221020015624.1703950-1-yung-chuan.liao@linux.intel.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <20221020015624.1703950-1-yung-chuan.liao@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/19/22 20:56, Bard Liao wrote:
> From: Sjoerd Simons <sjoerd@collabora.com>
> 
> The bus->clk_stop_timeout member is only initialized to a non-zero value
> during the codec driver probe. This can lead to corner cases where this
> value remains pegged at zero when the bus suspends, which results in an
> endless loop in sdw_bus_wait_for_clk_prep_deprep().
> 
> Corner cases include configurations with no codecs described in the
> firmware, or delays in probing codec drivers.
> 
> Initializing the default timeout to the smallest non-zero value avoid this
> problem and allows for the existing logic to be preserved: the
> bus->clk_stop_timeout is set as the maximum required by all codecs
> connected on the bus.
> 
> Fixes: 1f2dcf3a154ac ("soundwire: intel: set dev_num_ida_min")
> Signed-off-by: Sjoerd Simons <sjoerd@collabora.com>
> Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Reviewed-by: Chao Song <chao.song@intel.com>
> Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>

this patch should be sent to GregKH/Linus as a 6.1-rcx fix, it does seem
to make the life of Arch/Debian users less miserable - for some reason
very large delays on driver probe seem to trigger this corner case and
make things even worse.

see https://github.com/thesofproject/linux/issues/3777 for details.

Thanks Vinod.

> ---
>  drivers/soundwire/intel.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
> index 25ec9c272239..78d35bb4852c 100644
> --- a/drivers/soundwire/intel.c
> +++ b/drivers/soundwire/intel.c
> @@ -1311,6 +1311,7 @@ static int intel_link_probe(struct auxiliary_device *auxdev,
>  
>  	bus->link_id = auxdev->id;
>  	bus->dev_num_ida_min = INTEL_DEV_NUM_IDA_MIN;
> +	bus->clk_stop_timeout = 1;
>  
>  	sdw_cdns_probe(cdns);
>  
