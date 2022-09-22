Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D11405E6C01
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 21:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbiIVTt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 15:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbiIVTtz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 15:49:55 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4B92C11B;
        Thu, 22 Sep 2022 12:49:51 -0700 (PDT)
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MJk0oL027564;
        Thu, 22 Sep 2022 19:49:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=AJNwSWYhPDM+mTEDrbxNPzoDZcYGtMDN77+331lqXFU=;
 b=MRBzVieHOfip1Wn8UUEPaJDI5EiZs4hsYBZD5tnmAoQevvSN3oW8CZytMUsx3hmVf+uH
 NBaW1RdlYkCiD3cXvaSUQqokyLsYRccJZVjal1fTEDYIdFD5Pu+Hz89dqSrhBFX4zNuj
 yCkZf42M6DctULE32LqbwCcgFcpFWFtxe1JwQeN5SfISMVahuY5d+65LlrDwPNfJ1r9x
 izHnqNBnvQbzVCvhkI1bcvjdHjxquoesvKI4Ds8X5x1mnP3SXtngDdut8T/4GIao8cTv
 W7SjNHWCuk2ydzxoUzpWLZB68gtMBH6Iz1FPAXqQb3nfrgx0aMplZS6WhzNbyIU/y/J4 2g== 
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jrg4ctecf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Sep 2022 19:49:01 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 28MJmxE4029024
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Sep 2022 19:48:59 GMT
Received: from [10.110.101.161] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 22 Sep
 2022 12:48:58 -0700
Message-ID: <668ebc3a-b731-cd0c-0f60-ba9faabbf978@quicinc.com>
Date:   Thu, 22 Sep 2022 12:48:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [Freedreno] [PATCH v2 01/10] drm/msm: fix use-after-free on probe
 deferral
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
 <20220913085320.8577-2-johan+linaro@kernel.org>
Content-Language: en-US
From:   Kuogee Hsieh <quic_khsieh@quicinc.com>
In-Reply-To: <20220913085320.8577-2-johan+linaro@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: XFS2v7F2z7Z4grplLaqVY6tfI2QTR_EF
X-Proofpoint-ORIG-GUID: XFS2v7F2z7Z4grplLaqVY6tfI2QTR_EF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_14,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 clxscore=1011 lowpriorityscore=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209220128
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 9/13/2022 1:53 AM, Johan Hovold wrote:
> The bridge counter was never reset when tearing down the DRM device so
> that stale pointers to deallocated structures would be accessed on the
> next tear down (e.g. after a second late bind deferral).
>
> Given enough bridges and a few probe deferrals this could currently also
> lead to data beyond the bridge array being corrupted.
>
> Fixes: d28ea556267c ("drm/msm: properly add and remove internal bridges")
> Fixes: a3376e3ec81c ("drm/msm: convert to drm_bridge")
> Cc: stable@vger.kernel.org      # 3.12
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Kuogee Hsieh <quic_khsieh@quicinc.com>

> ---
>   drivers/gpu/drm/msm/msm_drv.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
> index 391d86b54ded..d254fe2507ec 100644
> --- a/drivers/gpu/drm/msm/msm_drv.c
> +++ b/drivers/gpu/drm/msm/msm_drv.c
> @@ -241,6 +241,7 @@ static int msm_drm_uninit(struct device *dev)
>   
>   	for (i = 0; i < priv->num_bridges; i++)
>   		drm_bridge_remove(priv->bridges[i]);
> +	priv->num_bridges = 0;
>   
>   	pm_runtime_get_sync(dev);
>   	msm_irq_uninstall(ddev);
