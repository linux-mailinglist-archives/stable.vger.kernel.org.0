Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C59310259
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 02:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbhBEBpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 20:45:44 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58750 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232903AbhBEBpk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 20:45:40 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 1151W82i131075;
        Thu, 4 Feb 2021 20:44:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TIEb3+afSV3AJbVcVj/P0BfDKRQCY1YSyX9SgNW3ix4=;
 b=dDwHotrsSF5VvqV7PvsYKvUULl87DICuO2j769V0giKVCm0n/FFSRkWcFVOmnbZD0pEG
 mgoMzSo73iCEavkOydmh0jVC/u6fEr+mu1revCIiOS/hjvpzyxRSRDKbeLx7HvHODQrE
 Qy+QSarLno+gEEM+VK5H6tpVmCEwbZFvlU1Set/FUVClaSL6kdXW65WP0nUaQ3drHHW3
 7eUlXWFJ3FgActOnkTvK31lNFqnbB+ZWlf5zAD6Dv8178IxNi1rz8tw2IpIXYRDVpL9I
 xdeZqhiCSjPENUoVrewTy4JPtRYFZPNhuSJYpTBHnnkmjy+uu8vZS22PcrDva+eODVgN Dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36guxxgvsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Feb 2021 20:44:50 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1151WKjL131535;
        Thu, 4 Feb 2021 20:44:50 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36guxxgvs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Feb 2021 20:44:50 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 1151gBbG011914;
        Fri, 5 Feb 2021 01:44:49 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03wdc.us.ibm.com with ESMTP id 36f2nxehg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Feb 2021 01:44:49 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1151inLB26018076
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Feb 2021 01:44:49 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41681124054;
        Fri,  5 Feb 2021 01:44:49 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B35A124053;
        Fri,  5 Feb 2021 01:44:49 +0000 (GMT)
Received: from sbct-3.pok.ibm.com (unknown [9.47.158.153])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  5 Feb 2021 01:44:49 +0000 (GMT)
Subject: Re: [PATCH v3 1/2] tpm: fix reference counting for struct tpm_chip
From:   Stefan Berger <stefanb@linux.ibm.com>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de,
        jarkko@kernel.org
Cc:     jgg@ziepe.ca, stefanb@linux.vnet.ibm.com,
        James.Bottomley@hansenpartnership.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
 <1612482643-11796-2-git-send-email-LinoSanfilippo@gmx.de>
 <b36db793-9b40-92a8-19ef-4853ea10f775@linux.ibm.com>
