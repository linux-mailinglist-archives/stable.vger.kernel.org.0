Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010B16227D9
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 11:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiKIKCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 05:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiKIKB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 05:01:59 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D49EEE2D;
        Wed,  9 Nov 2022 02:01:57 -0800 (PST)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A994HMu003464;
        Wed, 9 Nov 2022 10:01:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=OCAem8P+hIMDlpZSQaS7m++Ccy020llh9wTdoS9OO3Y=;
 b=ZekCdSFiom9WY3nOgE1eAf5aAjzb4By/y6Ug7eTXVCJYp/1mkUu60UrPWM/RiWQ69FE8
 SzzB4S1dMHaQq4pUpn0X3l9AX1w75Cm2pCGMFqHzg99rRWP8VVmNjlL10XCbu+gOxM5T
 j+k0e0S/QjDncesf3yNm7Nez5jaisJuEXrRWID68Nbwqw0MbXkO282XyX9+Vs3TTuIAC
 wo/mpBqJLmfD9NXKcPtvPID/tqF9kSFiNn8LJbIIk3bGkROjJmTkzlqaDJHiwvg9hkea
 o1nr+fQM3pJNOtRsjtUODHpMs33X/iJ6EG3H63vgb/PGEwWUYnDAZQ6DD/Q8iqMXaXSt Fg== 
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3kr6568qke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Nov 2022 10:01:52 +0000
Received: from nasanex01a.na.qualcomm.com ([10.52.223.231])
        by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 2A9A1pob028695
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 9 Nov 2022 10:01:52 GMT
Received: from [10.239.133.73] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 9 Nov 2022
 02:01:50 -0800
Message-ID: <5faf926b-7ac2-8d0a-032d-a1984b5b217b@quicinc.com>
Date:   Wed, 9 Nov 2022 18:01:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] pinctrl: core: Make p->state in order in
 pinctrl_commit_state
To:     <paulmck@kernel.org>, Linus Walleij <linus.walleij@linaro.org>
CC:     Arnd Bergmann <arnd@arndb.de>, <linux-gpio@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20221027065110.9395-1-quic_aiquny@quicinc.com>
 <CACRpkdbCwvGr4JA+=khynduWSZSbSN8D9dtsY0h_9LxkqJuQ_Q@mail.gmail.com>
 <20221108192039.GH3907045@paulmck-ThinkPad-P17-Gen-1>
From:   "Aiqun(Maria) Yu" <quic_aiquny@quicinc.com>
In-Reply-To: <20221108192039.GH3907045@paulmck-ThinkPad-P17-Gen-1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: Vs5J_Qh1tsunpZRcEQKHwUYA-2lT0jMw
X-Proofpoint-GUID: Vs5J_Qh1tsunpZRcEQKHwUYA-2lT0jMw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_03,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 malwarescore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 clxscore=1011 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211090076
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/9/2022 3:20 AM, Paul E. McKenney wrote:
> On Tue, Nov 08, 2022 at 01:47:15PM +0100, Linus Walleij wrote:
>> Hi Maria,
>>
>> thanks for your patch!
>>
>> On Thu, Oct 27, 2022 at 8:51 AM Maria Yu <quic_aiquny@quicinc.com> wrote:
>>
>>> We've got a dump that current cpu is in pinctrl_commit_state, the
>>> old_state != p->state while the stack is still in the process of
>>> pinmux_disable_setting. So it means even if the current p->state is
>>> changed in new state, the settings are not yet up-to-date enabled
>>> complete yet.
>>>
>>> Currently p->state in different value to synchronize the
>>> pinctrl_commit_state behaviors. The p->state will have transaction like
>>> old_state -> NULL -> new_state. When in old_state, it will try to
>>> disable all the all state settings. And when after new state settings
>>> enabled, p->state will changed to the new state after that. So use
>>> smp_mb to synchronize the p->state variable and the settings in order.
>>> ---
>>>   drivers/pinctrl/core.c | 2 ++
>>>   1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
>>> index 9e57f4c62e60..cd917a5b1a0a 100644
>>> --- a/drivers/pinctrl/core.c
>>> +++ b/drivers/pinctrl/core.c
>>> @@ -1256,6 +1256,7 @@ static int pinctrl_commit_state(struct pinctrl *p, struct pinctrl_state *state)
>>>                  }
>>>          }
>>>
>>> +       smp_mb();
>>>          p->state = NULL;
>>>
>>>          /* Apply all the settings for the new state - pinmux first */
>>> @@ -1305,6 +1306,7 @@ static int pinctrl_commit_state(struct pinctrl *p, struct pinctrl_state *state)
>>>                          pinctrl_link_add(setting->pctldev, p->dev);
>>>          }
>>>
>>> +       smp_mb();
>>>          p->state = state;
>>>
>>>          return 0;
>>
>> Ow!
>>
>> It's not often that I loop in Paul McKenney on patches, but this is in the core
>> of the subsystem used across all architectures so if this is a generic problem
>> of concurrency, I really want some professional concurrency person to
>> look at it before I apply it.
> 
> Hello, Linus and Maria!
> 
> Insertion of unadorned and uncommented memory barriers does rouse more
> than a bit of suspicion, to be sure.  ;-)
> 
Thx Paul and Linus,

