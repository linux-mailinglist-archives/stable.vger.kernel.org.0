Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2865E6C41
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 21:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbiIVT4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 15:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiIVT4l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 15:56:41 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9B1DCCF2;
        Thu, 22 Sep 2022 12:56:40 -0700 (PDT)
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MJIpOF020737;
        Thu, 22 Sep 2022 19:56:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=ZTkz8vQtvEkZ4vLdSZN+/b90HRPomAuoAiLsUZcB2Ps=;
 b=PW/alb1xPAP6ya97a9ryc5lU/Zia4MPWt5OC3UERyrOzSvB9clsdHejfqJD6cPIIoK74
 grlzcQWemhuidMOtgUeC4SBs8laUjsf8fRFVsWKv6ehWqyavjblPkNQLN8bKUOgBz/PK
 FYE0bqDAE4SAHz5p7CkL7F0XsE35HJS1dG0rXlIYRLE/Ko26+t/q1rGi4KUaoabzQWPL
 9d2O4RfB/neS5XsG74WDt0LyH3AZPapYRwVzOS24md7jD9QDfxFgZb3P/zF5V786B8R9
 qe+lBY1AOB2KasrKhUeadljmiLAf5sSiwwDt4v0JxKzwcJkRgHyGh/Av0xBS/htRwlo5 7Q== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jr85v3eav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Sep 2022 19:56:29 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 28MJuSAi028017
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Sep 2022 19:56:28 GMT
Received: from [10.110.101.161] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 22 Sep
 2022 12:56:27 -0700
Message-ID: <a77be457-7009-02bc-6a67-33b2cd22429a@quicinc.com>
Date:   Thu, 22 Sep 2022 12:56:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [Freedreno] [PATCH v2 07/10] drm/msm/dp: fix bridge lifetime
Content-Language: en-US
To:     Johan Hovold <johan+linaro@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        "Rob Clark" <robdclark@gmail.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>
CC:     <dri-devel@lists.freedesktop.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonas Karlman <jonas@kwiboo.se>,
        <linux-arm-msm@vger.kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        <freedreno@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Robert Foss <robert.foss@linaro.org>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        <stable@vger.kernel.org>, Sean Paul <sean@poorly.run>,
        Steev Klimaszewski <steev@kali.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
References: <20220913085320.8577-1-johan+linaro@kernel.org>
 <20220913085320.8577-8-johan+linaro@kernel.org>
From:   Kuogee Hsieh <quic_khsieh@quicinc.com>
In-Reply-To: <20220913085320.8577-8-johan+linaro@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: RSoy-A_-_wUjoXoPl7b3HuMZTwxrR_V-
X-Proofpoint-GUID: RSoy-A_-_wUjoXoPl7b3HuMZTwxrR_V-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_14,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209220129
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 9/13/2022 1:53 AM, Johan Hovold wrote:
> Device-managed resources allocated post component bind must be tied to
> the lifetime of the aggregate DRM device or they will not necessarily be
> released when binding of the aggregate device is deferred.
>
> This can lead resource leaks or failure to bind the aggregate device
> when binding is later retried and a second attempt to allocate the
> resources is made.
>
> For the DP bridges, previously allocated bridges will leak on probe
> deferral.
>
> Fix this by amending the DP parser interface and tying the lifetime of
> the bridge device to the DRM device rather than DP platform device.
>
> Fixes: c3bf8e21b38a ("drm/msm/dp: Add eDP support via aux_bus")
> Cc: stable@vger.kernel.org      # 5.19
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>

Tested-by: Kuogee Hsieh <quic_khsieh@quicinc.com>

Reviewed-by: Kuogee Hsieh <quic_khsieh@quicinc.com>

> ---
>   drivers/gpu/drm/msm/dp/dp_display.c | 2 +-
>   drivers/gpu/drm/msm/dp/dp_parser.c  | 6 +++---
>   drivers/gpu/drm/msm/dp/dp_parser.h  | 5 +++--
>   3 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
> index 4b0a2d4bb61e..808a516e84c5 100644
> --- a/drivers/gpu/drm/msm/dp/dp_display.c
> +++ b/drivers/gpu/drm/msm/dp/dp_display.c
> @@ -1586,7 +1586,7 @@ static int dp_display_get_next_bridge(struct msm_dp *dp)
>   	 * For DisplayPort interfaces external bridges are optional, so
>   	 * silently ignore an error if one is not present (-ENODEV).
>   	 */
> -	rc = dp_parser_find_next_bridge(dp_priv->parser);
> +	rc = devm_dp_parser_find_next_bridge(dp->drm_dev->dev, dp_priv->parser);
>   	if (!dp->is_edp && rc == -ENODEV)
>   		return 0;
>   
> diff --git a/drivers/gpu/drm/msm/dp/dp_parser.c b/drivers/gpu/drm/msm/dp/dp_parser.c
> index dd732215d55b..dcbe893d66d7 100644
> --- a/drivers/gpu/drm/msm/dp/dp_parser.c
> +++ b/drivers/gpu/drm/msm/dp/dp_parser.c
> @@ -240,12 +240,12 @@ static int dp_parser_clock(struct dp_parser *parser)
>   	return 0;
>   }
>   
> -int dp_parser_find_next_bridge(struct dp_parser *parser)
> +int devm_dp_parser_find_next_bridge(struct device *dev, struct dp_parser *parser)
>   {
> -	struct device *dev = &parser->pdev->dev;
> +	struct platform_device *pdev = parser->pdev;
>   	struct drm_bridge *bridge;
>   
> -	bridge = devm_drm_of_get_bridge(dev, dev->of_node, 1, 0);
> +	bridge = devm_drm_of_get_bridge(dev, pdev->dev.of_node, 1, 0);
>   	if (IS_ERR(bridge))
>   		return PTR_ERR(bridge);
>   
> diff --git a/drivers/gpu/drm/msm/dp/dp_parser.h b/drivers/gpu/drm/msm/dp/dp_parser.h
> index 866c1a82bf1a..d30ab773db46 100644
> --- a/drivers/gpu/drm/msm/dp/dp_parser.h
> +++ b/drivers/gpu/drm/msm/dp/dp_parser.h
> @@ -138,8 +138,9 @@ struct dp_parser {
>   struct dp_parser *dp_parser_get(struct platform_device *pdev);
>   
>   /**
> - * dp_parser_find_next_bridge() - find an additional bridge to DP
> + * devm_dp_parser_find_next_bridge() - find an additional bridge to DP
>    *
> + * @dev: device to tie bridge lifetime to
>    * @parser: dp_parser data from client
>    *
>    * This function is used to find any additional bridge attached to
> @@ -147,6 +148,6 @@ struct dp_parser *dp_parser_get(struct platform_device *pdev);
>    *
>    * Return: 0 if able to get the bridge, otherwise negative errno for failure.
>    */
> -int dp_parser_find_next_bridge(struct dp_parser *parser);
> +int devm_dp_parser_find_next_bridge(struct device *dev, struct dp_parser *parser);
>   
>   #endif
