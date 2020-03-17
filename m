Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5B718876D
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 15:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgCQOZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 10:25:04 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:22936 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726759AbgCQOZE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 10:25:04 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02HEEKTX020282;
        Tue, 17 Mar 2020 15:24:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=STMicroelectronics;
 bh=zP92rnQ3i+hHFZVKP9Da5Pr7ddiPctkkMFjIu1bZNsY=;
 b=qVH/Myd8pANtHOlfnsUMUZcckuRby+S3QVEkXzu04Vk8vIdLX+LHozxOAvBAKPsCLywV
 V5KXpuOApLVVUOUWq6UfCYEPl5MxjVFp8Nz8tR/9qu5bkJ+Z0wsL7cuWu2C2iFCtSWL1
 1TGtVZrpGVMvodGHwtZnm86Lp57yf5zeTvciWvt1k9Q+EE6wkatCcsXSLODf8KvXiCKp
 haKdaFYEVi7WR/WIBqpMLaBdpLQaSfq7plEEHtbTPOcNQJzzEpmRDp6Xao81/bg35kox
 QRbQFU7lBr60Hd/EjJ0nfnLir4xzMK5dlr/fjNdE4NGCmuXxf5LgPd/njOeAi44Aroip Eg== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2yrqv08b3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Mar 2020 15:24:59 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 2125A100038;
        Tue, 17 Mar 2020 15:24:55 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag3node1.st.com [10.75.127.7])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 103252AF35E;
        Tue, 17 Mar 2020 15:24:55 +0100 (CET)
Received: from lmecxl0889.lme.st.com (10.75.127.45) by SFHDAG3NODE1.st.com
 (10.75.127.7) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Mar
 2020 15:24:54 +0100
Subject: Re: [PATCH v5] remoteproc: Fix NULL pointer dereference in
 rproc_virtio_notify
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
CC:     Nikita Shubin <nshubin@topcon.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
References: <20200306070325.15232-1-NShubin@topcon.com>
 <20200306072452.24743-1-NShubin@topcon.com>
 <6c7ef4f2-6f71-c2fb-b2e9-ad7cbeb7cfbc@st.com>
 <20200310120846.GA19430@topcon.com>
 <507197c5412e4b438aeb5c527be74b3a@SFHDAG3NODE1.st.com>
 <20200311200107.GZ1214176@minitux>
From:   Arnaud POULIQUEN <arnaud.pouliquen@st.com>
Message-ID: <f6de2571-3541-7004-bc57-92cb3fef2c71@st.com>
Date:   Tue, 17 Mar 2020 15:24:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200311200107.GZ1214176@minitux>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.45]
X-ClientProxiedBy: SFHDAG6NODE2.st.com (10.75.127.17) To SFHDAG3NODE1.st.com
 (10.75.127.7)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-17_05:2020-03-17,2020-03-17 signatures=0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Bjorn

On 3/11/20 9:01 PM, Bjorn Andersson wrote:
> On Tue 10 Mar 06:19 PDT 2020, Arnaud POULIQUEN wrote:
> 
>>
>>
>>> -----Original Message-----
>>> From: linux-remoteproc-owner@vger.kernel.org <linux-remoteproc-
>>> owner@vger.kernel.org> On Behalf Of Nikita Shubin
>>> Sent: mardi 10 mars 2020 13:09
>>> To: Arnaud POULIQUEN <arnaud.pouliquen@st.com>
>>> Cc: stable@vger.kernel.org; Ohad Ben-Cohen <ohad@wizery.com>; Bjorn
>>> Andersson <bjorn.andersson@linaro.org>; linux-
>>> remoteproc@vger.kernel.org; linux-kernel@vger.kernel.org; Mathieu Poirier
>>> <mathieu.poirier@linaro.org>
>>> Subject: Re: [PATCH v5] remoteproc: Fix NULL pointer dereference in
>>> rproc_virtio_notify
>>>
>>> On Mon, Mar 09, 2020 at 03:22:24PM +0100, Arnaud POULIQUEN wrote:
>>>> Hi,
>>>>
>>>> sorry for the late answer...
>>>>
>>>> On 3/6/20 8:24 AM, Nikita Shubin wrote:
>>>>> Undefined rproc_ops .kick method in remoteproc driver will result in
>>>>> "Unable to handle kernel NULL pointer dereference" in
>>>>> rproc_virtio_notify, after firmware loading if:
>>>>>
>>>>>  1) .kick method wasn't defined in driver
>>>>>  2) resource_table exists in firmware and has "Virtio device entry"
>>>>> defined
>>>>>
>>>>> Let's refuse to register an rproc-induced virtio device if no kick
>>>>> method was defined for rproc.
>>>>>

[...]

>>>>>
>>>>> Signed-off-by: Nikita Shubin <NShubin@topcon.com>
>>>>> Fixes: 7a186941626d ("remoteproc: remove the single rpmsg vdev
>>>>> limitation")
>>>>> Cc: stable@vger.kernel.org
>>>>> ---
>>>>>  drivers/remoteproc/remoteproc_virtio.c | 7 +++++++
>>>>>  1 file changed, 7 insertions(+)
>>>>>
>>>>> diff --git a/drivers/remoteproc/remoteproc_virtio.c
>>>>> b/drivers/remoteproc/remoteproc_virtio.c
>>>>> index 8c07cb2ca8ba..31a62a0b470e 100644
>>>>> --- a/drivers/remoteproc/remoteproc_virtio.c
>>>>> +++ b/drivers/remoteproc/remoteproc_virtio.c
>>>>> @@ -334,6 +334,13 @@ int rproc_add_virtio_dev(struct rproc_vdev
>>> *rvdev, int id)
>>>>>  	struct rproc_mem_entry *mem;
>>>>>  	int ret;
>>>>>
>>>>> +	if (rproc->ops->kick == NULL) {
>>>>> +		ret = -EINVAL;
>>>>> +		dev_err(dev, ".kick method not defined for %s",
>>>>> +				rproc->name);
>>>>> +		goto out;
>>>>> +	}
>>>>> +
>>>> Should the kick ops be mandatory for all the platforms? How about making
>>> it optional instead?
>>>
>>> Hi, Arnaud.
>>>
>>> It is not mandatory, currently it must be provided if specified vdev entry is in
>>> resourse table. Otherwise it looks like there is no point in creating vdev.
>>
>> Yes, my question was about having it optional for vdev also. A platform could implement the vdev
>> without kick mechanism but by polling depending due to hardware capability...
>> This could be an alternative avoiding to implement a dummy function in platform driver.
>>
> 
> Is this a real thing or a theoretical suggestion?
Only a theoretical suggestion, trigged by the IMX platform patchset which implement a "temporary" dummy kick.
and based on OpenAMP lib implementation which does not request a doorbell.
Anyway no issue to keep it mandatory here. 

Regards,
Arnaud

> 
> Regards,
> Bjorn
> 
>> Anyway it just a proposal that makes sense from MPOV. If Bjorn is ok with your patch, nothing blocking on my side.
>>
>> Regards
>> Arnaud
>>
>>>
>>>
>>>>
>>>> Regards,
>>>> Arnaud
>>>>
>>>>>  	/* Try to find dedicated vdev buffer carveout */
>>>>>  	mem = rproc_find_carveout_by_name(rproc, "vdev%dbuffer",
>>> rvdev->index);
>>>>>  	if (mem) {
>>>>>
