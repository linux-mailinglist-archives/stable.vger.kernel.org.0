Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF6E76D804A
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 17:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238452AbjDEPCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 11:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238089AbjDEPCo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 11:02:44 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F7D4C15;
        Wed,  5 Apr 2023 08:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680706951; x=1712242951;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dFlO+IoyPt/cvrM8e5U9Z6n3Lak/MZq3BRfErTyVWhM=;
  b=A0CGUmS2P43prJu+OHH7Vy/D41qpw5jeMFOvbdfCJsmcxxwuz4WB9hbM
   ci+WSuvwmHy9T+LfV/AmeIjLbd27tCAThuLw/XWeZ9G6biKXI+QRXM5/h
   OvKPLVqdQD9BrRYEfZNHsvR2Sj1SkMJCzT5CvycJBJHNVRocdwQoNCyRK
   dxznbom0yA64dmw0SljKSij7K+7mte6nt0yHhs5+vpm+etUc8guA1T7NZ
   yx1B89lih5rESwThog19w2HtBPWo/D6+sLqkR2uquaqPcLAlCy5OX7AiG
   z40ypyZbuc/z01lXcPcY9en+SWtzB7D1MbG99lHU7j9O5f+1CHC5+Lyyk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="407559719"
X-IronPort-AV: E=Sophos;i="5.98,321,1673942400"; 
   d="scan'208";a="407559719"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 08:01:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="686779878"
X-IronPort-AV: E=Sophos;i="5.98,321,1673942400"; 
   d="scan'208";a="686779878"
Received: from mlokuyad-mobl.amr.corp.intel.com (HELO [10.212.149.36]) ([10.212.149.36])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 08:01:56 -0700
Message-ID: <ecc13046-1a4f-77e7-c4dc-a5a4c1248572@linux.intel.com>
Date:   Wed, 5 Apr 2023 10:01:56 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH] soundwire: qcom: Fix enumeration of second device on the
 bus
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Sanyog Kale <sanyog.r.kale@intel.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-arm-msm@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Patrick Lai <quic_plai@quicinc.com>
References: <20230405142926.842173-1-krzysztof.kozlowski@linaro.org>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <20230405142926.842173-1-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/5/23 09:29, Krzysztof Kozlowski wrote:
> Some Soundwire buses (like &swr0 on Qualcomm HDK8450) have two devices,
> which can be brought from powerdown state one after another.  We need to
> keep enumerating them on each slave attached interrupt, otherwise only
> first will appear.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: a6e6581942ca ("soundwire: qcom: add auto enumeration support")
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> ---
> 
> Cc: Patrick Lai <quic_plai@quicinc.com>
> ---
>  drivers/soundwire/qcom.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
> index c296e0bf897b..1e5077d91f59 100644
> --- a/drivers/soundwire/qcom.c
> +++ b/drivers/soundwire/qcom.c
> @@ -587,14 +587,9 @@ static irqreturn_t qcom_swrm_irq_handler(int irq, void *dev_id)
>  			case SWRM_INTERRUPT_STATUS_CHANGE_ENUM_SLAVE_STATUS:
>  				dev_dbg_ratelimited(swrm->dev, "SWR new slave attached\n");
>  				swrm->reg_read(swrm, SWRM_MCP_SLV_STATUS, &slave_status);
> -				if (swrm->slave_status == slave_status) {
> -					dev_dbg(swrm->dev, "Slave status not changed %x\n",
> -						slave_status);

it's not clear to me how removing this test helps with the two-device
configuration?

Or is this a case where the status for both devices changes at the same
time but the interrupt status remains set, so the next iteration of the
loop is ignored?

> -				} else {
> -					qcom_swrm_get_device_status(swrm);
> -					qcom_swrm_enumerate(&swrm->bus);
> -					sdw_handle_slave_status(&swrm->bus, swrm->status);
> -				}
> +				qcom_swrm_get_device_status(swrm);
> +				qcom_swrm_enumerate(&swrm->bus);
> +				sdw_handle_slave_status(&swrm->bus, swrm->status);
>  				break;
>  			case SWRM_INTERRUPT_STATUS_MASTER_CLASH_DET:
>  				dev_err_ratelimited(swrm->dev,
