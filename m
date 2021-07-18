Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181683CC843
	for <lists+stable@lfdr.de>; Sun, 18 Jul 2021 11:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhGRJRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Jul 2021 05:17:07 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:35632 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhGRJRH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Jul 2021 05:17:07 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru B137E2327E2A
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH AUTOSEL 4.19 05/39] scsi: hisi_sas: Propagate errors in
 interrupt_init_v1_hw()
To:     Sasha Levin <sashal@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
References: <20210710023204.3171428-1-sashal@kernel.org>
 <20210710023204.3171428-5-sashal@kernel.org>
 <3e2af821-00e3-6db9-5820-696fdbe003d6@omp.ru> <YPOB8hs4jOBRyQsS@sashalap>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <24e2041e-8dab-dabf-2b74-5573e25ead6d@omp.ru>
Date:   Sun, 18 Jul 2021 12:13:45 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YPOB8hs4jOBRyQsS@sashalap>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 18.07.2021 4:20, Sasha Levin wrote:

[...]
>>> [ Upstream commit ab17122e758ef68fb21033e25c041144067975f5 ]
>>>
>>> After commit 6c11dc060427 ("scsi: hisi_sas: Fix IRQ checks") we have the
>>> error codes returned by platform_get_irq() ready for the propagation
>>> upsream in interrupt_init_v1_hw() -- that will fix still broken deferred
>>> probing. Let's propagate the error codes from devm_request_irq() as well
>>> since I don't see the reason to override them with -ENOENT...
>>>
>>> Link: https://lore.kernel.org/r/49ba93a3-d427-7542-d85a-b74fe1a33a73@omp.ru
>>> Acked-by: John Garry <john.garry@huawei.com>
>>> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
>>> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>>  drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 12 ++++++------
>>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c 
>>> b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
>>> index 8aa3222fe486..5a777e48963b 100644
>>> --- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
>>> +++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
>> [...]
>>> @@ -1717,7 +1717,7 @@ static int interrupt_init_v1_hw(struct hisi_hba 
>>> *hisi_hba)
>>>          if (!irq) {
>>>              dev_err(dev, "irq init: could not map cq interrupt %d\n",
>>>                  idx);
>>> -            return -ENOENT;
>>> +            return irq;
>>
>>   This patch is borked too, we don't want to return 0 here...
> 
> Looks like it's broken on <=4.19, I'll drop it. Thanks!

    You might to want backport the below patch (before this one),
the same way yoo did for 5.x-stable):

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6c11dc060427e07ca144eacaccd696106b361b06

MBR, Sergei
