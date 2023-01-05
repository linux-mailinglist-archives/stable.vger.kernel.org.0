Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE2D65F09F
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 16:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbjAEP6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 10:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234813AbjAEP54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 10:57:56 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D77F66;
        Thu,  5 Jan 2023 07:57:55 -0800 (PST)
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 305DtCqG025495;
        Thu, 5 Jan 2023 15:57:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=Xo83gKabN1O0R3UktLS+Q+GhShKE1s8GwQ3eMi8lJz4=;
 b=NbnolHFEWM3w95DY3Ud7bVyUCp7CeeoE7FTgNCjVcO7UhiS2r1nDuBYYvy3t2OvcEZcV
 uHNW9WFO60wcwMuf0kn/EWjXDxkTrmPRtXrWcPOwLZ+Az7Ft7kwWtF086kwTN1zpDVl0
 UxTxdabTaOtm4cxjLic/3KgPggkKstmrBO31EcPzMZAqb19ZaZSnAEgK/dQyZ71fSACG
 LFfM9P5qwgj2tYKvhg2E3iDq2bOt69KTDjB8SFNx/ziMU4whaTgAxRWjhb33iYu0+o9O
 RhEbLMVhupvT9puOVD07YBp1hjd2e1H+C/86Fb+fWesdgEeks8BkqYq0snu8PYcxVtuI Zw== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3mwu4vrqaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 15:57:51 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 305FvoVx032293
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 5 Jan 2023 15:57:50 GMT
Received: from [10.226.59.182] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 5 Jan 2023
 07:57:50 -0800
Message-ID: <4497ea5f-e255-12a3-78ca-7210d34e3762@quicinc.com>
Date:   Thu, 5 Jan 2023 08:57:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 6/6] bus: mhi: ep: Save channel state locally during
 suspend and resume
Content-Language: en-US
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        <mhi@lists.linux.dev>
CC:     <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20221228161704.255268-1-manivannan.sadhasivam@linaro.org>
 <20221228161704.255268-7-manivannan.sadhasivam@linaro.org>
From:   Jeffrey Hugo <quic_jhugo@quicinc.com>
In-Reply-To: <20221228161704.255268-7-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: bnNwF8f_R4Sa1sDzZ8yNUNgLm8zcM9pV
X-Proofpoint-ORIG-GUID: bnNwF8f_R4Sa1sDzZ8yNUNgLm8zcM9pV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_06,2023-01-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=889 phishscore=0 suspectscore=0
 impostorscore=0 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301050125
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/28/2022 9:17 AM, Manivannan Sadhasivam wrote:
> During suspend and resume, the channel state needs to be saved locally.
> Otherwise, the endpoint may access the channels while they were being
> suspended and causing access violations.
> 
> Fix it by saving the channel state locally during suspend and resume.
> 
> Cc: <stable@vger.kernel.org> # 5.19
> Fixes: e4b7b5f0f30a ("bus: mhi: ep: Add support for suspending and resuming channels")
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com)
