Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7099320D978
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733259AbgF2TsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:48:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387779AbgF2Tkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B76EA248BE;
        Mon, 29 Jun 2020 15:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444415;
        bh=54tUvEvcNrm1z+E20e6+d00V4H9quND4CEjlUpsyeVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TowLkxs5ykdcu8gbwr+1cbYDd3xlySnUjhRYZGI3qnCGFpSzM9RAtvQQVjG1hyRPW
         eadHiK9UXd8bjZCbVDx1CN9zXo+KPmF5fzfILQwxvD4CS2nOQVMUyZrmzote4fN4a7
         yQcwlObgMhoozlcXGehT+TDAho6zTesbQ6s4SI7o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/178] net: qed: fix async event callbacks unregistering
Date:   Mon, 29 Jun 2020 11:23:58 -0400
Message-Id: <20200629152523.2494198-94-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@marvell.com>

[ Upstream commit 31333c1a2521ff4b4ceb0c29de492549cd4a8de3 ]

qed_spq_unregister_async_cb() should be called before
qed_rdma_info_free() to avoid crash-spawning uses-after-free.
Instead of calling it from each subsystem exit code, do it in one place
on PF down.

Fixes: 291d57f67d24 ("qed: Fix rdma_info structure allocation")
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c   | 9 +++++++--
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 2 --
 drivers/net/ethernet/qlogic/qed/qed_roce.c  | 1 -
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 0bf91df80d47f..ecd14474a6031 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -1368,6 +1368,8 @@ static void qed_dbg_user_data_free(struct qed_hwfn *p_hwfn)
 
 void qed_resc_free(struct qed_dev *cdev)
 {
+	struct qed_rdma_info *rdma_info;
+	struct qed_hwfn *p_hwfn;
 	int i;
 
 	if (IS_VF(cdev)) {
@@ -1385,7 +1387,8 @@ void qed_resc_free(struct qed_dev *cdev)
 	qed_llh_free(cdev);
 
 	for_each_hwfn(cdev, i) {
-		struct qed_hwfn *p_hwfn = &cdev->hwfns[i];
+		p_hwfn = cdev->hwfns + i;
+		rdma_info = p_hwfn->p_rdma_info;
 
 		qed_cxt_mngr_free(p_hwfn);
 		qed_qm_info_free(p_hwfn);
@@ -1404,8 +1407,10 @@ void qed_resc_free(struct qed_dev *cdev)
 			qed_ooo_free(p_hwfn);
 		}
 
-		if (QED_IS_RDMA_PERSONALITY(p_hwfn))
+		if (QED_IS_RDMA_PERSONALITY(p_hwfn) && rdma_info) {
+			qed_spq_unregister_async_cb(p_hwfn, rdma_info->proto);
 			qed_rdma_info_free(p_hwfn);
+		}
 
 		qed_iov_free(p_hwfn);
 		qed_l2_free(p_hwfn);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index 65ec16a316584..2b3102a2fe5c9 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -2832,8 +2832,6 @@ int qed_iwarp_stop(struct qed_hwfn *p_hwfn)
 	if (rc)
 		return rc;
 
-	qed_spq_unregister_async_cb(p_hwfn, PROTOCOLID_IWARP);
-
 	return qed_iwarp_ll2_stop(p_hwfn);
 }
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c b/drivers/net/ethernet/qlogic/qed/qed_roce.c
index e49fada854108..83817bb50e9fa 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
@@ -113,7 +113,6 @@ void qed_roce_stop(struct qed_hwfn *p_hwfn)
 			break;
 		}
 	}
-	qed_spq_unregister_async_cb(p_hwfn, PROTOCOLID_ROCE);
 }
 
 static void qed_rdma_copy_gids(struct qed_rdma_qp *qp, __le32 *src_gid,
-- 
2.25.1

