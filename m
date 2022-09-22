Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88A05E6C19
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 21:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbiIVTwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 15:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbiIVTwV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 15:52:21 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E9910C79D;
        Thu, 22 Sep 2022 12:52:19 -0700 (PDT)
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MJM97f028926;
        Thu, 22 Sep 2022 19:52:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=csVMJ4BwwnKu8PIrojA+07wtzzD5ekioJhhwRWYWgmc=;
 b=hOhLpddWcJgI8iHzboBsiPR2NakyMIR5vf7mljBTuB97p/7e4p1qf1CW2yEmpbEqPFvZ
 un0fGMzzFrUmtb2J1278v8HkMHvXEaJb1BYma/SJck95Pa96G6GClXIpW5lWPbuiiZRE
 3I67Q3/vs7rDPkdDjdHQQtFYkB56ZczFhyPi4Z+85Vb2O8lYQMJWY28s6rCpD/AnoRh7
 6klgrTIkcuDqEH76UlsAdhBIgF1HDi7/hUk1kExj86uiQE/42Fe/WUbTC68D5bI3yHu7
 H5EsRsE7v4K4T2Rfre+OU9Zw2UWn18iY5PS3frLzv/xD8S1o7/LQ7cQ0nmCaDDZXWFNK Pg== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jr8y1ubj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Sep 2022 19:52:00 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 28MJpxer023921
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Sep 2022 19:51:59 GMT
Received: from [10.110.101.161] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 22 Sep
 2022 12:51:57 -0700
Message-ID: <bdf8e503-3285-86ec-634f-9cb39055d0f5@quicinc.com>
Date:   Thu, 22 Sep 2022 12:51:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 03/10] drm/msm/dsi: fix memory corruption with too many
 bridges
Content-Language: en-US
To:     Johan Hovold <johan+linaro@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        "Rob Clark" <robdclark@gmail.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>
CC:     Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <robert.foss@linaro.org>,
        "Laurent Pinchart" <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, Sean Paul <sean@poorly.run>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        "Manivannan Sadhasivam" <manivannan.sadhasivam@linaro.org>,
        Steev Klimaszewski <steev@kali.org>,
        <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>,
        <freedreno@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20220913085320.8577-1-johan+linaro@kernel.org>
 <20220913085320.8577-4-johan+linaro@kernel.org>
From:   Kuogee Hsieh <quic_khsieh@quicinc.com>
In-Reply-To: <20220913085320.8577-4-johan+linaro@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: v-OEEt8yIStHfecSr4Rk0TtwcqtV9EK4
X-Proofpoint-GUID: v-OEEt8yIStHfecSr4Rk0TtwcqtV9EK4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_13,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 adultscore=0 spamscore=0 malwarescore=0
 suspectscore=0 phishscore=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2209220129
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 9/13/2022 1:53 AM, Johan Hovold wrote:
> Add the missing sanity check on the bridge counter to avoid corrupting
> data beyond the fixed-sized bridge array in case there are ever more
> than eight bridges.
>
> Fixes: a689554ba6ed ("drm/msm: Initial add DSI connector support")
> Cc: stable@vger.kernel.org	# 4.1
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
> ---
>   drivers/gpu/drm/msm/dsi/dsi.c | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/drivers/gpu/drm/msm/dsi/dsi.c b/drivers/gpu/drm/msm/dsi/dsi.c
> index 39bbabb5daf6..8a95c744972a 100644
> --- a/drivers/gpu/drm/msm/dsi/dsi.c
> +++ b/drivers/gpu/drm/msm/dsi/dsi.c
> @@ -218,6 +218,12 @@ int msm_dsi_modeset_init(struct msm_dsi *msm_dsi, struct drm_device *dev,
>   		return -EINVAL;
>   
>   	priv = dev->dev_private;
> +
> +	if (priv->num_bridges == ARRAY_SIZE(priv->bridges)) {
> +		DRM_DEV_ERROR(dev->dev, "too many bridges\n");
> +		return -ENOSPC;
> +	}
> +
>   	msm_dsi->dev = dev;
>   
>   	ret = msm_dsi_host_modeset_init(msm_dsi->host, dev);
