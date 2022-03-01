Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF714C8F4A
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 16:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235705AbiCAPlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 10:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiCAPlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 10:41:00 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA850AA02B;
        Tue,  1 Mar 2022 07:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1646149200;
        bh=7iN7wcARzdGBmULFO2icCMhivv1YtW36RUkP8rVrSrM=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=c2UlLgYddABpidhgBmZvQx48ECshAMbK04+kjC+kKKtYLq0Ri4Os2T4HGk6Vtv7bc
         djjKtYvcmwlEh/+HcQu5lEVvJwVqIUMPoT6V3QpXlCS39p7OpyJdXIdk4S5UIm7037
         xp/rpQfti9gJDHnw46xkLSgUZv/v67zTljxHhveE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.74] ([149.172.237.68]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N8XPt-1oKhVm3lYH-014WYG; Tue, 01
 Mar 2022 16:39:59 +0100
Subject: Re: [PATCH v8 1/1] tpm: fix reference counting for struct tpm_chip
To:     Stefan Berger <stefanb@linux.ibm.com>, peterhuewe@gmx.de,
        jarkko@kernel.org, jgg@ziepe.ca
Cc:     stefanb@linux.vnet.ibm.com, James.Bottomley@hansenpartnership.com,
        David.Laight@ACULAB.COM, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.rosenberger@kunbus.com,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>,
        stable@vger.kernel.org
References: <20220301022108.30310-1-LinoSanfilippo@gmx.de>
 <20220301022108.30310-2-LinoSanfilippo@gmx.de>
 <99eff469-3faf-1e9a-9ad9-e087aeafc301@linux.ibm.com>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <d8b5814f-c77b-0431-942a-b295d14fea50@gmx.de>
Date:   Tue, 1 Mar 2022 16:39:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <99eff469-3faf-1e9a-9ad9-e087aeafc301@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:yw2hVG/vwJ0AplBDvF3xK7a4ydQWdm4fO9VnoPeQVY4JYaMdFEi
 bx9WVpl86BWCq+8q3VE6H6pAqjO/jeVAtBj9in8tZOMe0a5IrU9GCUhs1VGSQ29m6WLZ1xS
 uUhD0/tyuz6rotaG/bwC0g2BuRdw2+Rn5Ao/DQVcsocRxoFRO44usGenqI/+SdOkhqVzF8r
 6imkMMXzjbYi7OH+emL7Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:9l0axYEAke4=:z7T7gId0aNvEX+G4kRTBAW
 edf0O0KamPGhyN5LN6dcCImBuOkD0L7k4BSmUQR333ykovyraqE47STbfjxcMH0SSJpBWNNh9
 uRRsWEO89tmBEwXpXrZbxPKkrUIBJNhx2MnkGO8rpi5c8uF5WEqRO7NzGGd53VVwagKcCrGfe
 FF/OoqNC0wu7mwMBory5b0a0lJQNV0hYLRdJHd4tfshLVvWmS8niuHT379ZGw09rFVgE/wIxj
 K2DMbQmc4505iN0JkJ/0B9F5AWgYs7Q2yS1m7gi0oSfdfDt3qCimV3a8LKdRH6JJyxROmE6Qw
 R62zibmuK70noiK/in+yP087Hc8g1CF39Y2CnPkPOZzjSMnymilGJQvjnaCEPDFOAQhJ4kdOe
 HSBJ0jLitRCHd7aoCcOtehvQ9SdVszV2ck1uBlQJhufITvRy6QQJDy0PSWz0pEqzAiogj2NVJ
 Mecyfa2mtCSyjK0ySSUVnN5h9taCPDq72RBoSj6mjODKZR4nEcEkWRhHzKHnOkaUdFRFhaBg/
 hfyznJgan+fGc739e+TuJkhweC6tAxQI2FOz51Y1qre/B8QGHvBRat+/oCeb8ye19Xj44CPOC
 JEi3gISNdRdRL3uasykMRKgBwV8cDihmEsrt6Qw7Q4NX8hFLqHQpThKjuwplHT6PhFrGhbjg+
 w2z5HQmdYcRz8hWCAEF+dQ/yy1QRcNRCPJZcHjrZz7/79IWNsHgcUcYSIDra1jfTorT9EQeDL
 Rvi72wvhZLlukQrIJhxVxyz9Pdct9nw1Y0u1n16BVvIQQCBpYqg2YTFAeOeLhq8xLqlVkB8l/
 qQNLI+xXspEtKMcnkkIQHH1zy7/4AEBrglxapZ0AuvIQL1t2ML7d6tQKrs7YjV3xWz3+SYRvC
 XTgQwO1yDfbtmZjR6R2BoC4aFSjy2pUKaULH5Pr/HQgznChygatTS/xR3ilbzncxofkabMn0F
 dp1FA72DILXIWanf7Z3iAt19zmLRYoGp4rIyVn4k05YUnD52MLfb47GupJ59Yhzr2kV3vin/P
 a6HgeX+PGZyFFvDnGL1SoXnAGrchH2tesk05ZAJx2CScgyJBgjmosm4ngITHO5GmgQKJ/jnc/
 J7MPc5czYraxrc=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi,

On 01.03.22 at 13:36, Stefan Berger wrote:
>
> On 2/28/22 21:21, Lino Sanfilippo wrote:
>> From: Lino Sanfilippo <l.sanfilippo@kunbus.com>
>>
>> The following sequence of operations results in a refcount warning:
>>
>> 1. Open device /dev/tpmrm.
>> 2. Remove module tpm_tis_spi.
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
>> Finally move the new implementation for the TPM 2 handling into a new
>> function to avoid multiple checks for the TPM_CHIP_FLAG_TPM2 flag in th=
e
>> good case and error cases.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n=
>")
>> Fixes: 8979b02aaf1d ("tpm: Fix reference count to main device")
>> Co-developed-by: Jason Gunthorpe <jgg@ziepe.ca>
>> Signed-off-by: Jason Gunthorpe <jgg@ziepe.ca>
>> Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
>
> Tested-by: Stefan Berger <stefanb@linux.ibm.com>
>

Thanks for testing this!

Regards,
Lino
