Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C173AEEAA
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbhFUQas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231429AbhFUQ2p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:28:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C1FA613E9;
        Mon, 21 Jun 2021 16:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292627;
        bh=WvaPbcNA+EDFJ6n4l8FKemglCe+jBKtDS0JqubBFvsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ued2amQOWtqXsc0+lOphZQZtO7i6L0XQo0uImsz5hE8drXvGfvod5e2mkYF4tN4qC
         nxeG4Mgojqt5XdEo0Quor7D0G3WGVSpjUtTKucMbm39YNr69SmhwNFRhYOBDw0WGa5
         mXJLwgYyxyFnjD9Kgb8qsYPnEz+4NiAvnemZIBls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rukhsana Ansari <rukhsana.ansari@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/146] bnxt_en: Fix TQM fastpath ring backing store computation
Date:   Mon, 21 Jun 2021 18:15:00 +0200
Message-Id: <20210621154915.295344929@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rukhsana Ansari <rukhsana.ansari@broadcom.com>

[ Upstream commit c12e1643d2738bcd4e26252ce531878841dd3f38 ]

TQM fastpath ring needs to be sized to store both the requester
and responder side of RoCE QPs in TQM for supporting bi-directional
tests.  Fix bnxt_alloc_ctx_mem() to multiply the RoCE QPs by a factor of
2 when computing the number of entries for TQM fastpath ring.  This
fixes an RX pipeline stall issue when running bi-directional max
RoCE QP tests.

Fixes: c7dd7ab4b204 ("bnxt_en: Improve TQM ring context memory sizing formulas.")
Signed-off-by: Rukhsana Ansari <rukhsana.ansari@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 70c03c156e00..3f3d13a18992 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7184,7 +7184,7 @@ skip_rdma:
 	entries_sp = ctx->vnic_max_vnic_entries + ctx->qp_max_l2_entries +
 		     2 * (extra_qps + ctx->qp_min_qp1_entries) + min;
 	entries_sp = roundup(entries_sp, ctx->tqm_entries_multiple);
-	entries = ctx->qp_max_l2_entries + extra_qps + ctx->qp_min_qp1_entries;
+	entries = ctx->qp_max_l2_entries + 2 * (extra_qps + ctx->qp_min_qp1_entries);
 	entries = roundup(entries, ctx->tqm_entries_multiple);
 	entries = clamp_t(u32, entries, min, ctx->tqm_max_entries_per_ring);
 	for (i = 0; i < ctx->tqm_fp_rings_count + 1; i++) {
-- 
2.30.2



