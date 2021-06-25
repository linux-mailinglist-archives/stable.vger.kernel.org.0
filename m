Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135353B3A1A
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 02:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhFYAUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 20:20:24 -0400
Received: from mout.gmx.net ([212.227.15.18]:50913 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229521AbhFYAUY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 20:20:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1624580280;
        bh=swjWUhJ7ti4wOo9q/TLpVinRb1Z0wsQCkXa7GXKM7Pw=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=lJEtIVn2kqP8E9SR2FEf8KnQz+6kcxjydfyBSBl5xwXyp6QQBoLYZ+PILl6DcnHN5
         0uTyxsbqc/b3LEyPjeXntZHBygYQ5QxHMXIX0skcJ0SDgbgMKhN5llODFQ/uct+5aw
         WuHgBBRdbwd9ZOhvmIhJLKTj+6uprrSjrlFv/5wc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([149.172.234.120]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MeU4s-1lMPqN3yJI-00aTzd; Fri, 25
 Jun 2021 02:18:00 +0200
Subject: Re: [PATCH v2] tpm, tpm_tis_spi: Allow to sleep in the interrupt
 handler
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     peterhuewe@gmx.de, jgg@ziepe.ca, linus.walleij@linaro.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20210620023444.14684-1-LinoSanfilippo@gmx.de>
 <20210623133420.gw2lziue5nkvjtps@kernel.org>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <5fbe3f44-8c0d-f185-45fd-fcaa7af3657d@gmx.de>
Date:   Fri, 25 Jun 2021 02:17:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210623133420.gw2lziue5nkvjtps@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:BpmE95Wz/wro0J6PeKv1BJFP5+cb7QlgHSxV6ggbmZlD8k8/pHD
 Br7wsTabWG4goyqNdHv7ZvKp/NvmJcAYXmO2MyFwPom4FEU0Bk5F7nMolL1XAV+Rfnm+9ZY
 U/nZuSW+0VZQ2HHwlb6ohwjNImWP/nmY4R5CfrExzGZKPLeJmgBohVXu+WCbjUcgDku9DSd
 ao0W+BTrtUI+Brz6/2XyQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:3PmWfYZqWHQ=:Eei6EZGPIT8eAOSXRj5g6l
 M03hkwEZ/08UCZi7364D+HUcqz3E1PakHXJd4UXmEWhiOwY+/PJCGpg6GoYrF2I4pT6ckRAL8
 r+HwblBj+IIeacDMKuYO0T24HTukehNe7pgsYEq+wHIFk3lfDhfSR+dgpkdMGPOKIMxDeMqd1
 jt6WN6ZD0r+Ht4TTMq34yafywK0vngLgsIR4HywaHdazNFdSYMRQ2IKjz/xz3cYYvTNu2WXOA
 gxxHvW4mj3AKMc4Bt3AXcti/0L8jvJyy7oWNUUXYoR30iYBAhUyUUeKLYAhQnfoARmS8PNQ55
 p4aqjBACmzKkgzWeWRe67BoVjF14GL3U8kJuAUPl6TR1nA7aHY0UVQN07E8vrllh55oDTrcBn
 8dcT4PE1ZAtrU1If2LRp50Ad2XHGYmduS3gUEWmuPekOleuUHy3nocX0sRAZcysL7erDqDZbg
 XaNZteoA7/gkSiDx2z9BFjgxEad/6nutRmzezUKVcpk7dCr8+05Uko8mQgZsQxJIn8PoRhPjZ
 J40GuhGHDrxpXrElo8bYhaZEUio0kekoAXE7YeWNPu1SftC0ST+QY5gL8D0rYzZsKIXLTWDnD
 JfjoGyyKa8RUoTe5Imguu/OmdiRq949SouT/diThJRhNKWXLJkkvKtKSCqT1knBHKRWoMsNZC
 WbqmhrY8VEBh0sTXCqBL88rL0qYtfwjIJ+tWMXAC8AiQ0zv0WvHeiGyo9wjt4gepes2I6sxSo
 C/BAJuQzqCiG4etmYFX+F7HmVt9gvtql+6csfVtKaJQyBlIc0GTdG9axBjR63Pwefnw4TwXF9
 WTXL+UomFRf8hneWDw6LP1R4FOhdq9aXB7rWqQGjkN53Gi5ULQfvfsdxnHOlCSwqkEboupcI4
 yz9m6aiwS18p5VzJ4n2W1ErjpXGu7XjEk5ESUkps/ruVfxsjCtkoKxXAPAb6E5Qa1DjeiGE5B
 3Kfv82EZUGEff7w8jDMCCQAZbIXvYGh+/mlF40EcJlaqyfGGZb0UpC7E6vpPplueNI03gS962
 hZ4lelosdoDyf6R+toP83B34dRE9ntn/RNeNwXrhM60iPrjoJE+4/oYuLNu5brc0WQVfntnbS
 hMQrIwDKGaW1KvWOhcZ3503kQmjF/0WZaPkI3qRgdcOotx02Us55+yh3A==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 23.06.21 at 15:34, Jarkko Sakkinen wrote:
> On Sun, Jun 20, 2021 at 04:34:44AM +0200, Lino Sanfilippo wrote:
>> Interrupt handling at least includes reading and writing the interrupt
>> status register within the interrupt routine. For accesses over SPI a m=
utex
>> is used in the concerning functions. Since this requires a sleepable
>> context request a threaded interrupt handler for this case.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 1a339b658d9d ("tpm_tis_spi: Pass the SPI IRQ down to the driver"=
)
>> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
>
> I'll test this after rc1 PR (I have one NUC which uses tpm_tis_spi).
>
> /Jarkko
>

Sounds great, thank you!

Regards,
Lino
