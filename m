Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CFB1FDB13
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728394AbgFRBKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:10:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728385AbgFRBKF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:10:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D718E21D7B;
        Thu, 18 Jun 2020 01:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442605;
        bh=BGdvKK5DrbYBFeR4C8aGl3gQsYyEsDpaxKr1dkc8478=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gmiAm8sEQw9CzzdNSxIKtk1WXyp3TJProqX1txhxhLyy74xJFLlJ2iMgOluSH3WG9
         d4Ok5VC2xZgG4Hfg+0RJKIpFYRZ3GSipsHcR9HKfmRDBg1sE83VrJYlNFMzmQ0XM5v
         3eG4LUMz4NDH7IeOwLLyZvIKfyy+UngUgtL7Ov/I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tero Kristo <t-kristo@ti.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 091/388] crypto: omap-sham - huge buffer access fixes
Date:   Wed, 17 Jun 2020 21:03:08 -0400
Message-Id: <20200618010805.600873-91-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tero Kristo <t-kristo@ti.com>

[ Upstream commit 6395166d7a19019d5e9574eb9ecdaf0028abb887 ]

The ctx internal buffer can only hold buflen amount of data, don't try
to copy over more than that. Also, initialize the context sg pointer
if we only have data in the context internal buffer, this can happen
when closing a hash with certain data amounts.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/omap-sham.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index e4072cd38585..0cbf9c932a0f 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -751,8 +751,15 @@ static int omap_sham_align_sgs(struct scatterlist *sg,
 	int offset = rctx->offset;
 	int bufcnt = rctx->bufcnt;
 
-	if (!sg || !sg->length || !nbytes)
+	if (!sg || !sg->length || !nbytes) {
+		if (bufcnt) {
+			sg_init_table(rctx->sgl, 1);
+			sg_set_buf(rctx->sgl, rctx->dd->xmit_buf, bufcnt);
+			rctx->sg = rctx->sgl;
+		}
+
 		return 0;
+	}
 
 	new_len = nbytes;
 
@@ -896,7 +903,7 @@ static int omap_sham_prepare_request(struct ahash_request *req, bool update)
 	if (hash_later < 0)
 		hash_later = 0;
 
-	if (hash_later) {
+	if (hash_later && hash_later <= rctx->buflen) {
 		scatterwalk_map_and_copy(rctx->buffer,
 					 req->src,
 					 req->nbytes - hash_later,
-- 
2.25.1

