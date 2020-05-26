Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CAC1E1C60
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 09:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgEZHjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 03:39:05 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5283 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726736AbgEZHjF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 03:39:05 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 01741EAB2AD22967CF57;
        Tue, 26 May 2020 15:39:02 +0800 (CST)
Received: from [10.174.151.115] (10.174.151.115) by smtp.huawei.com
 (10.3.19.207) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 26 May
 2020 15:38:53 +0800
Subject: Re: [PATCH v2 2/2] crypto: virtio: Fix use-after-free in
 virtio_crypto_skcipher_finalize_req()
To:     Markus Elfring <Markus.Elfring@web.de>,
        <linux-crypto@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>
CC:     Corentin Labbe <clabbe@baylibre.com>,
        Gonglei <arei.gonglei@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20200526031956.1897-1-longpeng2@huawei.com>
 <20200526031956.1897-3-longpeng2@huawei.com>
 <0248e0f6-7648-f08d-afa2-170ad2e724b7@web.de>
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Message-ID: <03d3387f-c886-4fb9-e6f2-9ff8dc6bb80a@huawei.com>
Date:   Tue, 26 May 2020 15:38:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <0248e0f6-7648-f08d-afa2-170ad2e724b7@web.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.151.115]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Markus,

On 2020/5/26 15:19, Markus Elfring wrote:
>> The system'll crash when the users insmod crypto/tcrypto.ko with mode=155
>> ( testing "authenc(hmac(sha1),cbc(aes))" ). It's caused by reuse the memory
>> of request structure.
> 
> Wording adjustments:
> * … system will crash …
> * … It is caused by reusing the …
> 
> 
>> when these memory will be used again.
> 
> when this memory …
> 
OK.

> 
>> … Thus release specific resources before
> 
> Is there a need to improve also this information another bit?
> 
You mean the last two paragraph is redundant ?
'''
When the virtio_crypto driver finish skcipher req, it'll call ->complete
callback(in crypto_finalize_skcipher_request) and then free its
resources whose pointers are recorded in 'skcipher parts'.

However, the ->complete is 'crypto_authenc_encrypt_done' in this case,
it will use the 'ahash part' of the request and change its content,
so virtio_crypto driver will get the wrong pointer after ->complete
finish and mistakenly free some other's memory. So the system will crash
when these memory will be used again.

The resources which need to be cleaned up are not used any more. But the
pointers of these resources may be changed in the function
"crypto_finalize_skcipher_request". Thus release specific resources before
calling this function.
'''

How about:
'''
When the virtio_crypto driver finish the skcipher request, it will call the
function "crypto_finalize_skcipher_request()" and then free the resources whose
pointers are stored in the 'skcipher parts', but the pointers of these resources
 may be changed in that function. Thus fix it by releasing these resources
befored calling the function "crypto_finalize_skcipher_request()".
'''


> Regards,
> Markus
> 
---
Regards,
Longpeng(Mike)
