Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCCF668759C
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 06:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjBBFwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 00:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbjBBFv4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 00:51:56 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70ED84B89E;
        Wed,  1 Feb 2023 21:51:28 -0800 (PST)
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3125MKxh027015;
        Thu, 2 Feb 2023 05:51:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=46a241Qrz+Hgzj/mu1IRBLRssCv218yOz5mY3agGF2E=;
 b=S8gzdTt3Wj35CmcF2VdhNUM1m4evjb4ti3Kx4Ur9jfNChn+LQCnJUfQaqJpgchVs6xz0
 nCZLw+BUN0c4iF1PsSYHfBZKvKxdaL72BwKP4KqCTRjPH7AVM3OQVRz2TcIc4I1xK8hM
 zY0tCjfRNGcoCTyxtYn5lMiUmxak3ahofuKQ1+oTOVQ2LKFmzKbimHB9DKmwWCslpO5Z
 bu66kSgUyGOUELbDsvJCbGsTGNx286X6QQB6jt26/dB9gBSzGCwhjBh6VHoGEb/XqOEm
 pWAbtRFIfc5gCsWgay9s6frvKBjruYODu3n1CgA7B0O1GXRgMzvNW6G6ZOHHdaHHALAg 3w== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3nfqt3hsv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 05:51:25 +0000
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3125pOEa014989
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 2 Feb 2023 05:51:24 GMT
Received: from [10.233.19.102] (10.80.80.8) by nalasex01b.na.qualcomm.com
 (10.47.209.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 21:51:22 -0800
Message-ID: <197a1446-9382-3d83-d26e-694e4d707679@quicinc.com>
Date:   Thu, 2 Feb 2023 13:51:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] usb: dwc3: update link state when process wakeup
 interrupt
Content-Language: en-US
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jack Pham <quic_jackp@quicinc.com>,
        Wesley Cheng <quic_wcheng@quicinc.com>
References: <1675221286-23833-1-git-send-email-quic_linyyuan@quicinc.com>
 <20230201190550.jozzrvwdi5lcwtbo@synopsys.com>
From:   Linyu Yuan <quic_linyyuan@quicinc.com>
In-Reply-To: <20230201190550.jozzrvwdi5lcwtbo@synopsys.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: RRQlmk7snKutWypixmhAlaTBlHKpWhBX
X-Proofpoint-GUID: RRQlmk7snKutWypixmhAlaTBlHKpWhBX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-01_15,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 adultscore=0 mlxlogscore=751 impostorscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302020054
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2/2/2023 3:05 AM, Thinh Nguyen wrote:
> On Wed, Feb 01, 2023, Linyu Yuan wrote:
>> Consider there is interrpt sequences as suspend (U3) -> wakeup (U0) ->
> interrupt?


thanks, will change next version.


>
>> suspend (U3), as there is no update to link state in wakeup interrupt,
> Instead of "no update", can you note in the commit that the link state
> change event is not enabled for most devices, so the driver doesn't
> update its link_state.


thanks, will change next version.


>
>> the second suspend interrupt will not report to upper layer.
>>
>> Fix it by update link state in wakeup interrupt handler.
>>
>> Cc: stable@vger.kernel.org
> Can you add fix tag?


seem this change can apply to all current stable kernel.

I think CC stable is good. also it is not good to find appreciate tag.


>
>> Signed-off-by: Linyu Yuan <quic_linyyuan@quicinc.com>
>> ---
>>   drivers/usb/dwc3/gadget.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
>> index 89dcfac..3533241 100644
>> --- a/drivers/usb/dwc3/gadget.c
>> +++ b/drivers/usb/dwc3/gadget.c
>> @@ -4066,7 +4066,7 @@ static void dwc3_gadget_conndone_interrupt(struct dwc3 *dwc)
>>   	 */
>>   }
>>   
>> -static void dwc3_gadget_wakeup_interrupt(struct dwc3 *dwc)
>> +static void dwc3_gadget_wakeup_interrupt(struct dwc3 *dwc, unsigned int evtinfo)
>>   {
>>   	/*
>>   	 * TODO take core out of low power mode when that's
>> @@ -4078,6 +4078,8 @@ static void dwc3_gadget_wakeup_interrupt(struct dwc3 *dwc)
>>   		dwc->gadget_driver->resume(dwc->gadget);
>>   		spin_lock(&dwc->lock);
>>   	}
>> +
>> +	dwc->link_state = evtinfo & DWC3_LINK_STATE_MASK;
>>   }
>>   
>>   static void dwc3_gadget_linksts_change_interrupt(struct dwc3 *dwc,
>> @@ -4227,7 +4229,7 @@ static void dwc3_gadget_interrupt(struct dwc3 *dwc,
>>   		dwc3_gadget_conndone_interrupt(dwc);
>>   		break;
>>   	case DWC3_DEVICE_EVENT_WAKEUP:
>> -		dwc3_gadget_wakeup_interrupt(dwc);
>> +		dwc3_gadget_wakeup_interrupt(dwc, event->event_info);
>>   		break;
>>   	case DWC3_DEVICE_EVENT_HIBER_REQ:
>>   		if (dev_WARN_ONCE(dwc->dev, !dwc->has_hibernation,
>> -- 
>> 2.7.4
>>
> Thanks,
> Thinh
