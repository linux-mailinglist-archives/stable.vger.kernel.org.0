Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A9E20E823
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391782AbgF2WD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:03:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgF2SfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C23212405B;
        Mon, 29 Jun 2020 15:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443929;
        bh=fLY1AgT1wEp7fNrc7MHIRNNDgz4/uoC9E8LizHZsIdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cVzkNFoPv7tbsBCDE8cki91XTlEK4NkxTLMyux2GvUz3l+/PZD5jJ9n8ORePi4jBa
         uEEfpAzAnwv4sbAJzkSa2VKb6DmsVpvuH5woTYFypkovI1FeF0PY3lfq8oTl73TJGr
         JEgcnsEYzkzVEZW/OFipgErR8EBMNE3HRBbE7Uvw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kicinski@fb.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 030/265] bnxt_en: Fix statistics counters issue during ifdown with older firmware.
Date:   Mon, 29 Jun 2020 11:14:23 -0400
Message-Id: <20200629151818.2493727-31-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit c2dec363feb41544a76c8083aca2378990e17166 ]

On older firmware, the hardware statistics are not cleared when the
driver frees the hardware stats contexts during ifdown.  The driver
expects these stats to be cleared and saves a copy before freeing
the stats contexts.  During the next ifup, the driver will likely
allocate the same hardware stats contexts and this will cause a big
increase in the counters as the old counters are added back to the
saved counters.

We fix it by making an additional firmware call to clear the counters
before freeing the hw stats contexts when the firmware is the older
20.x firmware.

Fixes: b8875ca356f1 ("bnxt_en: Save ring statistics before reset.")
Reported-by: Jakub Kicinski <kicinski@fb.com>
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Tested-by: Jakub Kicinski <kicinski@fb.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6bf97b3acdadc..c202c2a3d140d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6293,6 +6293,7 @@ int bnxt_hwrm_set_coal(struct bnxt *bp)
 
 static void bnxt_hwrm_stat_ctx_free(struct bnxt *bp)
 {
+	struct hwrm_stat_ctx_clr_stats_input req0 = {0};
 	struct hwrm_stat_ctx_free_input req = {0};
 	int i;
 
@@ -6302,6 +6303,7 @@ static void bnxt_hwrm_stat_ctx_free(struct bnxt *bp)
 	if (BNXT_CHIP_TYPE_NITRO_A0(bp))
 		return;
 
+	bnxt_hwrm_cmd_hdr_init(bp, &req0, HWRM_STAT_CTX_CLR_STATS, -1, -1);
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_STAT_CTX_FREE, -1, -1);
 
 	mutex_lock(&bp->hwrm_cmd_lock);
@@ -6311,7 +6313,11 @@ static void bnxt_hwrm_stat_ctx_free(struct bnxt *bp)
 
 		if (cpr->hw_stats_ctx_id != INVALID_STATS_CTX_ID) {
 			req.stat_ctx_id = cpu_to_le32(cpr->hw_stats_ctx_id);
-
+			if (BNXT_FW_MAJ(bp) <= 20) {
+				req0.stat_ctx_id = req.stat_ctx_id;
+				_hwrm_send_message(bp, &req0, sizeof(req0),
+						   HWRM_CMD_TIMEOUT);
+			}
 			_hwrm_send_message(bp, &req, sizeof(req),
 					   HWRM_CMD_TIMEOUT);
 
-- 
2.25.1

