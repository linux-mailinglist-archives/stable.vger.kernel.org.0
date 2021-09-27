Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFC9419A77
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236317AbhI0RJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236037AbhI0RIO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:08:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51BF4611C3;
        Mon, 27 Sep 2021 17:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762390;
        bh=S57IW9XmSMDd9bCtpUv5DsztSvjqjiQqbyJLha77QWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vuvbKcfhMY+KiPJuhZHsWs3cBdiFetKWpYh7ppRYadJRZY52ZhlhDWIsqcRvi0TdB
         oZkhsItwfj+lhycj6bRg2zpJRjgb3h7g4p8V7SRoG8zKI6DxkdrfgVDgdEMyMVpEMG
         lZP4UG0cYIFg6dcfoVP2ASdPNQQ1MoZL1UrnaG+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Kalderon <mkalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Shai Malin <smalin@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 31/68] qed: rdma - dont wait for resources under hw error recovery flow
Date:   Mon, 27 Sep 2021 19:02:27 +0200
Message-Id: <20210927170221.050930152@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
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
index 9adbaccd0c5e..934740d60470 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -1307,6 +1307,14 @@ qed_iwarp_wait_cid_map_cleared(struct qed_hwfn *p_hwfn, struct qed_bmap *bmap)
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
index 83817bb50e9f..6e6563b51d68 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
@@ -107,6 +107,14 @@ void qed_roce_stop(struct qed_hwfn *p_hwfn)
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



