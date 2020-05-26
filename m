Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E98F1E1E8E
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 11:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgEZJad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 05:30:33 -0400
Received: from mout.web.de ([212.227.17.12]:54455 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728568AbgEZJac (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 05:30:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1590485411;
        bh=OeYim8yBjozIPKSFJcaiQRkbcX4fQ3N+2I35Z8lFEIE=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Il7NJzBN6rMjfiyAMUjh2h8DS5iXJvSzHx8kVJZ/qyULjISknbQ8RoVnCDTOLngU6
         iKv491VgnFiJHVnewtXwTyKDIQ30Z/uGfgWxz8K50jm5Q452wuBfv375v6aomsCOYs
         uNaPRJkbISasFr9Svhb528RzCEBkNRvJ9ScOMAlA=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.141.233]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MSJGB-1jTFJg2Xzn-00TRzr; Tue, 26
 May 2020 11:30:11 +0200
Subject: Re: [v2 2/2] crypto: virtio: Fix use-after-free in
 virtio_crypto_skcipher_finalize_req()
To:     "Longpeng (Mike)" <longpeng2@huawei.com>,
        linux-crypto@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     Gonglei <arei.gonglei@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Corentin Labbe <clabbe@baylibre.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200526031956.1897-1-longpeng2@huawei.com>
 <20200526031956.1897-3-longpeng2@huawei.com>
 <0248e0f6-7648-f08d-afa2-170ad2e724b7@web.de>
 <03d3387f-c886-4fb9-e6f2-9ff8dc6bb80a@huawei.com>
 <8aab4c6b-7d41-7767-4945-e8af1dec902b@web.de>
 <321c79df-6397-bbf1-0047-b0b10e5af353@huawei.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <2ef98863-fbbf-beca-6a45-cedd686dc23a@web.de>
Date:   Tue, 26 May 2020 11:30:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <321c79df-6397-bbf1-0047-b0b10e5af353@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
X-Provags-ID: V03:K1:b9F6H/St2CwxJIAu9QLCNQ+WrPT00rf9OrvQzyJtZgeXHG3Zfpj
 pSnlf81id+1U2/Kw5XfZBBqI6nCNwXhQLg9rBSVMiYm0SWAfSug18i4SOox3LSNxxnHP3MO
 ZnE1lyAF5zZa7tzwYE4kgF8cOoLeM4rqLXpnYTE2H/DyvWDw2WfBAJDvIpd3Q/p/3CEsEvo
 klfUfUJGi5cG3PwwmKhUw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:rCdLDoKpgtw=:esx7MM8Zd8D0R0QIo42SDr
 YRCQRplNjlfdVZc4vZPmz66ebmHdn+ymhNcFezoNnsLqVHhn/+L5uR7R5z6MF20YEr6JKLLJk
 TinppO2N3lminpcKn120/uA3NYjYUvXpTkeg64BrTm7+9/mIK5MnPQkzmw5NQJUarE0hONvpe
 W20qZ81CulQSi2vYYPhVRQGGvqTDh1qkWl0FKFuuIVmyjUYe3fOooBYBW/eQzylttfIVtAEti
 2AleFBHV3DRDC6w5sKIhf+aNWW+QY8oBrhqb2E8+395UpzKfRIaeVcQZJN9wQswDMNjFwV2xD
 9AtvHLf3IDQFjhPw82f2jhYJoa26cS4glGIsMnIKn5D3Ex5hy4hkPjD7DZCRPjjQQhChiGU/X
 5p9xvQdtHutHauD7tNKI7vyvxECX1I44b/Z+wD9GtpmjeP330SUnWx3mK9ocHiJRbfIisO9J1
 eMZesL+Y+pRQEREAWvI4c/Z6hsgdksGkC+9JkZc90wmTPek3CKJqlzKXCrKXrEiUwVszBQxs6
 7woMd4FKGlRPO77X0vu8i0g6hyfHBh7nIC3vTOVloz7Q6DVdb4Dp9Hzu+JMOA2pIujz1PJBWO
 xgCS65gLvDJf69TXTbYqCfCbQ3QHRzksjshdjlXqyr0GH+IMN9lJYZIOEGD6M+KfE+xWLwCNc
 ygDe2+3FGfThPqm+JzT9PzDdh57CdZi2lq07ooXGFF6Bb63Hb/d3gzSF+wuonnTW+rHQzGoph
 X3fCXDzSRPXVtl0rTJeKx9b6yKzAFUwx049PbhArW+ZgKUw4QITX3oR29enhx5oBazsuNKBNE
 WqNaouXjaLtgSG9qe+DzDK9HvrjBEw5QAdznJrfWzrVslzO5x3rDbpTYupaMr8cOxXMa1E+Cp
 Dmtd9FjuOWDOk5HViDA2heu0Y6bZlxF1EOqb5XhE2QgLy0wP9OOhBA3qU0rz33xQyqB4vnRfV
 oCOar9pqmtrsVtXSbL5xdYpGJGSDOh9BMKSKQtx4Hy58a9YkXM2RWQunFVGZgJOk+RdZfu0hT
 TZtK+3ZjjxnyuCj8LgzqBpnAYzt5DkwWO7UbEzMSbTxtGXl4cHxqgjJNbO96KMK4Ypt/iDQE6
 IfZ2m17h/ywvhM81Isi66RvBE8fpk1XVUhzTKFBxFvGLDbLyi7iNRt0zOnCFe4t4s5d+PNID+
 S7WGBMuT0qwBv+iswS0eR51q159bIHTB15NUzsy1O4dJvSfUQ5+OxKCURflClSF2M7NLha53u
 AF9FLU2Qe7+ocpdt5
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> I respect your work, but please let us to focus on the code itself. I think
> experts in this area know what these patches want to solve after look at the code.

I suggest to reconsider such a view.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?id=9cb1fd0efd195590b828b9b865421ad345a4a145#n102

Regards,
Markus
