Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F2A408EA0
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242422AbhIMNgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:36:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241548AbhIMNdx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:33:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBD3D6138B;
        Mon, 13 Sep 2021 13:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539583;
        bh=rpU8p4UhJp625meSElwb8mq8oA3sN2360sf4npiXMwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rEGpsr6HwYpDZKgXWanoID7EqBE0dsT1ccjFc9gnTDli8Nkvzb3Bmuibb/nvdX+8A
         94slvttlyCUjbEuXWT653cTnfcvH5TDBJEOmNylRQ8vbq3GQDN6nM6hwyTWMzjfvII
         jYMsIh8CIdZW79YWImcSFLgu8uk/kCB3s4oFrGX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/236] blk-crypto: fix check for too-large dun_bytes
Date:   Mon, 13 Sep 2021 15:12:48 +0200
Message-Id: <20210913131102.509859702@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit cc40b7225151f611ef837f6403cfaeadc7af214a ]

dun_bytes needs to be less than or equal to the IV size of the
encryption mode, not just less than or equal to BLK_CRYPTO_MAX_IV_SIZE.

Currently this doesn't matter since blk_crypto_init_key() is never
actually passed invalid values, but we might as well fix this.

Fixes: a892c8d52c02 ("block: Inline encryption support for blk-mq")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20210825055918.51975-1-ebiggers@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 5da43f0973b4..5ffa9aab49de 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -332,7 +332,7 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key, const u8 *raw_key,
 	if (mode->keysize == 0)
 		return -EINVAL;
 
-	if (dun_bytes == 0 || dun_bytes > BLK_CRYPTO_MAX_IV_SIZE)
+	if (dun_bytes == 0 || dun_bytes > mode->ivsize)
 		return -EINVAL;
 
 	if (!is_power_of_2(data_unit_size))
-- 
2.30.2



