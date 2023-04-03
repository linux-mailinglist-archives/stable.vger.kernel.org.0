Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A52D6D5105
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 20:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbjDCSvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 14:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbjDCSvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 14:51:08 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522121BFB;
        Mon,  3 Apr 2023 11:51:07 -0700 (PDT)
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3339kfIV023192;
        Mon, 3 Apr 2023 18:50:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=nt/8bJi9Qxp+v5aglNRxusY+X3VTlioUN3gK3uI0gJE=;
 b=FCloFJ4dJyKD+qbWEkDSZ0PirVjxuv2QsezUmGvO4APuH+UWfvfCjSI7d+GwF8OO4woB
 EdCPlaWmmWAjBo6O/9r5pr159pp57qgquCjW6k1Rj584boqwDe3SayKbzLhTL/ul96Ia
 KKOUnzwwBRIaxUoNzMPhQYpAV0m6Wwtt7g+Yvg2xoCW8wor1kmpmLaSB8Oky7iTl7jve
 wuV239m9s/Gw6e/KMbf6ERWMlDh9qICZ5bx+7fAenEMxYCnDWeUp1wOSfmZWADcBivar
 XzuJeydArr2NWSWhoDAttq75yKFnQ64+sdZymSmyo43dA0aJ11pWJyxt6KWvgFsfeHiO 2Q== 
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3pqusu1dsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 18:50:58 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 333Iou6M004019
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 3 Apr 2023 18:50:56 GMT
Received: from [10.226.59.182] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Mon, 3 Apr 2023
 11:50:55 -0700
Message-ID: <59e68312-9bd0-73b1-2d18-cd5744588070@quicinc.com>
Date:   Mon, 3 Apr 2023 12:50:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v2] PCI: hv: Fix the definition of vector in
 hv_compose_msi_msg()
Content-Language: en-US
To:     Dexuan Cui <decui@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "quic_carlv@quicinc.com" <quic_carlv@quicinc.com>
CC:     Boqun Feng <boqun.feng@gmail.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20221027205256.17678-1-decui@microsoft.com>
 <ZCTsPFb7dBj2IZmo@boqun-archlinux> <ZCT6JEK/yGpKHVLn@boqun-archlinux>
 <SA1PR21MB13354973735A5E727F94A169BF8E9@SA1PR21MB1335.namprd21.prod.outlook.com>
 <ZCUk_9YQGSfedCOR@kroah.com>
 <SA1PR21MB13350093800BC2C387EE0648BF8E9@SA1PR21MB1335.namprd21.prod.outlook.com>
From:   Jeffrey Hugo <quic_jhugo@quicinc.com>
In-Reply-To: <SA1PR21MB13350093800BC2C387EE0648BF8E9@SA1PR21MB1335.namprd21.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: jbM0HfIxhn9L3qp6398K3X7BVqbYKTf3
X-Proofpoint-ORIG-GUID: jbM0HfIxhn9L3qp6398K3X7BVqbYKTf3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-03_15,2023-04-03_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 clxscore=1011
 priorityscore=1501 mlxlogscore=878 impostorscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304030144
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/30/2023 1:50 PM, Dexuan Cui wrote:
>> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> ...
>>> e70af8d040d2 has a Fixes tag. Not sure why it's not automatically
>> backported.
>>
>> Because "Fixes:" is not the flag that we are sure to trigger off of.
>> Please read:
>> https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>> for how to do this properly.
> 
> Thanks, I just read this again to refresh my memory :-)
> I remember Sasha has an AI algorithm to pick up patches into the stable
> tree and a "Fixes" tag should be a strong indicator.
> 
> I tired to manually cherry-pick e70af8d040d2 to 5.15.y and got some
> merge conflicts. Probably that's why Sasha's script didn't automatically
> do the backport. @Carl, @Jeffrey, may I know if you have some cycles to
> help backport e70af8d040d2?

We might have some cycles this week.

-Jeff
