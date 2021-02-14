Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2CE831B188
	for <lists+stable@lfdr.de>; Sun, 14 Feb 2021 18:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbhBNRYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 12:24:36 -0500
Received: from mout.gmx.net ([212.227.17.20]:53837 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229740AbhBNRYf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Feb 2021 12:24:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1613323369;
        bh=c1gtv63Pa+secmNNZ9I2Rx3+3cPoEs33KOz8GXpWQo4=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=U4k/suJVeCCVSEtSQHbjgIHBO3F1bqv+ClPe1BwsS/TqkX3leYsKY1zIaTcyeMDd/
         zgwUnNuo3kk1R6hQC84mG3/3Hk8KwTNmEohEuf2Hl3gXRiMy9cKRJff1HIzMWuGSux
         XLbHxIGF8Fac2GYjpUHEOP052EMYfa5BvvMFxWrc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([78.42.220.31]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mnpru-1ledVb0Lco-00pIXR; Sun, 14
 Feb 2021 18:22:49 +0100
Subject: Re: [PATCH v3 2/2] tpm: in tpm2_del_space check if ops pointer is
 still valid
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        peterhuewe@gmx.de, stefanb@linux.vnet.ibm.com,
        stable@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
 <1612482643-11796-3-git-send-email-LinoSanfilippo@gmx.de>
 <7308e5e9f51501bd92cced8f28ff6130c976b3ed.camel@HansenPartnership.com>
 <YByrCnswkIlz1w1t@kernel.org>
 <ee4adfbb99273e1bdceca210bc1fa5f16a50c415.camel@HansenPartnership.com>
 <20210205172528.GP4718@ziepe.ca>
 <08ce58ab-3513-5d98-16a5-b197276f6bce@kunbus.com>
 <YCZfrjZGKVyWuglE@kernel.org>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <940f4ced-20bd-ae8e-feab-5c6850129d92@gmx.de>
Date:   Sun, 14 Feb 2021 18:22:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YCZfrjZGKVyWuglE@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:aXh3LgOWKQ3dui4BzDVu3TeMdHQ/9F0PYUyUJrAAeDrT2LX3VdW
 IOORxkPcvhX8/rTByGlBHvUUYo+KyFefcZT6poZtaobA4l7nk3N6gGUomR00KkoO+WXz1Jq
 tCX3HUXscVDMi/O5612eGNjmHxmeLliztWzGWfO+VOr/XByiom+i8fEHv52r2E0HIOPYuA1
 1o8NHMt/0ZLCkjPXWcx1g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:FTjNfs2vQqU=:MO9sbsYVpMp/wBRHE1gDB0
 KfFtt7Ht5OxUWKIppzrEITA9FXGHBgEUOwdC0UbuQTUCelkXgpa1rcbXkvP1dhe7bpC099h+A
 BFDjvTWHfmuRFU/SeBRTqbFOjLV5QZTtbkO4l7SYAjm1498YmJqD5zxZK3p4/gAA97P5TdlN9
 m8RSlOnR/wbjGfwX4LFIE1Gdqgb7AhY/fFanrKA4X+GnVewDVjlqcdxszLTbPMHg5pFqH3kBy
 42baG2g3impnDWsP65zkvxXsGPE4NyMiv2OVpCxhr30+V1skcE2G/jCfIvOv+35GXKf8+pw8E
 F906Mr4ost0z21xuPMPZBKaHYNZCb8lYRBV8rpWf5EgLzvnrvyJWwljVX3UDXHFBY/yOec8OY
 Au1cl61A2zc83ytbZ2z+EmLi2VYImA7AsNc43rrVLUqCWQQvRoVKLeSH+euFTeJAg2IbKGJ+w
 Ay3wyQZDIDFKN0T0EZyl4QOSm29M9JECXpLQ0Mwgj4hONNm9EsmwKpLxVF69mERsB7+97Wpe+
 BHFCxMaPa6NUO1i1jtkSAPbEf66rx7skkuLE++TuYWEjzYpB67QW935lMfP8yYGcenPaGaAKl
 RixxZhTgeX9Qp9fKqxg9QnzucNazRxQPQVm7G93HWNqvc7yzq9gswrJs71k7CAk0cnyd2UdmU
 VkmtXdmoukyM1uCiVvISQtpBMhBz79gyCWu63dRcxEoQpBuaUDWiWa5mN8KUwiV+AVUuXXrDF
 AvaOlYMqp03WNR5cnrBU7EfGhJxwHXRKb9jm/XeP35Mtvc2D9pQq14sDM+UiluhMK9LvHLE5K
 AeToHFEaH703v2UVWiJZkA1SjvFX0/NAXhGWcp/DpcKQ6HlAdlrB5xlntiLyi6yl3V0Ob/R3b
 CBkGCX1UhKyY4t8EqFjw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 12.02.21 at 11:59, Jarkko Sakkinen wrote:

>
> One *option*:
>
> 1. You take the Jason's patch.
> 2. https://www.kernel.org/doc/html/v5.10/process/submitting-patches.html=
#when-to-use-acked-by-cc-and-co-developed-by
>
> Just mentioning this, and spreading the knowledge about co-developed-by.
>

This seems to me like a very good fit, thanks for pointing at this.
I will prepare a new patch series and use that tag.

Best regards,
Lino


