Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECF8601AD6
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 23:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiJQVAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 17:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiJQVAc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 17:00:32 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF7F9FDA;
        Mon, 17 Oct 2022 14:00:31 -0700 (PDT)
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29HK4Aax020772;
        Mon, 17 Oct 2022 21:00:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=D6PTclKQckbCBwVMkCe4UAqivm2Mn3NOcSkfQ97wmcQ=;
 b=E1RePHdfKe11rBb+dSirSyRR0iIfodoh/2kZKieOo+/ZyZnxGyNkJGJSxZBl9Z2/6DT3
 J882FBGj0jqWCTylrJAqq57eysdP5+x4gXzhOMCxoCd6MBT5xnG+uD3O4L7+rwttF/2u
 xJdwBrgOwmbZ5jHkpL1VG/HXJCbl2cjnWre07mggs69vkRsTl3EIHgvA1Tj5xPb5wYaK
 pEUTMTwnkhDFxlgI757DlIb2N2sHa9PI3RrEAmUbi7T1/tn2GbKSnSVNicoubxhXDbpZ
 uN9VzWWKvzPztFX0LgHXMazeMc4M5km+PR9GNb0ZU6p6zuHmq1ODkIA+2w7obI+2kxfx Fw== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3k7m6ud249-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Oct 2022 21:00:00 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 29HKxxs2014897
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Oct 2022 20:59:59 GMT
Received: from [10.110.49.5] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 17 Oct
 2022 13:59:58 -0700
Message-ID: <75d65e4c-961a-0338-8101-d1ea05542dd6@quicinc.com>
Date:   Mon, 17 Oct 2022 13:59:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH] usb: gadget: aspeed: Fix probe regression
Content-Language: en-US
To:     Joel Stanley <joel@jms.id.au>, Zev Weiss <zev@bewilderbeest.net>
CC:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Jeffery <andrew@aj.id.au>, <linux-usb@vger.kernel.org>,
        <linux-aspeed@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20221017053006.358520-1-joel@jms.id.au>
 <Y029u+ZZZikW4fYl@hatter.bewilderbeest.net>
From:   Jae Hyun Yoo <quic_jaehyoo@quicinc.com>
In-Reply-To: <Y029u+ZZZikW4fYl@hatter.bewilderbeest.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: LybL_bHUFg_clhpM2JtrDF-UVpm83T9R
X-Proofpoint-GUID: LybL_bHUFg_clhpM2JtrDF-UVpm83T9R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_13,2022-10-17_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 bulkscore=0 spamscore=0 malwarescore=0 mlxlogscore=918 priorityscore=1501
 suspectscore=0 clxscore=1011 adultscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210170119
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/17/2022 1:40 PM, Zev Weiss wrote:
> On Sun, Oct 16, 2022 at 10:30:06PM PDT, Joel Stanley wrote:
>> Since commit fc274c1e9973 ("USB: gadget: Add a new bus for gadgets"),
>> the gadget devices are proper driver core devices, which caused each
>> device to request pinmux settings:
>>
>> aspeed_vhub 1e6a0000.usb-vhub: Initialized virtual hub in USB2 mode
>> aspeed-g5-pinctrl 1e6e2080.pinctrl: pin A7 already requested by 
>> 1e6a0000.usb-vhub; cannot claim for gadget.0
>> aspeed-g5-pinctrl 1e6e2080.pinctrl: pin-232 (gadget.0) status -22
>> aspeed-g5-pinctrl 1e6e2080.pinctrl: could not request pin 232 (A7) 
>> from group USB2AD  on device aspeed-g5-pinctrl
>> g_mass_storage gadget.0: Error applying setting, reverse things back
>>
>> The vhub driver has already claimed the pins, so prevent the gadgets
>> from requesting them too by setting the magic of_node_reused flag. This
>> causes the driver core to skip the mux request.
>>
>> Reported-by: Zev Weiss <zev@bewilderbeest.net>
>> Reported-by: Jae Hyun Yoo <quic_jaehyoo@quicinc.com>
>> Fixes: fc274c1e9973 ("USB: gadget: Add a new bus for gadgets")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Joel Stanley <joel@jms.id.au>
> 
> Thanks Joel!
> 
> Tested-by: Zev Weiss <zev@bewilderbeest.net>

It works for my AST2600 build targets too. Thanks Joel!

Tested-by: Jae Hyun Yoo <quic_jaehyoo@quicinc.com>
