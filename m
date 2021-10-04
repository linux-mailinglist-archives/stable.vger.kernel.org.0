Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3386E42168E
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 20:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238731AbhJDSc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 14:32:58 -0400
Received: from mout.gmx.net ([212.227.15.15]:57667 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235252AbhJDSc5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 14:32:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1633372253;
        bh=xsdXZCIxECKbJqvAVvk/1or5BnC2aUn2qlxBoVzS3yE=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=j5LsNJL3eLr1U3ooUrQKI9vNb5/X3TdQJ5HmpGgAj8yueeE/S41jIxrwnaGm1kcAO
         N2AmcxQP5uciyq3c5chaSYdM4PYeztCeEem8/hevfEG1YahkdAubARHc9UEAzVD55p
         h7eRq1RmWr56ARlTLknYZmA25CYfFGKOrAHuPtt8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([46.223.119.124]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MnakR-1nGSjo17y9-00jaEX; Mon, 04
 Oct 2021 20:30:53 +0200
Subject: Re: [PATCH] spi: bcm2835: do not unregister controller in shutdown
 handler
To:     Jason Gunthorpe <jgg@ziepe.ca>, Mark Brown <broonie@kernel.org>
Cc:     f.fainelli@gmail.com, rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, nsaenz@kernel.org,
        linux-spi@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        p.rosenberger@kunbus.com, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org
References: <20210928195657.5573-1-LinoSanfilippo@gmx.de>
 <20211001175422.GA53652@sirena.org.uk>
 <2c4d7115-7a02-f79e-c91b-3c2dd54051b2@gmx.de>
 <YVr4USeiIoQJ0Pqh@sirena.org.uk> <20211004131756.GW3544071@ziepe.ca>
 <YVsLxHMCdXf4vS+i@sirena.org.uk> <20211004154436.GY3544071@ziepe.ca>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <af8df53c-93e9-f157-9308-b0b69908e112@gmx.de>
Date:   Mon, 4 Oct 2021 20:30:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211004154436.GY3544071@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6BawwZRvhSZFNFahnbJztUOfPMlcFJNspLu2cSkUdr6m9nIuqj1
 i4mVmx96ySWIzhvtPAb9xtA98bkjRdBwrKF0r1p1zoVrnpfGiaBlPm4uBieLZXXqaYq2FJ4
 SY9QZ0fRvqMoYxC5i9fCTn8gNmO98MRY4EcSPrSjU362piegFL2yyYJpaqVF/OAbAKkrdAe
 vPsPO2+FcyTDbksiRR4+Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:CS9UQIO2qgc=:dt3rstHiQk6qz0r5/HxxKQ
 ZXElpRA1yQTyRXX3TCGaJF0XLRcFyXoCHL1nCjMI6Scwn57rL3saa1NBtOjatAJ8yv836OI6X
 reAsfMv1kHBzYlvlM9o3g9usJg087vl0VAv7hwUsjDtiv5x22z41yJ5bmZCvaMiq1iF2a9B7j
 1OSAIdwUVXBaXVImJiew/eW/YM+miedU98kl25BmDwXYRBREB6XUoUJ80cWQ72J1cZjbxVRCq
 oP1xutjx8O5gJmaribCb0Vy3ZF2vHODt9MZcwgx/WeDsbVj314uMcr6PZyxIOBRooDgExCx5D
 GgQ8zXz2scDg7PXDZfsoxawJjPsVtw2pm34Ya4XK+fN3SDPgbY8cl2KA/OK2tDQGKwhEzATMZ
 7lfONjN/EgSjzvRYSX7Jr+Hus1z51BIq3xU4XhIubbys0GjquUjQShvAdL2KtXj6R46yUBBQW
 6BeYvVvOFfTQXBLHux9wF9eyNk+KhFyQPe6MEjypTyBVEFu/7D9FYKEBfQw7EBKpQKHIdKCID
 ghQQkPRzzwqNVQvs7WBzJ/roNqQWZonxGug22cwyBfJewLa6XYNm+0p7FpO3iWpijmnnI6AL5
 kRVkK2cjbBRElCQDuEyWbKern3BkLZV24WsYvLJKuKO0adaULYE1EfHl7tJC8iAOTBzozuJI5
 6nsCgODqw33j+X7USRgdFY9Q1nhIYm0g8e4EGf1nyqgQZjBiS5pnrpjVPuqg0NfLdDAuxPyWh
 Wnel+2SglSdzKjtGBQn08cLB2pzWYAKPGkEDrQ2JIJS6ZVJsH558ZZ4mDbS6OW24nWi1gz/Hx
 VNvxowohrplkbQOQ4LHGhAOdn2cTGDRWAHpoPmYfjJqaV44jqYVd8TmG47RxEiYswKBLBUeHf
 CTtoBQH3MWmbig/Ni6GtKH8tFnNhVJmyBGr1UHGUobj6ysHuP1qObYL2NQYtOshHf2AEA2TIw
 EcyNAnbjrAC1c5HzdYIeUUHY4AfiB6VOS7QegSZdhQ/z3V7wfvgIv7tfA79oDLT4i+NeJx4XQ
 4OGE9lvnukSnLesazpJ2DqHKnwCn+QMzr/IYjfnqZGTu/qldxhJq1WxYqK1aub9WgNxmC+d2j
 XahgvKuYDdWDco=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04.10.21 at 17:44, Jason Gunthorpe wrote:

>
> Well, that is up to the driver implementing this. It looks like device
> shutdown is called before the userspace is all nuked so yes,
> concurrency with userspace is a possible concern here.
>

So the TPM driver has to handle remove() after shutdown() anyway, right?
Because even if not caused by the BCM2835 drivers controller unregistratio=
n
something else could unload the module and the problem (NULL pointer acces=
s)
would be the same.

Regards,
Lino
