Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D102F13D9
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731857AbhAKNPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:15:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:33882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731838AbhAKNPf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:15:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AB482246B;
        Mon, 11 Jan 2021 13:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370919;
        bh=0Xwk5scFIROJEGullXvUPQ8TZHfXsavCG4gpCugdOLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ydGoj7ReuIZNau1HOD8CIwb70ZZweGTzyBnp/DQUeqRQa7wWZUKaZG2KRPmZ7BH4N
         oFb5rEdubuLxzV8dJ3B500ysd3/om+gMAFkLSivaKpikDapukdQh25J+L6dUMByEMq
         uB3OMEpMR6y+L366xxTB2G9656ExNQdNSa2to9GI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 031/145] bnxt_en: Check TQM rings for maximum supported value.
Date:   Mon, 11 Jan 2021 14:00:55 +0100
Message-Id: <20210111130050.008885782@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit a029a2fef5d11bb85587433c3783615442abac96 ]

TQM rings are hardware resources that require host context memory
managed by the driver.  The driver supports up to 9 TQM rings and
the number of rings to use is requested by firmware during run-time.
Cap this number to the maximum supported to prevent accessing beyond
the array.  Future firmware may request more than 9 TQM rings.  Define
macros to remove the magic number 9 from the C code.

Fixes: ac3158cb0108 ("bnxt_en: Allocate TQM ring context memory according to fw specification.")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    7 +++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |    7 ++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6790,8 +6790,10 @@ static int bnxt_hwrm_func_backing_store_
 		ctx->tqm_fp_rings_count = resp->tqm_fp_rings_count;
 		if (!ctx->tqm_fp_rings_count)
 			ctx->tqm_fp_rings_count = bp->max_q;
+		else if (ctx->tqm_fp_rings_count > BNXT_MAX_TQM_FP_RINGS)
+			ctx->tqm_fp_rings_count = BNXT_MAX_TQM_FP_RINGS;
 
-		tqm_rings = ctx->tqm_fp_rings_count + 1;
+		tqm_rings = ctx->tqm_fp_rings_count + BNXT_MAX_TQM_SP_RINGS;
 		ctx_pg = kcalloc(tqm_rings, sizeof(*ctx_pg), GFP_KERNEL);
 		if (!ctx_pg) {
 			kfree(ctx);
@@ -6925,7 +6927,8 @@ static int bnxt_hwrm_func_backing_store_
 	     pg_attr = &req.tqm_sp_pg_size_tqm_sp_lvl,
 	     pg_dir = &req.tqm_sp_page_dir,
 	     ena = FUNC_BACKING_STORE_CFG_REQ_ENABLES_TQM_SP;
-	     i < 9; i++, num_entries++, pg_attr++, pg_dir++, ena <<= 1) {
+	     i < BNXT_MAX_TQM_RINGS;
+	     i++, num_entries++, pg_attr++, pg_dir++, ena <<= 1) {
 		if (!(enables & ena))
 			continue;
 
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1435,6 +1435,11 @@ struct bnxt_ctx_pg_info {
 	struct bnxt_ctx_pg_info **ctx_pg_tbl;
 };
 
+#define BNXT_MAX_TQM_SP_RINGS		1
+#define BNXT_MAX_TQM_FP_RINGS		8
+#define BNXT_MAX_TQM_RINGS		\
+	(BNXT_MAX_TQM_SP_RINGS + BNXT_MAX_TQM_FP_RINGS)
+
 struct bnxt_ctx_mem_info {
 	u32	qp_max_entries;
 	u16	qp_min_qp1_entries;
@@ -1473,7 +1478,7 @@ struct bnxt_ctx_mem_info {
 	struct bnxt_ctx_pg_info stat_mem;
 	struct bnxt_ctx_pg_info mrav_mem;
 	struct bnxt_ctx_pg_info tim_mem;
-	struct bnxt_ctx_pg_info *tqm_mem[9];
+	struct bnxt_ctx_pg_info *tqm_mem[BNXT_MAX_TQM_RINGS];
 };
 
 struct bnxt_fw_health {


