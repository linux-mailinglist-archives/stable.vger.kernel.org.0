Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD815E6C25
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 21:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiIVTyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 15:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiIVTyS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 15:54:18 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B5C10CA40;
        Thu, 22 Sep 2022 12:54:17 -0700 (PDT)
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MJrfeq013982;
        Thu, 22 Sep 2022 19:54:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=juEmjHmuZ3ZebWBOD13w/A2IRQORtasctzW9YtDtUb4=;
 b=dJDX3g1maRwYatcDLuGiqTAd56CcPt4LttrJq0qJTSAUuZKb07MdfYePyTsWs8QEB3HO
 Gfcmw7BaArub8L3lJ1+QW66+plG/uUpgUDMO/bjbbgPU22aaOR4THYnb+PPJyJA0huAw
 DcnxXT5hGbMLjyE82AyvjN7a/3FeXi3lsVEZW9vJRoWC/1h3OQC/EFErEz1MuqnU+Wbw
 zoSBuRS60WwOANtI/tIN6rzQdOkDE+ejvAQ1C6TsxlPqm7OBmQwtRFG+QgWIFDgn0UuC
 VnZqrvbGbk48f2fYEo2NbW/T21eXDzQ2UTn97SN8kSrD98tUiMEUTh8tOofhJKlvUSiy kw== 
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jr85v3e04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Sep 2022 19:54:06 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 28MJs4BR017027
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Sep 2022 19:54:04 GMT
Received: from [10.110.101.161] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 22 Sep
 2022 12:54:03 -0700
Message-ID: <c8584da1-43b6-f008-f5b0-d27e6516b59b@quicinc.com>
Date:   Thu, 22 Sep 2022 12:54:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [Freedreno] [PATCH v2 05/10] drm/msm/dp: fix IRQ lifetime
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
 <20220913085320.8577-6-johan+linaro@kernel.org>
From:   Kuogee Hsieh <quic_khsieh@quicinc.com>
In-Reply-To: <20220913085320.8577-6-johan+linaro@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: XAvMUbnJ2nqau0YFa3JkhFeKuChldZT4
X-Proofpoint-GUID: XAvMUbnJ2nqau0YFa3JkhFeKuChldZT4
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
> This is specifically true for the DP IRQ, which will otherwise remain
> requested so that the next bind attempt fails when requesting the IRQ a
> second time.
>
> Since commit c3bf8e21b38a ("drm/msm/dp: Add eDP support via aux_bus")
> this can happen when the aux-bus panel driver has not yet been loaded so
> that probe is deferred.
>
> Fix this by tying the device-managed lifetime of the DP IRQ to the DRM
> device so that it is released when bind fails.
>
> Fixes: c943b4948b58 ("drm/msm/dp: add displayPort driver support")
> Cc: stable@vger.kernel.org      # 5.10
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Kuogee Hsieh <quic_khsieh@quicinc.com>

> ---
>   drivers/gpu/drm/msm/dp/dp_display.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
> index fbe950edaefe..ba557328710a 100644
> --- a/drivers/gpu/drm/msm/dp/dp_display.c
> +++ b/drivers/gpu/drm/msm/dp/dp_display.c
> @@ -1258,7 +1258,7 @@ int dp_display_request_irq(struct msm_dp *dp_display)
>   		return -EINVAL;
>   	}
>   
> -	rc = devm_request_irq(&dp->pdev->dev, dp->irq,
> +	rc = devm_request_irq(dp_display->drm_dev->dev, dp->irq,
>   			dp_display_irq_handler,
>   			IRQF_TRIGGER_HIGH, "dp_display_isr", dp);
>   	if (rc < 0) {
