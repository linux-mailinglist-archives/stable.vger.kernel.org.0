Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4F667829B
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 18:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbjAWRKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 12:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbjAWRKR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 12:10:17 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5203A7;
        Mon, 23 Jan 2023 09:10:16 -0800 (PST)
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NGvN6J026960;
        Mon, 23 Jan 2023 17:10:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=pTuOp5LlMUVJWR1XuURU/ySq8b3L4N71BJXYI/OV+6E=;
 b=MizU+vAIFrxeHgG3Nw8kzDabUB3yyGEesamgjRdIugYNUF90iDknigCtVi3MEwkHuDEX
 8GUYzix1F5ugVfoF2WI7h03KJQyMKZyXkr45TPboac09oZJFuEJGZwm28ABqOzr4IAbr
 /eXl1jjNBrFmc4aSiet/RwpuZMCMkwfaIWJiyzjWIDgQWFF1OQxqrxatWk4tldm7hr1f
 ZKhva2YLPJuWavmLkk/iEfON94dac7GDC2snJ73m5Og5VRJxxXQsR3NSywx6UrWRCan1
 kyLhj8jZPdnrkaYj4qe/Wdr4j6OZoems00DoukfOn1N5GEUr+uk2Y96iI0ng2jVyRAbK 4Q== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3n89gt3cuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 17:10:08 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 30NHA7GO007117
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 17:10:07 GMT
Received: from [10.226.59.182] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 23 Jan
 2023 09:10:07 -0800
Message-ID: <59422195-28eb-4617-2529-5e997e5a7903@quicinc.com>
Date:   Mon, 23 Jan 2023 10:10:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH] bus: mhi: ep: Change state_lock to mutex
Content-Language: en-US
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        <mhi@lists.linux.dev>
CC:     <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Dan Carpenter <error27@gmail.com>
References: <20230123075049.168040-1-manivannan.sadhasivam@linaro.org>
From:   Jeffrey Hugo <quic_jhugo@quicinc.com>
In-Reply-To: <20230123075049.168040-1-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: n9SL77rLGTAsIWFNr5Pd4S64zT4LmzVV
X-Proofpoint-ORIG-GUID: n9SL77rLGTAsIWFNr5Pd4S64zT4LmzVV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=376 spamscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 adultscore=0
 clxscore=1011 mlxscore=0 suspectscore=0 phishscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230165
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/23/2023 12:50 AM, Manivannan Sadhasivam wrote:
> state_lock, the spinlock type is meant to protect race against concurrent
> MHI state transitions. In mhi_ep_set_m0_state(), while the state_lock is
> being held, the channels are resumed in mhi_ep_resume_channels() if the
> previous state was M3. This causes sleeping in atomic bug, since
> mhi_ep_resume_channels() use mutex internally.
> 
> Since the state_lock is supposed to be held throughout the state change,
> it is not ideal to drop the lock before calling mhi_ep_resume_channels().
> So to fix this issue, let's change the type of state_lock to mutex. This
> would also allow holding the lock throughout all state transitions thereby
> avoiding any potential race.
> 
> Cc: <stable@vger.kernel.org> # 5.19
> Fixes: e4b7b5f0f30a ("bus: mhi: ep: Add support for suspending and resuming channels")
> Reported-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Looks sane.
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
