Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E811FA555
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 03:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbgFPBBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 21:01:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726634AbgFPBBp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 21:01:45 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FC98207D3;
        Tue, 16 Jun 2020 01:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592269304;
        bh=DQ646eq31frV728tQH0cvQDdWZ703kh3rlvIjiCOFK4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M44cZOHUCUz8sZoNv5bCj7or4Unn/giUkFZf38GOuk7KK3QriPESAU+yDKtyR86gs
         lkcAIY5OOtUU1XZBb6Tk1ioWXsCM3FlwmNjosNWmy97fkhhtJIY4O3k6Si1aKaqCnN
         cQ8EXRkLLsI8k9RyJ/o5e/cGlp1D963nuGrEwEGI=
Date:   Mon, 15 Jun 2020 21:01:43 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     longpeng2@huawei.com, arei.gonglei@huawei.com, clabbe@baylibre.com,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        jasowang@redhat.com, mst@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] crypto: virtio: Fix use-after-free in"
 failed to apply to 5.4-stable tree
Message-ID: <20200616010143.GL1931@sasha-vm>
References: <159225236994131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <159225236994131@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 10:19:29PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.4-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 8c855f0720ff006d75d0a2512c7f6c4f60ff60ee Mon Sep 17 00:00:00 2001
>From: "Longpeng(Mike)" <longpeng2@huawei.com>
>Date: Tue, 2 Jun 2020 15:05:00 +0800
>Subject: [PATCH] crypto: virtio: Fix use-after-free in
> virtio_crypto_skcipher_finalize_req()
>
>The system'll crash when the users insmod crypto/tcrypto.ko with mode=155
>( testing "authenc(hmac(sha1),cbc(aes))" ). It's caused by reuse the memory
>of request structure.
>
>In crypto_authenc_init_tfm(), the reqsize is set to:
>  [PART 1] sizeof(authenc_request_ctx) +
>  [PART 2] ictx->reqoff +
>  [PART 3] MAX(ahash part, skcipher part)
>and the 'PART 3' is used by both ahash and skcipher in turn.
>
>When the virtio_crypto driver finish skcipher req, it'll call ->complete
>callback(in crypto_finalize_skcipher_request) and then free its
>resources whose pointers are recorded in 'skcipher parts'.
>
>However, the ->complete is 'crypto_authenc_encrypt_done' in this case,
>it will use the 'ahash part' of the request and change its content,
>so virtio_crypto driver will get the wrong pointer after ->complete
>finish and mistakenly free some other's memory. So the system will crash
>when these memory will be used again.
>
>The resources which need to be cleaned up are not used any more. But the
>pointers of these resources may be changed in the function
>"crypto_finalize_skcipher_request". Thus release specific resources before
>calling this function.
>
>Fixes: dbaf0624ffa5 ("crypto: add virtio-crypto driver")
>Reported-by: LABBE Corentin <clabbe@baylibre.com>
>Cc: Gonglei <arei.gonglei@huawei.com>
>Cc: Herbert Xu <herbert@gondor.apana.org.au>
>Cc: "Michael S. Tsirkin" <mst@redhat.com>
>Cc: Jason Wang <jasowang@redhat.com>
>Cc: "David S. Miller" <davem@davemloft.net>
>Cc: virtualization@lists.linux-foundation.org
>Cc: linux-kernel@vger.kernel.org
>Cc: stable@vger.kernel.org
>Link: https://lore.kernel.org/r/20200123101000.GB24255@Red
>Acked-by: Gonglei <arei.gonglei@huawei.com>
>Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
>Link: https://lore.kernel.org/r/20200602070501.2023-3-longpeng2@huawei.com
>Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Conflict due to missing eee1d6fca0a0 ("crypto: virtio - switch to
skcipher API"). Fixed and queued for 5.4, 4.19, and 4.14.

-- 
Thanks,
Sasha
