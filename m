Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBB031CE79
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 17:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhBPQxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 11:53:32 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46836 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230097AbhBPQx0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 11:53:26 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11GGXCgO147308;
        Tue, 16 Feb 2021 11:52:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KS8Y+XGxUXIzrrjyQRSiPDJAYsSbs8BAQ7A0YAHTHDk=;
 b=O6cGGnjc5Vscm0lqnxQcRj/MEkjzgCjfGHCpicYcBltnke2b7feh8NgoB2MrZ0NcuoyK
 3OTO2MktlxxclXlJtiP+JAE+48asEVnYelQsDFC5q7/3tyTqC6JECS7YarVkRLVqBeUQ
 PIwJ3rwjkbCCkf+Aj/vG5sGe/KHqPcaG8XBXIwtUIVoM3/oP64FBtwgim0Z8rLD62nHb
 +mCTdrdwftIoL4+WGtPyyeVU88Uul3TJQQVTD3/qxBCGlfZt5LtRVhWfkMTl9rAY0R9L
 zTQJElv5GZaqCsSGj0q9WWyUV27s0qAjpyFSzIPfZ8gt0bHBQjcxeha3Nbuks6KlTArC OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36rhhyh988-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 11:52:39 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11GGp7oA059886;
        Tue, 16 Feb 2021 11:52:38 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36rhhyh97q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 11:52:38 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11GGpiFj003905;
        Tue, 16 Feb 2021 16:52:37 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03wdc.us.ibm.com with ESMTP id 36p6d8ypb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 16:52:37 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11GGqbKU28115350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Feb 2021 16:52:37 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A412124053;
        Tue, 16 Feb 2021 16:52:37 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC31A124052;
        Tue, 16 Feb 2021 16:52:36 +0000 (GMT)
Received: from sbct-3.pok.ibm.com (unknown [9.47.158.153])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 16 Feb 2021 16:52:36 +0000 (GMT)
Subject: Re: [PATCH v4] tpm: fix reference counting for struct tpm_chip
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de,
        jarkko@kernel.org, jgg@ziepe.ca
Cc:     stefanb@linux.vnet.ibm.com, James.Bottomley@hansenpartnership.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>,
        stable@vger.kernel.org
References: <1613435460-4377-1-git-send-email-LinoSanfilippo@gmx.de>
 <1613435460-4377-2-git-send-email-LinoSanfilippo@gmx.de>
From:   Stefan Berger <stefanb@linux.ibm.com>
Message-ID: <d36c324d-2f16-ed2a-7507-0d8f52da20ea@linux.ibm.com>
Date:   Tue, 16 Feb 2021 11:52:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1613435460-4377-2-git-send-email-LinoSanfilippo@gmx.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-16_07:2021-02-16,2021-02-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 bulkscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102160146
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/15/21 7:31 PM, Lino Sanfilippo wrote:
> From: Lino Sanfilippo <l.sanfilippo@kunbus.com>
>
> The following sequence of operations results in a refcount warning:
>
> 1. Open device /dev/tpmrm
> 2. Remove module tpm_tis_spi
> 3. Write a TPM command to the file descriptor opened at step 1.
>
> ------------[ cut here ]------------
> WARNING: CPU: 3 PID: 1161 at lib/refcount.c:25 kobject_get+0xa0/0xa4
> refcount_t: addition on 0; use-after-free.
> Modules linked in: tpm_tis_spi tpm_tis_core tpm mdio_bcm_unimac brcmfmac
> sha256_generic libsha256 sha256_arm hci_uart btbcm bluetooth cfg80211 vc4
> brcmutil ecdh_generic ecc snd_soc_core crc32_arm_ce libaes
> raspberrypi_hwmon ac97_bus snd_pcm_dmaengine bcm2711_thermal snd_pcm
> snd_timer genet snd phy_generic soundcore [last unloaded: spi_bcm2835]
> CPU: 3 PID: 1161 Comm: hold_open Not tainted 5.10.0ls-main-dirty #2
> Hardware name: BCM2711
> [<c0410c3c>] (unwind_backtrace) from [<c040b580>] (show_stack+0x10/0x14)
> [<c040b580>] (show_stack) from [<c1092174>] (dump_stack+0xc4/0xd8)
> [<c1092174>] (dump_stack) from [<c0445a30>] (__warn+0x104/0x108)
> [<c0445a30>] (__warn) from [<c0445aa8>] (warn_slowpath_fmt+0x74/0xb8)
> [<c0445aa8>] (warn_slowpath_fmt) from [<c08435d0>] (kobject_get+0xa0/0xa4)
> [<c08435d0>] (kobject_get) from [<bf0a715c>] (tpm_try_get_ops+0x14/0x54 [tpm])
> [<bf0a715c>] (tpm_try_get_ops [tpm]) from [<bf0a7d6c>] (tpm_common_write+0x38/0x60 [tpm])
> [<bf0a7d6c>] (tpm_common_write [tpm]) from [<c05a7ac0>] (vfs_write+0xc4/0x3c0)
> [<c05a7ac0>] (vfs_write) from [<c05a7ee4>] (ksys_write+0x58/0xcc)
> [<c05a7ee4>] (ksys_write) from [<c04001a0>] (ret_fast_syscall+0x0/0x4c)
> Exception stack(0xc226bfa8 to 0xc226bff0)
> bfa0:                   00000000 000105b4 00000003 beafe664 00000014 00000000
> bfc0: 00000000 000105b4 000103f8 00000004 00000000 00000000 b6f9c000 beafe684
> bfe0: 0000006c beafe648 0001056c b6eb6944
> ---[ end trace d4b8409def9b8b1f ]---
>
> The reason for this warning is the attempt to get the chip->dev reference
> in tpm_common_write() although the reference counter is already zero.
>
> Since commit 8979b02aaf1d ("tpm: Fix reference count to main device") the
> extra reference used to prevent a premature zero counter is never taken,
> because the required TPM_CHIP_FLAG_TPM2 flag is never set.
>
> Fix this by moving the TPM 2 character device handling from
> tpm_chip_alloc() to tpm_add_char_device() which is called at a later point
> in time when the flag has been set in case of TPM2.
>
> Commit fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n>")
> already introduced function tpm_devs_release() to release the extra
> reference but did not implement the required put on chip->devs that results
> in the call of this function.
>
> Fix this by putting chip->devs in tpm_chip_unregister().
>
> Finally move the new implemenation for the TPM 2 handling into a new
> function to avoid multiple checks for the TPM_CHIP_FLAG_TPM2 flag in the
> good case and error cases.
>
> Fixes: fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n>")
> Fixes: 8979b02aaf1d ("tpm: Fix reference count to main device")
> Co-developed-by: Jason Gunthorpe <jgg@ziepe.ca>
> Signed-off-by: Jason Gunthorpe <jgg@ziepe.ca>
> Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
> Cc: stable@vger.kernel.org


I know you'll post another version, but anyway:

Tested-by: Stefan Berger <stefanb@linux.ibm.com>


