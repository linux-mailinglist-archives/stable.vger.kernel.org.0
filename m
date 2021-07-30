Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B064E3DB801
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 13:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238652AbhG3Lp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 07:45:58 -0400
Received: from mout.gmx.net ([212.227.17.21]:38947 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230157AbhG3Lp5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 07:45:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1627645548;
        bh=5nwtFUK6rZsQSaPedvMtggo0kXPpIuOZXQXwWmwUXyw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=QV220zb7rpnBcz4J0qAKKimC58tuXv5SUSM1V8eY52hw/duRbaqxszjCI1958pJ26
         O9+H+cF/22/Pj3Z0YLmtgWe9eSYl1Ppn1phH9vW4QatTygOrQLQdhvo8cJos/Em1m2
         4B4P8er62f0ZqOOUidr13ckYbn+FBhHEYMuxvw3A=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [87.130.101.138] ([87.130.101.138]) by web-mail.gmx.net
 (3c-app-gmx-bs53.server.lan [172.19.170.137]) (via HTTP); Fri, 30 Jul 2021
 13:45:48 +0200
MIME-Version: 1.0
Message-ID: <trinity-23757337-a194-45c1-864b-6f96a754fed1-1627645548572@3c-app-gmx-bs53>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     peterhuewe@gmx.de, jgg@ziepe.ca, linus.walleij@linaro.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Aw: Re: [PATCH v2] tpm, tpm_tis_spi: Allow to sleep in the
 interrupt handler
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 30 Jul 2021 13:45:48 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20210623133420.gw2lziue5nkvjtps@kernel.org>
References: <20210620023444.14684-1-LinoSanfilippo@gmx.de>
 <20210623133420.gw2lziue5nkvjtps@kernel.org>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:iD0cgET1uosZgRcmeBTa/6zynHtSmS9RAa0zPzePWzPxyajS59Lk2bD+DghdCYoGMy3wl
 DVtcWR7eCEnJfdRwqKPuGaFNH6Y3TpQqnsas/6vYDwDPfhn7M41UIlWtz89kdV+bjN4Ki89TvXhu
 +fUryqpBqjDFTa0tBFgrBf6oEOiZaMx2SD3ao8FO3BQRyNESKtUiSZvY7gtvP60roXZLLMJyyY+s
 yxfYG1aZIMutHe979SBulg30sI8rVFFQ6gUiTT2l3vBJENW/DB295om1QJnPTtjil5Y5Cni93mBI
 Bw=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Sx8Hbnu69Tk=:P2zLXADOnYyEPlPGwyUGkl
 JDPf3njtHtSOnAvZRuaDs4w0PlIoy/fIbUyRQ7nv9sejlZ0e+S2K3DzLwjyvQuK5GtRfL5FL1
 EfZ3nbSpVQE6m0cwDoeDJnCbeaJiYjjacb3ru9yeVCxPIIPX+5iY3qNrCXbBgkA6u/BA4Td9q
 9H8QJjyuZFiw6joWvmw34iF+7Khtas7W4FsCuU1g03Y89Pzp7+LPonualQwIy4WVgvIRGTX3S
 +SU+U5DdLzl2zzBkB6bhO9ZGtX9ghU8eH0cNAYw1SjhU0cKu1JQGP2WODjQVns08Y1n30hzPV
 vSC44X9smcn/6j6A0bhC5KcBtMMf9jZewxqDDEqPVfQq6JlVyl/zoU7N8BYssQSjMhsVfPizH
 D8ew9d0iNVCT9w+dLBoQV83w9Ckj51kxUcR2wrIuNc2KJT/4qRKMSve3/F2vQx8krAxTbjj/N
 rudugvjvRAhJiKQ7k7pEkCsGO8qODhDXKMFI0/Z3xur0cO9uAt1iUbho7BfcXwsCymQjKrC1L
 X4yz5FEsW7+I0dDwQ8EeqafdOmhqpbSRva8kmIiiBLaIJKgElr7L1K8Bo7mSoPxlfoaO2HBkg
 IFdM6aMJuqCL0mPVR7BFm7kOc9nC30cg2AcsR0eLUjf90dDm6RlRdpRsCa1uNpZnosuuQ+gD9
 CMf6UTvH3A1rnVbhnI2Gswf0G2JPHaO+Tj+hvTb+Fs/1dR8qCEMZwL0mPQAiTpGGFBHz8VzSK
 R6anq5zpgN0mFUTK+LzjvToPLVJ/6jBs4irH8ejum0omELXzMlWkJrC/x9dW4aZJLgajW9DHP
 17NNPKbrfjOJg5pyfDjOhAncMHGbQ==
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jarko,

> Gesendet: Mittwoch, 23. Juni 2021 um 15:34 Uhr
> Von: "Jarkko Sakkinen" <jarkko@kernel.org>
> An: "Lino Sanfilippo" <LinoSanfilippo@gmx.de>
> Cc: peterhuewe@gmx.de, jgg@ziepe.ca, linus.walleij@linaro.org, linux-int=
egrity@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.o=
rg
> Betreff: Re: [PATCH v2] tpm, tpm_tis_spi: Allow to sleep in the interrup=
t handler
>
> On Sun, Jun 20, 2021 at 04:34:44AM +0200, Lino Sanfilippo wrote:
> > Interrupt handling at least includes reading and writing the interrupt
> > status register within the interrupt routine. For accesses over SPI a =
mutex
> > is used in the concerning functions. Since this requires a sleepable
> > context request a threaded interrupt handler for this case.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 1a339b658d9d ("tpm_tis_spi: Pass the SPI IRQ down to the driver=
")
> > Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
>
> I'll test this after rc1 PR (I have one NUC which uses tpm_tis_spi).
>
> /Jarkko
>

any news from this patch? Did you already have the opportunity to test it?

Regards,
Lino
