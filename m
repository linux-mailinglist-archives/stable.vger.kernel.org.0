Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB7864C9BE
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 14:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238502AbiLNNIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 08:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238469AbiLNNIf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 08:08:35 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A33E4;
        Wed, 14 Dec 2022 05:08:34 -0800 (PST)
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEB8JH6002833;
        Wed, 14 Dec 2022 13:08:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=37+qGMJBgVOiGU2Fz4wlebC5TynJF0yFwPx09eBNBsw=;
 b=nYM4Dv0HlxXWRviVaJRFYRMvCsA+BH35a7Gni52RzhMu3fmC3aqpb9kkK+ydwVUUFmPX
 zbf4yGA8vQt0HuT6EiDZcwRmh1CwM1hwkJYnvrYk2g2V5381tWASQz9o4i4xuzTHf7lY
 4WHu4eauY1+mWgqtioIYoNhhGEMmvH7/ojiWM3s0RI/menLExuWzEXvOHe6ggceu9Sij
 ysQ236PmvkB0G1uJ3XsyPLKyjR9Cuf/Z7mtRnpJYgaMjPAMufXCXHxzVaS4CnjGyseAb
 7Ss8cnZ2TwCOPoOL8u4ASMQypyS+jJKuiMAtMfV7cPXPgcxWw0ZKRom9QgcLz6puMPUr /g== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3mf6rkh8m7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 13:08:25 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 2BED8ObH027896
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 13:08:24 GMT
Received: from [10.206.28.191] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 14 Dec
 2022 05:08:20 -0800
Message-ID: <214c4b8f-b86b-3e1f-d34b-ccfa756f3136@quicinc.com>
Date:   Wed, 14 Dec 2022 18:38:17 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: usb: f_fs: Fix CFI failure in ki_complete
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        John Keeping <john@metanate.com>,
        Linyu Yuan <quic_linyyuan@quicinc.com>,
        Pratham Pratap <quic_ppratap@quicinc.com>,
        Vincent Pelletier <plr.vincent@gmail.com>,
        Dan Carpenter <error27@gmail.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "# 5 . 15" <stable@vger.kernel.org>
References: <1670851464-8106-1-git-send-email-quic_prashk@quicinc.com>
 <Y5cuCMhFIaKraUyi@kroah.com>
From:   Prashanth K <quic_prashk@quicinc.com>
In-Reply-To: <Y5cuCMhFIaKraUyi@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: k0qewZkJbsEEUT1ehs75A0VdQku6mViP
X-Proofpoint-GUID: k0qewZkJbsEEUT1ehs75A0VdQku6mViP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_06,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 clxscore=1015 phishscore=0 malwarescore=0
 mlxlogscore=959 spamscore=0 suspectscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212140102
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12-12-22 07:05 pm, Greg Kroah-Hartman wrote:
> On Mon, Dec 12, 2022 at 06:54:24PM +0530, Prashanth K wrote:
>> Function pointer ki_complete() expects 'long' as its second
>> argument, but we pass integer from ffs_user_copy_worker. This
>> might cause a CFI failure, as ki_complete is an indirect call
>> with mismatched prototype. Fix this by typecasting the second
>> argument to long.
> 
> "might"?  Does it or not?  If it does, why hasn't this been reported
> before?
Sorry for the confusion in commit text, We caught a CFI (Control Flow 
Integrity) failure internally on 5.15, hence pushed this patch. But 
later I came to know that CFI was implemented on 5.4 kernel for Android. 
Will push the same on ACK and share the related details there.

Thanks.
> 
>> Cc: <stable@vger.kernel.org> # 5.15
> 
> CFI first showed up in 6.1, not 5.15, right?
> 
>> Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
>>
>> ---
>>   drivers/usb/gadget/function/f_fs.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
>> index 73dc10a7..9c26561 100644
>> --- a/drivers/usb/gadget/function/f_fs.c
>> +++ b/drivers/usb/gadget/function/f_fs.c
>> @@ -835,7 +835,7 @@ static void ffs_user_copy_worker(struct work_struct *work)
>>   		kthread_unuse_mm(io_data->mm);
>>   	}
>>   
>> -	io_data->kiocb->ki_complete(io_data->kiocb, ret);
>> +	io_data->kiocb->ki_complete(io_data->kiocb, (long)ret);
> 
> Why just fix up this one instance?  What about ep_user_copy_worker()?
> And what about all other calls to ki_complete that are not using a
> (long) cast?
> 
> This feels wrong, what exactly is the reported error and how come other
> kernel calls to this function pointer have not had a problem with CFI?
> ceph_aio_complete() would be another example, right?
> 
> thanks,
> 
> greg k-h