Message-ID: <f5ad4381-773d-b994-51e5-a335ca4b44c3@linux.ibm.com>
Date:   Thu, 4 Feb 2021 20:44:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <b36db793-9b40-92a8-19ef-4853ea10f775@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-04_13:2021-02-04,2021-02-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 adultscore=0 impostorscore=0 spamscore=0
 phishscore=0 mlxlogscore=999 priorityscore=1501 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102050002
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/4/21 7:46 PM, Stefan Berger wrote:
> On 2/4/21 6:50 PM, Lino Sanfilippo wrote:
>> From: Lino Sanfilippo <l.sanfilippo@kunbus.com>
>>
>> The following sequence of operations results in a refcount warning:
>>
>> 1. Open device /dev/tpmrm
>> 2. Remove module tpm_tis_spi
>> 3. Write a TPM command to the file descriptor opened at step 1.
>>
>> ------------[ cut here ]------------
>> WARNING: CPU: 3 PID: 1161 at lib/refcount.c:25 kobject_get+0xa0/0xa4
>> refcount_t: addition on 0; use-after-free.
>> Modules linked in: tpm_tis_spi tpm_tis_core tpm mdio_bcm_unimac brcmfmac
>> sha256_generic libsha256 sha256_arm hci_uart btbcm bluetooth cfg80211 
>> vc4
>> brcmutil ecdh_generic ecc snd_soc_core crc32_arm_ce libaes
>> raspberrypi_hwmon ac97_bus snd_pcm_dmaengine bcm2711_thermal snd_pcm
>> snd_timer genet snd phy_generic soundcore [last unloaded: spi_bcm2835]
>> CPU: 3 PID: 1161 Comm: hold_open Not tainted 5.10.0ls-main-dirty #2
>> Hardware name: BCM2711
>> [<c0410c3c>] (unwind_backtrace) from [<c040b580>] (show_stack+0x10/0x14)
>> [<c040b580>] (show_stack) from [<c1092174>] (dump_stack+0xc4/0xd8)
>> [<c1092174>] (dump_stack) from [<c0445a30>] (__warn+0x104/0x108)
>> [<c0445a30>] (__warn) from [<c0445aa8>] (warn_slowpath_fmt+0x74/0xb8)
>> [<c0445aa8>] (warn_slowpath_fmt) from [<c08435d0>] 
>> (kobject_get+0xa0/0xa4)
>> [<c08435d0>] (kobject_get) from [<bf0a715c>] 
>> (tpm_try_get_ops+0x14/0x54 [tpm])
>> [<bf0a715c>] (tpm_try_get_ops [tpm]) from [<bf0a7d6c>] 
>> (tpm_common_write+0x38/0x60 [tpm])
>> [<bf0a7d6c>] (tpm_common_write [tpm]) from [<c05a7ac0>] 
>> (vfs_write+0xc4/0x3c0)
>> [<c05a7ac0>] (vfs_write) from [<c05a7ee4>] (ksys_write+0x58/0xcc)
>> [<c05a7ee4>] (ksys_write) from [<c04001a0>] (ret_fast_syscall+0x0/0x4c)
>> Exception stack(0xc226bfa8 to 0xc226bff0)
>> bfa0:                   00000000 000105b4 00000003 beafe664 00000014 
>> 00000000
>> bfc0: 00000000 000105b4 000103f8 00000004 00000000 00000000 b6f9c000 
>> beafe684
>> bfe0: 0000006c beafe648 0001056c b6eb6944
>> ---[ end trace d4b8409def9b8b1f ]---
>>
>> The reason for this warning is the attempt to get the chip->dev 
>> reference
>> in tpm_common_write() although the reference counter is already zero.
>>
>> Since commit 8979b02aaf1d ("tpm: Fix reference count to main device") 
>> the
>> extra reference used to prevent a premature zero counter is never taken,
>> because the required TPM_CHIP_FLAG_TPM2 flag is never set.
>>
>> Fix this by removing the flag condition.
>>
>> Commit fdc915f7f719 ("tpm: expose spaces via a device link 
>> /dev/tpmrm<n>")
>> already introduced function tpm_devs_release() to release the extra
>> reference but did not implement the required put on chip->devs that 
>> results
>> in the call of this function.
>>
>> Fix this also by installing an action handler that puts chip->devs as 
>> soon
>> as the chip is unregistered.
>>
>> Fixes: fdc915f7f719 ("tpm: expose spaces via a device link 
>> /dev/tpmrm<n>")
>> Fixes: 8979b02aaf1d ("tpm: Fix reference count to main device")
>> Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
>
> Tested-by: Stefan Berger <stefanb@linux.ibm.com>
>
> Steps:
>
> modprobe tpm_vtpm_proxy
>
> swtpm chardev --vtpm-proxy --tpm2 --tpmstate dir=./ &
>
> exec 100<>/dev/tpmrm1
>
> kill -9 <swtpm pid>
>
> rmmod tpm_vtpm_proxy
>
> exec 100>&-   # fails before, works after   --> great job! :-)
>
>
To clarify: When I tested this I had *both* patches applied. Without the 
patches I got the null pointer exception in tpm2_del_space(). The 2nd 
patch alone solves that issue when using the steps above.

[  525.647443] [c000000005d3bba0] [c000000000e81d78] 
mutex_lock+0x28/0x90 (unreliable)
[  525.647539] [c000000005d3bbd0] [c0080000001f5da0] 
tpm2_del_space+0x48/0x130 [tpm]
[  525.647635] [c000000005d3bc20] [c0080000001f56b8] 
tpmrm_release+0x40/0x70 [tpm]
[  525.647746] [c000000005d3bc50] [c0000000004bf718] __fput+0xb8/0x340
[  525.647842] [c000000005d3bca0] [c00000000017def4] 
task_work_run+0xe4/0x150
[  525.647930] [c000000005d3bcf0] [c00000000001feb4] 
do_notify_resume+0x484/0x4f0
[  525.648023] [c000000005d3bdb0] [c000000000033a64] 
syscall_exit_prepare+0x1d4/0x330
[  525.648115] [c000000005d3be20] [c00000000000d96c] 
system_call_common+0xfc/0x27c


