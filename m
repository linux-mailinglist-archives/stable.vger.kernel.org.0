Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFE9446968
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 21:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbhKEUIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 16:08:50 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:19492 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbhKEUIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 16:08:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1636142770; x=1667678770;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=4rh6XC/kTiVF2xsn37ZjBf32rxNh34P9YKlCdAoEzjc=;
  b=aEf0SoLT4UWVgDLacOTawHqgfqr6kDwx/nLqsbWJw6e6QuSl2uGwFioP
   Yme0eNmXYZlQXQrSdhMaATchChGqEKFM4vnxd6no0tBq05d3Bqz9mlee8
   hv1ABeX5ljt9jBnUUaUuoncoFqugFHSD8y7z+reZO3SLkj+shL27ltuOt
   k=;
Received: from ironmsg08-lv.qualcomm.com ([10.47.202.152])
  by alexa-out.qualcomm.com with ESMTP; 05 Nov 2021 13:06:09 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg08-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2021 13:06:09 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7;
 Fri, 5 Nov 2021 13:06:08 -0700
Received: from [10.47.233.232] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7; Fri, 5 Nov 2021
 13:06:08 -0700
Subject: Re: [RESEND PATCH v2] thermal: Fix a NULL pointer dereference
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        David Collins <quic_collinsd@quicinc.com>,
        Manaf Meethalavalappu Pallikunhi <quic_manafm@quicinc.com>,
        <stable@vger.kernel.org>
References: <1636070227-15909-1-git-send-email-quic_subbaram@quicinc.com>
 <YYTUMBWsqfiAYnCy@kroah.com>
From:   Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
Message-ID: <22447c4b-7fbe-ab19-d1c4-d7c21a562ab2@quicinc.com>
Date:   Fri, 5 Nov 2021 13:06:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YYTUMBWsqfiAYnCy@kroah.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/4/21 11:50 PM, Greg KH wrote:
> On Thu, Nov 04, 2021 at 04:57:07PM -0700, Subbaraman Narayanamurthy wrote:
>> of_parse_thermal_zones() parses the thermal-zones node and registers a
>> thermal_zone device for each subnode. However, if a thermal zone is
>> consuming a thermal sensor and that thermal sensor device hasn't probed
>> yet, an attempt to set trip_point_*_temp for that thermal zone device
>> can cause a NULL pointer dereference. Fix it.
>>
>>  console:/sys/class/thermal/thermal_zone87 # echo 120000 > trip_point_0_temp
>>  ...
>>  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
>>  ...
>>  Call trace:
>>   of_thermal_set_trip_temp+0x40/0xc4
>>   trip_point_temp_store+0xc0/0x1dc
>>   dev_attr_store+0x38/0x88
>>   sysfs_kf_write+0x64/0xc0
>>   kernfs_fop_write_iter+0x108/0x1d0
>>   vfs_write+0x2f4/0x368
>>   ksys_write+0x7c/0xec
>>   __arm64_sys_write+0x20/0x30
>>   el0_svc_common.llvm.7279915941325364641+0xbc/0x1bc
>>   do_el0_svc+0x28/0xa0
>>   el0_svc+0x14/0x24
>>   el0_sync_handler+0x88/0xec
>>   el0_sync+0x1c0/0x200
>>
>> While at it, fix the possible NULL pointer dereference in other
>> functions as well: of_thermal_get_temp(), of_thermal_set_emul_temp(),
>> of_thermal_get_trend().
>>
>> Suggested-by: David Collins <quic_collinsd@quicinc.com>
>> Signed-off-by: Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
>> ---
>>  drivers/thermal/thermal_of.c | 9 ++++++---
>>  1 file changed, 6 insertions(+), 3 deletions(-)
>>
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
>
> </formletter>

Hi Greg,
For this case, is it because I've missed adding "Cc:stable@vger.kernel.org" in commit text itself and cc-ed stable@vger.kernel.org directly?

Thanks,
Subbaraman