welcome for the discussion and thx for the envolvement, that's what 
values a lot through the open source work.

> Could you please outline what ordering this smp_mb() is intended to
> provide?  Yes, my guess is that the p->state change is to be seen as
> happening after the prior memory accesses, but:
> 
> 1.	What is the other side of the interaction doing?  My guess is
> 	that something is reading p->state and the referencing the same
> 	memory referenced prior to the pair of smp_mb() calls above.
> 	For example, are the other relevant memory references referenced
> 	by the pointer "p"?
> 
> 	For example, what happens if two of the above updates happen in
> 	quick succession during the execution of a single instance of
> 	the other side of the interaction?
> 

we've got a dump that the taskA is in call stack of pinctrl_commit_state 
-> pinmux_disable_setting ->dev_warn , while the old_state is not 
consistant with current p->state.

And from current ramdump, the kernel have warn each ~4us of the same 
dev_warn of "xxx-pinctrl xxx.pinctrl: not freeing pin xxx(GPIO_xxx) as 
part of deactivating group gpioxxx - it is already used for some other 
setting". It last for ~20ms and then have a final sysrq triggered crash.

so here is the possible the senario like below:
|TaskA pinctrl_commit_state| TaskB pinctrl_commit_state
| old_state = p->state;    |
|if (p->state)             | if(p->state); //old_state
|                          |list_for_each_entry
|                          |   pinmux_disable_setting(
|                          |      old_state->settings);
|                          |p->state = NULL;
|                          |list_for_each_entry
|                          | pinmux_enable_setting(
|                          |   new_state->settings);
|                          |p->state = new_state; //new state
|list_for_each_entry       |
|pinmux_disable_setting(   |
|  old_state->settings);   |
| dev_warn("not freeing pin")|
|                          |



> 2.	Why smp_mb() rather than using smp_store_release() to update
> 	p->state?
> 
For now I am a little afraid of the current memroy barrier is still not 
enough and need to use a lock to avoid concurency.

> 3.	More generally, why unmarked accesses to p->state?  Are the
> 	other relevant accesses also unmarked?
> 
> 	Please see these LWN articles for more on the potential dangers
> 	of unmarked accesses to shared variables:
> 
> 	Who's afraid of a big bad optimizing compiler?
> 		https://lwn.net/Articles/793253/
> 
> 	Calibrating your fear of big bad optimizing compilers
> 		https://lwn.net/Articles/799218/
> 
Let me have a study and try.
> 4.	There are some tools that can help with this sort of ordering
> 	code, for example:
> 
> 	Concurrency bugs should fear the big bad data-race detector (part 1)
> 		https://lwn.net/Articles/816850/
> 	Concurrency bugs should fear the big bad data-race detector (part 2)
> 		https://lwn.net/Articles/816854/
> 
> 	For this tool (KCSAN) to find a problem, your testing must come
> 	close to making it happen.
> 
> 	A design-level full-state-space tool may be found in
> 	tools/memotry-model.  This tool, as you might expect, is
> 	restricted to very short code fragments, but does fully handle
> 	concurrency.  It might take some work to squeeze what you have
> 	into the confines of this tool.
> 
Let me have a study and try.
> Again, to evaluate this change, I need to understand what it is trying
> to accomplish.
> 
Sure.
> 							Thanx, Paul
> 


-- 
Thx and BRs,
Aiqun(Maria) Yu
