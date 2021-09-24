Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45834176B4
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 16:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345170AbhIXOTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 10:19:32 -0400
Received: from mout.gmx.net ([212.227.17.20]:39995 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344675AbhIXOTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 10:19:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.net;
        s=badeba3b8450; t=1632493072;
        bh=pr0RZOMzxXrMHFBdCZaR3+l8sas8VDW0nrMQnd+FOgM=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=dzR2B3PvydKfjx4kez0+Shf+7KWXKBoI85+xrYcqvfoXDa0xDrdbwgWDk1ZHmIwY5
         XXWayzjA9LBRtIMuUQbGdLckIoNEM+Zx+v9Vn8lKbw0VnXSY8zy9rSXopAF+hfNlmi
         Gv0ltwrNM8zRwqGnvwmLPpamOWIEvrR+V0IdfxEc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([46.223.119.124]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MEm27-1mf3V52q67-00GJ9w; Fri, 24
 Sep 2021 16:17:52 +0200
Subject: Re: [PATCH] tpm: fix potential NULL pointer access in
 tpm_del_char_device()
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, peterhuewe@gmx.de,
        p.rosenberger@kunbus.com, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210910180451.19314-1-LinoSanfilippo@gmx.de>
 <204a438b6db54060d03689389d6663b0d4ca815d.camel@kernel.org>
 <trinity-27f56ffd-504a-4c34-9cda-0953ccc459a3-1631566430623@3c-app-gmx-bs69>
 <c22d2878f9816000c33f5349e7256cadae22b400.camel@kernel.org>
 <50bd6224-0f01-ca50-af0e-f79b933e7998@gmx.de>
 <20210924133321.GX3544071@ziepe.ca>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <b49f4b52-44c4-8cb8-a102-689e9f788177@gmx.de>
Date:   Fri, 24 Sep 2021 16:17:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210924133321.GX3544071@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:oWjlOrtiKQPng30WZ0cwBATS5seyB+BK20TFO6LvBOAyir8R5v0
 83Q0Zh73oZzZHgMBZIG+V+Y6zSE8TqfzIwG12mo++4SYVd2P0bRprVMnUPHrGb7KnpdkaOE
 aMTMeQJB9zucxFSLJVR+/UTWa3I/yLvOb9SN54sS2wV6/NpadaXABr2andOHvzFxCVgodLQ
 oaeWXGfHRQpLvCVaALcBg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:np5Jp9L7dRg=:tAasIpqrbfKwrh1T4UY/mT
 o2J2BaBJKO197LSAo6f9u9dtC/fhmmIibqKTKe+08EhWtWpoAZ2WjlYAqOmk7CtcrIE+QtlVq
 DQ65i4aF/eWrnIim+tlMP50KS0tZKvGXRQ9H+295hnRKBvWZMvld2g/Vio0jBpr9/6f1pmLW8
 rFrH8o3DW9kMROp+eId5DtVW+pr5dEr3d70Uvloi5Le+TUfly1OEWexf4jrzx5BO4CDdMyJZx
 7PuBEY9iDo7heUtuuINqgscc28FkDc7lomQDU6mQoC/+EYY767ClpfSh77GKQgITb0je2iR11
 fxRcKWizG8damtp7fJ92iLtIcXldnsQpzB3X04avNhN2rrnLnnz1r9dOWTr8xA/ogBRDPfDCv
 W6jE7nK0EkPOp6wF/K9tAJJMQODjKpythWP4d81Dw8rFbdbxZe7LGRYuKUhBSs5K5tYmZ9D1+
 UB4OO7JzNkr7SHt3+ghiAiFUnsuSvHkHAdqOVkiMnfprhm95X135QjUycbc0BMfefpbD0oWa4
 pTEEos+nF0hyfteV8hvDkmqT+ROII82Mlkra+0h7Ehar3M/AXSP1eUs4bHgX45sEt3WNtO2AV
 3auDMEGMoBWLLdzoJRDLCPtXGWJCHd3rp7WUNuftHSsjjOwofNOdEoOj1oXj2/8Ti+nCBjb6p
 p/6YNzQP/C6gvDqrp62HpPT7fhAdQQRdw4ozlbvsxazi0hmGGwo6EY+dQPp5lLPG/CXWpAZnM
 O/Z6PnNK9ASXvuxr6LroVMYQo0SemrL+R/qFv6u2/Av15Gdwb8vYF5AG1uwey2naFBlX2yxZS
 PICnZRiF/omlDvkYlQbFKJHwJtIUvCAn+xjP5EMPDyUSsAlkTXMxZxnBMfHySdRK2vIBHN9gF
 Q6J0QPe7xgk8PgdrCNjPZ2T4LpoY0zWq9oA13X4jtH1hI5oe+kHZUwn3xM86tHtEa3EalqF9S
 ODkoUcWm6PbPNu4f0JvKzQ6DbiU+XUkdMywCLRreo6BDhAKvLDnXHfHO8K+SF08ABcYnWA6o0
 eF0Q29K1vA4lhMoY3SRGUMRKpfd90LcA0flXGmKs0ECMTHWRW5Y2IpVq/wYRBFuNi+KDyIZU8
 rsTchXeancK3ZI=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24.09.21 at 15:33, Jason Gunthorpe wrote:
> On Fri, Sep 24, 2021 at 03:29:46PM +0200, Lino Sanfilippo wrote:
>
>> So this bug is triggered when the bcm2835 drivers shutdown() function i=
s called since this
>> driver does something quite unusual: it unregisters the spi controller =
in its shutdown()
>> handler.
>
> This seems wrong
>
> Jason
>


Unregistering the SPI controller during shutdown is only a side-effect of =
calling
bcm2835_spi_remove() in the shutdown handler:

static void bcm2835_spi_shutdown(struct platform_device *pdev)
{
	int ret;

	ret =3D bcm2835_spi_remove(pdev);
	if (ret)
		dev_err(&pdev->dev, "failed to shutdown\n");
}


Regards,
Lino
