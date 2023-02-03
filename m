Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEBE688D16
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 03:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjBCCby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 21:31:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjBCCbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 21:31:53 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2272278F;
        Thu,  2 Feb 2023 18:31:52 -0800 (PST)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 313297gv028705;
        Fri, 3 Feb 2023 02:31:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=jv3epMqncONzbIT4T8Ty/1OW0lkMcwgsh14aoGpR0MA=;
 b=LpYiRQ/L/L44b0IXw2vGmBeOb4EN0u7YGvJyyRq7M3lMDGfu3O0q69lMCG4dd+bOpW6U
 /a2BFbYx+p2Z8mOYaGw9eH8IO8yWzfcEc/Sk0eFFd0VqGO9fdVd5TWmexuRp6Nb6Ma6p
 O14/45tPg0nJFty+MzP3SasW/wDRQ46MGaaBh9RorbkXVBjqfZYpJUmLIOdze39kzCvb
 kBoGWKBbK0yju+km+tY4u31i36dsWOJcuiI5H99PZIqpC3j4g751RZzhoRqM8U3Z9MqP
 DABFobrWTZungox/DdNdvmXCKbi4Gc+62b1V6myInP7IK9OflvlFN47GxGipz/lrRO/g gQ== 
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ngncv0e9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 02:31:50 +0000
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
        by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3132Vn92005829
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 3 Feb 2023 02:31:49 GMT
Received: from [10.239.154.244] (10.80.80.8) by nalasex01b.na.qualcomm.com
 (10.47.209.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 18:31:46 -0800
Message-ID: <47a6e9cb-e07c-2296-c9f1-6c7f92abd670@quicinc.com>
Date:   Fri, 3 Feb 2023 10:31:44 +0800
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
        Wesley Cheng <quic_wcheng@quicinc.com>,
        "Elson Roy Serrao" <quic_eserrao@quicinc.com>,
        Prashanth K <quic_prashk@quicinc.com>
References: <1675221286-23833-1-git-send-email-quic_linyyuan@quicinc.com>
 <20230201190550.jozzrvwdi5lcwtbo@synopsys.com>
 <197a1446-9382-3d83-d26e-694e4d707679@quicinc.com>
 <d6e66c50-421d-f57e-fae3-1a4e14dce780@quicinc.com>
 <20230202203841.5vxxtejol3zyjjef@synopsys.com>
 <20230202235838.5d3a5lgdspahk6od@synopsys.com>
From:   Linyu Yuan <quic_linyyuan@quicinc.com>
In-Reply-To: <20230202235838.5d3a5lgdspahk6od@synopsys.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: SIFaBn7rJXt3urA88S09jbAcArR4B5YB
X-Proofpoint-GUID: SIFaBn7rJXt3urA88S09jbAcArR4B5YB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-02_16,2023-02-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0
 mlxlogscore=854 mlxscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302030021
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2/3/2023 7:58 AM, Thinh Nguyen wrote:
> On Thu, Feb 02, 2023, Thinh Nguyen wrote:
>> On Thu, Feb 02, 2023, Linyu Yuan wrote:
>>> hi Thinh,
>>>
>>>
>>> do you prefer below change ? will it be good for all cases ?
>>>
>>>
>>> +static void dwc3_gadget_update_link_state(struct dwc3 *dwc,
>>> +               const struct dwc3_event_devt *event)
>>> +{
>>> +       switch (event->type) {
>>> +       case DWC3_DEVICE_EVENT_HIBER_REQ:
>>> +       case DWC3_DEVICE_EVENT_LINK_STATUS_CHANGE:
>>> +       case DWC3_DEVICE_EVENT_SUSPEND:
>>> +               break;
>>> +       default:
>>> +               dwc->link_state = event->event_info & DWC3_LINK_STATE_MASK;
>>> +               break;
>>> +       }
>>> +}
>>> +
>>>   static void dwc3_gadget_interrupt(struct dwc3 *dwc,
>>>                  const struct dwc3_event_devt *event)
>>>   {
>>> +       dwc3_gadget_update_link_state(dwc3, event);
>>> +
>>>          switch (event->type)
>>>
>>>
>> This would break the check in dwc3_gadget_suspend_interrupt(). However,
>> I'm actually not sure why we had that check in the beginning. I suppose
>> certain setup may trigger suspend event multiple time consecutively?
>>
> Actually, looking at it again, you're skipping updating the events
> listed above and not for every event. So that should work. For some
> reason, I thought you want to update the link_state for every new event.


the reason why suggest new change is because we found it also need 
update link state in other case,

e.g. suspend -> reset ->conndone -> suspend


>
> However, this would complicate the driver. Now we have to remember when
> to set the link_state and when not to, and when to check the previous
> link_state. On top of that, dwc->link_state may not reflect the current
> state of the controller either, which makes it more confusing.


agree now it is complicate.


>
> Perhaps we should not update dwc->link_state outside of link state
> change event, and just track whether we called gadget_driver->suspend()
> to call the correspond resume() on wakeup? It can be tracked with
> dwc->gadget_driver_is_suspended.


could you help provide a change for this idea ?


>
> Thanks,
> Thinh
>
