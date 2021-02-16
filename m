Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830E931D0CC
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 20:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhBPTRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 14:17:16 -0500
Received: from mout.gmx.net ([212.227.17.20]:34597 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229761AbhBPTRL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Feb 2021 14:17:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1613502927;
        bh=E4tIcmYcw1deIws19hTE9bSb/hZ8n3mZUE3MVlKTw5Q=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=MhQUuOjRvqEah4kCJGmhoSO0iECL7rLBinTr47Mh64TUagg6e30cdGcjB5zJjeF4g
         sngT8lrG+O2HPcL6fiViWSKDlfVczIHb1FV0x8RK5Ffg67tUWV/iItcowZtKY5q4Sb
         XjgkD6Pzsn/O6JEajl7bxt2+b3iRIha2GM2mA/50=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([78.42.220.31]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mr9G2-1lgVAH0JMM-00oBSA; Tue, 16
 Feb 2021 20:15:27 +0100
Subject: Re: [PATCH v4] tpm: fix reference counting for struct tpm_chip
To:     Jarkko Sakkinen <jarkko@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc:     peterhuewe@gmx.de, stefanb@linux.vnet.ibm.com,
        James.Bottomley@hansenpartnership.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>,
        stable@vger.kernel.org, David Laight <David.Laight@ACULAB.COM>
References: <1613435460-4377-1-git-send-email-LinoSanfilippo@gmx.de>
 <1613435460-4377-2-git-send-email-LinoSanfilippo@gmx.de>
 <20210216125342.GU4718@ziepe.ca> <YCvtF4qfG35tHM5e@kernel.org>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <a9327758-dbd7-9272-b580-c9807bad2e24@gmx.de>
Date:   Tue, 16 Feb 2021 20:15:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YCvtF4qfG35tHM5e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:5pF6WmKpnSxFSiEfZNQYHo+4PigGBFgtXoWsLIRKkmBKOVJUJOq
 GO706NNFYRpGIquOXt4QOnNl2L5T4zzfmcOxZsa6IMRgzQJvILDHShcY4C54NHZ+b/0CycF
 PhiiSdAsiUUJ3BA50WNdGpbF0sNWMjmo5gZpRW70F5VJ71Uj0THiekkPbefta7sftPQwR5A
 w2CdW9XChmEVb7o/XwNZg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:3v3MkXkPuN4=:T9NwJebOiGefsXr8sY1gLx
 gCrOfcn5BexReeT0DIz6VBShnvlK3zm9ER4WOT0PicpEYGDQIiB+9DpKSPpoU5sNCzqHPO4PY
 CTbVouM+dnxjneE8QuDtvXrNVdtdPVeaZCt28qf7WEJOODUBd9y+xpsd373VEa9iRUCeIrA7Y
 uYYjrC9kUL2r19vGDOOSu/ypELlt8/psHzTvxUWV070i+cbU5sa8tWmXJBQAYnN/5JDMPR6Jz
 YG9fDmblusAnZgjVmjV8dKrWEGSlyiK/jr2qs3ttOj74+z6Ra2pjksPjtlZSkHieL1tgOyZC/
 frA4VBzV21GvoEtFf0Nhns+wRPhkBaaxzVsvQ4Mqcu+Wd9zxGfusqvdsSwPNUUG05afsrPePj
 b7mFI8hiNjP92mSs58yDBVTKTTlH5wIJxJLYkK4y+3aCoNzZRu+C4y7wCQYzEnefLuClXv+ju
 MOV0zVWOnh/hyLJOFilDSW5QLne44n0IjT3bGL3l9dUgjO4Alz5g+UUjrEinXBSvNAlw2D5CL
 S+R14ksQTgBCWTXCumfO0stdrXWzL40Jva93jDFhdRi+ET31I3sMEdfHM09Y1co2rA+bfO7FT
 +VDsSu8GZcXepDDMu5T4ykrlopwegZWinOmwqGKJc0Z/tTWHXZXeh8TIg/ageSmbXrDcozegk
 ytXVE/ByQDdJz02tnF3V2VIM/beb2rlIfSA4oTF+z4al0Io5lk3Kun9Hi7j0egl+N3T2NIxUp
 FoPz6CpgB8fyodn9g8esDHyd8oBejzFBph5XjS2ugM1douH0v3Lva7mOOUhiu21EjLt448p4x
 dQKxw3N5Vs7uMa1exKpN9xusjstUSDOZphkwoDWgNfJKt1HZ293B942V5IKfBa2r46xVkXvk1
 V+cWO5fJo048DHHMhzoQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

On 16.02.21 at 17:04, Jarkko Sakkinen wrote:

>>> +	/*
>>> +	 * get extra reference on main device to hold on behalf of devs.
>>> +	 * This holds the chip structure while cdevs is in use. The
>>> +	 * corresponding put is in the tpm_devs_release.
>>> +	 */
>>> +	get_device(&chip->dev);
>>> +	chip->devs.release =3D tpm_devs_release;
>>> +	chip->devs.devt =3D
>>> +		MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
>
> Isn't this less than 100 chars?
>

I just chose the same formatting that the original code used. Personally I=
 prefer what
David suggested, so if there is no objection against it I will format it t=
his way.

Regards,
Lino

