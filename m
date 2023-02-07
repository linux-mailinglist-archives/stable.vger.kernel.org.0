Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5703A68CD24
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 04:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjBGDNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 22:13:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBGDNn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 22:13:43 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B5814490;
        Mon,  6 Feb 2023 19:13:42 -0800 (PST)
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3172C3m9013776;
        Tue, 7 Feb 2023 03:13:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=smUu0KqA8nxvqZWVjdSpMGXHrp8MSM1Ao/dSlFdeWlY=;
 b=HfqTowwO/Xflp4tmg0cie7Cn0iz9y60B6IyZI2ET8uuQa7osRb/lRfq8Lwuv+wMFIAl/
 +A02/9Xvxztklbkbhdf9hmxsrJcB/97QHEMhbDztUDJCxnHMEGM+OP6J2y2ac2ZKozwt
 lgGh/zon3PjmsZpo2rPZ/eKfFm6rAJwbMenDZZ2EpRW2XH+1Jb1nGJ1VRQQ/R40oBa4q
 v/uEqhyTqemct9VD4MKw/xGUVgk/MnPcwrITd/o745PmiZCNZGrvEtkL4n3101o5AYZ/
 FouK40UQk2fFoJ3QIXbT4EfTKj/dwvXAC6RjzG2tllxqxkvzfcWsBps7M6h4BTeS6dHp pg== 
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3nheb0wa4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 03:13:28 +0000
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
        by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3173DRCX019578
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 7 Feb 2023 03:13:27 GMT
Received: from [10.47.206.1] (10.49.16.6) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 19:13:27 -0800
Message-ID: <efab844a-4ffe-bc68-d99e-8688ad222e3a@quicinc.com>
Date:   Mon, 6 Feb 2023 19:12:43 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 01/22] rtc: pm8xxx: fix set-alarm race
Content-Language: en-US
To:     Johan Hovold <johan+linaro@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Bjorn Andersson <andersson@kernel.org>
CC:     Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        <linux-arm-msm@vger.kernel.org>, <linux-rtc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20230202155448.6715-1-johan+linaro@kernel.org>
 <20230202155448.6715-2-johan+linaro@kernel.org>
From:   David Collins <quic_collinsd@quicinc.com>
In-Reply-To: <20230202155448.6715-2-johan+linaro@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: c3uBQBVhOjnB3ngB7UUuQJDCIXLtNq3z
X-Proofpoint-GUID: c3uBQBVhOjnB3ngB7UUuQJDCIXLtNq3z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-06_07,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=826 adultscore=0 phishscore=0 clxscore=1011 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302070027
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/2/23 07:54, Johan Hovold wrote:
> Make sure to disable the alarm before updating the four alarm time
> registers to avoid spurious alarms during the update.

What scenario can encounter a spurious alarm triggering upon writing the
new alarm time inside of pm8xxx_rtc_set_alarm()?

> Note that the disable needs to be done outside of the ctrl_reg_lock
> section to prevent a racing alarm interrupt from disabling the newly set
> alarm when the lock is released.

What scenario shows the IRQ race issue that you mentioned?  How does not
protecting this register write with a lock avoid the race condition?

> Fixes: 9a9a54ad7aa2 ("drivers/rtc: add support for Qualcomm PMIC8xxx RTC")
> Cc: stable@vger.kernel.org      # 3.1
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
>  drivers/rtc/rtc-pm8xxx.c | 24 ++++++++++--------------
>  1 file changed, 10 insertions(+), 14 deletions(-)

Note that since locking is removed later in the patch series, my
questions above are mainly for the sake of curiosity.


Reviewed-by: David Collins <quic_collinsd@quicinc.com>

Thanks,
David

