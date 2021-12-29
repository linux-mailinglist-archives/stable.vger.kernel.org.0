Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378A3480EA7
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 02:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbhL2BmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 20:42:01 -0500
Received: from mout.gmx.net ([212.227.17.21]:37645 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232447AbhL2BmB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Dec 2021 20:42:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1640742113;
        bh=4rw0DiRiB7zr8ea2iPB3BgmbP/o2J+ORNcX/3/0fQjY=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=cy13H2P1TKNMwsweR/6gbtAlijxZIHZxtm5UX1rPNKYkKB+z4dfIej2WGZ9ia7C89
         oigyi0dnOfhmef59QQipPy89ci7izIjYJLQNdEXjDHyrERUySO0R+mtTiQgqvgg1TQ
         298QyGnrSOg3RDrruNHcNjr7duBBrhi88ULz9ecA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.70] ([46.223.119.124]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1McpJq-1mSVBz18xW-00ZzOb; Wed, 29
 Dec 2021 02:41:53 +0100
Subject: Re: [PATCH v2] tpm: fix potential NULL pointer access in
 tpm_del_char_device
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     peterhuewe@gmx.de, jgg@ziepe.ca, p.rosenberger@kunbus.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20211220150635.8545-1-LinoSanfilippo@gmx.de>
 <YcuoMVn3eWm1fcLp@iki.fi>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <185a096b-96f1-cc99-52e8-08a35151e347@gmx.de>
Date:   Wed, 29 Dec 2021 02:41:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YcuoMVn3eWm1fcLp@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:lmaV2yLEuRw2e9XIhLxU1qeOOmyfIXvIicckLqxD4ZDvObdoviq
 Axc0ZuzmqomaqW0H+vr35aKC/lzQRQFVqB4ulZRF9VoStfBYO+u1ESIhS7e6McxekXqNJ69
 xyUjel6JG4Yn+089D0crxkEFZjjK9noJaCNRmq7016NnRorRUy7YNNW3LhP4CoUW5ebwvSI
 NcLIPkNMDkQRxotk6mAMA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:DDtfXDnoBxE=:9gDvdPvju0e9TihubwUYBp
 3dhvCqbFAmlqK/qbSyhVFqXXiWXYiuxPnUg2VzVIPdv0EMKK7c1NzfKM92PzVAXnr+W/1ofFI
 9zxJVXyMnzprTMJ+66qRWEBs4qXzWeCyNx6CtQFZOEaLQX/1Ge7I/h8kT3YJVgcdkHjLMVxWg
 s4Dl2T2gAisI5q1IsKTEh7hUuNEQfef7iy4k/F+TvfyUo9zIJBZ19qIHpeXt8lhB4Glvq/Z2+
 zDQhBlpSVIdIMx7D33Cu39RvUszKxq35ZNUYmHB05vJa5jjU0tqKT/WfwvJHL1wCOQiU054P3
 g6FtaP5sD/HYoRRd4lWC8amkWN8909FChKLLccgGKmLeXVcERAawmMfCHZIqG60NsqZeYzjZl
 NN5nbyy/qDacidpqqnj3YSpVLXkK2ZdacvLNBBwbVbArJGlWy9ilVH1mxk9zfNahnisc6uGfe
 g9FesH2P/c9X+sZTvCe9niK06doblMEkvfOPIDRJ7O+Ofq/IheK/HAXv/UcEwVzPzSXxT1XGJ
 Scg2TnG4IovyQ4ZBvJE9AkV99kpqzr/vAUDJggfvLSrhMTVfbZQbLWD38+5OnbvGx0ZXzJfEA
 Ps6zpdKXVAaVQ2Z0mx630eNZeo8j868mfoaK4sa0JSdzw36G3Z2XL9vnSTpcSHX5VT4Vu5ZmY
 hFbOA8fxLZdaev6jvXzLJxqYc70OeHWkRTkMSuYNCBa7WdZiWzg+mAZRmR+vtxzKbIJXB/kgz
 dGoKrkEqOU1ftzbcd7ytDhDloDyf+pD/qvBn5txRIikkWeNx23gvpsq9DD1HyYZ68/P4ckHlc
 VcT/SzJ3vtLA1+xjW2IkNwhC85N/gsBSNn4tTxqAuTNw4GFSKnlxARnMJuzEh9D9K/xiU8KfD
 MPWWPsGu/Ng0WUmoyP5THHQX9PVRrKidU6B1FMsd+P4ywcLRrF0zbQJaTKeki/rzmAm0PTJLw
 QAsOabyngUcWqsB4wuOsXL1wjiCK3qMO8y93f5IPGue3WWB97zjZXVX4uq+8loRZL4U0DlfrX
 2QCjf3rBqW6bPk9I34ejM0l5gJss251vrDUc0IDOma68J+3pAeofFOv9GGmpxlZ3ot0NZl5LE
 Odt2k67pBYNNsg=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 29.12.21 at 01:13, Jarkko Sakkinen wrote:
> On Mon, Dec 20, 2021 at 04:06:35PM +0100, Lino Sanfilippo wrote:
>> Some SPI controller drivers unregister the controller in the shutdown
>> handler (e.g. BCM2835). If such a controller is used with a TPM 2 slave
>> chip->ops may be accessed when it is already NULL:
>>
>> At system shutdown the pre-shutdown handler tpm_class_shutdown() shuts =
down
>> TPM 2 and sets chip->ops to NULL. Then at SPI controller unregistration
>> tpm_tis_spi_remove() is called and eventually calls tpm_del_char_device=
()
>> which tries to shut down TPM 2 again. Thereby it accesses chip->ops aga=
in:
>> (tpm_del_char_device calls tpm_chip_start which calls tpm_clk_enable wh=
ich
>> calls chip->ops->clk_enable).
>>
>> Avoid the NULL pointer access by testing if chip->ops is valid and skip=
ping
>> the TPM 2 shutdown procedure in case it is NULL.
>>
>> Fixes: dcbeab1946454 ("tpm: fix crash in tpm_tis deinitialization")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
>
> Thank you.
>
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
>
> BR,
> Jarkko
>

Thanks a lot for the review. Please note that the latest version is v3 whi=
ch
contains one more Fixes tag and also a tag for the review by Stefan. I als=
o
adjusted the source code comment in that version which I somehow messed up=
 in v2.

Regards,
Lino
