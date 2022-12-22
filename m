Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7FF654152
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 13:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiLVMv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 07:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiLVMvY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 07:51:24 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336171FCD1;
        Thu, 22 Dec 2022 04:51:23 -0800 (PST)
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BMAlwfd010892;
        Thu, 22 Dec 2022 12:51:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=dQWDc633Ytw2GCHBm5Z4OBT+5qdBrfSR64+yxyehY5U=;
 b=A6I4I3zXD+b6XJ2x5w2tRukd4ZStZVXv18iAI6N6UV6uAU8C7ymhuLXgb3KNO07CKAOR
 iIUHnY5Cjxfnfx5SDXCUkuNYB+A1o5FNXw7pn1c79NrwUOzPDHgthBurCF8cCLyZ2TR6
 j4tHPu/7TXL4fy473JjmBjK0YJgaUFaRAJsq+Yhl5ImXeGP1xwX4FOGTE4TMMRAeOCSk
 y5/s5WdFYEvbsRuD5MK8U//Vf6Y73EWq160A0S32FEsDXd35vWE6eTCnUQjD7rbZxDJ7
 zR9vRpgmbrXLBJui6GaV/quf9kS7Ps6jCJNsPq1dneLVlAFMui8j8ETra3z7PDB5HgSd Ng== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3mk90t5rse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Dec 2022 12:51:11 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 2BMCpAaU005294
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Dec 2022 12:51:10 GMT
Received: from [10.206.25.6] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 22 Dec
 2022 04:51:06 -0800
Message-ID: <acdda510-945f-ff68-5c8b-a1a0290bed6d@quicinc.com>
Date:   Thu, 22 Dec 2022 18:21:03 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: usb: f_fs: Fix CFI failure in ki_complete
Content-Language: en-US
To:     David Laight <David.Laight@ACULAB.COM>,
        'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>,
        Dan Carpenter <error27@gmail.com>
CC:     "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        John Keeping <john@metanate.com>,
        Pratham Pratap <quic_ppratap@quicinc.com>,
        Vincent Pelletier <plr.vincent@gmail.com>,
        "Udipto Goswami" <quic_ugoswami@quicinc.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "# 5 . 15" <stable@vger.kernel.org>
References: <1670851464-8106-1-git-send-email-quic_prashk@quicinc.com>
 <Y5cuCMhFIaKraUyi@kroah.com>
 <abe47a47aa5d49878c58fc1199be18ea@AcuMS.aculab.com>
From:   Prashanth K <quic_prashk@quicinc.com>
In-Reply-To: <abe47a47aa5d49878c58fc1199be18ea@AcuMS.aculab.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: pFPZgNiXiluh-RTeQnpXqgMOU1DpSMA7
X-Proofpoint-ORIG-GUID: pFPZgNiXiluh-RTeQnpXqgMOU1DpSMA7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-22_05,2022-12-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 malwarescore=0
 spamscore=0 impostorscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212220112
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 14-12-22 11:05 pm, David Laight wrote:
> From: Greg Kroah-Hartman
>> Sent: 12 December 2022 13:35
>>
>> On Mon, Dec 12, 2022 at 06:54:24PM +0530, Prashanth K wrote:
>>> Function pointer ki_complete() expects 'long' as its second
>>> argument, but we pass integer from ffs_user_copy_worker. This
>>> might cause a CFI failure, as ki_complete is an indirect call
>>> with mismatched prototype. Fix this by typecasting the second
>>> argument to long.
>>
>> "might"?  Does it or not?  If it does, why hasn't this been reported
>> before?
> 
> Does the cast even help at all.
Actually I also have these same questions
- why we haven't seen any instances other than this one?
- why its not seen on other indirect function calls?

Here is the the call stack of the failure that we got.

[  323.288681][    T7] Kernel panic - not syncing: CFI failure (target: 
0xffffffe5fc811f98)
[  323.288710][    T7] CPU: 6 PID: 7 Comm: kworker/u16:0 Tainted: G S 
    W  OE     5.15.41-android13-8-g5ffc5644bd20 #1
[  323.288730][    T7] Workqueue: adb ffs_user_copy_worker.cfi_jt
[  323.288752][    T7] Call trace:
[  323.288755][    T7]  dump_backtrace.cfi_jt+0x0/0x8
[  323.288772][    T7]  dump_stack_lvl+0x80/0xb8
[  323.288785][    T7]  panic+0x180/0x444
[  323.288797][    T7]  find_check_fn+0x0/0x218
[  323.288810][    T7]  ffs_user_copy_worker+0x1dc/0x204
[  323.288822][    T7]  kretprobe_trampoline.cfi_jt+0x0/0x8
[  323.288837][    T7]  worker_thread+0x3ec/0x920
[  323.288850][    T7]  kthread+0x168/0x1dc
[  323.288859][    T7]  ret_from_fork+0x10/0x20
[  323.288866][    T7] SMP: stopping secondary CPUs

And from address to line translation, we got know the issue is from
ffs_user_copy_worker+0x1dc/0x204
		||
io_data->kiocb->ki_complete(io_data->kiocb, ret);

And "find_check_fn" was getting invoked from ki_complete. Only thing 
that I found suspicious about ki_complete() is its argument types. 
That's why I pushed this patch here, so that we can discuss this out here.

Thanks in advance

> 
> ...
>>> -	io_data->kiocb->ki_complete(io_data->kiocb, ret);
>>> +	io_data->kiocb->ki_complete(io_data->kiocb, (long)ret);
> ...
> 
> If definition of the parameter in the structure member ki_complete()
> definition is 'long' then the compiler has to promote 'ret' to long
> anyway. CFI has nothing to do with it.
> 
> OTOH if you've used a cast to assign a function with a
> different prototype to ki_complete then 'all bets are off'
> and you get all the run time errors you deserve.
> CFI just converts some of them to compile time errors.
> 
> For instance if you assign xx_complete(long) to (*ki_complete)(int)
> then it is very likely that xx_complete() will an argument
> with some of the high bits set.
> But adding a cast to the call - ki_complete((long)int_var)
> will make absolutely no difference.
> The compiler wont zero/sign extend int_var to 64bits for you,
> that will just get optimised away and the high bits will
> be unchanged.
> 
> You're description seems to be the other way around (which might
> be safe, but CFI probably still barfs).
> But you need to fix the indirect calls so the function types
> match.
So does that mean, we need to add casts in al indirect calls to match 
the function signature?
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

