Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D381820DBEF
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgF2UK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:10:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732893AbgF2TaV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71B2225267;
        Mon, 29 Jun 2020 15:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444977;
        bh=fTQpfNLKO9oapLMx2ZgGjNS9yY6qb3mJpu3D8PVWy1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xS75MhZ3LZ1923eDY3PT0mamhkVmFLGkiq5pAXRVEfluTCcvc3dX7cLpRFFGj2Dhs
         pnkFF3epiZWcI5pWgI9v3BCbzwZBKtt+e6MdktfleGIOAW851Zrv3QAJJfZ6dGp9RL
         XE/XoNK4owYmNVKI2tGxFz0YGOgBX7gjBzlLGOVc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 076/131] net: qed: fix NVMe login fails over VFs
Date:   Mon, 29 Jun 2020 11:34:07 -0400
Message-Id: <20200629153502.2494656-77-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@marvell.com>

[ Upstream commit ccd7c7ce167a21dbf2b698ffcf00f11d96d44f9b ]

25ms sleep cycles in waiting for PF response are excessive and may lead
to different timeout failures.

Start to wait with short udelays, and in most cases polling will end
here. If the time was not sufficient, switch to msleeps.
usleep_range() may go far beyond 100us depending on platform and tick
configuration, hence atomic udelays for consistency.

Also add explicit DMA barriers since 'done' always comes from a shared
request-response DMA pool, and note that in the comment nearby.

Fixes: 1408cc1fa48c ("qed: Introduce VFs")
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_vf.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_vf.c b/drivers/net/ethernet/qlogic/qed/qed_vf.c
index 5dda547772c13..93a0fbf6a132b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_vf.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_vf.c
@@ -81,12 +81,17 @@ static void qed_vf_pf_req_end(struct qed_hwfn *p_hwfn, int req_status)
 	mutex_unlock(&(p_hwfn->vf_iov_info->mutex));
 }
 
+#define QED_VF_CHANNEL_USLEEP_ITERATIONS	90
+#define QED_VF_CHANNEL_USLEEP_DELAY		100
+#define QED_VF_CHANNEL_MSLEEP_ITERATIONS	10
+#define QED_VF_CHANNEL_MSLEEP_DELAY		25
+
 static int qed_send_msg2pf(struct qed_hwfn *p_hwfn, u8 *done, u32 resp_size)
 {
 	union vfpf_tlvs *p_req = p_hwfn->vf_iov_info->vf2pf_request;
 	struct ustorm_trigger_vf_zone trigger;
 	struct ustorm_vf_zone *zone_data;
-	int rc = 0, time = 100;
+	int iter, rc = 0;
 
 	zone_data = (struct ustorm_vf_zone *)PXP_VF_BAR0_START_USDM_ZONE_B;
 
@@ -126,11 +131,19 @@ static int qed_send_msg2pf(struct qed_hwfn *p_hwfn, u8 *done, u32 resp_size)
 	REG_WR(p_hwfn, (uintptr_t)&zone_data->trigger, *((u32 *)&trigger));
 
 	/* When PF would be done with the response, it would write back to the
-	 * `done' address. Poll until then.
+	 * `done' address from a coherent DMA zone. Poll until then.
 	 */
-	while ((!*done) && time) {
-		msleep(25);
-		time--;
+
+	iter = QED_VF_CHANNEL_USLEEP_ITERATIONS;
+	while (!*done && iter--) {
+		udelay(QED_VF_CHANNEL_USLEEP_DELAY);
+		dma_rmb();
+	}
+
+	iter = QED_VF_CHANNEL_MSLEEP_ITERATIONS;
+	while (!*done && iter--) {
+		msleep(QED_VF_CHANNEL_MSLEEP_DELAY);
+		dma_rmb();
 	}
 
 	if (!*done) {
-- 
2.25.1

