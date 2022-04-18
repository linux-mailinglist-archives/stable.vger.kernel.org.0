Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38EFA505F63
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 23:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiDRVgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 17:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiDRVgD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 17:36:03 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403B72D1CA
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 14:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650317603; x=1681853603;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Zn+NXcLyI1ueXup+QlRSkgZFGbo5MELKDMfnPmqO124=;
  b=RO11pIDl3mHXu0guO380gCMZbtTZUAEYhI42UmTlZ7Uq4wI+pPAEf6Ah
   CrAh2eoh6k9LuHKBZtI8CHw/H3ACZRiFjkVE2psiSYcTqUlaYV6q3AJse
   jPQmqJtO5NfBSC/Q+JgmB2Ax2+nVdjnJvCApDdyuuNrON5vsyddAGJJla
   //0ll3HB7h39STVu19c9IQdK7Xg6yLQ67W/rxh83TcW+lRL0zUoFUocr/
   XvAbIUmoSh3PSnkMdwPrtAmO3Mu3Qz/prh6KK33lTGr2RHGT1lj9W2DHr
   RIdkmun+WJjKVurzJ26eWCJBD94av02EDbPxcNg3fQ4nsUpeS5RbTOVvP
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="350064632"
X-IronPort-AV: E=Sophos;i="5.90,270,1643702400"; 
   d="scan'208";a="350064632"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 14:33:22 -0700
X-IronPort-AV: E=Sophos;i="5.90,270,1643702400"; 
   d="scan'208";a="665535405"
Received: from tsahu-mobl.amr.corp.intel.com (HELO [10.251.20.74]) ([10.251.20.74])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 14:33:22 -0700
Message-ID: <c77d892f-4ff3-f7ad-482f-c9673a3cd86f@linux.intel.com>
Date:   Mon, 18 Apr 2022 16:33:21 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH v1 2/4] ASoC: ops: Fix stereo change notifications in
 snd_soc_put_volsw_sx()
Content-Language: en-US
To:     Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
References: <20220201155629.120510-1-broonie@kernel.org>
 <20220201155629.120510-3-broonie@kernel.org>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <20220201155629.120510-3-broonie@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/1/22 09:56, Mark Brown wrote:
> When writing out a stereo control we discard the change notification from
> the first channel, meaning that events are only generated based on changes
> to the second channel. Ensure that we report a change if either channel
> has changed.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  sound/soc/soc-ops.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
> index 73c9d53de25b..f0d1aeb38346 100644
> --- a/sound/soc/soc-ops.c
> +++ b/sound/soc/soc-ops.c
> @@ -413,6 +413,7 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
>  	int min = mc->min;
>  	unsigned int mask = (1U << (fls(min + max) - 1)) - 1;
>  	int err = 0;
> +	int ret;
>  	unsigned int val, val_mask;
>  
>  	val_mask = mask << shift;
> @@ -422,6 +423,7 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
>  	err = snd_soc_component_update_bits(component, reg, val_mask, val);
>  	if (err < 0)
>  		return err;
> +	ret = err;
>  
>  	if (snd_soc_volsw_is_stereo(mc)) {
>  		unsigned int val2;
> @@ -432,6 +434,11 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
>  
>  		err = snd_soc_component_update_bits(component, reg2, val_mask,
>  			val2);
> +
> +		/* Don't discard any error code or drop change flag */
> +		if (ret == 0 || err < 0) {
> +			ret = err;
> +		}
>  	}
>  	return err;

cppcheck flags a warning on this patch, I believe we should use "return ret;" here, as done in the other patches of this series?

https://github.com/thesofproject/linux/pull/3597/commits/85b667d190953231ef314ac429019a011596f6d7

