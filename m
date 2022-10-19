Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1EDA605343
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 00:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiJSWkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 18:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiJSWkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 18:40:42 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7305750182;
        Wed, 19 Oct 2022 15:40:41 -0700 (PDT)
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JMVvGj016450;
        Wed, 19 Oct 2022 22:40:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=TiLEYPvKF8tH7BL8zlFtX313ymTXCb8WGzsaUNZPMQU=;
 b=W9fiWdoWSlUu60Q+BRe8CSZ3wIZjlUQDG8i7QkQ5fttX9Mcn4PDBrjhhkmwSpWXdL2o1
 WVcuml0STvLLzEqjDYdXkTap6Y7dDqA3skBSOgyFc2D0awt2MoLaewgxVTheimtC18z2
 iwch6sMBlZe7aFLw2y6ZIFbPY7mOrz56MFBg5pIvcyjA/eb9S1mVsA611wC+hFp/YWKZ
 Pb5cvlpNV+dsxC1UwCbvsSL41B9c6z7CNdUWVcehtz6fhCH6IMEC7OjcwwGlTfzbbbNF
 aSymPUTSshflE+mWtOXrzH2oQQXvnKlsTozu3Qdh+sJGgvkACdveRC0CGHgFJVIYUfyz jQ== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3kak1c114k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 22:40:36 +0000
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
        by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 29JMeYj0000802
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 22:40:34 GMT
Received: from [10.110.50.14] (10.80.80.8) by nalasex01b.na.qualcomm.com
 (10.47.209.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 19 Oct
 2022 15:40:33 -0700
Message-ID: <c01ad237-4091-aabf-0878-0e72aeae5d3c@quicinc.com>
Date:   Wed, 19 Oct 2022 15:40:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2] usb: dwc3: gadget: Don't delay End Transfer on
 delayed_status
Content-Language: en-US
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     John Youn <John.Youn@synopsys.com>, <linux-usb@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <3f9f59e5d74efcbaee444cf4b30ef639cc7b124e.1666146954.git.Thinh.Nguyen@synopsys.com>
From:   Wesley Cheng <quic_wcheng@quicinc.com>
In-Reply-To: <3f9f59e5d74efcbaee444cf4b30ef639cc7b124e.1666146954.git.Thinh.Nguyen@synopsys.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: gcAvKVOdrJTKfjbhSLmJK-3LO2WuGzI1
X-Proofpoint-ORIG-GUID: gcAvKVOdrJTKfjbhSLmJK-3LO2WuGzI1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_12,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 adultscore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210190125
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/18/2022 7:39 PM, Thinh Nguyen wrote:
> The gadget driver may wait on the request completion when it sets the
> USB_GADGET_DELAYED_STATUS. Make sure that the End Transfer command can
> go through if the dwc->delayed_status is set so that the request can
> complete. When the delayed_status is set, the Setup packet is already
> processed, and the next phase should be either Data or Status. It's
> unlikely that the host would cancel the control transfer and send a new
> Setup packet during End Transfer command. But if that's the case, we can
> try again when ep0state returns to EP0_SETUP_PHASE.

Hi Thinh,

In the scenario you saw your issue in, was there something else that 
triggered the EP0 stall and restart to bring back EP0 to SETUP state? 
(which will do the retry)  Just wanted to make sure, because there were 
situations that I had to add that sequence for the endxfer retry to 
happen. (ie in the disconnect interrupt)

Thanks
Wesley Cheng

> 
> Fixes: e1ee843488d5 ("usb: dwc3: gadget: Force sending delayed status during soft disconnect")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> ---
>   Changes in v2:
>   - Fix build issue due to cherry-picking...
> 
>   drivers/usb/dwc3/gadget.c | 12 +++++++++++-
>   1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 079cd333632e..dd8ecbe61bec 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -1698,6 +1698,16 @@ static int __dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force, bool int
>   	cmd |= DWC3_DEPCMD_PARAM(dep->resource_index);
>   	memset(&params, 0, sizeof(params));
>   	ret = dwc3_send_gadget_ep_cmd(dep, cmd, &params);
> +	/*
> +	 * If the End Transfer command was timed out while the device is
> +	 * not in SETUP phase, it's possible that an incoming Setup packet
> +	 * may prevent the command's completion. Let's retry when the
> +	 * ep0state returns to EP0_SETUP_PHASE.
> +	 */
> +	if (ret == -ETIMEDOUT && dep->dwc->ep0state != EP0_SETUP_PHASE) {
> +		dep->flags |= DWC3_EP_DELAY_STOP;
> +		return 0;
> +	}
>   	WARN_ON_ONCE(ret);
>   	dep->resource_index = 0;
>   
> @@ -3719,7 +3729,7 @@ void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
>   	 * timeout. Delay issuing the End Transfer command until the Setup TRB is
>   	 * prepared.
>   	 */
> -	if (dwc->ep0state != EP0_SETUP_PHASE) {
> +	if (dwc->ep0state != EP0_SETUP_PHASE && !dwc->delayed_status) {
>   		dep->flags |= DWC3_EP_DELAY_STOP;
>   		return;
>   	}
> 
> base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780
