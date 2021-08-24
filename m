Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C84E3F651B
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239287AbhHXRK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234514AbhHXRIV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:08:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A900961414;
        Tue, 24 Aug 2021 17:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824405;
        bh=l8gGLBDUbV9G+aJgNjnTrh2hnAn5kXY/4ZEmGO8S52g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YpB/cT0sJbeO3zpWh7RrfnR7Yxjyd4LcU+qHftjjFeQ4rbLEWNgCKgnNBrdWJEOnG
         nJUKB77W/LXICpa+ksIfM/MVLSY+PUw3+MvDPRPQJNADcC+MVeVOqUXjJ3AaoALQYR
         TZH/4JIbpZE5rWP4fzN6+cS8X/7/tTU2+XjsGzWFfbn1Pw9p8QLXZVgERK9RHYYCQW
         9SK58N/G2EKlPaBKZiKlooPOVxtRfoGolAB/bc/5Sk3cNMZpmNmcpscsDh6RCmoWSZ
         P/h4qDI8DYsGDJEyUWE9CCVOY3guE61ra0Ee4sOP7amr/j/TYFDGWAMSZDIUBCwSlY
         ygBHG2CH4XRGQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Lance Richardson <lance.richardson@broadcom.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 56/98] bnxt_en: Add missing DMA memory barriers
Date:   Tue, 24 Aug 2021 12:58:26 -0400
Message-Id: <20210824165908.709932-57-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 828affc27ed43441bd1efdaf4e07e96dd43a0362 ]

Each completion ring entry has a valid bit to indicate that the entry
contains a valid completion event.  The driver's main poll loop
__bnxt_poll_work() has the proper dma_rmb() to make sure the valid
bit of the next entry has been checked before proceeding further.
But when we call bnxt_rx_pkt() to process the RX event, the RX
completion event consists of two completion entries and only the
first entry has been checked to be valid.  We need the same barrier
after checking the next completion entry.  Add missing dma_rmb()
barriers in bnxt_rx_pkt() and other similar locations.

Fixes: 67a95e2022c7 ("bnxt_en: Need memory barrier when processing the completion ring.")
Reported-by: Lance Richardson <lance.richardson@broadcom.com>
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Reviewed-by: Lance Richardson <lance.richardson@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index dbd99a8fd9c9..849ae99a955a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1747,6 +1747,10 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	if (!RX_CMP_VALID(rxcmp1, tmp_raw_cons))
 		return -EBUSY;
 
+	/* The valid test of the entry must be done first before
+	 * reading any further.
+	 */
+	dma_rmb();
 	prod = rxr->rx_prod;
 
 	if (cmp_type == CMP_TYPE_RX_L2_TPA_START_CMP) {
@@ -1950,6 +1954,10 @@ static int bnxt_force_rx_discard(struct bnxt *bp,
 	if (!RX_CMP_VALID(rxcmp1, tmp_raw_cons))
 		return -EBUSY;
 
+	/* The valid test of the entry must be done first before
+	 * reading any further.
+	 */
+	dma_rmb();
 	cmp_type = RX_CMP_TYPE(rxcmp);
 	if (cmp_type == CMP_TYPE_RX_L2_CMP) {
 		rxcmp1->rx_cmp_cfa_code_errors_v2 |=
@@ -2394,6 +2402,10 @@ static int bnxt_poll_nitroa0(struct napi_struct *napi, int budget)
 		if (!TX_CMP_VALID(txcmp, raw_cons))
 			break;
 
+		/* The valid test of the entry must be done first before
+		 * reading any further.
+		 */
+		dma_rmb();
 		if ((TX_CMP_TYPE(txcmp) & 0x30) == 0x10) {
 			tmp_raw_cons = NEXT_RAW_CMP(raw_cons);
 			cp_cons = RING_CMP(tmp_raw_cons);
-- 
2.30.2

