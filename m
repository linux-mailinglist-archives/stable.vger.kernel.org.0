Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08F81FA567
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 03:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgFPBJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 21:09:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbgFPBJW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 21:09:22 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5032B206D7;
        Tue, 16 Jun 2020 01:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592269762;
        bh=RCQWm2OVe9lfFR8CohcCeavVfxrl7jOmzcMj7O5gMHU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qh2n4bj4EpiUm3pT3Gu5Jgv4p9kPJ8tpORPtkXh8uJKo4YvaxQNBZv3C2ks56uYi8
         W5In5eaUfdAy3lhmHrQ+wSqEKs7Z1BkxImbLujoWu02mW6HuoTNd2DM9ylhgfYFXbz
         va59cyu6bY+4fc/KbF1LrH2z1D+lXT79NUcto/s8=
Date:   Mon, 15 Jun 2020 21:09:21 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     longpeng2@huawei.com, arei.gonglei@huawei.com, clabbe@baylibre.com,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        jasowang@redhat.com, mst@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] crypto: virtio: Fix src/dst scatterlist
 calculation in" failed to apply to 5.4-stable tree
Message-ID: <20200616010921.GM1931@sasha-vm>
References: <15922523850161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15922523850161@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 10:19:45PM +0200, gregkh@linuxfoundation.org wrote:
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
>From b02989f37fc5e865ceeee9070907e4493b3a21e2 Mon Sep 17 00:00:00 2001
>From: "Longpeng(Mike)" <longpeng2@huawei.com>
>Date: Tue, 2 Jun 2020 15:04:59 +0800
>Subject: [PATCH] crypto: virtio: Fix src/dst scatterlist calculation in
> __virtio_crypto_skcipher_do_req()
>
>The system will crash when the users insmod crypto/tcrypt.ko with mode=38
>( testing "cts(cbc(aes))" ).
>
>Usually the next entry of one sg will be @sg@ + 1, but if this sg element
>is part of a chained scatterlist, it could jump to the start of a new
>scatterlist array. Fix it by sg_next() on calculation of src/dst
>scatterlist.
>
>Fixes: dbaf0624ffa5 ("crypto: add virtio-crypto driver")
>Reported-by: LABBE Corentin <clabbe@baylibre.com>
>Cc: Herbert Xu <herbert@gondor.apana.org.au>
>Cc: "Michael S. Tsirkin" <mst@redhat.com>
>Cc: Jason Wang <jasowang@redhat.com>
>Cc: "David S. Miller" <davem@davemloft.net>
>Cc: virtualization@lists.linux-foundation.org
>Cc: linux-kernel@vger.kernel.org
>Cc: stable@vger.kernel.org
>Link: https://lore.kernel.org/r/20200123101000.GB24255@Red
>Signed-off-by: Gonglei <arei.gonglei@huawei.com>
>Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
>Link: https://lore.kernel.org/r/20200602070501.2023-2-longpeng2@huawei.com
>Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

I've worked around missing eee1d6fca0a0 ("crypto: virtio - switch to
skcipher API") and queued it for 5.4, 4.19, and 4.14.

-- 
Thanks,
Sasha
