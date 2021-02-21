Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3320320997
	for <lists+stable@lfdr.de>; Sun, 21 Feb 2021 11:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbhBUKVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 05:21:24 -0500
Received: from mout.gmx.net ([212.227.17.21]:56465 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229502AbhBUKVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Feb 2021 05:21:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1613902773;
        bh=wODiBjnT/f1js89rh/S8lYuasVsARYyh6GdrFA3yrhU=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=A0tIUFTQKnmlPC//r5ZCVnLhq+JDm5bNZWQY7CSZsN+C+YExZcKrxZPTuxA0/Qvi9
         VwttV24CqfY5di3DH8Rd2aL9D6igzByrkedWEg4HKgEUMm4USjch43YxFfVgt5fwvj
         NS5AArOIc2pua094vVV1ew/fGzOG7HQMVOR8cH6Q=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([78.42.220.31]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N7R1J-1lv6oD3aQv-017j41; Sun, 21
 Feb 2021 11:19:32 +0100
Subject: Re: [PATCH v6] tpm: fix reference counting for struct tpm_chip
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     peterhuewe@gmx.de, jgg@ziepe.ca, stefanb@linux.vnet.ibm.com,
        James.Bottomley@hansenpartnership.com, David.Laight@aculab.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>,
        stable@vger.kernel.org
References: <1613680181-31920-1-git-send-email-LinoSanfilippo@gmx.de>
 <1613680181-31920-2-git-send-email-LinoSanfilippo@gmx.de>
 <YC+BRfvtA3n7yeaR@kernel.org>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <aa2ec878-f8ea-d28b-c7c2-ecdc3d19f71e@gmx.de>
Date:   Sun, 21 Feb 2021 11:19:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YC+BRfvtA3n7yeaR@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tDY68+aMWOXi/OV26ccKmpyEOr/TeQn3WoE3bI5N8tH6P/hFuw0
 nQBa5b5JUtPB6b8beQbW5BM7a6Lf4P8KODv3DLspYpwvBQ2nHA38ZUzYk2qHDlPiXMo7q6q
 VPiGouesy5YDeXRxeaLOXIxrqX9ncKu2xzMq1FHUQXgw1llcxF2rrFs/cQo1rh20P5+kc4L
 1IOxWe+nB03cIua3NlLHA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:KgUuKdzeVis=:9KlqlSLf+kq82Xx1ngoruL
 yfyLS72OofET7ldJXf0rHp9MG5HOMnK1/QwXsETWwMJejPjRo3VwHAKJ6Ag4kIrRLOJ6oH1Ls
 6tEdw4/LVo09swwfHzfmW2doEbxAAKTvWHeNuQuMHYyItzTTRFavKgHWce0VwjZlzCtA6HgRG
 VaRCPw20h+o/Znu5SNp2XkOvXS9f7vPckzSHOI1+CIwp4zE9hB02XDUT2ztZszuZo1zxFlrd6
 dtig4vtr47hefuwa+Qjvv0FW5MtvH1UAPMM7K5OQ0iePSBu+TE2YeeKfpJOYeDNzwfcnxiyre
 aohYaIcbla/CCQegHYNlxS8cOLZqdNQb43UUuWhuDHbPi8LF7pVf7rWyQRcFVTgXvFC3k+3dv
 g4FPoRJB0Ycc/nS750ZRVse3h6HJnDwZ1NwVIJ2Xgio4KfGO8kXguFLFmecgT6gc8Ue3KBZAj
 3VbX3mSPt6LatXTQr9KbzM0Hr4NbXKItj7pX6qmgyGds0mnDr1KmpL6niTlGMGYw/+FZ7UkS/
 OWrtcR1HmcJr6Nx3GqAENzJXlhv9cAJsraCBf7MyXlJlNXrP/rwt3PlsNcbrrYl25DQw39xK9
 BWh/5HiYhgWNp6xj99mIYA2D1VQrQE2MXuJX2PHW2olmNWuQxNgVzS/KUx3fZpE3eH0Cpvn/3
 TCDOaIpJn5TO3ImCU3B776eWCFc3D2WZHcFL5484A5Lvhfit+tM0PD3bl8424wbGekURtPVYc
 7xaxeL3npAgtTaitOzvUYv79CDBm+C0e3BzxQJp5S/ABJy2+ccDU6YCX9e5eEmZAMUpi2F2GN
 H/msTBAd8oaznu8Q4we8ZLrqOYKkSs+Otu5Mmr/3kzVs0A5zmmBsbY0YQ4Q+4ka+8k+oB71fN
 gZifhpYTLNHG4K/aj13Q==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi,

On 19.02.21 at 10:13, Jarkko Sakkinen wrote:

>> +	rc =3D cdev_device_add(&chip->cdevs, &chip->devs);
>> +	if (rc) {
>> +		dev_err(&chip->devs,
>> +			"unable to cdev_device_add() %s, major %d, minor %d, err=3D%d\n",
>> +			dev_name(&chip->devs), MAJOR(chip->devs.devt),
>> +			MINOR(chip->devs.devt), rc);
>> +		goto out_put_devs;
>> +	}
>> +
>> +	return 0;
>> +
>> +out_put_devs:
>
> A nit:
>
> 1. You have already del_cdev:
> 2. Here you use a differing convention with out prefix.
>
> I'd suggest that you put err_ to both:
>
> 1. err_del_cdev
> 2. err_put_devs
>
> It's quite coherent what we have already:
>
> linux-tpmdd on =EE=82=A0 next took 8s
> =E2=9D=AF git grep "^err_.*" drivers/char/tpm/ |  wc -l
> 17
>


The label del_cdev is indeed a bit inconsistent with the rest of the code.
But AFAICS out_put_devs is not:
1. all labels in tpm2-space.c start with out_
2. there are more hits for out_ across the whole TPM code (i.e. with the s=
ame command
you used above I get 31 hits for _out) than for err_.

I suggest to rename del_cdev to something like out_del_cdev or maybe out_c=
dev which
seems to be even closer to the existing naming scheme for labels.


Regards,
Lino


