Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8061E1C0C
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 09:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731442AbgEZHTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 03:19:47 -0400
Received: from mout.web.de ([212.227.17.11]:58605 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731378AbgEZHTq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 03:19:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1590477559;
        bh=vtLybQWULEnc8jc79o+HmD2pb8+JhjoASvv07l4WYQ8=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=N5taJhvtt0lwyIvI4zJOY7FizucmQbTAjNvwFgBUxG+mvDSmR2D068HvZeWmcYv9g
         IHt1Hkvb8PFrovQy53HeCJju/SDlZrMWSyP4gzQmmNHop+efAqS3TE7YcRwdaIpwDm
         oSsKqYh7VGQGNg4PK1bt6WVZEPin3VqETOrrzv5c=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.141.233]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1M2Phc-1jak2r2Baw-0041o5; Tue, 26
 May 2020 09:19:19 +0200
Subject: Re: [PATCH v2 2/2] crypto: virtio: Fix use-after-free in
 virtio_crypto_skcipher_finalize_req()
To:     "Longpeng(Mike)" <longpeng2@huawei.com>,
        linux-crypto@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        Gonglei <arei.gonglei@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200526031956.1897-1-longpeng2@huawei.com>
 <20200526031956.1897-3-longpeng2@huawei.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <0248e0f6-7648-f08d-afa2-170ad2e724b7@web.de>
Date:   Tue, 26 May 2020 09:19:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200526031956.1897-3-longpeng2@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:1H4SgTlabezxCxmUggdffuSxcW9wuad3DGOuq62XhzX/LihUvRN
 Fm1SNiPf/T25mWSUgVS7iGIKVZJsi0oSHVkX87rEbNbkB5MvIE8kxAyed3JcOOSpp3X0UuT
 Qntg7LPjM6FyIhOd+Wd6MCDUCxeaSWN4awvI1LrZnAwWqWTOyVfuJWY1NIXgpGMTYD0ynUp
 KhgbkqGb+tizpl6aJiwjA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:4m1VkoStH1g=:b/G5ZvXncX3Tycc3rm4s5k
 U39rtVZ9kv3Kh2u01hmuRJz7ebZqZUb73vHX3MCvbCRpxck6WWL4PTrsC/XaiZEc7yzTP5b6Y
 aowvBhAJhhJp6jUxd7Q7wtoDEPIt9Mig6kRZmuMN9FkBWRzOZX/ORzc/S7NmSmAtTOKYp6tRg
 e+7la2RywZcBEGbdstATmPljHE3PHzV03jcgqGkj1gRibVSV/UuUYbOmMQrw9qw+6wRUKk/9U
 c3jLQTcJdyzeTTNh9vfQYlXdb7tOLMRaSjl/rG7668RwUOImm51bbAgCNp9F0jJZ7489y9NuK
 QIFLddOz5Ka86LtNCMaVRdGV1G3qTQ6SO5cXDBrNo0bL5tbcahnKq+Y2VpJz1iBTqfQ8uGmzl
 eKF+5G88MbFyJ/bvbi1PashS+hC8foterUJiUPBu9LnBoXHPA57U6muQxtxOY2Lzz2Ziw3Ssv
 RMns7quvUdtdGmPro8XdnZxgrPZ334a3Kyt+RxOv9ZtC3jc7Rbe8En3Nfb27JETeCt0GReHwC
 S/tz7QjNAX1ERlJ+ho5pUEZY5CcF2DmRxoWeEX6Lp8TyXw4H3k/Ls/2zTWIFTHPWxb/oSLtaH
 4Bj4WdB1gaceYUFVPxNSeB7AD9StekvttEvPfYxHXTXZJ/SyV/NdVm0Rs0d9Y0adOhj9/pFY4
 6V0LMyXGCDn7oG66dRlH6Qkulgxr0d9UOSAQgLofNbd8OdnUF+YpRdAa7tX9KUwFmITRbln+X
 1yJls1mMPe/CvHXcRTLRkwjhpj2DKQwtc29+Cgi/LgLKMBv7+kfXE/STbt0p6DlhjcLu/PMJv
 oeM8ukm37B6jwDk2FeVYGBQWiEMuLOMdEWC78gTDzAx/XBFMLMoL5Hz+OWDOr1Hxj4Bj71GQa
 mgmrnOj8B/KxWwUIVdzdYDqT+Gck0M+NtPtDF0PL/L5HNjstcFZCyiRXp0rQHTVOBQWFzesGe
 8zzFvG0/bfBD3GWLXCqWffuFFwKaVHQDG2IWBi8UBhIIK2baBPixxD/hVJJKc1cZLJgpUCeX7
 xQKHjGtTvsxRwogRyul8C0oztfPFa3Zzd2RsdSwaTfMZBdNR8KZDCP6kZEqCYEuumDBO5d9X0
 gO2zmGEnYbpDkuSh6T4ikOndccpCjUJ9sP0mu2NmskWMbBnHJyF2acbp12y7GUnh4bvZgPT+L
 bzPjq6kalbPv65XczL6qShl8wy7GOFX4j0qpbH5EFCHAmUyoXqaDi2DbpFsnlyouDTSJSEmVn
 iOjA0z2j9W3vX7Nro
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> The system'll crash when the users insmod crypto/tcrypto.ko with mode=3D=
155
> ( testing "authenc(hmac(sha1),cbc(aes))" ). It's caused by reuse the mem=
ory
> of request structure.

Wording adjustments:
* =E2=80=A6 system will crash =E2=80=A6
* =E2=80=A6 It is caused by reusing the =E2=80=A6


> when these memory will be used again.

when this memory =E2=80=A6


> =E2=80=A6 Thus release specific resources before

Is there a need to improve also this information another bit?

Regards,
Markus
