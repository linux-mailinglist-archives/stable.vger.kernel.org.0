Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61543113E8
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 22:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhBEVwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 16:52:00 -0500
Received: from mout.gmx.net ([212.227.15.15]:38133 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230038AbhBEVv4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 16:51:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1612561807;
        bh=ML2q4g4mzki1+bGinziqhHSPPvaG79ZS+7tvrsuX1oI=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=LfIPjfUIHz9GLocJUf0jLFyYjCmkbDrZYEn8UOeegb1yTLiJHAKkgv1Q4/oCI1Vp1
         NfLqP7xBqU0jKwmEmM58m0VNEQRt5bqv4ofJ+sFu53CvrCMHLo4lf+UMZdU+9m+obm
         QohcM+ZIF6wM9TT05xu7C0BkFBLIB/26gaXFtNL8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([78.42.220.31]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MtwZ4-1lvYiB1kwG-00uGAU; Fri, 05
 Feb 2021 22:50:07 +0100
Subject: Re: [PATCH v3 1/2] tpm: fix reference counting for struct tpm_chip
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>
Cc:     peterhuewe@gmx.de, jarkko@kernel.org, stefanb@linux.vnet.ibm.com,
        James.Bottomley@hansenpartnership.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
 <1612482643-11796-2-git-send-email-LinoSanfilippo@gmx.de>
 <20210205130511.GI4718@ziepe.ca>
 <3b821bf9-0f54-3473-d934-61c0c29f8957@kunbus.com>
 <20210205151511.GM4718@ziepe.ca>
 <f6e5dd7d-30df-26d9-c712-677c127a8026@kunbus.com>
 <20210205155808.GO4718@ziepe.ca>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <db7c90c3-d86a-65c9-81a2-be1527b47e11@gmx.de>
Date:   Fri, 5 Feb 2021 22:50:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210205155808.GO4718@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Dc+DyMFu83Fre0D6v74WAtZQa6sRGXtjxhfcs6BuCMcFJ4VAv2d
 4DhriDvPrW1+ZOyKVRTo2fsxFhwZjC3b7HcDV8ylKpNwrdpqfyMI/w+jQfSWYHp7m0evBUr
 bLMsdci80ThI8GzE3vijiGfgEpz9PkX0jQmMcnYwcNdPXuWM6uleFCKtJ+yY2tuMyMTxYPP
 5tPFakeWEMw8w7b0gmYlg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:R0bB3hGyUPo=:k4HkKdMep4QkVXmo5xW4/o
 P4WuCtr9KKEe8CZ21M0/grJHF1pwQHg+8T2ADxWicmuJL/PjiAMOynm57BiiDcjJkV7kLF++S
 aaMCLZ5DNGRcUcgcSL2Yn1PUp1m6yPFkOM7ALbeOVuI103wuL0KhsAtfto57BMkdHY64/OVT2
 1VSwGDoHgoZV+I7ehO5RSvE4sRnEhrx0828HMSPnS8mj/OPNQPrZdQTdw2mSw5PztEvbtQU2M
 V3BOhfL1QPuZpr+TYLf9wGssHMlAF1ICpIRnBQ16EOBV0O3Ls5zJk7DTxwS1Fd1MLEQU4U6p3
 uv3wDiP/grsMcYhcIYYguLOslSdhjt3mI/YZHUpIBI8GIoO0wD/NwfkWWbbsm8I0jaaM2wJCy
 hBANeI0Y+q3CWPsZBa0oz13cOagxLtIcz65uWf8V5bJiuuifWow7vMVyXl9a0xLNh0UNTdDeq
 RN20zEwqOpAE9wd/8hSzU/YOJ6nGi8bWdZ6giKnagn7G7/b3A1Pz1Mz+YGCgJpMKjjbF+0GUO
 DIzdOFEL4xIKgynVcNEHiDK5ZwGlXU02iKr/9s34rZxzOG6Cgp4c/KpsBVyuiNXzg0GAhtayW
 4uHj5Klsl/YZPh7EKxLrkSNg6ciyY8/4dclfPkqAfWqY1+atxK36Ia99pGOYfg1vuoCGvq5ZI
 OKQBYaTRKjK8Uh6gov3qQns6ilrYuKZQ0xttoJYiOHAzs+o3x9fEqKB+UXe/3Xxu3/UH6Q1qv
 NX/DghukkKLUolh+Cjckbr31cjhZgdNU87RVG1icQ4tV2pOVEpbx6tSFnMgDDyYNgGEa5vuxi
 o37aYpS3H3WPi32aoDQJlMAFume0Y7w2WBqpchqNIRjAZDPF5UQIK53EMye9l+yo2Tv04nR9w
 X7aFUyUSi44wCngC35zA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05.02.21 at 16:58, Jason Gunthorpe wrote:
eference in the first place).
>
> No, they are all chained together because they are all in the same
> struct:
>
> struct tpm_chip {
> 	struct device dev;
> 	struct device devs;
> 	struct cdev cdev;
> 	struct cdev cdevs;
>
> dev holds the refcount on memory, when it goes 0 the whole thing is
> kfreed.
>
> The rule is dev's refcount can't go to zero while any other refcount
> is !=3D 0.
>
> For instance devs holds a get on dev that is put back only when devs
> goes to 0:
>
> static void tpm_devs_release(struct device *dev)
> {
> 	struct tpm_chip *chip =3D container_of(dev, struct tpm_chip, devs);
>
> 	/* release the master device reference */
> 	put_device(&chip->dev);
> }
>
> Both cdev elements do something similar inside the cdev layer.

Well this chaining is exactly what does not work nowadays and what the pat=
ch is supposed
to fix: currently we dont ever take the extra ref (not even in TPM 2 case,=
 note that
TPM_CHIP_FLAG_TMP2 is never set), so

-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		get_device(&chip->dev);
+	get_device(&chip->dev);


and tpm_devs_release() is never called, since there is nothing that ever p=
uts devs, so


+	rc =3D devm_add_action_or_reset(pdev,
+				      (void (*)(void *)) put_device,
+				      &chip->devs);


The race with only get_device()/putdevice() in tpm_common_open()/tpm_commo=
n_release() is:

1. tpm chip is allocated with dev refcount =3D 1, devs refcount =3D 1
2. /dev/tpmrm is opened but before we get the ref to dev in tpm_common() a=
nother thread
rmmmods the chip driver:
3. the chip is unregistered, dev is put with refcount =3D 0 and the whole =
chip struct is freed
3. Now open() proceeds, tries to grab the extra ref chip->dev from a chip =
that has already
been deallocated and the system crashes.

As I already wrote, that approach was my first thought, too, but since the=
 result crashed due to the
race condition, I chose the approach in patch 1.

Regards,
Lino

> The net result is during any open() the tpm_chip is guarenteed to have
> a positive refcount.
>


