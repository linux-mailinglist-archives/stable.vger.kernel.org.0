Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B878165F098
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 16:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbjAEP4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 10:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234603AbjAEP4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 10:56:09 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCA7632D;
        Thu,  5 Jan 2023 07:56:08 -0800 (PST)
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 305DvBxm028713;
        Thu, 5 Jan 2023 15:56:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=CtPIhHeAJA4m+zVi/FDKTYFd5B/YC6Qu98yEWmwyBT8=;
 b=YEMflYDb0nYr+oKTjJTERmOF2dqGaZIXCZXSt09SOHoHOmCNWNkuwvu9ZwssvsY3DmvH
 4iYsntDV+gRdvwd+oeX21Gt3BGC4mriRoSzU5++0D1/WwZraFYg33NBnP9gc1VuCnbub
 huSDpHjHcaq7G6D4GfWmqy6NN/mlHsI6VruObBTW1978xiUotndrDLFQFX3hrLE7ZUoS
 Og1S4RfqKGlNxJMnmmY0/doQ80ZCvyRE2Qq9F6Kqny04cKxotFfSejxFZ7811fF7DTni
 EprEJFNfDfVY6E9DhCAINBKjkEkDz3IAw01tfru1GSYjSKU4EalHa7Pf51hFDZsblHW5 vw== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3mwpc299r1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 15:56:04 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 305Fu3wm013402
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 5 Jan 2023 15:56:03 GMT
Received: from [10.226.59.182] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 5 Jan 2023
 07:56:03 -0800
Message-ID: <40f16530-304e-3916-e5f2-7556e2e9b7dd@quicinc.com>
Date:   Thu, 5 Jan 2023 08:56:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 5/6] bus: mhi: ep: Move chan->lock to the start of
 processing queued ch ring
Content-Language: en-US
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        <mhi@lists.linux.dev>
CC:     <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20221228161704.255268-1-manivannan.sadhasivam@linaro.org>
 <20221228161704.255268-6-manivannan.sadhasivam@linaro.org>
From:   Jeffrey Hugo <quic_jhugo@quicinc.com>
In-Reply-To: <20221228161704.255268-6-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: RMOHYaUKmaD1ZziuTHpGvEcKtmWoSHQW
X-Proofpoint-ORIG-GUID: RMOHYaUKmaD1ZziuTHpGvEcKtmWoSHQW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_06,2023-01-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=752
 spamscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301050125
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/28/2022 9:17 AM, Manivannan Sadhasivam wrote:
> There is a good chance that while the channel ring gets processed, the STOP
> or RESET command for the channel might be received from the MHI host. In
> those cases, the entire channel ring processing needs to be protected by
> chan->lock to prevent the race where the corresponding channel ring might
> be reset.
> 
> While at it, let's also add a sanity check to make sure that the ring is
> started before processing it. Because, if the STOP/RESET command gets
> processed while mhi_ep_ch_ring_worker() waited for chan->lock, the ring
> would've been reset.
> 
> Cc: <stable@vger.kernel.org> # 5.19
> Fixes: 03c0bb8ec983 ("bus: mhi: ep: Add support for processing channel rings")
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---

Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
