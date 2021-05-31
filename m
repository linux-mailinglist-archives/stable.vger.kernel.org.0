Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6AFE3962B2
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbhEaPAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:00:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233681AbhEaO5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:57:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62E4861CC1;
        Mon, 31 May 2021 14:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469642;
        bh=zgbrX1qRWhrPrz1SlMyFHOBev3SVQj6F8bu9ITaeYek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0xPgEawe+K6ZV0XVWylKg8+RiAvcCiXcqRQ1X5uHvCLPuqzOBavQkc1xKVq/HwSTk
         kfmrlKM2XQ6bchINueghtl0TFp9BvOkLbcIpgk7YlscXE7kFWY6fBXnMbXcGW2/t2N
         la8k/zLRdG3mpERHnoblm846FnYi+7/zyby13//o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 248/296] bnxt_en: Fix context memory setup for 64K page size.
Date:   Mon, 31 May 2021 15:15:03 +0200
Message-Id: <20210531130712.111922411@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 702279d2ce4650000bb6302013630304e359dc13 ]

There was a typo in the code that checks for 64K BNXT_PAGE_SHIFT in
bnxt_hwrm_set_pg_attr().  Fix it and make the code more understandable
with a new macro BNXT_SET_CTX_PAGE_ATTR().

Fixes: 1b9394e5a2ad ("bnxt_en: Configure context memory on new devices.")
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |  9 +--------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 10 ++++++++++
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index fc7345e57bc1..027997c711ab 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6920,17 +6920,10 @@ ctx_err:
 static void bnxt_hwrm_set_pg_attr(struct bnxt_ring_mem_info *rmem, u8 *pg_attr,
 				  __le64 *pg_dir)
 {
-	u8 pg_size = 0;
-
 	if (!rmem->nr_pages)
 		return;
 
-	if (BNXT_PAGE_SHIFT == 13)
-		pg_size = 1 << 4;
-	else if (BNXT_PAGE_SIZE == 16)
-		pg_size = 2 << 4;
-
-	*pg_attr = pg_size;
+	BNXT_SET_CTX_PAGE_ATTR(*pg_attr);
 	if (rmem->depth >= 1) {
 		if (rmem->depth == 2)
 			*pg_attr |= 2;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 1259e68cba2a..f6bf69b02de9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1456,6 +1456,16 @@ struct bnxt_ctx_pg_info {
 
 #define BNXT_BACKING_STORE_CFG_LEGACY_LEN	256
 
+#define BNXT_SET_CTX_PAGE_ATTR(attr)					\
+do {									\
+	if (BNXT_PAGE_SIZE == 0x2000)					\
+		attr = FUNC_BACKING_STORE_CFG_REQ_SRQ_PG_SIZE_PG_8K;	\
+	else if (BNXT_PAGE_SIZE == 0x10000)				\
+		attr = FUNC_BACKING_STORE_CFG_REQ_QPC_PG_SIZE_PG_64K;	\
+	else								\
+		attr = FUNC_BACKING_STORE_CFG_REQ_QPC_PG_SIZE_PG_4K;	\
+} while (0)
+
 struct bnxt_ctx_mem_info {
 	u32	qp_max_entries;
 	u16	qp_min_qp1_entries;
-- 
2.30.2



