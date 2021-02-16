Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120E331D0BB
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 20:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhBPTKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 14:10:02 -0500
Received: from mout.gmx.net ([212.227.17.20]:54973 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231284AbhBPTJy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Feb 2021 14:09:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1613502491;
        bh=4ONbLuA4g1cBrBPWkp4wG3Wk4KYO2HWK8en5fKbW724=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=WetCouUcn84mJMADbL5kZ0+2I+s43qqkjGceD6HLNXB9hNEebuOLGo3tVbMRwRGE+
         EHEuyZ/BvY96R+lnm01PLF/l0IGLyA4Yv/Lx+5hUEOQrUNT6RtAwxUwk/dAB5lWdf+
         wSZTTSla+Sdf4dC9Q3a1L/SEYdJZOK4vRGnMm/Jc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([78.42.220.31]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MBUqF-1l0qlo1Cvv-00Czqa; Tue, 16
 Feb 2021 20:08:11 +0100
Subject: Re: [PATCH v4] tpm: fix reference counting for struct tpm_chip
To:     Jarkko Sakkinen <jarkko@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc:     peterhuewe@gmx.de, stefanb@linux.vnet.ibm.com,
        James.Bottomley@hansenpartnership.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>,
        stable@vger.kernel.org
References: <1613435460-4377-1-git-send-email-LinoSanfilippo@gmx.de>
 <1613435460-4377-2-git-send-email-LinoSanfilippo@gmx.de>
 <20210216125342.GU4718@ziepe.ca> <YCvtF4qfG35tHM5e@kernel.org>
 <YCvuS9cIT7umOjhy@kernel.org> <YCvulinbuHWunTqD@kernel.org>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <527e8905-d727-3a45-f542-5827fa0bca47@gmx.de>
Date:   Tue, 16 Feb 2021 20:08:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YCvulinbuHWunTqD@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:XXbH05bbQ9Q4ZdsVOQQBkpsUBiB9+tqnOYu/aZOwwHBmdlcJ+Kj
 abWU/NDTvj22rmfxo9aEOjJT16T+g9YFG8QywCHuJVHG/vNwXmy3upgdenulY9EqUG7xMuY
 Wjuob5ZssWr9dsi0k6BmvP9emcT+M3JS/Hct5FnASutkx7d6iw+JRIvtiDbOP7igheFBptd
 5c/MypfGRZRa/h5IgOAsA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:8d2R17VOEOo=:QmDLIMXxBNCLzlCWg1tZo+
 tdfGfD9v8tRUujNCbrIHNXdv5AMq2SuvCUKJe4Nau6zo/uo5aKLXZfPfO3irva0aArK0zrtoD
 wHr9A6kA8uEVFQQA/TbZxHN3hDT5+oJBLZ8raYoK+hn8srMNN9lF1IegGXwUiKHqEfRWkY/U7
 sEbyR8lEw8x8KkbuQW4QNxEydntA6zBZSRCLLC3LObHfbeQPxgk0BUyyrhczLXWQaj2WEOhIe
 f7AjsqfZqqMf/jysNXxtuhAPn9VDt3MdrowWfx3Q7cLoyMFFdgHvkHC0g3zt29v6lZCVlMGZx
 pN9KVOG8Y3glJKionLFj85Eo8MkbYGIL9BGMCyG014yUri6vVsJQBj1wuQ+csXmIfb7Plq1xt
 7dM7k5a+plGnGnjEpHFvY49NupjDJ7XV3dRsMUWGoyphVozdzCIPX6YFTqGj0Ss0+S3rU5zk8
 4/hU2Hmh+VJaSlLVeLlCcHYWK0v2yu/h47qlGZhN4xSVb10pYpBDNx2Fb/wdLfIBJ0zErPBTP
 J0XQkWCQazTsvF2sSpjRc5KD4c/PDh1vgF6SaxiGBSLeXIJPpHhSHshTx1LYJOp0muO5J3mCf
 OBnKnnLmg4xqQEBTjD/E76hgEreuIdKaPnFSj/Gma4wGJ6U6RSETRcbNk+5ATwvs/ttfW8FGI
 Nuc1GceDNtH1R57EiCQ1AZehz130Fj2G/GWTXYBYG0rx0WewA9VL2Nwdzr8VYTkGKxfjt+j2K
 qYFb+IjRGvIImnTRoYi6A2MtAly8nmTrTyti9lwxLTq8cBD8M9KRriJquofx9g8peU9EveW2v
 J3s1fwfr7QjQ9rFSrbETbSpmFs2UoxAzy8pjH49FB6xznwU91TlorPD4iKXjB6jTAAZfapQXk
 K20iMph93AhdXoqb/z7g==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 16.02.21 at 17:11, Jarkko Sakkinen wrote:
> On Tue, Feb 16, 2021 at 06:09:50PM +0200, Jarkko Sakkinen wrote:
>> On Tue, Feb 16, 2021 at 06:04:42PM +0200, Jarkko Sakkinen wrote:
>>> On Tue, Feb 16, 2021 at 08:53:42AM -0400, Jason Gunthorpe wrote:
>>>> On Tue, Feb 16, 2021 at 01:31:00AM +0100, Lino Sanfilippo wrote:
>>>>>
>>>>> +static int tpm_add_tpm2_char_device(struct tpm_chip *chip)
>>>
>>> BTW, this naming is crap.
>>>
>>> - 2x tpm
>>> - char is useless
>>>
>>> -> tpm2_add_device
>>
>> Actually, tpm2s_add_device() add put it to tpm2-space.c.
>
> No, tpms_add_device() :-)
>
> (sorry)
>
> /Jarkko
>

I strongly assume you mean tmp2_add_device() :) I will move and rename the=
 function
accordingly.

Thanks,
Lino
