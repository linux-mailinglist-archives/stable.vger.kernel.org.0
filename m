Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83D965E47E
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 05:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjAEEMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 23:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbjAEEMX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 23:12:23 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B255913D39;
        Wed,  4 Jan 2023 20:12:22 -0800 (PST)
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30543kV0020204;
        Thu, 5 Jan 2023 04:12:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=h5tJprJsUMF2KrpzE35hPHeUJaUoqcYRm33Jr1+Uiz8=;
 b=SXELPZuCkDbzv6IDx0TVcWBC+5uMl1C28omqH7nE13pTRfPfZEsWNdIDK3tGjWV2FMcz
 VGLOGVmoccWd6SIbHCgTmSKeoVf1AUoyWnoy8bZEJkcKovRZsn5NgxIHtICwvSE9177m
 5GnOqHSNbxw7lxIWea0pI4Dt0NNhQjGhHu06FOm7OjJwnKE+kx8cwiZVpeiSO96XL+do
 ttBJj4omQIcjkd4xcwvDXPGQgenSSl8tNDoGBVr7vVnKRT/zFnoWz9Dya1mVbrSWLXeQ
 CZ/PL1T5oJW5GtzW4lGDmzXidx0DJyYf/mU169GdxpIb+pK3AeiuxFDSywrOiRXrfoPc AQ== 
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3mvsvf3dbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 04:12:14 +0000
Received: from nasanex01a.na.qualcomm.com (corens_vlan604_snip.qualcomm.com [10.53.140.1])
        by NASANPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3054CDeQ007848
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 5 Jan 2023 04:12:14 GMT
Received: from [10.226.59.182] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 4 Jan 2023
 20:12:13 -0800
Message-ID: <8b145e5a-f021-795d-a083-636a3ac3cf74@quicinc.com>
Date:   Wed, 4 Jan 2023 21:12:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 3/6] bus: mhi: ep: Only send -ENOTCONN status if client
 driver is available
Content-Language: en-US
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        <mhi@lists.linux.dev>
CC:     <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20221228161704.255268-1-manivannan.sadhasivam@linaro.org>
 <20221228161704.255268-4-manivannan.sadhasivam@linaro.org>
From:   Jeffrey Hugo <quic_jhugo@quicinc.com>
In-Reply-To: <20221228161704.255268-4-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: jt5fE1gYFq_pf0Gh0VUaVfVIRLjidT8l
X-Proofpoint-GUID: jt5fE1gYFq_pf0Gh0VUaVfVIRLjidT8l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_07,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 clxscore=1011 priorityscore=1501 spamscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=984 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301050033
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/28/2022 9:17 AM, Manivannan Sadhasivam wrote:
> For the STOP and RESET commands, only send the channel disconnect status
> -ENOTCONN if client driver is available. Otherwise, it will result in
> null pointer dereference.
> 
> Cc: <stable@vger.kernel.org> # 5.19
> Fixes: e827569062a8 ("bus: mhi: ep: Add support for processing command rings")
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
