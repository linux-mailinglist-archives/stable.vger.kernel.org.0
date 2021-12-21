Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D3847C74B
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 20:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237366AbhLUTQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 14:16:10 -0500
Received: from mout.gmx.net ([212.227.15.15]:47699 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229659AbhLUTQK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Dec 2021 14:16:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1640114161;
        bh=a9Ev8+mzUT7djVwPdE0euA9s9JKk4vtQOXpreiuTIhQ=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=I1lFPsYKZv9RH3L6Ne8HM5OsvEeo7lf2vuI1klQW9h44Y9+0B1rKzVkEGtWjZE3Bk
         NL4hkJypajxZzo/13cESjWUFDmIrrdVkUJfs0N5VlmpjOf69WoJdQQWWANAzKMMhgK
         dUgKqI3zNyMZMM3YL3kbJqOfpVfpLwAox6BmZPZI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.70] ([46.223.119.124]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MTABZ-1mu0lT3pa3-00UasG; Tue, 21
 Dec 2021 20:16:00 +0100
Subject: Re: [PATCH v2] tpm: fix potential NULL pointer access in
 tpm_del_char_device
To:     peterhuewe@gmx.de, jarkko@kernel.org, jgg@ziepe.ca
Cc:     p.rosenberger@kunbus.com, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stefanb@linux.vnet.ibm.com
References: <20211220150635.8545-1-LinoSanfilippo@gmx.de>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <d247bcfd-8c51-c8c3-3b30-d78624f89629@gmx.de>
Date:   Tue, 21 Dec 2021 20:16:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211220150635.8545-1-LinoSanfilippo@gmx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:8UDmIHV3kmv4MDWO3EYxH/p3iIzZPJoIofhdnH+qoochXSK3zjF
 /wNRGjUaXre7VJfvW1cqDb6Eb6btf5riY6Ean92Sc5q+OO0SL6ThGBw7EHUbmnBdIEkrwyA
 mzotuZSHusU1fE3CFZWW+s8A6qltxPm93iZ6xC22vIpkjTlJK8C+Kz9AVdJ4daWlbhGNvOH
 nyiPTOzpKIEToJ4v+EsPw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:4ADerPwFa6E=:CbunJZ1lwIdGtgo3z2/Ja9
 QTGV2OhGQtDj/+wMd8A0QOGD1zZBxmvAJkZVd3SotNgeZuoIC2U5hIo1VnndSrFpkcGibBCb1
 oLMpIkND5B4H7CxtD3LOP6/03JIKZB+o9pUMXy8N3LNcuIeoHOlaeFdHIsEnTx9x9h1f9xC9c
 dMqzy0dp1SaGsbtoSeP30gme0YtXtNpHgJpwZcowSmEN5SSHO2/94cgpzMbsAtpzw2kXN2gsx
 V2xqwTwg1fMBM5GajV3zLsv8ErBLNdto5anj5Hq5YniKiwSQV9B6nWriqDF5+t+/eJ9sLi+wj
 B4FfpuyRGCV0vLQrcQufVQabvPuyrEEfXdbLopbNwS3EzsYaOx5ZLj1TVrNqy4NQgemD9Axz6
 YKiFpI+1Uv9tA6ulMISrTv1yC9tFvXxQlUoEyrbavUZIgI+z/C3IbsvUf10UgphyWvJkdkMRL
 q0pmkc3aTI6jR0+cql7T7h7iqHiH8D/xgY8B+AeWZQTJTikYwzDFxSKVjSHmE7h3ghzmT3TWK
 NCZ7RllHcGTN9jxgKpoKjN5po0Uc6ihGv5nOkcZgo7eUtCfCB/k2mV1vBbvYLwDnc6AP1nDt0
 wjVO5CHHwXyDV3UYNGS8J/YQ4KqXNS1lN3Qx/Wtu4JiHZ+6oxuOzKDVq/EhCg8o9lqckqBIKo
 C+TvYGPrujql/K86cLYYNoSDal+sEGJqOsoYLuy9qYAFFZ9FN3OjiewSIaqTFftbveCcT/2Nf
 U2qvPxogX2h+4NDpqqD4VmjKHjkaIFPPybaQiZbpfCPqmyxmF6v8sBCehmabzBeRXiO7R2LNH
 fJQztjhftFudOOQMI7Si5YDGnWMAFX6Gq5k/yI6N5PPoccrHlAp3+OwRq0eAauFs6f6C0x8sA
 091fU/xzG6a0PVrzRsWOmq2regWWzCQIOjRhB7at9Pa07+fvuUwmMv3Gzin05co/I4tqInmo0
 dsUJuttYH73EeMA8NLjPgWCo0gUjI+pHHusTl6dwb4dx4tqffa6aPMXxA00I1QFAqLl0cqo+6
 TOxdtyDOPDE4Sw+oW1nnW+88XIJo7MypDREIkao88IcnbEJbNOghOwQ6nibbQ0Hw9MVs7XqqA
 ok/QYGL+1tmcYw=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

the patch below should also fix the issue that Stefan reported here:

https://marc.info/?l=3Dlinux-integrity&m=3D163927245509564&w=3D2


Regards,
Lino


On 20.12.21 at 16:06, Lino Sanfilippo wrote:
> Some SPI controller drivers unregister the controller in the shutdown
> handler (e.g. BCM2835). If such a controller is used with a TPM 2 slave
> chip->ops may be accessed when it is already NULL:
>
> At system shutdown the pre-shutdown handler tpm_class_shutdown() shuts d=
own
> TPM 2 and sets chip->ops to NULL. Then at SPI controller unregistration
> tpm_tis_spi_remove() is called and eventually calls tpm_del_char_device(=
)
> which tries to shut down TPM 2 again. Thereby it accesses chip->ops agai=
n:
> (tpm_del_char_device calls tpm_chip_start which calls tpm_clk_enable whi=
ch
> calls chip->ops->clk_enable).
>
> Avoid the NULL pointer access by testing if chip->ops is valid and skipp=
ing
> the TPM 2 shutdown procedure in case it is NULL.
>
> Fixes: dcbeab1946454 ("tpm: fix crash in tpm_tis deinitialization")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> ---
>
> Changes to v2:
> - rephrased the commit message to clarify the circumstances under which
>   this bug triggers (as requested by Jarkko)
>
>
> I was able to reproduce this issue with a SLB 9670 TPM chip controlled b=
y
> a BCM2835 SPI controller.
>
> The approach to fix this issue in the BCM2835 driver was rejected after =
a
> discussion on the mailing list:
>
> https://marc.info/?l=3Dlinux-integrity&m=3D163285906725367&w=3D2
>
> The reason for the rejection was the realization, that this issue should=
 rather
> be fixed in the TPM code:
>
> https://marc.info/?l=3Dlinux-spi&m=3D163311087423271&w=3D2
>
> So this is the reworked version of a patch that is supposed to do that.
>
>
>  drivers/char/tpm/tpm-chip.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index ddaeceb7e109..7960da490e72 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -474,13 +474,19 @@ static void tpm_del_char_device(struct tpm_chip *c=
hip)
>
>  	/* Make the driver uncallable. */
>  	down_write(&chip->ops_sem);
> -	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> -		if (!tpm_chip_start(chip)) {
> -			tpm2_shutdown(chip, TPM2_SU_CLEAR);
> -			tpm_chip_stop(chip);
> +	/* Check if chip->ops is still valid: In case that the controller
> +	 * drivers shutdown handler unregisters the controller in its
> +	 * shutdown handler we are called twice and chip->ops to NULL.
> +	 */
> +	if (chip->ops) {
> +		if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> +			if (!tpm_chip_start(chip)) {
> +				tpm2_shutdown(chip, TPM2_SU_CLEAR);
> +				tpm_chip_stop(chip);
> +			}
>  		}
> +		chip->ops =3D NULL;
>  	}
> -	chip->ops =3D NULL;
>  	up_write(&chip->ops_sem);
>  }
>
>
> base-commit: a7904a538933c525096ca2ccde1e60d0ee62c08e
>

