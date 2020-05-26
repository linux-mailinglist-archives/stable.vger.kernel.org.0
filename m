Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBEC1E1BD9
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 09:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731568AbgEZHEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 03:04:02 -0400
Received: from mout.web.de ([212.227.17.11]:43949 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731436AbgEZHEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 03:04:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1590476607;
        bh=4fceq8vaTOMSo1ynATqC6pvDF2OSXWw+csa59KTJiw4=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=gIQEf+q+Gqykc2TfHpVQy8b093zq0kaWgl8ONcRdY+wOUhnCklR1o/W/aLdTu5U0B
         sKLSMYTO9z0sGzhKn213ID/p68FN458B56qkl/mNzpXjWvEbvezAE5C8MR9maau0TK
         xD2TBI672X/BO/Auq+nvggH2TCT2kcmRM8bOOjnA=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.141.233]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MwjJo-1ipKlh2FmE-00y4Ia; Tue, 26
 May 2020 09:03:27 +0200
Subject: Re: [PATCH v2 1/2] crypto: virtio: Fix src/dst scatterlist
 calculation in __virtio_crypto_skcipher_do_req()
To:     "Longpeng(Mike)" <longpeng2@huawei.com>,
        linux-crypto@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Gonglei <arei.gonglei@huawei.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20200526031956.1897-1-longpeng2@huawei.com>
 <20200526031956.1897-2-longpeng2@huawei.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <d58a046a-e559-55be-16ba-64db43a06568@web.de>
Date:   Tue, 26 May 2020 09:03:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200526031956.1897-2-longpeng2@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:mwIDtqbnN3sr6FHLWLd3pAlrzyCI3agWEZgJkR30fcd5ggjBt7n
 Z9cVs3yOc8aZsbn+e+XgyJJpxuy2L03JUle6RzYiim4nZ2+L8L9oPxHfhJW6TYib26C3/N1
 pD6D5uwD2Ltw4FVlRj9Gt9FFdXgy396S4Lk/L8BpZ8MHZcVxH0H7W4m/cq5d6XDyNasOOzp
 vy54Ad1iFfOXAXuZwu1lQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:3wmfId0TF1o=:vvxME5t4d7Z6VrCjrsvVEB
 7VqPzrSG+nXd6gxznMl+Cd7GuowqFR51gXq0RYy7byfo99qomoVg06UaoiBy+Z9DWszwWaPlJ
 TUPLb6NHgR6zR41AoaK89vcl+5FQuBJcJKoDas4PVTHOdO2VMT4hHZ2dE3ZL/AehP1r5vGXTZ
 1w6U3pQnbkQcoCxc3PE2sD+bLFq/VjGhwSrv/fNP3ZHLiYPm4BaqVKf0dFQZASj/xidXydk6j
 Ty8N3bD315ze5tJUI3bxBERUAUTMvqaBQNeSmCX2sNFhphOe1TV4v+nlNqntY2VPg4EzPqtZV
 1f8Oenqk4dKA/BUL3yQbToqARdCgg0pt4Xl/3YMwdQeVyESqFA9TK/pNyspaO8L6/pH5mjoUr
 plMEdtgIRr6gD8e0tziy85tJvFJH1nvWPtLBqNTLOIrSBEjshmFq8eOZJNMpMPZza4Mjazbe1
 Z6p/GIlAzbQ5ND/s+udx+wSrUEvNEWWt4h9cCRJXg5LWm8wMCBm/i0IFzdWkTaoFvB1zPcAfi
 T33TSTbjR51F6d+HP4I4c9ilVmZF4NCuoXYuErd00e2+6KRlqP4/yfsDodWa8SpzK+nIlaNW0
 F5FNQ6kf+YwvkrRPQmZMlpEHlje/o47LJ4qkBnnwbcCPxSVcDe35hWigf8qvzei9YcHlWTl9v
 +PpwVPcXWM6uaQ9Jj4WzQvX0k9lVjWBK1OPtOjZQQR8Qni1NdEpEzYXE1HgWsQlk/A4/AmY2d
 6Oetv/a4C2gPSXcwiD62moIs+f+1mYE1ETCo3wWirkuz6KwhWxI2BgzwLulh7YH5LV/sixkFd
 qQYyGDcY9GGkxYg9CHnuSoaA+PoKrCUh+V9k13sTZMir9zvtwbN0uOrrPkMCfAfEwJ4Aq/HeM
 W9PostV+WUIbWUre4y8hIB1WL1uCkDCSjcgQLtoUBgihRlUZ6Q8RV6S0QKZS0nX7Np1EM1KnG
 QFVzSf9GiiRlVWmccEzkYXBOMFeUzFZaGVTWK+uTZj/4WA/es4zAdii7oOovN+hiLmKmDkz6w
 mi+yBDG5qNjznZILabbp06s0Oe7jL+91H62nqzFic6VGiIRmzrCqQIK34NkpQSI+aVPiJZ0nZ
 PLhGEE5tyFxiCV/prBJ8ETjsvonE1x/nVXipFz4Mycd9kLTCvHo6Mkdx46BTa9Ww2x95SOsGg
 JFGLtwnded/qt3taiF8Ihx6St247kb5JbT950L5gMMrJPXvQcIuVc0GK3f7OIyVEutDlNZLc9
 MH++ft+PGj2akCbui
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Fix it by sg_next() on calculation of src/dst scatterlist.

Wording adjustment:
=E2=80=A6 by calling the function =E2=80=9Csg_next=E2=80=9D =E2=80=A6


=E2=80=A6
> +++ b/drivers/crypto/virtio/virtio_crypto_algs.c
> @@ -350,13 +350,18 @@ __virtio_crypto_skcipher_do_req(struct virtio_cryp=
to_sym_request *vc_sym_req,
=E2=80=A6
>  	src_nents =3D sg_nents_for_len(req->src, req->cryptlen);
> +	if (src_nents < 0) {
> +		pr_err("Invalid number of src SG.\n");
> +		return src_nents;
> +	}
> +
>  	dst_nents =3D sg_nents(req->dst);
=E2=80=A6

I suggest to move the addition of such input parameter validation
to a separate update step.

Regards,
Markus
