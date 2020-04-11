Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E32911A57AF
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgDKXYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:24:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729802AbgDKXMk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:12:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52F3B20757;
        Sat, 11 Apr 2020 23:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646761;
        bh=Cs9Qe4kNc/+4SFavUbccjPjRjBI5sOfSRGradyFox30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=slnFYFjx1IyxGNHtdmO+u3MaT7plRoKnQKq/jCCwboSbtmru2Y6+TpBsEqtV091Ge
         /OFJbehrgerUsmOkMUAVbnsyZlx2iMzowV3eegWYRfrO3EgmysqhVaqL81iB+tW12n
         NR9x97E/pBZEe6/upZHqxk1V7zIRJXBg3Cai93Sw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 31/66] crypto: chelsio - This fixes the kernel panic which occurs during a libkcapi test
Date:   Sat, 11 Apr 2020 19:11:28 -0400
Message-Id: <20200411231203.25933-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231203.25933-1-sashal@kernel.org>
References: <20200411231203.25933-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ayush Sawal <ayush.sawal@chelsio.com>

[ Upstream commit 9195189e00a7db55e7d448cee973cae87c5a3c71 ]

The libkcapi test which causes kernel panic is
aead asynchronous vmsplice multiple test.

./bin/kcapi  -v -d 4 -x 10   -c "ccm(aes)"
-q 4edb58e8d5eb6bc711c43a6f3693daebde2e5524f1b55297abb29f003236e43d
-t a7877c99 -n 674742abd0f5ba -k 2861fd0253705d7875c95ba8a53171b4
-a fb7bc304a3909e66e2e0c5ef952712dd884ce3e7324171369f2c5db1adc48c7d

This patch avoids dma_mapping of a zero length sg which causes the panic,
by using sg_nents_for_len which maps only upto a specific length

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/chelsio/chcr_algo.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 8b68ccc137c53..796206faabec9 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -2418,8 +2418,9 @@ int chcr_aead_dma_map(struct device *dev,
 	else
 		reqctx->b0_dma = 0;
 	if (req->src == req->dst) {
-		error = dma_map_sg(dev, req->src, sg_nents(req->src),
-				   DMA_BIDIRECTIONAL);
+		error = dma_map_sg(dev, req->src,
+				sg_nents_for_len(req->src, dst_size),
+					DMA_BIDIRECTIONAL);
 		if (!error)
 			goto err;
 	} else {
-- 
2.20.1

