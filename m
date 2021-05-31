Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216B3395F49
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbhEaOJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:09:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233149AbhEaOHe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:07:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CF5461408;
        Mon, 31 May 2021 13:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468358;
        bh=KLSH0nHP6iWM/iZlyTw+XyKElfMnEL1/zIgwuEG1xsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=psCFEJnK8JH0Z5xrcuHP4Zy/1VuiEdqhzBDNTx/VE80sjX7CXCLSITSDMjSJPwoMJ
         cNxpbwmYzbR632tbhQ0PQIcQe2+Rdwm/zmsqML/HWhfCn52YmArRvLwP3UT+YoXsJ0
         HOFUkyrH+j1jj35UeVvMUEtJ7El/LyLSO/rQdyws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 213/252] bnxt_en: Fix context memory setup for 64K page size.
Date:   Mon, 31 May 2021 15:14:38 +0200
Message-Id: <20210531130705.251104887@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
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
index ff86324c7fb8..adfaa9a850dd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6834,14 +6834,7 @@ ctx_err:
 static void bnxt_hwrm_set_pg_attr(struct bnxt_ring_mem_info *rmem, u8 *pg_attr,
 				  __le64 *pg_dir)
 {
-	u8 pg_size = 0;
-
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
index e4e926c65118..a95c5afa2f01 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1440,6 +1440,16 @@ struct bnxt_ctx_pg_info {
 #define BNXT_MAX_TQM_RINGS		\
 	(BNXT_MAX_TQM_SP_RINGS + BNXT_MAX_TQM_FP_RINGS)
 
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



