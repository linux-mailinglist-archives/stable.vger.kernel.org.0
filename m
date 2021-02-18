Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE0B31EFB2
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 20:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbhBRTVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 14:21:33 -0500
Received: from mout.gmx.net ([212.227.17.20]:42193 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232818AbhBRTQA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Feb 2021 14:16:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1613675643;
        bh=OumvlyMfMF8OuGKnB6ZFA0Vs6VIp2wW434PmpZU2Q6Q=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=ihgEJyvmqs+l/amrtE06CAB/NYjM7xkKQur7JyySpDs7c8S6UnXoi+owRCwAlGSFv
         ArzhyF5lyUJnXpx6AZW5IhpmMlv7ZohRYFjroxupK8p0K6s3w6apcfE3J4aaPaQ1RF
         uklIUSG67/kXSFx7ytgtmyXdLFYeMPUobzDL5fwQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([78.42.220.31]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N2V0B-1lr7x60pfr-013xFj; Thu, 18
 Feb 2021 20:14:03 +0100
Subject: Re: [PATCH RESEND v5] tpm: fix reference counting for struct tpm_chip
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     peterhuewe@gmx.de, jgg@ziepe.ca, stefanb@linux.vnet.ibm.com,
        James.Bottomley@hansenpartnership.com, David.Laight@aculab.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>,
        stable@vger.kernel.org
References: <1613505191-4602-1-git-send-email-LinoSanfilippo@gmx.de>
 <1613505191-4602-2-git-send-email-LinoSanfilippo@gmx.de>
 <YC2WRJfNbY22yIOn@kernel.org>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <5d0f7222-a9ef-809b-cd9a-86bbacb03790@gmx.de>
Date:   Thu, 18 Feb 2021 20:13:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YC2WRJfNbY22yIOn@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:7qLkTgedFEkckgxUROxL2yXb/CiegrAXFaO7P+ZZ6y332p2Kyhw
 nfvX0hLPtks4MpwkLI+MRW9XERkSVQz3zn3vpki6xAldWtvoeJ1nJZ/pF1VT+aO8xKyE4jx
 GTzOTY+QxNH+2RAgTAEk1+noK3UcRWodvfCX5At9Bhcos903jErpz2dQHfFQ/MW/N3KphhZ
 oILK+nPqG4lhDKUD656kQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:wobcJB6G+es=:69RYnVhGdD1O8pwHzqrV64
 tTpd7JJ1VCNrBI05C9qKULlr+DEbL/g0+o8SrK1r/n+rhWRn3fsKcsPrmAiCkqPnqOEp9FXBX
 9ac9ELpnoJPblr1KjAxGG8cS5/CErq+DM/O61VzNDxZMus1V2YUQ4jjeH0VyvOXMUZJU5Vxsk
 cxYD/4mnFSr4vG0Bav9GipfJJy5yPLrj8WZYU9ghkrQq9ymqaHBlq8aCK2JmBK/8sPtO54QqP
 rXFPnaGWLfUPnIljJlxIRdEYOm6gKV1Y9IUzMjNsw8ds4LMu9ha5wMmdXIq4UAPKUD6yWnseX
 GjiaVm3M0ORlxLpg3AT1d7Ba2xxo+jnRhwFx3WaI4o0HkUVp7dL9wtaxTBdgGm4QizmpPhHNO
 ZDTWPkGXc+m/RiPyPespC1taUT268Hqpl/0koTBooYVAp8G2/qeanjftehnjtxCqeviDKmYLo
 OaXeBN+56AksoCSCP25WI49Eo7zGmj2MSUtMz53PD74Ut7IKpJTvRTKuxzCd4eJT1aYCkcLpb
 xVbkFaAQ+PqoJl2W7e3pexwuBMjTj9AumXzwqxIcvLYbjOPkBLbqRgXnyBRC5SjZDV3ubeCpU
 0k4RS7R/bPFu0IXv94NaQtQeptOKJjaCutwduvbJzSRoSQz/rca3xy2FZjlfyfIq8Gh3F7/yC
 gORO/gG7t772vxaifOGGEGjl8eWMQ5tAG3obTnnnGlxrDKZMtsTeZ4bRZNzndq347arKRIunl
 ZZZmB+eMGL80lP0zhixLJ2C88rjkwSY3uElaDnuOEbGamJjRe0+7mz0PkMDQb161WEnhndK07
 NDP+r1+E2JWOcnacaGDen0WbYmFh9phEf/LApXSQAzuDcB5hl44XSiM6NpdDQP2VMQEjx8iT4
 3y/6F9Qdp2JPIh1lyMMQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi,

On 17.02.21 at 23:18, Jarkko Sakkinen wrote:

>> +
>
> /*
>  * Please describe what the heck the function does. No need for full on
>  * kdoc.
>  */

Ok.

>> +int tpm2_add_device(struct tpm_chip *chip)
>
> Please, rename as tpm_devs_add for coherency sake.
>

Sorry I confused this and renamed it wrongly. I will fix it in the next
patch version.

>> +{
>> +	int rc;
>> +
>> +	device_initialize(&chip->devs);
>> +	chip->devs.parent =3D chip->dev.parent;
>> +	chip->devs.class =3D tpmrm_class;
>
> Empty line. Cannot recall, if I stated before.
>> +	/* +	 * get extra reference on main device to hold on behalf of devs.
>> +	 * This holds the chip structure while cdevs is in use. The
>> +	 * corresponding put is in the tpm_devs_release.
>> +	 */
>> +	get_device(&chip->dev);
>> +	chip->devs.release =3D tpm_devs_release;
>> +	chip->devs.devt =3D MKDEV(MAJOR(tpm_devt),
>> +					chip->dev_num + TPM_NUM_DEVICES);
>
> NAK, same comment as before.
>

Thx for the review, I will fix these issues.

Regards,
Lino
