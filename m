Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E273687880
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 10:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjBBJNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 04:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbjBBJNs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 04:13:48 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469FC5BBE;
        Thu,  2 Feb 2023 01:13:27 -0800 (PST)
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3128OtDj005306;
        Thu, 2 Feb 2023 09:12:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=OCwaJ6C1lOVND9T/swRUkWAuo/z51wRqAbF07B9mwzk=;
 b=BRneSkb0d+Wru1aZq1/mjcX1YKzDhMmOIO8A6eSlwvtoEZfKgUTCaf8MBvX7DCsgkOua
 oSLmG/q/ZdRHmrathK5MC2asi43cPd+DTAiDsTzP6UkBv0Alvw5vaLUKlZVnu8qa648k
 +yOmUCE3LaDBJKHXhOn/5/yGUxJh73CsB4GLJl2LNH2x/kiJmO2uJLqcoF4otzfcZAEB
 T7juN4gYHWC+UIDGN3oOgK+O0+I8KUbiZ5ol3UkmPEZdxbuss2V/KVXv+WD/3uUqGnYE
 NmLJ57+58BdUs7zzyGBjUxWRhkAXxod8JukNNTXoEG4vOd5kgxfNOA7QwvPpQa9Rm6oS pw== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3nfkj4aqsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 09:12:26 +0000
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
        by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3129CPVj025922
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 2 Feb 2023 09:12:25 GMT
Received: from [10.239.154.244] (10.80.80.8) by nalasex01b.na.qualcomm.com
 (10.47.209.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 01:12:23 -0800
Message-ID: <d6e66c50-421d-f57e-fae3-1a4e14dce780@quicinc.com>
Date:   Thu, 2 Feb 2023 17:12:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] usb: dwc3: update link state when process wakeup
 interrupt
Content-Language: en-US
From:   Linyu Yuan <quic_linyyuan@quicinc.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jack Pham <quic_jackp@quicinc.com>,
        Wesley Cheng <quic_wcheng@quicinc.com>,
        "Elson Roy Serrao" <quic_eserrao@quicinc.com>
References: <1675221286-23833-1-git-send-email-quic_linyyuan@quicinc.com>
 <20230201190550.jozzrvwdi5lcwtbo@synopsys.com>
 <197a1446-9382-3d83-d26e-694e4d707679@quicinc.com>
In-Reply-To: <197a1446-9382-3d83-d26e-694e4d707679@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: Z2V-YlaKd_Jn8PkCojCfKDzAG-i-0oD6
X-Proofpoint-ORIG-GUID: Z2V-YlaKd_Jn8PkCojCfKDzAG-i-0oD6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-02_01,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 impostorscore=0 mlxscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=724 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302020086
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


hi Thinh,


do you prefer below change ? will it be good for all cases ?


+static void dwc3_gadget_update_link_state(struct dwc3 *dwc,
+               const struct dwc3_event_devt *event)
+{
+       switch (event->type) {
+       case DWC3_DEVICE_EVENT_HIBER_REQ:
+       case DWC3_DEVICE_EVENT_LINK_STATUS_CHANGE:
+       case DWC3_DEVICE_EVENT_SUSPEND:
+               break;
+       default:
+               dwc->link_state = event->event_info & DWC3_LINK_STATE_MASK;
+               break;
+       }
+}
+
  static void dwc3_gadget_interrupt(struct dwc3 *dwc,
                 const struct dwc3_event_devt *event)
  {
+       dwc3_gadget_update_link_state(dwc3, event);
+
         switch (event->type)


