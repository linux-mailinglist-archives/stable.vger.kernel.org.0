Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C3F47CD28
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 07:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239030AbhLVG4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 01:56:37 -0500
Received: from mout.gmx.net ([212.227.17.20]:57369 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235252AbhLVG4h (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Dec 2021 01:56:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1640156183;
        bh=usaE+auloC0pKur1KyeikoeCQuPrvDwpepUfa8MTVBM=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=bfAhe70bDEEZZnFnE7Ox822RAFR0ZxPycmQqYq9kynkvLpT05LL/qs0wgyalyFSxc
         pP13EnpAs/trPnl0l0ZzrF1XdR48T82Z+jCY6L22iBx3U3Zg0WUW7sQK4VgL0iEzUN
         uTzG2SkoXFBV1szfheDPjoAY6VANpc1BjxwbfJp0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.70] ([46.223.119.124]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MtwUm-1mCDD111eW-00uHCG; Wed, 22
 Dec 2021 07:56:23 +0100
Subject: Re: [PATCH v2] tpm: fix potential NULL pointer access in
 tpm_del_char_device
To:     Stefan Berger <stefanb@linux.ibm.com>, peterhuewe@gmx.de,
        jarkko@kernel.org, jgg@ziepe.ca
Cc:     p.rosenberger@kunbus.com, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20211220150635.8545-1-LinoSanfilippo@gmx.de>
 <af847879-0f29-08e7-7609-da3b27381d3a@linux.ibm.com>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <926f57a8-81b8-b3a9-8338-71213f1b85ac@gmx.de>
Date:   Wed, 22 Dec 2021 07:56:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <af847879-0f29-08e7-7609-da3b27381d3a@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:drYXROArZ3cwX1WlTQdq2uKpG6SFxH+1Ub6aaSiTYRYnuKz9Qbm
 sTvQtIwb4GPEWvFj4om8LDumN8p/hd2ps4z/5y1kiso7Lm84XM9QCTtZnKWWf4RsqJMgLnh
 fiINh7ajSWGhZPx95inayWuoFH9csLKDZ40sEPdPhm2wXP4zifRnlEgtDLVNcnatfnfSSGw
 Ltd+wexmEJpyy4iOVEQAw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:q5XXRM0EOvE=:dxGm4/HlpZ1+G/pXELQt6g
 rXkhfXj8XkbJOiNKkcqbWAjVQuF+5YckJLzOALfQ4QpDWFWGNzhdh/A8yPDmvrVrorXD6rui8
 YIrd83Usd3R5FzMAJZ8BXzMHHQa7oHH1YVtdLuirupZrEKWQgmBzJ2D4ExORFk855TCH5aO3f
 ZxnnEwLuaCKMRDyDQQn6CQFjiLLcr7qXXcLYHte4iNrnGZOB0VSVwmNcSeXmLN5tgFkT73N98
 FrfYkOAu9zSjy6nbw9hACdOL9DdAP3Tqu1epKZrJY2bfEEjcYtTR+dc8eJg9gweu5iR90ihzP
 H+xUrniG+tL042JFYmmYNYzKf7Mdnmo7wiNkDic3s9PHjyunN9vPSDeeMfJ/o4SZ6VaaYj5E6
 U1LbkYn3rq8CAkjbb1P1UVw5BTjTF3sVMbPVCpf4Ex2HZC4RAY7mb0wV2L7tbDe5CMNC3vjjE
 e51NoEdXaPsXUMwZ5+o9Z8GsaJYOD7z4A9sdgkFiLSD7LJkSTYpzfQke6ZP8Ag9qxtCKZ0Y7B
 /Go+TN1pG8Fhg9qqBvntdXO0nlIS2vdP4j3FxY71omK1oIoykzETER8oLp8lg4VIbqX3N9SfY
 pdL09lySuIW5F2icP908BnRs289gEMGHLNQqFGPHmv02klDsirDAGbCRcd/3AKpooGDCw+Ezh
 bex950zJkFLYhlFoVxOkeurM8q//vdT1BUxjBg+dkQ1rPrT6+q3UclPi0+xccbxiqYhO1Nbtc
 Kks/NCdwX7Xa9sLK4UaTu8LyMZYf5GjQ+brD4eS0sRiuUI6MqWBQ56BDVELel7KccGM97faLO
 o/arbV8Ng5qSzQLGbVT5ZbAb6OHPwCsWp+J5AEM1fMNeHZpa9hPB7KXj8ssl1hVpvd58wHnvU
 F1M5VB6tFt7aNnBh2f3LXHoncMGEpp3cIpgATNL99R7wDUBJcisPh0QhmrwlyRm3l+/EKOeOL
 C24X1gR3w7NzvU0pLFVJkWYwv+iqYaAu+98T+0BNuFq82pDuOS8SEY76WsXsvWpvrTsw/fV+q
 Hgm/gVR1cm730V+4Ehrd3w6slh/xyAf9VNGD9xtlWpBhcdcIZdAHt9ijIYB+JLO7daR0FzYUx
 hQM0rjbCo0l4WY=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi Stefan,


On 22.12.21 at 05:53, Stefan Berger wrote:

>>
>> =C2=A0 drivers/char/tpm/tpm-chip.c | 16 +++++++++++-----
>> =C2=A0 1 file changed, 11 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
>> index ddaeceb7e109..7960da490e72 100644
>> --- a/drivers/char/tpm/tpm-chip.c
>> +++ b/drivers/char/tpm/tpm-chip.c
>> @@ -474,13 +474,19 @@ static void tpm_del_char_device(struct tpm_chip *=
chip)
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Make the driver uncallable. */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 down_write(&chip->ops_sem);
>> -=C2=A0=C2=A0=C2=A0 if (chip->flags & TPM_CHIP_FLAG_TPM2) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!tpm_chip_start(chip)) =
{
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tpm=
2_shutdown(chip, TPM2_SU_CLEAR);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tpm=
_chip_stop(chip);
>> +=C2=A0=C2=A0=C2=A0 /* Check if chip->ops is still valid: In case that =
the controller
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * drivers shutdown handler unregisters the co=
ntroller in its
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * shutdown handler we are called twice and ch=
ip->ops to NULL.
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +=C2=A0=C2=A0=C2=A0 if (chip->ops) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (chip->flags & TPM_CHIP_=
FLAG_TPM2) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if =
(!tpm_chip_start(chip)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 tpm2_shutdown(chip, TPM2_SU_CLEAR);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 tpm_chip_stop(chip);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 chip->ops =3D NULL;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> -=C2=A0=C2=A0=C2=A0 chip->ops =3D NULL;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 up_write(&chip->ops_sem);
>> =C2=A0 }
>> =C2=A0
>> base-commit: a7904a538933c525096ca2ccde1e60d0ee62c08e
>
>
> Fixes: 39d0099f9439 ("powerpc/pseries: Add shutdown() to vio_driver and =
vio_bus")
>
> Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
>
> Tested-by: Stefan Berger <stefanb@linux.ibm.com>
>
>

Thanks a lot for testing this.

Best regards,
Lino
