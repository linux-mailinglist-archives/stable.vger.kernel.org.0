Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9EE531D0AB
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 20:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhBPTGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 14:06:16 -0500
Received: from mout.gmx.net ([212.227.17.20]:56825 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231190AbhBPTGN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Feb 2021 14:06:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1613502266;
        bh=Gcc5iJpCN/tRdzd9u0FeyUXIBdZ6g6MDDhUiRhYcTmQ=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=JSRBy2iiq2Ha2QWmrqj4J7UU5le3lvZRnwO8mX+t9SClF/y37cEmTTZirQrn2R/Z0
         FMFdzA+gYE7+LSo2rAtgwpnS50LtZbui+lt94fyZq6EAjv5wsa67WVob6edtfzqQub
         BcjJMQfUZgJb2CObYLRCyQWq8PqIXSzv9QgQKNe4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([78.42.220.31]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MbAci-1ljEbS1cOe-00bdlk; Tue, 16
 Feb 2021 20:04:26 +0100
Subject: Re: [PATCH v4] tpm: fix reference counting for struct tpm_chip
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     peterhuewe@gmx.de, jarkko@kernel.org, stefanb@linux.vnet.ibm.com,
        James.Bottomley@hansenpartnership.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>,
        stable@vger.kernel.org
References: <1613435460-4377-1-git-send-email-LinoSanfilippo@gmx.de>
 <1613435460-4377-2-git-send-email-LinoSanfilippo@gmx.de>
 <20210216125342.GU4718@ziepe.ca>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <792e6e77-ef0a-d678-88fe-71efb7dcd52e@gmx.de>
Date:   Tue, 16 Feb 2021 20:04:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210216125342.GU4718@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:h7jCrqqy3z5Jg1+BdJKncrnPJhGlD49jqwg98CWdGkxgQsH83HS
 hYijkUr+2p9xdJJzbffO/ZaccBUWgJ661qisQf3yTyo/W7UfNI16beI4LEJgpDaa3itDjAF
 gFy3FESVJbyrjXR2nucH8YSESNENebeFKCJlpj1kusijBdPwbg/afMEEKmenA0qcCJvIWCg
 ClmMHQyGUMxPIvspuCXzw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:wVrZ2O4NEY4=:gZ7+9PjOxQcqutPGoPbRfM
 mOWruhu9pjYz5qMoo5hvGiUxGBE/sQ/oDYv5RX9wREReI+q/UChtt5HgiD5m86f4524K1UhAv
 NYTT632TeGkvhgAqqFZKkAWID5RSPHfuwD8NBvYzo6+BDgcZomp1yRNO1MCfRiRXcecvIVIx+
 Y3dF0ykKRGbv17GxxmN1HLVZI//xNV46EIxl0RbN11iUuDgIVuSgFHw1kyM/1EPhsEzHqGKrb
 XvJHvOsbNls2/LhzMCgUSkKiHstu7aDvsRD/0ZnJPS6bIrXYSlRROk5eZHah1Ai32XMlStvlW
 mtD4W/7gd4c3K/Zn1+mamHWANj/5jq7yg5bdLrjq/uKKfaHsWg92I3QHRgS/gPVbxSgSMGKt3
 0O/xW3udAj+S5gpVDV8K1e/S0uLdhgL5jb9pwG4ZSOipYmNZKfZaGBMqrzUeepUOkdFSliU77
 EwTszqgEv/149lGHddQxvpheEwm0IUIdawManjDoPcxI2drYqfg67KcuKs+RpTylCHcAgPDae
 tKW9yX067NKk7/QFU2qYfpl6OchrG8U31y70vJ8x0tNmFLGIK2AL8Bl9IcxIHvuiqJruAdqZ8
 ijxisyx1qKJen9V8QlGaPm3AJvoqoaOeYpRZyUo5KLwtupHmlv900NK1eL/Tkfz6QPsT88Y0D
 xTeKwYT7HseryZZQBe6MRF4UOxe+odEFdE7EcdCVweiuJ5JyGiznLXEy6ZC5C39PK38WoHbJy
 2OpCmdiKlrV+CvlOGj+RhCSeuW5ccZzJvmWQC1LBuUpIpicwG0as2WhBNqC8LPoLRe0NrwCrn
 K5jj2+oXk8CNzDmexyrm7BYuwi/NpPkEPQ1JqTOTn5tjGyBjYvVUP7+LzYLAmcrxQTIMX62gN
 lt6SdJkKstmiGmefRyqQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 16.02.21 at 13:53, Jason Gunthorpe wrote:
> On Tue, Feb 16, 2021 at 01:31:00AM +0100, Lino Sanfilippo wrote:
>>
>> +static int tpm_add_tpm2_char_device(struct tpm_chip *chip)
>> +{
>> +	int rc;
>> +
>> +	device_initialize(&chip->devs);
>> +	chip->devs.parent =3D chip->dev.parent;
>> +	chip->devs.class =3D tpmrm_class;
>> +
>> +	rc =3D dev_set_name(&chip->devs, "tpmrm%d", chip->dev_num);
>> +	if (rc)
>> +		goto out_put_devs;
>> +	/*
>> +	 * get extra reference on main device to hold on behalf of devs.
>> +	 * This holds the chip structure while cdevs is in use. The
>> +	 * corresponding put is in the tpm_devs_release.
>> +	 */
>> +	get_device(&chip->dev);
>> +	chip->devs.release =3D tpm_devs_release;
>> +	chip->devs.devt =3D
>> +		MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
>> +	cdev_init(&chip->cdevs, &tpmrm_fops);
>> +	chip->cdevs.owner =3D THIS_MODULE;
>> +
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
>> +	put_device(&chip->devs);
>
> I'd rather you organize this so chip->devs.release and the get_device
> is always sent instead of having the possiblity for a put_device that
> doesn't call release
>

Agreed, I will change it. It should not make a difference in terms of corr=
ectness
but I see that it is less confusing if both error cases are handled simila=
rly (plus its
only a minimal change).


Best regards,
Lino
