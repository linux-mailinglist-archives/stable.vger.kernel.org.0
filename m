Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5D12170CA
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbgGGPUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:20:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728369AbgGGPUn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:20:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9122C2065D;
        Tue,  7 Jul 2020 15:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135243;
        bh=ygIBNeWu8GVUpOQTfqxaNYxa0o9TkRmFkWyiDMbqcDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vrx39c8oAHZruLKkLC1JiakFYZcZ5ZflzvkAZ0ej86nee7zLKw5eRuJeXYGF6f2y6
         vaxNQkNoWXvgyU3G0o05bdJidcY6ebQpxaRFiZZb+him8jY6MAytcvJNx52amj5nSi
         7Jayd7eapTdqktbWKanaszeAspVTpyL1MpsQGWRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 29/65] cxgb4: fix SGE queue dump destination buffer context
Date:   Tue,  7 Jul 2020 17:17:08 +0200
Message-Id: <20200707145753.884263138@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145752.417212219@linuxfoundation.org>
References: <20200707145752.417212219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

[ Upstream commit 1992ded5d111997877a9a25205976d8d03c46814 ]

The data in destination buffer is expected to be be parsed in big
endian. So, use the right context.

Fixes following sparse warning:
cudbg_lib.c:2041:44: warning: incorrect type in assignment (different
base types)
cudbg_lib.c:2041:44:    expected unsigned long long [usertype]
cudbg_lib.c:2041:44:    got restricted __be64 [usertype]

Fixes: 736c3b94474e ("cxgb4: collect egress and ingress SGE queue contexts")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
index 7bcdce182ee5c..e26ae298a080a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
@@ -1980,7 +1980,6 @@ int cudbg_collect_dump_context(struct cudbg_init *pdbg_init,
 	u8 mem_type[CTXT_INGRESS + 1] = { 0 };
 	struct cudbg_buffer temp_buff = { 0 };
 	struct cudbg_ch_cntxt *buff;
-	u64 *dst_off, *src_off;
 	u8 *ctx_buf;
 	u8 i, k;
 	int rc;
@@ -2049,8 +2048,11 @@ int cudbg_collect_dump_context(struct cudbg_init *pdbg_init,
 		}
 
 		for (j = 0; j < max_ctx_qid; j++) {
+			__be64 *dst_off;
+			u64 *src_off;
+
 			src_off = (u64 *)(ctx_buf + j * SGE_CTXT_SIZE);
-			dst_off = (u64 *)buff->data;
+			dst_off = (__be64 *)buff->data;
 
 			/* The data is stored in 64-bit cpu order.  Convert it
 			 * to big endian before parsing.
-- 
2.25.1



