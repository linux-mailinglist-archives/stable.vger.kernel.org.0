Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC66B379A7D
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 01:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhEJXK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 19:10:58 -0400
Received: from mout.gmx.net ([212.227.17.22]:55661 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229561AbhEJXK5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 19:10:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1620688177;
        bh=eMqhC2oMTqWtYVoIPiJOZD27KLY0FWTsD7z9V/P+6LM=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=JPylW/VbSUDyswUOKrahirMeFRQNN2kXLI4taUzrIofkvhJn9K3NdMNzZjiP+mk4W
         PVlfIaQ9wY3cB4OpHG5Xv1a4zBgnSCzZsiqotlPU/HT1XNyHS5/vPp3n+sfRn6DbOz
         3Sz4LcH3BiNp+A/cLutdHRuiLs4P4bfzFmCC/gqI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([78.42.220.31]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MqJqN-1lBWy33b51-00nRXB; Tue, 11
 May 2021 01:09:36 +0200
Subject: Re: [PATCH 1/2] tpm, tpm_tis: Extend locality handling to TPM2 in
 tpm_tis_gen_interrupt()
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        linux-integrity@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>
References: <20210510122831.409608-1-jarkko@kernel.org>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <daf823b3-522c-6c9a-984b-0ca849512a54@gmx.de>
Date:   Tue, 11 May 2021 01:09:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210510122831.409608-1-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:YshV3KIeC+zguZvJB0wqK5CRyMyLWaVtTQwSgVJdxR/84mirp4t
 kH6kX5oZE/wWxfl+8BMJcDa/XHMs7SBoKHIW1AW/8YB72l0j18wZ06bnBsRqbt1gLmaH+yo
 fsjEl+2DzY8sNoAlIIHfLZ8NGJosNh+F1xWS13qrYSzvHCjKclD69QlwKtI80SCSlCTsmsD
 67rQlZG4Xi5GGay5THr4w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:yXNHML4dHQI=:nYfrTOyg9+gHFdVRLOgtSv
 bKZ06cqbU6B+l/wmsqYBG9lkRmCEdybhMeFiTI5VyBx3C3hMPH+Zll7HoW6Ze/VevA4wKFZkF
 QOsiRMTR1Rf1zh4PuRarDkwGkfbIwRrWL7oeSqGFdd+miN2wYuVVRaRg3+4bgzGO4BWc1oZoh
 X4NtiRChWDHEi6jRsxOKS/JNpmpkXCE0oDZDfxTUbDDZe40Hs+xHhPmmxQhyqbWSAuCEvaOiD
 rOF10D+G0MVmVhZ4vpNVeyhBCe9Njq1LzeHsAHOFUNdX+SC7IP2Mcj0XJw7ZgK5rrsD6o31+A
 bXEX1zIQIr82ugXx0UrnkoNnlmWXPVm/PQpIQriOoqMDsVFkudoOY7KXf+NqbTTCxIFLg+/BY
 c3pulkIz8ImX5IgasvndatinIfwa0YzKDMQ8Nkj1tnfdoCsw7gSgC8QBfrYrT0cJArpltrOPN
 8KQO8wNosK00+1AJKXCaygRh3AnKbZmgyTMqrEbCE0zFlXRibBR6Xu2HpwjxGCGxbQ8l9UG4M
 2/4kkFQIghiwT/HdJjKGjGnXtjDHHwu7d28nd87hD1qg6VeXycMD99WDEzdbAgVjE59yXtnri
 s53fMfUwWBGNsfq/TjFcfhvg1z9koqmIHgWyOWDMfDJ0Dj2oAmWMIth/0Q66eyweXvkyySFtJ
 L2Ag8dlp1iYHjovhycXny71syOyDf2T3A9op5xN2neAY8m8anisRCwILv/Q2EIv/sTuUNJRbF
 1LR5totFoH9BUCPL83ELOo21YFV5umONBCBDICaMcvktcUfnxSbDFl2xpX5TqM15+Zwg8alvD
 fOaVn1j/48mlnuruiuUIJTFsZhYoungzBR/Alput1r3VwA3GmyAOYSljVVLmEsZAbwUacIQYw
 vVODExKOUo2DhTdhls1SxYNPV5IHLOHGeAnEEYEr1MlEWqZnMslUTTd6LWSVe8zqKv9SaPhiW
 xRpA6Rz+t7vVBZW1hn7W/zaj6ZZjOgTfuRftYwVgnwna6fZHOYplkyCQFXvxJHjpWI4837BFG
 u/PGe49sZ1I89mMI3K+5QmCZldtJmU9kW1T8i5H//6wN1bpKh6feBQ7u2G0dndpW4XwdG6YWd
 xHHsllKaVGbTOhIaJev6Ib5PzKI1keLEYxz0gydsojEHXwxCYIZsGi1b4RSHHOWOfDzn5ZkMt
 0UI42/+IZj94jnNwjLaDpOYlHKy4+oU6BzjrHfWGlYd7FSLpr7FQkE35Hts+ECJORkV7hIvTO
 3Ujm4BrRmYnaPaJa6
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 10.05.21 at 14:28, Jarkko Sakkinen wrote:
> The earlier fix (linked) only partially fixed the locality handling bug
> in tpm_tis_gen_interrupt(), i.e. only for TPM 1.x.
>
> Extend the locality handling to cover TPM2.
>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/linux-integrity/20210220125534.20707-1-jar=
kko@kernel.org/
> Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmi=
t()")
> Reported-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>
> v1:
> * Testing done with Intel NUC5i5MYHE with SLB9665 TPM2 chip.
>
>  drivers/char/tpm/tpm_tis_core.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_=
core.c
> index a2e0395cbe61..6fa150a3b75e 100644
> --- a/drivers/char/tpm/tpm_tis_core.c
> +++ b/drivers/char/tpm/tpm_tis_core.c
> @@ -709,16 +709,14 @@ static int tpm_tis_gen_interrupt(struct tpm_chip *=
chip)
>  	cap_t cap;
>  	int ret;
>
> -	/* TPM 2.0 */
> -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> -		return tpm2_get_tpm_pt(chip, 0x100, &cap2, desc);
> -
> -	/* TPM 1.2 */
>  	ret =3D request_locality(chip, 0);
>  	if (ret < 0)
>  		return ret;
>
> -	ret =3D tpm1_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc, 0);
> +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> +		ret =3D tpm2_get_tpm_pt(chip, 0x100, &cap2, desc);
> +	else
> +		ret =3D tpm1_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc, 0);
>
>  	release_locality(chip, 0);
>
>

This fix works for me. Tested on a SLB9670vq2.0 and the warning message is=
 gone.

Tested-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>

Regards,
Lino
