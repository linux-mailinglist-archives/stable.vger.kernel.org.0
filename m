Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3C81FA575
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 03:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgFPBOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 21:14:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbgFPBOK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 21:14:10 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47D1F206D8;
        Tue, 16 Jun 2020 01:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592270049;
        bh=7aUm0dopw7cgOhYt4RoQJS84uWHe6Bpg7pjzMRJYXrs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gQ1qWBhlLR4NMOJIdn7yKrf4jGtPbYG2dkGKjMbdnhkoqtTYQ6xhiGZSVSnPsS3t0
         hckL7cFsqtqoqU0zoWospZ42f8kMJZ8DkaKRVWhE38Z2JP41LV7ba5r5+lLKLIpX/I
         ontToAAloGnmfokSdU3o2aeRxwmMfTvNFdUE+kOY=
Date:   Mon, 15 Jun 2020 21:14:08 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     longpeng2@huawei.com, arei.gonglei@huawei.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, jasowang@redhat.com, mst@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] crypto: virtio: Fix dest length
 calculation in" failed to apply to 5.4-stable tree
Message-ID: <20200616011408.GN1931@sasha-vm>
References: <159225302411542@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <159225302411542@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 10:30:24PM +0200, gregkh@linuxfoundation.org wrote:
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
>From d90ca42012db2863a9a30b564a2ace6016594bda Mon Sep 17 00:00:00 2001
>From: "Longpeng(Mike)" <longpeng2@huawei.com>
>Date: Tue, 2 Jun 2020 15:05:01 +0800
>Subject: [PATCH] crypto: virtio: Fix dest length calculation in
> __virtio_crypto_skcipher_do_req()
>
>The src/dst length is not aligned with AES_BLOCK_SIZE(which is 16) in some
>testcases in tcrypto.ko.
>
>For example, the src/dst length of one of cts(cbc(aes))'s testcase is 17, the
>crypto_virtio driver will set @src_data_len=16 but @dst_data_len=17 in this
>case and get a wrong at then end.
>
>  SRC: pp pp pp pp pp pp pp pp pp pp pp pp pp pp pp pp pp (17 bytes)
>  EXP: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc pp (17 bytes)
>  DST: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 00 (pollute the last bytes)
>  (pp: plaintext  cc:ciphertext)
>
>Fix this issue by limit the length of dest buffer.
>
>Fixes: dbaf0624ffa5 ("crypto: add virtio-crypto driver")
>Cc: Gonglei <arei.gonglei@huawei.com>
>Cc: Herbert Xu <herbert@gondor.apana.org.au>
>Cc: "Michael S. Tsirkin" <mst@redhat.com>
>Cc: Jason Wang <jasowang@redhat.com>
>Cc: "David S. Miller" <davem@davemloft.net>
>Cc: virtualization@lists.linux-foundation.org
>Cc: linux-kernel@vger.kernel.org
>Cc: stable@vger.kernel.org
>Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
>Link: https://lore.kernel.org/r/20200602070501.2023-4-longpeng2@huawei.com
>Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Conflict due to missing eee1d6fca0a0 ("crypto: virtio - switch to
skcipher API"). I've fixed it and queued up for 5.4, 4.19, and 4.14.
-- 
Thanks,
Sasha
