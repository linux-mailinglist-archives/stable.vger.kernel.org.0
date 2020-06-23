Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F55206583
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388227AbgFWUEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:04:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388222AbgFWUEd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:04:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC8952080C;
        Tue, 23 Jun 2020 20:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942673;
        bh=ejEZqh1eLihEvR8qz0EAH2FGNdmKGoi+s0AiUyXYpmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h4jU6jp8i8um10n8kQOZ8DSxHAnGduFrxnHzI8GkXPOzSSlMYtaFuOHqalPiB41/q
         oxj9h4jR8OSASEK2v4lH5UlUd5L2ObWTSy+f9ufF3RUMaaXbacG9eqSs/W/WMc6Z5V
         2/BmtSH++voMA+cGFB1xNiVM/Yalx4Qya/Ja/GmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tero Kristo <t-kristo@ti.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 090/477] crypto: omap-sham - huge buffer access fixes
Date:   Tue, 23 Jun 2020 21:51:27 +0200
Message-Id: <20200623195411.860807142@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e4072cd385857..0cbf9c932a0f0 100644
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



