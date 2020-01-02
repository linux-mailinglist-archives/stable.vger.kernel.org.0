Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6377E12EE34
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730906AbgABWgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:36:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:46836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730362AbgABWgJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:36:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F04F20866;
        Thu,  2 Jan 2020 22:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004569;
        bh=lhoQuyIkfheikLtVGHSgIcS2VxeCYOxZooRUI3X0+M8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wy2qyjWmZ0t1C09qyby3GhFnmBTffgiZ3itjkKf/gRHVpqBejQdoonW/8OyZdg41I
         aCWjebkMzjTyrM8bLPER9n9Ahkw4QSq/AvNqfub2myqIlnxOYK5bw0yPUiRNXtnzEM
         qCKaAwgi1lPF/aZYQarUVBYzcJqhew9LWGhdPqZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 062/137] crypto: sun4i-ss - Fix 64-bit size_t warnings on sun4i-ss-hash.c
Date:   Thu,  2 Jan 2020 23:07:15 +0100
Message-Id: <20200102220554.834811726@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
References: <20200102220546.618583146@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe.montjoie@gmail.com>

[ Upstream commit a7126603d46fe8f01aeedf589e071c6aaa6c6c39 ]

If you try to compile this driver on a 64-bit platform then you
will get warnings because it mixes size_t with unsigned int which
only works on 32-bit.

This patch fixes all of the warnings on sun4i-ss-hash.c.
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
index ff8031498809..bff3cbd05c0a 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
@@ -245,8 +245,8 @@ int sun4i_hash_update(struct ahash_request *areq)
 			 */
 			while (op->len < 64 && i < end) {
 				/* how many bytes we can read from current SG */
-				in_r = min3(mi.length - in_i, end - i,
-					    64 - op->len);
+				in_r = min(end - i, 64 - op->len);
+				in_r = min_t(size_t, mi.length - in_i, in_r);
 				memcpy(op->buf + op->len, mi.addr + in_i, in_r);
 				op->len += in_r;
 				i += in_r;
@@ -266,8 +266,8 @@ int sun4i_hash_update(struct ahash_request *areq)
 		}
 		if (mi.length - in_i > 3 && i < end) {
 			/* how many bytes we can read from current SG */
-			in_r = min3(mi.length - in_i, areq->nbytes - i,
-				    ((mi.length - in_i) / 4) * 4);
+			in_r = min_t(size_t, mi.length - in_i, areq->nbytes - i);
+			in_r = min_t(size_t, ((mi.length - in_i) / 4) * 4, in_r);
 			/* how many bytes we can write in the device*/
 			todo = min3((u32)(end - i) / 4, rx_cnt, (u32)in_r / 4);
 			writesl(ss->base + SS_RXFIFO, mi.addr + in_i, todo);
@@ -289,8 +289,8 @@ int sun4i_hash_update(struct ahash_request *areq)
 	if ((areq->nbytes - i) < 64) {
 		while (i < areq->nbytes && in_i < mi.length && op->len < 64) {
 			/* how many bytes we can read from current SG */
-			in_r = min3(mi.length - in_i, areq->nbytes - i,
-				    64 - op->len);
+			in_r = min(areq->nbytes - i, 64 - op->len);
+			in_r = min_t(size_t, mi.length - in_i, in_r);
 			memcpy(op->buf + op->len, mi.addr + in_i, in_r);
 			op->len += in_r;
 			i += in_r;
-- 
2.20.1



