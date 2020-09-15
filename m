Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9780A26B6F1
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgIPAOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:14:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726916AbgIOOYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:24:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 825CE223C7;
        Tue, 15 Sep 2020 14:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179519;
        bh=EoV+2gvWeE0722imjDRmPdsajLeZiY1Y17/YqjxpJsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b+nR2AxN8Hbm0VN7cp+To2/bEmtOcsbywhGyM8FT/I0f5DcWy9TUn1CaNb3X/5IQq
         1Wstihae1LTx/AchZQ+TVRzCuJtepHk5JzjrBJcY6c0xi3k6rCfak6PmomqfRb0Ioa
         WYdt32dXF4DQYkt38qta4vRuW0HpziqL32h4CudQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 013/132] RDMA/bnxt_re: Do not report transparent vlan from QP1
Date:   Tue, 15 Sep 2020 16:11:55 +0200
Message-Id: <20200915140644.730166596@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 2d0e60ee322d512fa6bc62d23a6760b39a380847 ]

QP1 Rx CQE reports transparent VLAN ID in the completion and this is used
while reporting the completion for received MAD packet. Check if the vlan
id is configured before reporting it in the work completion.

Fixes: 84511455ac5b ("RDMA/bnxt_re: report vlan_id and sl in qp1 recv completion")
Link: https://lore.kernel.org/r/1598292876-26529-3-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index ebc3e3d4a6e2a..3b05c0640338f 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2973,6 +2973,19 @@ static void bnxt_re_process_res_rawqp1_wc(struct ib_wc *wc,
 	wc->wc_flags |= IB_WC_GRH;
 }
 
+static bool bnxt_re_check_if_vlan_valid(struct bnxt_re_dev *rdev,
+					u16 vlan_id)
+{
+	/*
+	 * Check if the vlan is configured in the host.  If not configured, it
+	 * can be a transparent VLAN. So dont report the vlan id.
+	 */
+	if (!__vlan_find_dev_deep_rcu(rdev->netdev,
+				      htons(ETH_P_8021Q), vlan_id))
+		return false;
+	return true;
+}
+
 static bool bnxt_re_is_vlan_pkt(struct bnxt_qplib_cqe *orig_cqe,
 				u16 *vid, u8 *sl)
 {
@@ -3041,9 +3054,11 @@ static void bnxt_re_process_res_shadow_qp_wc(struct bnxt_re_qp *qp,
 	wc->src_qp = orig_cqe->src_qp;
 	memcpy(wc->smac, orig_cqe->smac, ETH_ALEN);
 	if (bnxt_re_is_vlan_pkt(orig_cqe, &vlan_id, &sl)) {
-		wc->vlan_id = vlan_id;
-		wc->sl = sl;
-		wc->wc_flags |= IB_WC_WITH_VLAN;
+		if (bnxt_re_check_if_vlan_valid(rdev, vlan_id)) {
+			wc->vlan_id = vlan_id;
+			wc->sl = sl;
+			wc->wc_flags |= IB_WC_WITH_VLAN;
+		}
 	}
 	wc->port_num = 1;
 	wc->vendor_err = orig_cqe->status;
-- 
2.25.1



