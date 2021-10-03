Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2777742022E
	for <lists+stable@lfdr.de>; Sun,  3 Oct 2021 17:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhJCP14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Oct 2021 11:27:56 -0400
Received: from mout.gmx.net ([212.227.15.18]:37487 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230516AbhJCP1z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 3 Oct 2021 11:27:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1633274750;
        bh=GsIV15WbViOKkLUGeouMdOFdGvs2UA2diG7UBvlfgvs=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Ge0tKegNb5s7q3aqxsDMJHZPB8zu4m5Bo0cdOLI/C77t7EAzDyrVtkIWsjFw/jrQm
         +7Fp3hAor1gaANsykcuO9pNSwG+7rsJCkt73vE5ny+YRb7q9lwvzt/CT3lWjlo6usK
         BSsSfzSZJ8Kbm2oSWv9SB+nlhspxwsO3+gdePTYk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.54] ([46.223.119.124]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M26rD-1mUZKZ0EeX-002aNz; Sun, 03
 Oct 2021 17:25:50 +0200
Subject: Re: [PATCH] spi: bcm2835: do not unregister controller in shutdown
 handler
To:     Mark Brown <broonie@kernel.org>
Cc:     f.fainelli@gmail.com, rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, nsaenz@kernel.org,
        linux-spi@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jgg@ziepe.ca, p.rosenberger@kunbus.com,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org
References: <20210928195657.5573-1-LinoSanfilippo@gmx.de>
 <20211001175422.GA53652@sirena.org.uk>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <2c4d7115-7a02-f79e-c91b-3c2dd54051b2@gmx.de>
Date:   Sun, 3 Oct 2021 17:25:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211001175422.GA53652@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:JXzItrah1Ysv5H34L0vLflnCcU0pNh57s1u2g2KlMO1ntSz2/KF
 Et+leSUTxSIhHkZiqMU1lG5a887SeUgTQNSAGrQ47OTfPWcmhYOBQieM7Q8IxQkcxn1dPRK
 Sdn8pK5zyk2sjy48Q9TPNYs+SOw45UDXoehKfjltYlu6P+qtymLNQ57SSLFr3A0EwzvhMh9
 VrXUWfBLHGTtUxXDtsBRw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:6zwH3r+iLco=:6W0apopmoj2B09KvDs+rIU
 cQFTT2y4R3c2xdCAjDCYOPwfYFHJMFovhRRHMzJmilHReC+fla8JZKctZTE/cIIwx3MmYvUwX
 2WT61p/+37yZGEnAVkCKnfFqYHArblQEDKt3Un/BJzyJV7f8WRVM1N1sow2dcX0Ix0o3IQPC8
 0pewl87Sa/4X+7FuC2NG24n6+HWmZCJ77BN789zZPFqTs/5m4VZcooH5cX1KDaS/1/ITCsCLF
 uGgxry8VQIXPtXtEbqjzY+vP7zT8hoMVubPcPQLyHkhbBGuq8GsU26inAGmLXqxFH4FFzyiK4
 glKOrpeFz280AxlQAWxWZ23nKiAd+4gIIe6q343ZeIyQHtKAna8/q8Bx1SI33D+l0oBdPG0hK
 hWKNrVD5tXJCC9n/nMVFewHqn/g+4PR1IhdYY1zGweUkdmq/Pz0rYKTIeWeLJd/YOp0An7BZ8
 lZNIOODue23K7WjV1KEI/DZ4ao1mYT/6LtM0V1W73KDOGqwVSfkzAhXMMM/9bpd/kE4flaaI9
 JUWIi5FzhI88cZgsxyFTBdYf1HSFIVz3DwRNhQ96KHTYcN091RlgMKueSZ/vbbenlbbzj6Mwt
 4PKEBNrLAIilLoVFWSw2t8aQYRKqry4puEbqNn1ZMi5PvcUp2/ZqE1HL1izNk+NyQKOfSqD+8
 AC4f6dHk+s5QR6zliP1lF4vZ+M9cF54H3GSRhHCDFBYDJg0J1bPt3eX12n+17dnYRKGfYOeTp
 bTMIumzxiC/9u5w1HUBAeDWf8/X+poWAHg8f7ezWxpwIIvgq/sWuovsAWHWABG4CPVg2gH96L
 1VrlE4U5Z3V+W1fn8ctj4jlh1lr0dRkPdYPmNslhahuDOHCWuApQZ5uKnAgx5WTJ1T5Tq8SX3
 UBYwRXmR5M/+kfjTbHcbPVvtQvk/YUPW5AxJK+leNSMVpryhOdaqiLFIIiuWSA8cHWks8LHVD
 PMLB+iJ5UKLsvagA+HWrzYHcRSkt3ACJKzsNPN6+5i6ZD0Qwg7CG6yfoRbbSd1691frm7aPNS
 FEijcEJ0vji19sHXaQn/8iZICE3Z7WLfRWRt3sgnpb/HRIMBThz5xWeEyfnKr+UanHj5+fKpq
 rePWMb5ClTYlQc=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi,

On 01.10.21 at 19:54, Mark Brown wrote:
> On Tue, Sep 28, 2021 at 09:56:57PM +0200, Lino Sanfilippo wrote:
>
>> One example is if the BCM2835 driver is used together with the TPM SPI
>> driver:
>> At system shutdown first the TPM chip devices (pre) shutdown handler
>> (tpm_class_shutdown) is called, stopping the chip and setting an operat=
ions
>> pointer to NULL.
>> Then since the BCM2835 shutdown handler unregisters the SPI controller =
the
>> TPM SPI remove function (tpm_tis_spi_remove) is also called. In case of
>> TPM 2 this function accesses the now nullified operations pointer,
>> resulting in the following NULL pointer access:
>
> This is a bug in that driver, it should be able to cope with a race
> between a removal (which might be triggered for some other reason) and a
> shutdown.  Obviously this is actively triggered by this code path but it
> could happen via some other mechanism.
>
>> The first attempt to fix this was with an extra check in the tpm chip
>> driver (see https://marc.info/?l=3Dlinux-integrity&m=3D163129718414118&=
w=3D2) to
>> avoid the NULL pointer access.
>> Then Jason Gunthorpe noted that the real issue was the BCM driver
>> unregistering the chip in the shutdown handler(see
>> https://marc.info/?l=3Dlinux-integrity&m=3D163129718414118&w=3D2) which=
 led
>> me to this solution.
>
> Whatever happens here you should still fix the driver.

Agreed.

>
>> -static int bcm2835_spi_remove(struct platform_device *pdev)
>> +static void bcm2835_spi_shutdown(struct platform_device *pdev)
>>  {
>>  	struct spi_controller *ctlr =3D platform_get_drvdata(pdev);
>>  	struct bcm2835_spi *bs =3D spi_controller_get_devdata(ctlr);
>>
>> -	bcm2835_debugfs_remove(bs);
>> -
>> -	spi_unregister_controller(ctlr);
>> -
>>  	bcm2835_dma_release(ctlr, bs);
>
> It is not at all clear to me that it is safe to deallocate the DMA
> resources the controller is using without first releasing the
> controller, I don't see what's stopping something coming along and
> submitting new transactions which could in turn try to start doing
> DMA.
>

I see your point here. So what about narrowing down the shutdown handler
to only disable the hardware:

static void bcm2835_spi_shutdown(struct platform_device *pdev)
{
	struct spi_controller *ctlr =3D platform_get_drvdata(pdev);
	struct bcm2835_spi *bs =3D spi_controller_get_devdata(ctlr);

	if (ctlr->dma_tx)
		dmaengine_terminate_sync(ctlr->dma_tx);

	if (ctlr->dma_rx)
		dmaengine_terminate_sync(ctlr->dma_rx);

	/* Clear FIFOs, and disable the HW block */
	bcm2835_wr(bs, BCM2835_SPI_CS,
		   BCM2835_SPI_CS_CLEAR_RX | BCM2835_SPI_CS_CLEAR_TX);

	clk_disable_unprepare(bs->clk);
}

Regards,
Lino





