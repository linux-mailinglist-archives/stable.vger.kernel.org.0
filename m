Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C686999A24
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390845AbfHVRKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390728AbfHVRJT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:09:19 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FDE32342D;
        Thu, 22 Aug 2019 17:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493758;
        bh=GiWhgEtmw+CrWmKoy5ECUngRb5KMcXW1Dpi5tpfSIjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hANLY8XznmejT/iEGSfDNH5kPnVX8TLn/WCLIFNDsNzI/1Bry798GB285+oOhxAW6
         rCdsG0DD5m/cww/vui41UxjBjb/81mCErRBa4qVADk3s3j4/EGFUIx+X7iB4vWL3A8
         Y8cg2v+UFIcK5fINBktEVOR1sPL3bGEAfywJxoXI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 119/135] bnxt_en: Fix VNIC clearing logic for 57500 chips.
Date:   Thu, 22 Aug 2019 13:07:55 -0400
Message-Id: <20190822170811.13303-120-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit a46ecb116fb7f722fa8cb2da01959c36e4e10c41 ]

During device shutdown, the VNIC clearing sequence needs to be modified
to free the VNIC first before freeing the RSS contexts.  The current
code is doing the reverse and we can get mis-directed RX completions
to CP ring ID 0 when the RSS contexts are freed and zeroed.  The clearing
of RSS contexts is not required with the new sequence.

Refactor the VNIC clearing logic into a new function bnxt_clear_vnic()
and do the chip specific VNIC clearing sequence.

Fixes: 7b3af4f75b81 ("bnxt_en: Add RSS support for 57500 chips.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 26 ++++++++++++++++-------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7afae9d80e758..d9eaafa93970b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6963,19 +6963,29 @@ static void bnxt_hwrm_clear_vnic_rss(struct bnxt *bp)
 		bnxt_hwrm_vnic_set_rss(bp, i, false);
 }
 
-static void bnxt_hwrm_resource_free(struct bnxt *bp, bool close_path,
-				    bool irq_re_init)
+static void bnxt_clear_vnic(struct bnxt *bp)
 {
-	if (bp->vnic_info) {
-		bnxt_hwrm_clear_vnic_filter(bp);
+	if (!bp->vnic_info)
+		return;
+
+	bnxt_hwrm_clear_vnic_filter(bp);
+	if (!(bp->flags & BNXT_FLAG_CHIP_P5)) {
 		/* clear all RSS setting before free vnic ctx */
 		bnxt_hwrm_clear_vnic_rss(bp);
 		bnxt_hwrm_vnic_ctx_free(bp);
-		/* before free the vnic, undo the vnic tpa settings */
-		if (bp->flags & BNXT_FLAG_TPA)
-			bnxt_set_tpa(bp, false);
-		bnxt_hwrm_vnic_free(bp);
 	}
+	/* before free the vnic, undo the vnic tpa settings */
+	if (bp->flags & BNXT_FLAG_TPA)
+		bnxt_set_tpa(bp, false);
+	bnxt_hwrm_vnic_free(bp);
+	if (bp->flags & BNXT_FLAG_CHIP_P5)
+		bnxt_hwrm_vnic_ctx_free(bp);
+}
+
+static void bnxt_hwrm_resource_free(struct bnxt *bp, bool close_path,
+				    bool irq_re_init)
+{
+	bnxt_clear_vnic(bp);
 	bnxt_hwrm_ring_free(bp, close_path);
 	bnxt_hwrm_ring_grp_free(bp);
 	if (irq_re_init) {
-- 
2.20.1

