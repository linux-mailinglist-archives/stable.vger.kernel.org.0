Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E59419AE7
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235767AbhI0ROh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:14:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236364AbhI0RME (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:12:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C793161264;
        Mon, 27 Sep 2021 17:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762512;
        bh=RSZkiJ2yqzaRdXX9rL57ZA7zNS/yRoj+t1rLaJ5pFUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S75hrmmoYl1I9DVH1h5fbt/mxFRvsSAtvRRbqfEbQi4z8+WO1CTMm01WG8Y0aqqVn
         p48a25rSaVS0haV+lhaHnDTkINITv5x3olrw77OLpyRf/THZ3h9htp8eK5ixWzyQ/G
         QxrskE0C6CGEa5CWQa94f/DRdcAgLhp7IANge4fs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Kalderon <mkalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Shai Malin <smalin@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/103] qed: rdma - dont wait for resources under hw error recovery flow
Date:   Mon, 27 Sep 2021 19:02:22 +0200
Message-Id: <20210927170227.485895652@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shai Malin <smalin@marvell.com>

[ Upstream commit 1ea7812326004afd2803cc968a4776ae5120a597 ]

If the HW device is during recovery, the HW resources will never return,
hence we shouldn't wait for the CID (HW context ID) bitmaps to clear.
This fix speeds up the error recovery flow.

Fixes: 64515dc899df ("qed: Add infrastructure for error detection and recovery")
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 8 ++++++++
 drivers/net/ethernet/qlogic/qed/qed_roce.c  | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index a99861124630..68fbe536a1f3 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -1297,6 +1297,14 @@ qed_iwarp_wait_cid_map_cleared(struct qed_hwfn *p_hwfn, struct qed_bmap *bmap)
 	prev_weight = weight;
 
 	while (weight) {
+		/* If the HW device is during recovery, all resources are
+		 * immediately reset without receiving a per-cid indication
+		 * from HW. In this case we don't expect the cid_map to be
+		 * cleared.
+		 */
+		if (p_hwfn->cdev->recov_in_prog)
+			return 0;
+
 		msleep(QED_IWARP_MAX_CID_CLEAN_TIME);
 
 		weight = bitmap_weight(bmap->bitmap, bmap->max_count);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c b/drivers/net/ethernet/qlogic/qed/qed_roce.c
index f16a157bb95a..cf5baa5e59bc 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
@@ -77,6 +77,14 @@ void qed_roce_stop(struct qed_hwfn *p_hwfn)
 	 * Beyond the added delay we clear the bitmap anyway.
 	 */
 	while (bitmap_weight(rcid_map->bitmap, rcid_map->max_count)) {
+		/* If the HW device is during recovery, all resources are
+		 * immediately reset without receiving a per-cid indication
+		 * from HW. In this case we don't expect the cid bitmap to be
+		 * cleared.
+		 */
+		if (p_hwfn->cdev->recov_in_prog)
+			return;
+
 		msleep(100);
 		if (wait_count++ > 20) {
 			DP_NOTICE(p_hwfn, "cid bitmap wait timed out\n");
-- 
2.33.0



