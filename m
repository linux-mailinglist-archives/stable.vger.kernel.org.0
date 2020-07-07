Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D117921708A
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbgGGPSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:18:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729216AbgGGPSi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:18:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B5892065D;
        Tue,  7 Jul 2020 15:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135117;
        bh=zixSc3b/IaBLaB9+Nhpr8wMit1YkgopGuFIq1Rk5x0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DB4Bn85/u0+VViMT6sR77ovGaBANSqVziacvhKWjiCgPslh1dy4JhaoP2ehBUb6Dm
         ptfP5BRs3nnTzrHRMvdYgLHZGZXJACK6kzS3dRiiFEPD3HHmrbdjklqzU0+IsQ8y0o
         cRZvLpenXsPArrZ+mjkEVlaQ+PgIvVT86g+W9rNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/36] cxgb4: fix SGE queue dump destination buffer context
Date:   Tue,  7 Jul 2020 17:17:10 +0200
Message-Id: <20200707145750.005172102@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145749.130272978@linuxfoundation.org>
References: <20200707145749.130272978@linuxfoundation.org>
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
index 5bc58429bb1c4..c91e155c147ca 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
@@ -1987,7 +1987,6 @@ int cudbg_collect_dump_context(struct cudbg_init *pdbg_init,
 	u8 mem_type[CTXT_INGRESS + 1] = { 0 };
 	struct cudbg_buffer temp_buff = { 0 };
 	struct cudbg_ch_cntxt *buff;
-	u64 *dst_off, *src_off;
 	u8 *ctx_buf;
 	u8 i, k;
 	int rc;
@@ -2056,8 +2055,11 @@ int cudbg_collect_dump_context(struct cudbg_init *pdbg_init,
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



