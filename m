Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA071E1D40
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 10:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbgEZI0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 04:26:00 -0400
Received: from mout.web.de ([217.72.192.78]:49005 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbgEZI0A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 04:26:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1590481531;
        bh=MHUhDhjpT9N5EskffASLpUqtZNVgU+zVvatYDdbMok8=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=OWDKcYBpVx9vdO/4uND5drEPEbg8D32sizcA+DFwW9q02Ys8Jq6PpRUKVFFB1n2OK
         3DXRDN6HtPq4enJ6Nlbd4N4RKA/FaE01HaOtQmLv4hvPohv31z6d5vwNrdFICB0m2w
         EA5yCkwoM9j5719GmQjz2eH8Sm49Hx2WoJ1gB71E=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.141.233]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LbJ02-1jBLwP2kX4-00kyq7; Tue, 26
 May 2020 10:25:31 +0200
Subject: Re: [v2 1/2] crypto: virtio: Fix src/dst scatterlist calculation in
 __virtio_crypto_skcipher_do_req()
To:     "Longpeng (Mike)" <longpeng2@huawei.com>,
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
 <d58a046a-e559-55be-16ba-64db43a06568@web.de>
 <e1864c6d-6380-831f-9c2f-85611a78779b@huawei.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <b863c03b-18f3-4942-10fd-563ab4cf5b43@web.de>
Date:   Tue, 26 May 2020 10:25:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <e1864c6d-6380-831f-9c2f-85611a78779b@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
X-Provags-ID: V03:K1:JjnLJNNiAAtloc2ewUlo+kpYIFI6SilE8hkaI6cJ8Hc9FAHiAeA
 gN00egs1gacfbp5p3qshSpQFHzBxZR9MmMJuaa0Ia86oLRjtVRILtQoBnc5Zr3QzkmK+yfo
 FAi0IUjQvNmTuEGIeFBdtQoRfG41aDCS6NAZZwu7VYpdY27PaB6Xf525YWAkugD/LaB3dmx
 0BsR3ShxwLH229JYYnZXA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:/ZslzTazrAM=:0HirD3ctT6bKc+8Q27dPkL
 Ziw8eIcVFM7hE3xCyifAHxNzjU3u0ciyjOZdpYTb+38qOPGo/lNpLym38Fq97s3hab0e4L+PY
 SwAi4z2FwxBkhkZWeNLL/P2XPqAzAZB87LDyyFFqhXVRGZ4MLd3Xh6dwwkpIpKdoisoCcnEqN
 GymadA8bGBL/acqk6etfSnsGceUACTr1VvCa/Fg2VQ8lO/E3f+dqSXYCqPzRZxOli6govr279
 aeCM2Cxc7AMBvrw2mJWo37FcBhAJ113CTKLn4teZI7f9lC04fVys3Yb0DeRZqhMlN9/XKsTut
 au9VSE33w1z48sHlzFOlpwV00cXpRNMKH0UrChwvkRIXVSWlsrhr6q818vb1FAkvZMOJmlkoB
 DXNmlQrmFQS+jyQKjBGrl5fY+rtaSVcwKBkG/NSSmzg11E6OOegTFnM9cQk5x8FUmE0RuLico
 LmyZ+GxLSY1eRDwSnDHRDG+mwVx218XQkjZhbVdTftO3RuFkaZu1ZRrvVxS3p7g6GUnAXp4KU
 2a8lzcztRyEOzSX/xK9dyee02cDsdi+LNkLHVktLKzTBSIOiKGdQtUeM+pKaoSU8ve8KenGns
 y/W4mflGpT4Fy1uzm3pi3QXZJD7i5Ufi70fvXcPTBY8PYe6WSRGlJaLvsVpiEKWJ1+hrDhOhT
 jYuqGfhRTUSu7YPsHJXmfq1qu6ot8sx+HkLf4DPq/O9weK3K3mr9dIIthQwILpuJMFYv4FXA7
 SHWbyX2+xnxuQmUPEcEgafFG4nzHP4V1oVHVHO9A9bqpwKF/Mva1ENGrnOB6Crug/7DoapjZ9
 soC/7zwTKzhp90FMsy4IxXZS+79cMYc5RmsaQvQEJ6tfsQs3XISfKZapipdjTZkd7MwyB3A8A
 UKAekou0HQd3K9Jq/M0i8uT3YXZrTe9jjVHx2IxYrzc++Z5J55VxjJSaTEjWB4o118u/2ALgC
 WyavSl2AhdxMZDNCLyusY4GTVzg+F0Tp6o74Ew+eMwU3xSnd2EQ85Ar5F54T0S8L7ks/6nh4W
 3dbGXYV+vmxSKhAFwfKE9CXajZcbEgz2zATh3yY/1zEy826yhcvPjsRjQBkPOJngI1po6yROP
 581vGIXWYlV8t3rXTkI5CehWdjcZLCKBwSc9vtwBMDCXSiw3mV1YQVjmwBFZOED6xqQn6kRMz
 esCa9WMtuUHgpR3iZc1zBhpu1XBgPhIP3qKXweQ4clWOnc88WaVC9A7QHDJIpbYRiZhLl+a/E
 /L3H4rm/hAqiWB4Zm
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>> I suggest to move the addition of such input parameter validation
>> to a separate update step.
>>
> Um...The 'src_nents' will be used as a loop condition,
> so validate it here is needed ?

Would you prefer to add such checking as the first update in
another small patch series?

Regards,
Markus
