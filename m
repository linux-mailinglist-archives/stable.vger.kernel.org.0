Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE90344696C
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 21:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhKEULE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 16:11:04 -0400
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:16998 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229698AbhKEULD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 16:11:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1636142904; x=1667678904;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=iEQyOxEpu1v2n/yjp3OP13AcVAy+o4Y94WT9P1jQb/Q=;
  b=cvwNZeD3txYK7Ua4y3leTcyIze9BxN63bUDgobJSR1IVPi67f3rm4L6f
   uOr3wVBDugCbkxDKctzeq9x5Q70r3j8Pk1YXolk14VxdLrSbucJZJTXk1
   UPKJRZYdnTh8nZTdfexPHcSLq+y5PShNdxEQSVOxYqCKjUjs/BanPJ4rj
   Q=;
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 05 Nov 2021 13:08:23 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg02-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2021 13:08:23 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7;
 Fri, 5 Nov 2021 13:08:23 -0700
Received: from [10.47.233.232] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7; Fri, 5 Nov 2021
 13:08:22 -0700
Subject: Re: [RESEND PATCH v2] thermal: Fix a NULL pointer dereference
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
CC:     Amit Kucheria <amitk@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Collins <quic_collinsd@quicinc.com>,
        Manaf Meethalavalappu Pallikunhi <quic_manafm@quicinc.com>,
        Stable <stable@vger.kernel.org>
References: <1636070227-15909-1-git-send-email-quic_subbaram@quicinc.com>
 <CAJZ5v0gONybD_pVCAq6ZJTMuStXtoF064u9qPYxco4y=b-JD9A@mail.gmail.com>
 <c7ede029-b75f-e57e-24f1-9633d5d47401@linaro.org>
 <CAJZ5v0j1TDe0ZiBg_ju-JDuCsBDb_exueRDUwCcJ6VD_=fbzjg@mail.gmail.com>
From:   Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
Message-ID: <6fd1b6ca-15fc-757b-8755-7f8ec4110bcc@quicinc.com>
Date:   Fri, 5 Nov 2021 13:08:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAJZ5v0j1TDe0ZiBg_ju-JDuCsBDb_exueRDUwCcJ6VD_=fbzjg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/5/21 9:37 AM, Rafael J. Wysocki wrote:
> On Fri, Nov 5, 2021 at 5:19 PM Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>> On 05/11/2021 16:14, Rafael J. Wysocki wrote:
>>> On Fri, Nov 5, 2021 at 12:57 AM Subbaraman Narayanamurthy
>>> <quic_subbaram@quicinc.com> wrote:
>>>> of_parse_thermal_zones() parses the thermal-zones node and registers a
>>>> thermal_zone device for each subnode. However, if a thermal zone is
>>>> consuming a thermal sensor and that thermal sensor device hasn't probed
>>>> yet, an attempt to set trip_point_*_temp for that thermal zone device
>>>> can cause a NULL pointer dereference. Fix it.
>>>>
>>>>  console:/sys/class/thermal/thermal_zone87 # echo 120000 > trip_point_0_temp
>>>>  ...
>>>>  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
>>>>  ...
>>>>  Call trace:
>>>>   of_thermal_set_trip_temp+0x40/0xc4
>>>>   trip_point_temp_store+0xc0/0x1dc
>>>>   dev_attr_store+0x38/0x88
>>>>   sysfs_kf_write+0x64/0xc0
>>>>   kernfs_fop_write_iter+0x108/0x1d0
>>>>   vfs_write+0x2f4/0x368
>>>>   ksys_write+0x7c/0xec
>>>>   __arm64_sys_write+0x20/0x30
>>>>   el0_svc_common.llvm.7279915941325364641+0xbc/0x1bc
>>>>   do_el0_svc+0x28/0xa0
>>>>   el0_svc+0x14/0x24
>>>>   el0_sync_handler+0x88/0xec
>>>>   el0_sync+0x1c0/0x200
>>>>
>>>> While at it, fix the possible NULL pointer dereference in other
>>>> functions as well: of_thermal_get_temp(), of_thermal_set_emul_temp(),
>>>> of_thermal_get_trend().
>>> Can the subject be more specific, please?
>>>
>>> The issue appears to be limited to the of_thermal_ family of
>>> functions, but the subject doesn't reflect that at all.
>>>
>>>> Suggested-by: David Collins <quic_collinsd@quicinc.com>
>>>> Signed-off-by: Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
>>> Daniel, any concerns regarding the code changes below?
>> I've a concern about the root cause but I did not have time to
>> investigate how to fix it nicely.
>>
>> thermal_of is responsible of introducing itself between the thermal core
>> code and the backend. So it defines the ops which in turn call the
>> sensor ops leading us to this problem.
>>
>> So, without a better solution, this fix can be applied until we rethink
>> the thermal_of approach.
>>
>> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Thanks!
>
> I've queued it up for 5.16-rc as "thermal: Fix NULL pointer
> dereferences in of_thermal_ functions".

Thanks, Daniel and Rafael. So, I guess I don't need to send v3 with fixing commit subject right?

-Subbaraman
