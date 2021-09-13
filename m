Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151EF409400
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345770AbhIMO0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:26:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346411AbhIMOY2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:24:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40C3D61B46;
        Mon, 13 Sep 2021 13:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540889;
        bh=xqA451Gq5eHVww4O97l3wIjinDAwalyeCfv3LaE39KA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EDLWpB2MVys5RGEOsx/CT4VgVtLttsN5palwOJ5HzUMCcalrxyP5WZNEX6SLyk1s7
         ejJQ0rIiTA3yfFfXQ4iW0F1rcwezKFrDHcQuZ18Zchb9dFmWbGzstRaw30Dtewo3Sp
         qg4+8+2biH2J/ZCrsR2ilco+IAuujT3XrcFk/BkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 077/334] blk-crypto: fix check for too-large dun_bytes
Date:   Mon, 13 Sep 2021 15:12:11 +0200
Message-Id: <20210913131115.996308273@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
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
index c5bdaafffa29..103c2e2d50d6 100644
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



