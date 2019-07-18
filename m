Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F91C6C528
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389247AbfGRDDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:03:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389210AbfGRDDU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:03:20 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55761204EC;
        Thu, 18 Jul 2019 03:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563418998;
        bh=ZDMqeg5t2LKoO8WRVLKUiZYeta3X5hoq5Vc3vtlnqZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0DQmP9X2+GfvN0hojYUWzrIlfZg9ftqP1qLmWtDrlfYl1FePay7/zU0W211oIXv9E
         XcsG0fvNJo/YparQEN2jjYHzOMJhQu46yS1oJs+gn9LqdKZkX7KVuxcRgRtr9YLsnt
         1JEvHok9IjN0nfEvg9zpgYI9E8r3kr4/cyXXSQvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.2 18/21] crypto: talitos - move struct talitos_edesc into talitos.h
Date:   Thu, 18 Jul 2019 12:01:36 +0900
Message-Id: <20190718030035.566029914@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030030.456918453@linuxfoundation.org>
References: <20190718030030.456918453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit d44769e4ccb636e8238adbc151f25467a536711b upstream.

Moves struct talitos_edesc into talitos.h so that it can be used
from any place in talitos.c

It will be required for next patch ("crypto: talitos - fix hash
on SEC1")

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: stable@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/talitos.c |   30 ------------------------------
 drivers/crypto/talitos.h |   30 ++++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 30 deletions(-)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -948,36 +948,6 @@ badkey:
 	goto out;
 }
 
-/*
- * talitos_edesc - s/w-extended descriptor
- * @src_nents: number of segments in input scatterlist
- * @dst_nents: number of segments in output scatterlist
- * @icv_ool: whether ICV is out-of-line
- * @iv_dma: dma address of iv for checking continuity and link table
- * @dma_len: length of dma mapped link_tbl space
- * @dma_link_tbl: bus physical address of link_tbl/buf
- * @desc: h/w descriptor
- * @link_tbl: input and output h/w link tables (if {src,dst}_nents > 1) (SEC2)
- * @buf: input and output buffeur (if {src,dst}_nents > 1) (SEC1)
- *
- * if decrypting (with authcheck), or either one of src_nents or dst_nents
- * is greater than 1, an integrity check value is concatenated to the end
- * of link_tbl data
- */
-struct talitos_edesc {
-	int src_nents;
-	int dst_nents;
-	bool icv_ool;
-	dma_addr_t iv_dma;
-	int dma_len;
-	dma_addr_t dma_link_tbl;
-	struct talitos_desc desc;
-	union {
-		struct talitos_ptr link_tbl[0];
-		u8 buf[0];
-	};
-};
-
 static void talitos_sg_unmap(struct device *dev,
 			     struct talitos_edesc *edesc,
 			     struct scatterlist *src,
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -65,6 +65,36 @@ struct talitos_desc {
 
 #define TALITOS_DESC_SIZE	(sizeof(struct talitos_desc) - sizeof(__be32))
 
+/*
+ * talitos_edesc - s/w-extended descriptor
+ * @src_nents: number of segments in input scatterlist
+ * @dst_nents: number of segments in output scatterlist
+ * @icv_ool: whether ICV is out-of-line
+ * @iv_dma: dma address of iv for checking continuity and link table
+ * @dma_len: length of dma mapped link_tbl space
+ * @dma_link_tbl: bus physical address of link_tbl/buf
+ * @desc: h/w descriptor
+ * @link_tbl: input and output h/w link tables (if {src,dst}_nents > 1) (SEC2)
+ * @buf: input and output buffeur (if {src,dst}_nents > 1) (SEC1)
+ *
+ * if decrypting (with authcheck), or either one of src_nents or dst_nents
+ * is greater than 1, an integrity check value is concatenated to the end
+ * of link_tbl data
+ */
+struct talitos_edesc {
+	int src_nents;
+	int dst_nents;
+	bool icv_ool;
+	dma_addr_t iv_dma;
+	int dma_len;
+	dma_addr_t dma_link_tbl;
+	struct talitos_desc desc;
+	union {
+		struct talitos_ptr link_tbl[0];
+		u8 buf[0];
+	};
+};
+
 /**
  * talitos_request - descriptor submission request
  * @desc: descriptor pointer (kernel virtual)


