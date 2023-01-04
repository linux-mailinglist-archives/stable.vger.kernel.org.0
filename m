Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF2AB65D530
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239490AbjADOMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239678AbjADOLv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:11:51 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5F811A1A;
        Wed,  4 Jan 2023 06:10:58 -0800 (PST)
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 304DcWhg021439;
        Wed, 4 Jan 2023 14:10:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=date : from : to :
 cc : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=qcppdkim1; bh=x9OOQVyq/BLgjeDzLgMuVgKdwd13+INdbkP4hoyCx8M=;
 b=bJGXPFvwLGBs9NEGo/ZbNduNVWLWAJfUYlYhcyAvUD3ECmRrdNURr84t85beyjtUUSBu
 bQXBeUEVlKmtf889NvVg6pNJSsU08LtEi9ztzZKkfEGXq+OokDDuKAvayuVRdb/rntab
 +jOS9Ec1/Igkm/r1xRq4JP89xGAtDFNcw2+OPgssAVfI/zdnqvWyUjVW/xRLFI5HTB2c
 OOMCKo0TrdsQLy9ySpU9+0eQvogfXq1/sn1bjyuzL76luoPTJ5BGqIULN1tga3a8tXZy
 2Ua4NB+IJClbUslNhdgrosiCjvyQ/e8DQcdIR7sdECCcmExbUf0IelyhFoVEWM2i9f6V tQ== 
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3mvsvf9xtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 14:10:48 +0000
Received: from nasanex01a.na.qualcomm.com (corens_vlan604_snip.qualcomm.com [10.53.140.1])
        by NASANPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 304EAjoK014467
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 4 Jan 2023 14:10:45 GMT
Received: from asutoshd-linux1.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 4 Jan 2023 06:10:45 -0800
Date:   Wed, 4 Jan 2023 06:10:45 -0800
From:   Asutosh Das <quic_asutoshd@quicinc.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Johan Hovold <johan+linaro@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Can Guo <quic_cang@quicinc.com>
Subject: Re: [PATCH] scsi: ufs: core: fix devfreq deadlocks
Message-ID: <20230104141045.GB8114@asutoshd-linux1.qualcomm.com>
References: <20221222102121.18682-1-johan+linaro@kernel.org>
 <85e91255-1e6f-f428-5376-08416d2107a2@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Disposition: inline
In-Reply-To: <85e91255-1e6f-f428-5376-08416d2107a2@acm.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: zEqWUFqKC9RYj1dTlGriAwsalX9RpyWw
X-Proofpoint-GUID: zEqWUFqKC9RYj1dTlGriAwsalX9RpyWw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_07,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 clxscore=1011 mlxlogscore=767 priorityscore=1501 malwarescore=0
 adultscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301040120
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 03 2023 at 13:45 -0800, Bart Van Assche wrote:
>On 12/22/22 02:21, Johan Hovold wrote:
>>+	/* Enable Write Booster if we have scaled up else disable it */
>>+	if (ufshcd_enable_wb_if_scaling_up(hba))
>>+		ufshcd_wb_toggle(hba, scale_up);
>
>Hi Asutosh,
>
>This patch is the second complaint about the mechanism that toggles 
>the WriteBooster during clock scaling. Can this mechanism be removed 
>entirely?
>
>I think this commit introduced that mechanism: 3d17b9b5ab11 ("scsi: 
>ufs: Add write booster feature support"; v5.8).
>
>Thanks,
>
>Bart.

Hello Bart,
Load based toggling of WB seemed fine to me then.
I haven't thought about another method to toggle WriteBooster yet.
Let me see if I can come up with something.
IMT if you have a mechanism in mind, please let me know.

-asd

>
