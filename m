Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC3120E6BC
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391502AbgF2Vtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:49:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726690AbgF2Sfl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87A7324728;
        Mon, 29 Jun 2020 15:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444047;
        bh=Ht9oBW9+GiV9POucHEmRG02sEXdW3uG9rcfD6XnO24g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWmldLe71n+UNtLg3JKqlUzWhCEM2AyKcDV1V4gaU1BXfXgN75GQ7Ndn1yj/4xfQ3
         gPmfaDqrJvsF2dXQ33m0JCi8bD9RfvY1QUVR93DEgS9K3m21jB+ZRjdfWY/Ctl2mYY
         AR3Lv9kY9TfuEq2dxXa1A7+9LcMkTMy0dzJoQya4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 154/265] net: qed: reset ILT block sizes before recomputing to fix crashes
Date:   Mon, 29 Jun 2020 11:16:27 -0400
Message-Id: <20200629151818.2493727-155-sashal@kernel.org>
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

From: Alexander Lobakin <alobakin@marvell.com>

[ Upstream commit c221dd1831732449f844e03631a34fd21c2b9429 ]

Sizes of all ILT blocks must be reset before ILT recomputing when
disabling clients, or memory allocation may exceed ILT shadow array
and provoke system crashes.

Fixes: 1408cc1fa48c ("qed: Introduce VFs")
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_cxt.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index 1880aa1d3bb59..aeed8939f410a 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -442,6 +442,20 @@ static struct qed_ilt_cli_blk *qed_cxt_set_blk(struct qed_ilt_cli_blk *p_blk)
 	return p_blk;
 }
 
+static void qed_cxt_ilt_blk_reset(struct qed_hwfn *p_hwfn)
+{
+	struct qed_ilt_client_cfg *clients = p_hwfn->p_cxt_mngr->clients;
+	u32 cli_idx, blk_idx;
+
+	for (cli_idx = 0; cli_idx < MAX_ILT_CLIENTS; cli_idx++) {
+		for (blk_idx = 0; blk_idx < ILT_CLI_PF_BLOCKS; blk_idx++)
+			clients[cli_idx].pf_blks[blk_idx].total_size = 0;
+
+		for (blk_idx = 0; blk_idx < ILT_CLI_VF_BLOCKS; blk_idx++)
+			clients[cli_idx].vf_blks[blk_idx].total_size = 0;
+	}
+}
+
 int qed_cxt_cfg_ilt_compute(struct qed_hwfn *p_hwfn, u32 *line_count)
 {
 	struct qed_cxt_mngr *p_mngr = p_hwfn->p_cxt_mngr;
@@ -461,6 +475,11 @@ int qed_cxt_cfg_ilt_compute(struct qed_hwfn *p_hwfn, u32 *line_count)
 
 	p_mngr->pf_start_line = RESC_START(p_hwfn, QED_ILT);
 
+	/* Reset all ILT blocks at the beginning of ILT computing in order
+	 * to prevent memory allocation for irrelevant blocks afterwards.
+	 */
+	qed_cxt_ilt_blk_reset(p_hwfn);
+
 	DP_VERBOSE(p_hwfn, QED_MSG_ILT,
 		   "hwfn [%d] - Set context manager starting line to be 0x%08x\n",
 		   p_hwfn->my_id, p_hwfn->p_cxt_mngr->pf_start_line);
-- 
2.25.1

