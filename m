Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750E43115B0
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhBEWjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:39:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48238 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229492AbhBEN3x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 08:29:53 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 115D6PKp074327;
        Fri, 5 Feb 2021 08:29:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ds+uLYaHve6zEahUCo8fIlAL1PPupRZhe0r78y3kncc=;
 b=lswSdBWx9NxY2gYbUsarGcZeyAeaDj2IeNwgSqzuclw/mBS8A3idQT5Tf1br4WmDqBO9
 0s+iylhgYY7HEUH2WPSmr8rh8lmnlvjSO3T3wCQ0pZhd0K3oljttdF2s4OBNIfZk1E20
 HjQXJdfXk4mwDQlwm5+TnzablQOhi2+pnVWfGfDsU9pUVdQXgeK6L1g/r4qDgwJ0JEKx
 1Wtb/AWAAVB3YGNGbHkEH7rXzQH6UiP0fpHdFaIparh4QoqtRpzxSRPD3BAd2b0u7aG9
 MS3nnDbS+KITSc7ErBG5xts5+3jU5ZrbsBQ+A9RbNeg2EaS6PXW2WnAYotME6UkqguJK vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36h69998j9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Feb 2021 08:29:05 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 115DKjPf140394;
        Fri, 5 Feb 2021 08:29:05 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36h69998hx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Feb 2021 08:29:04 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 115DMCVs006503;
        Fri, 5 Feb 2021 13:29:04 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03dal.us.ibm.com with ESMTP id 36f3kw06d7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Feb 2021 13:29:04 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 115DT3st30146980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Feb 2021 13:29:03 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E9A6124053;
        Fri,  5 Feb 2021 13:29:03 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6AD92124052;
        Fri,  5 Feb 2021 13:29:03 +0000 (GMT)
Received: from sbct-3.pok.ibm.com (unknown [9.47.158.153])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  5 Feb 2021 13:29:03 +0000 (GMT)
Subject: Re: [PATCH v3 1/2] tpm: fix reference counting for struct tpm_chip
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de,
        jarkko@kernel.org
Cc:     jgg@ziepe.ca, stefanb@linux.vnet.ibm.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
 <1612482643-11796-2-git-send-email-LinoSanfilippo@gmx.de>
 <b36db793-9b40-92a8-19ef-4853ea10f775@linux.ibm.com>
 <f5ad4381-773d-b994-51e5-a335ca4b44c3@linux.ibm.com>
 <78f6bc5799c744dc3fdb2f508549cedf76ac1c1d.camel@HansenPartnership.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
Message-ID: <db1bb1ab-b2d6-cd4b-9908-b471b8cc7df5@linux.ibm.com>
Date:   Fri, 5 Feb 2021 08:29:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <78f6bc5799c744dc3fdb2f508549cedf76ac1c1d.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-05_07:2021-02-05,2021-02-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 mlxlogscore=840 adultscore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102050084
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/4/21 9:01 PM, James Bottomley wrote:
> On Thu, 2021-02-04 at 20:44 -0500, Stefan Berger wrote:
>> To clarify: When I tested this I had *both* patches applied. Without
>> the patches I got the null pointer exception in tpm2_del_space(). The
>> 2nd patch alone solves that issue when using the steps above.
>
> Yes, I can't confirm the bug either.  I only have lpc tis devices, so
> it could be something to do with spi, but when I do


I can confirm this bug:

insmod /usr/lib/modules/5.10.0+/extra/tpm.ko ; insmod 
/usr/lib/modules/5.10.0+/extra/tpm_vtpm_proxy.ko

swtpm chardev --vtpm-proxy --tpm2 --tpmstate dir=./ &

exec 100<>/dev/tpmrm0

kill -9 <swtpm pid>

rmmod tpm_vtpm_proxy

echo -en '\x80\x01\x00\x00\x00\x0c\x00\x00\x01\x44\x00\x00' >&100


[  167.289390] [c000000015d6fb60] [c0000000007d3ac0] 
refcount_warn_saturate+0x210/0x230 (unreliable)
[  167.290392] [c000000015d6fbc0] [c000000000831328] kobject_put+0x1b8/0x2e0
[  167.291398] [c000000015d6fc50] [c000000000955548] put_device+0x28/0x40
[  167.292409] [c000000015d6fc70] [c0080000008609a8] 
tpm_try_get_ops+0xb0/0x100 [tpm]
[  167.293417] [c000000015d6fcb0] [c008000000861864] 
tpm_common_write+0x15c/0x250 [tpm]
[  167.294429] [c000000015d6fd20] [c0000000004be190] vfs_write+0xf0/0x380
[  167.295437] [c000000015d6fd70] [c0000000004be6c8] ksys_write+0x78/0x130
[  167.296450] [c000000015d6fdc0] [c00000000003377c] 
system_call_exception+0x15c/0x270
[  167.297461] [c000000015d6fe20] [c00000000000d960] 
system_call_common+0xf0/0x27c

With this patch applied this error here is gone. Just have make sure to 
replace tpm.ko and tpm_vtpm_proxy.ko, not just the latter.

So my Tested-By is good for both patches.


    Stefan

