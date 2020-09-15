Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025D526B5A1
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbgIOXsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:48:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727100AbgIOOcn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:32:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0FC423BDB;
        Tue, 15 Sep 2020 14:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179869;
        bh=nLIZ4rz3AzWfJZKEwtQbTIaCjlMrEpz+G7rH4wV9c8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cmo2Ju3qyWsWHHoF1iRm5enSjGGWaO1tKjqO0qhupnkR74DM2bGep5/mFWBBu4Wmp
         dQ15ZqFq+Gc2GOhcuFeDQ9oTw8A76wy7IR8Ryb9FbDhjW7Nzv0W8sfGHY26unj/1X2
         ijCojiBxTKEWgh5HttO4sqUB1PX0r5GEljlqiKls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 018/177] RDMA/bnxt_re: Do not report transparent vlan from QP1
Date:   Tue, 15 Sep 2020 16:11:29 +0200
Message-Id: <20200915140654.518979900@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
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
index 8b6ad5cddfce9..dad38aa06403d 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -3178,6 +3178,19 @@ static void bnxt_re_process_res_rawqp1_wc(struct ib_wc *wc,
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
@@ -3246,9 +3259,11 @@ static void bnxt_re_process_res_shadow_qp_wc(struct bnxt_re_qp *gsi_sqp,
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



