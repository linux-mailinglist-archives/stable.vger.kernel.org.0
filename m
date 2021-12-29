Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D7E480EB7
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 02:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238271AbhL2Bv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 20:51:59 -0500
Received: from mout.gmx.net ([212.227.17.22]:33957 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238270AbhL2Bv7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Dec 2021 20:51:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1640742712;
        bh=gnkMuksvyKUCoI1djwWKuUjyBil5A9V/0efk8mGIY+0=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=g5PuZzcXSF3/STf+wX8q7J2BqRzR/sF1s2ZYy95F02gLk49Ox6ktzMYailebeyLzK
         MKvUKvjfSygn9PbXVNFzXzmXEAI3Y7mUVPdoJDVZi8ViZRXhcgMTztmMhAS9pec2Yu
         rB/6mHYdC9KPsPeLAY7mkqEvAMFiyUsmDaipre+Q=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.70] ([46.223.119.124]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N0XD2-1mH0Ae0yn6-00wSpt; Wed, 29
 Dec 2021 02:51:52 +0100
Subject: Re: [PATCH v2] tpm: fix potential NULL pointer access in
 tpm_del_char_device
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     peterhuewe@gmx.de, jgg@ziepe.ca, p.rosenberger@kunbus.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20211220150635.8545-1-LinoSanfilippo@gmx.de>
 <YcuoMVn3eWm1fcLp@iki.fi> <185a096b-96f1-cc99-52e8-08a35151e347@gmx.de>
 <Ycu9/C1IKQveozL6@iki.fi>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <8db52102-6023-9eda-6b96-937624b61cdb@gmx.de>
Date:   Wed, 29 Dec 2021 02:51:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <Ycu9/C1IKQveozL6@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:0sztabqv051fFRtW6AjkZH67DamtA1YBGMG1mwn/VF3du5x7xy2
 IpAt3ofPArk1n31wT/ha7qh7hk98diHF28d7kfVXml1Zw5DvUkEah5BIwCAC2QqYF9fxv6I
 7qLB//S0lEsUoE9so/L0LVwV7wekhtao8fC3fOWhzDkwZd6jBTUDBmaUiC2kDOyFIVvjnoI
 0ZqaFvp49Bqcbo8fDKNyA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:WDP+RwjZVso=:B94GmNIoUfjeSqK6r9+PNy
 8aqTYrqJQRJURuR6zfttZXvTQHL2rbNszPKzLAG7N9B7AFcArw1dUAJqP7TS3LTeasSU2aFFN
 emSlZtQKWWx4V3G1aGC0zgJN54F7/PyMQoEZmA/CM8F6wizKhyvVA29edYyc/t00mMg/wm+RF
 grsTmt0oHt7vUuF+XwJwnh5eSeXezY0KizpjufzvOh96zQx/w+ebEmDQ2JWDzO6uPFVHOMQN4
 H1pZvHgv2HsD1N/6wBMTY7nUnlzCV1HHWMf5T2Nn83ptcTYe8GPm570bwr96jVt4IFDhHXr0s
 fVH3tGSnscWb8J91JbCOqFDGQahvfAUexDLnGhnfV+PvxG7AHIiKSk/8nkw42zuYQyj0G3oVm
 5HgLtn1DTeVhrFHeDBfdtowfxYLhyVOiHEEHJT5yl2g69IveyqSa19ovmWdgptd9/KvVn7M2V
 NAnBe2ZhqEENBL+aTfjPov2rsDD3uTdmdt5flqSUfpPHqTtcXvBn+g4NJ94uHY1rn7anMzn67
 5q+qk37+HvIB1LLJEKQYyVFV24q+OiDL4HESF4TeqCcWPQklne5rqC4Lq9y0D9LQACdBpxcjS
 VTOJJZj+4OqE7ZaspV8Jdn/K9oArMTX7kHmuvQb6ZOhUliHmpN7IIu7gmkANo/ftzzdgrnLne
 JVkpymq9nfY/PJLksv2P8lXtefmU3DLEr8h0yBGm6jIUAg50P7q0uISlnuhmk72xcniz9SgZn
 I57+8QDXDfSZisOuXK/4wvva3ewbfRkgBYidESJgNA95I4FBZmrr4pF5XW+50vo+jIMZMD/hr
 9TaQtE5fXtfT/+wGosgz8y63l//4NOF0x0NklPnxymqV9wZHL6ZqveqyxLtzhRN7C7BS07FPY
 MFwBU3e1+soCODoE3kEUjdAdsq0smzarjTAsUSA66fPC8Q8NEizkVAtJ/EJrfaAG+HGmBy1aX
 LGvnpdsqMsSScuJOsVFa0KRz8DUnpbfm/RTU5Z4bqXw3thyQQ2R130E2/mozQJshDuAnWpJMf
 b6YQZE6T5kmbSGLF2PxNOaJUIun8U5rSyRSe7KRe+mF3Fo/D+0dGwZ8vGORm7YEuMpRT6h4hq
 LHFhK5Pbb6Qa5U=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29.12.21 at 02:46, Jarkko Sakkinen wrote:

>
> Since there is no functional difference, I rather do not swap it.
>
> I fixed a glitch:
>
> +
> +       /*
>
> A multi-line commit needs to have this as the very first line.
> You can check if the all tags were pulled by b4.
>
> /Jarkko
>

I see, thanks for fixing the comment then.

Regards,
Lino
