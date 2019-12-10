Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3708119CA1
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfLJWcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:32:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729374AbfLJWcT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:32:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6D1820836;
        Tue, 10 Dec 2019 22:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576017138;
        bh=gMQJx5a47q9tzmeWMH+Nyl5/xW+psyxad65AY41C2fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tC6Vmngqi8XukPvafQZOtICp3YSLLDukT7epa3btixpHu9BgERP0rIYKIcVngvPhO
         qksylpDxh72dXc3qEEduX2xOzGeH40ys5i5Pn6GuCsz4vBTKr6VcP/TQ/ZbCf6LDfu
         C94qC6+78BdTZc4aLPFbpYMB8SmsA1NBSbKHdBTE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 86/91] crypto: sun4i-ss - Fix 64-bit size_t warnings on sun4i-ss-hash.c
Date:   Tue, 10 Dec 2019 17:30:30 -0500
Message-Id: <20191210223035.14270-86-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210223035.14270-1-sashal@kernel.org>
References: <20191210223035.14270-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index ec16ec2e284d0..b2e6837135393 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
@@ -286,8 +286,8 @@ static int sun4i_hash(struct ahash_request *areq)
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
@@ -307,8 +307,8 @@ static int sun4i_hash(struct ahash_request *areq)
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
@@ -334,8 +334,8 @@ static int sun4i_hash(struct ahash_request *areq)
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

