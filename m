Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4756B3F65C4
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239213AbhHXRQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:16:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240211AbhHXRO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:14:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C61E661A7D;
        Tue, 24 Aug 2021 17:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824502;
        bh=40OIWE7AIzRI9LFlsAS+mxr+GK7T0FWQir9TH+Ag0p4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sK6IeUKym0cQFvblfX7aGYTnDrb55JnyoBoIM9I3Qms7HjBvVykv3floflF7wunAl
         NjHN3879bWgLmFWLXrOJ5DCNNWDS20fF93CH81zXkJplSU7G2S4zWC7SVpNdGkT4oN
         4VpKxR1atQoppCX3V8uvpVzHPdNWTf0w0YC363NmX8Vgh0wX/Zgjs+zeQ6D0Ela2IN
         3SmlzZN6JmYlGYOkKM9sYGUFllMo8roFMHTyobETQx01bY+VtChB8wkj9PVzN+clbS
         RgjvhSoKq5oZMJ1wsJHLZiN/NJ9xX7pC66DbtLa1IIiL1IjZeAqrHmtTzgwydj7LHr
         IpSv7p3Sn3y3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Lance Richardson <lance.richardson@broadcom.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 35/61] bnxt_en: Add missing DMA memory barriers
Date:   Tue, 24 Aug 2021 13:00:40 -0400
Message-Id: <20210824170106.710221-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.143-rc1
X-KernelTest-Deadline: 2021-08-26T17:01+00:00
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
index 1b5839ad97b6..e67f07faca78 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1724,6 +1724,10 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	if (!RX_CMP_VALID(rxcmp1, tmp_raw_cons))
 		return -EBUSY;
 
+	/* The valid test of the entry must be done first before
+	 * reading any further.
+	 */
+	dma_rmb();
 	prod = rxr->rx_prod;
 
 	if (cmp_type == CMP_TYPE_RX_L2_TPA_START_CMP) {
@@ -1918,6 +1922,10 @@ static int bnxt_force_rx_discard(struct bnxt *bp,
 	if (!RX_CMP_VALID(rxcmp1, tmp_raw_cons))
 		return -EBUSY;
 
+	/* The valid test of the entry must be done first before
+	 * reading any further.
+	 */
+	dma_rmb();
 	cmp_type = RX_CMP_TYPE(rxcmp);
 	if (cmp_type == CMP_TYPE_RX_L2_CMP) {
 		rxcmp1->rx_cmp_cfa_code_errors_v2 |=
@@ -2314,6 +2322,10 @@ static int bnxt_poll_nitroa0(struct napi_struct *napi, int budget)
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

