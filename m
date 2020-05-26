Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68DD1E1DC4
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 11:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731491AbgEZJCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 05:02:22 -0400
Received: from mout.web.de ([212.227.17.12]:54375 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731379AbgEZJCW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 05:02:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1590483707;
        bh=tC1lcWgSkJUDwdFz37m8nHVhnuangUpA3ePdl47xFLI=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=e4jI0HRKnU21Hsl1IWQPAfixarYtrvw8mXdehl2WnJCdCxC62EOgKWzfbNWwd9CMM
         Tv7w12+ieomasD44dlC5/0iI7Kbj+zYNNyw5VQ7pz0E/61SRLmgeZ7MC2fzfGtLJ2d
         BsCT/T3+sYJ/pCpjSKTXJVq2ggJy5bkYKPWL54M8=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.141.233]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LZedc-1j9hTz1a8q-00lUMP; Tue, 26
 May 2020 11:01:47 +0200
Subject: Re: [v2 2/2] crypto: virtio: Fix use-after-free in
 virtio_crypto_skcipher_finalize_req()
To:     "Longpeng (Mike)" <longpeng2@huawei.com>,
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
 <0248e0f6-7648-f08d-afa2-170ad2e724b7@web.de>
 <03d3387f-c886-4fb9-e6f2-9ff8dc6bb80a@huawei.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <8aab4c6b-7d41-7767-4945-e8af1dec902b@web.de>
Date:   Tue, 26 May 2020 11:01:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <03d3387f-c886-4fb9-e6f2-9ff8dc6bb80a@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vC9r7t8/SLhD23H4Y0hH9EyGbPrzcz3mUqsJW0ou4v8CBYT5Q12
 kdg5PIwF12m1r+LKxV/9UW+13Aoy4EvD5dGbRiRH9tzuAzeRlBNPmRtI8cXQPZQ1d3mI+P1
 KQdHWev3NEqjR/XoUgYOR2ILaWIYeVN3T8EPR6fPiH+VaHFAXB+YE4SPC7J4cCr/GodB707
 6vHemKoF2WLqet+Jg+XmA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:PvagU0B7/GU=:jzbe2UMO3Svq2yzydrBKnv
 XXYpkX8t5IAt4GLuudyrhHQ0+wbEinUfwVPjrprJJdZT6IgUzL7GCBTDx9mY8V1m8aZrNtPKI
 xSoeb+zANI8mPol8CCZsvBb5acnHWgQ933VbSm+ywb9bhvjsnxf36AT67/w+g1w+bi1EIEyfQ
 iTJujVGM0/2xkjhvZuRUyKWjMHXHhEo8uCkk2aV+oHMbZUUtL4jnVWRtBwosfO5r+b+L01H86
 CvnZZ4AsEJK+LRfyyOSFUjynbsSq9QeBZtNd02enxOXd1XaDTNvB4e8Htn0szJEMhYrzorKpZ
 DXWy0jLpnRweXRi1286zUcVtWSsk/lYKsbPq4Evb8n47mHFuIVaNiVgxi7Xjz/qs+qsLUA4Or
 qJjlLciG6Q6kKusdHzsI2FItM5eURCqyCB9ATeX2C4rkOUdp3FNF8gppz1phTwhfnCgCZ9reo
 ne8pUB0UnPWTLiQ1TFruJ8b1GdjslusJ6/+Sfab1mDfLuF7D1piVLcCpTEN+IJf3UfT6cDXoM
 D0OVNKF0lwDRXh0LHmIJRrsrjvu/yjpXtajFYpxCChy0H68g+ZrhLMVp8y7KCI9f2lCL9UCrE
 MTTnsV3X+wHHeR+a0GOoRLSGQWWrl27Rb3Xm8I8k5MHh+GhAbiXpCiVDoDL2enq47nDhWlwRO
 gn/IsF6F0VJGcL6Qkxe08jby3mqOXsE9d/ruqy7ZouzQ45T8ePVAxMSDX44lNbIwfkoYbiD2u
 GIG3WAYPd9SfjGH6EMWqSwsAwqjhuyolCGPysFmWQVU7xQBcrCo4vbgOhZYo5TT3r4KnwdTzH
 L7p/kQjMVx/50H/jbwKNpnBSIae4TQi9EUvJW3BI5PYzwzcY/qavoIRI37ATypSnoaalcBneu
 27l7RPVA2gCE9wcaj35vZyO0HCgzXOG0V1Yjlh3dNzydnOXwAa1rdVuA1tmtNkwf6UeYcbR0n
 TPzrd/tyYkTb97ZBcQgClXrNsfYsFdRFyk6l43EOWvnVhHYm2q5rRrGM3i1d9Dm4Kiv8IQvIH
 SKJACpusm/oi4zqTdtaq7jWOeXWEqheL60smTuCC4GqkfWUaaDwE27ke5ajw/ncU0YNQkf1bj
 fNNKhJbTpK1a3ZXeJ/5lms8xlpf6kuHwtjt+LhIu7cVh2oaxfDOmnRtA6LNjUbYLxSM8uCveO
 mYEQmGo5GDVUV4c9b2acY79XsuIzGy12GC2faa8Oq8nyGQkYclyk9+h5BYuydRXX23IgYQHiA
 JkHd2zcdmXM1JsXHH
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>>> =E2=80=A6 Thus release specific resources before
>>
>> Is there a need to improve also this information another bit?
>>
> You mean the last two paragraph is redundant ?

No.

I became curious if you would like to choose a more helpful information
according to the wording =E2=80=9Cspecific resources=E2=80=9D.

Regards,
Markus
