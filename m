Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E68831D0D8
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 20:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhBPTTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 14:19:40 -0500
Received: from mout.gmx.net ([212.227.17.20]:57361 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229879AbhBPTTc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Feb 2021 14:19:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1613503062;
        bh=GykttgD/ScwH21Rwzt2CmBMPNmJNtJwa1QV9F7Pvq+U=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=h++RhMptxUfRi21wZODUlTRUOuxvZpCOHAIhPaBIsidiRtgFoMNENpYoKti/cab8s
         XrvSz3JSxA/Vg8tTImPwWZNvvzPaWGGWrP+9/KSJcvo1a30EtCByvCaJpT0s8YwbvS
         3muB8nFKznlLT4HDO8+L5Rbc96SbOnFzdxRxQrSQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([78.42.220.31]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N0Fxf-1m7CuP0Qh5-00xMrs; Tue, 16
 Feb 2021 20:17:42 +0100
Subject: Re: [PATCH v4] tpm: fix reference counting for struct tpm_chip
To:     Stefan Berger <stefanb@linux.ibm.com>, peterhuewe@gmx.de,
        jarkko@kernel.org, jgg@ziepe.ca
Cc:     stefanb@linux.vnet.ibm.com, James.Bottomley@hansenpartnership.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>,
        stable@vger.kernel.org
References: <1613435460-4377-1-git-send-email-LinoSanfilippo@gmx.de>
 <1613435460-4377-2-git-send-email-LinoSanfilippo@gmx.de>
 <d36c324d-2f16-ed2a-7507-0d8f52da20ea@linux.ibm.com>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <5657f8c4-e85e-ad9f-fa1f-ec5d6b659423@gmx.de>
Date:   Tue, 16 Feb 2021 20:17:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d36c324d-2f16-ed2a-7507-0d8f52da20ea@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:N9Z020PUwELxIP0h9mVPoTis529QDzCGk6is8644g5qh2yQvxbG
 pbXRWmA7EgOeAGCf+G6OYdtbgcFve2kQekNc3Ka8blxbgX+X3Id/9yL8XByj5165sRvsjiO
 XqVFcaZT2IB+cuXMsvmtWYUksYnBZsUL619RJvBoIxcoZ/Sxs4xTiP433pWnlzrcFJOhhEg
 0c2sApYfJHquqqD7RCZtw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:W1xwbuXKB94=:sdmSEGYuF66tRYWywMpUD9
 WS5LuohyHI9YKnvsVi0E3e7B7O3dWdZNFZ0YK6HyCG61UtIVDR+fmSgPtscn0WG+M6PvBWUwq
 FJzvBTQ3Nnw1XYPQok9PWbsfj9trrGspCqRP5rqBXHUvLxlHMYuk8tww1JyKnJuypUEoRiMPB
 gYRHBqPceUC4+G9jOCtKaysHC1aj5GwhOlCj5qke1CS3HAJfXDchPBbsqp9ScMF9d5IS5nrOf
 CJuARLaSqr0KHGO1kxVL/LqJZ8AAoBRTaUNKTiYNv2AI689TL3v6EC5xv0yXOt7Q7FXtjPif5
 p5c/Ve9FjEVH1f6TYsLJ1tnqbLD00WazAotQPA3IfIdn8G1Gtv80as+CtaCyy05XW7k+En4kN
 HR82EFDh6wRluDwluXjsSj/DfO4bOookH0jSv+hBfKfr3+c/YR8/h53KhdkW+5CAGHhsMSpvS
 FVPLAWRHuppUGXP1a+MBfi6uUaAt8iSDZ4FLkk0JjjkfmefJEoDa2rgfErNf1vFTbxiovqmeg
 eLs82QMjmImI8a11rhVyPA8ma3NTUZbXg+xQoUqjYG3ZJ+5MUy7l8ASHBc3CRPCT37fUu9Pfb
 oIbG65iBCFTteXvjohuEQd78DnMA0wqVsmlryMrLVc9yXaciilgopRxZz2C37L5FvyE37olt0
 MFIxTRVIwuWWuCBYVNwzCRN9kVOUdNpJ8hMzUIaIBmTJ4oSrc5ZUXhOHqcTrDUPP45kQLlyxh
 LUTM6G2vM4dqQojQwmzmRgXBgCRiBKy4zuqrZoI3dDxoZWrmZII1bqarP5pPpl0DrSOTlGRnp
 u6zbVdPbPgx96OnlNZ2zXQBGcHak/1yozSxQ0GszcoYlb7FBJ5Wa314b2zVlcBWoW/rePjtzt
 qjdNC87alDMcCzLBxAgw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi Stefan,

On 16.02.21 at 17:52, Stefan Berger wrote:
> On 2/15/21 7:31 PM, Lino Sanfilippo wrote:
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
>> Modules linked in: tpm_tis_spi tpm_tis_core tpm mdio_bcm_unimac brcmfma=
c
>> sha256_generic libsha256 sha256_arm hci_uart btbcm bluetooth cfg80211 v=
c4
>> brcmutil ecdh_generic ecc snd_soc_core crc32_arm_ce libaes
>> raspberrypi_hwmon ac97_bus snd_pcm_dmaengine bcm2711_thermal snd_pcm
>> snd_timer genet snd phy_generic soundcore [last unloaded: spi_bcm2835]
>> CPU: 3 PID: 1161 Comm: hold_open Not tainted 5.10.0ls-main-dirty #2
>> Hardware name: BCM2711
>> [<c0410c3c>] (unwind_backtrace) from [<c040b580>] (show_stack+0x10/0x14=
)
>> [<c040b580>] (show_stack) from [<c1092174>] (dump_stack+0xc4/0xd8)
>> [<c1092174>] (dump_stack) from [<c0445a30>] (__warn+0x104/0x108)
>> [<c0445a30>] (__warn) from [<c0445aa8>] (warn_slowpath_fmt+0x74/0xb8)
>> [<c0445aa8>] (warn_slowpath_fmt) from [<c08435d0>] (kobject_get+0xa0/0x=
a4)
>> [<c08435d0>] (kobject_get) from [<bf0a715c>] (tpm_try_get_ops+0x14/0x54=
 [tpm])
>> [<bf0a715c>] (tpm_try_get_ops [tpm]) from [<bf0a7d6c>] (tpm_common_writ=
e+0x38/0x60 [tpm])
>> [<bf0a7d6c>] (tpm_common_write [tpm]) from [<c05a7ac0>] (vfs_write+0xc4=
/0x3c0)
>> [<c05a7ac0>] (vfs_write) from [<c05a7ee4>] (ksys_write+0x58/0xcc)
>> [<c05a7ee4>] (ksys_write) from [<c04001a0>] (ret_fast_syscall+0x0/0x4c)
>> Exception stack(0xc226bfa8 to 0xc226bff0)
>> bfa0:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 00000000 000105b4 00000003 beaf=
e664 00000014 00000000
>> bfc0: 00000000 000105b4 000103f8 00000004 00000000 00000000 b6f9c000 be=
afe684
>> bfe0: 0000006c beafe648 0001056c b6eb6944
>> ---[ end trace d4b8409def9b8b1f ]---
>>
>> The reason for this warning is the attempt to get the chip->dev referen=
ce
>> in tpm_common_write() although the reference counter is already zero.
>>
>> Since commit 8979b02aaf1d ("tpm: Fix reference count to main device") t=
he
>> extra reference used to prevent a premature zero counter is never taken=
,
>> because the required TPM_CHIP_FLAG_TPM2 flag is never set.
>>
>> Fix this by moving the TPM 2 character device handling from
>> tpm_chip_alloc() to tpm_add_char_device() which is called at a later po=
int
>> in time when the flag has been set in case of TPM2.
>>
>> Commit fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n=
>")
>> already introduced function tpm_devs_release() to release the extra
>> reference but did not implement the required put on chip->devs that res=
ults
>> in the call of this function.
>>
>> Fix this by putting chip->devs in tpm_chip_unregister().
>>
>> Finally move the new implemenation for the TPM 2 handling into a new
>> function to avoid multiple checks for the TPM_CHIP_FLAG_TPM2 flag in th=
e
>> good case and error cases.
>>
>> Fixes: fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n=
>")
>> Fixes: 8979b02aaf1d ("tpm: Fix reference count to main device")
>> Co-developed-by: Jason Gunthorpe <jgg@ziepe.ca>
>> Signed-off-by: Jason Gunthorpe <jgg@ziepe.ca>
>> Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
>> Cc: stable@vger.kernel.org
>
>
> I know you'll post another version, but anyway:
>
> Tested-by: Stefan Berger <stefanb@linux.ibm.com>

Thank you for testing this, I will send a v5 shortly.

Regards,
Lino

