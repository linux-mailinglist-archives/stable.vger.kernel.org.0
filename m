Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52AC8247613
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390732AbgHQTc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:32:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730279AbgHQPbV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:31:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EDE323F27;
        Mon, 17 Aug 2020 15:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678280;
        bh=cMWAhRBaEveQmsRcNSuNfgdblNS22Db2KlEA8uckwjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHRzx3XqAYZ3xZfaVhGtw6kt6ObSE6I/EmUkfFaH82ckTr8VKU8P337xHIrZCAolF
         oJfQz/g6G2mueFzjxpNxQYazKYSYxNcCOl+GUhhXc5PrhCANXRF+S1U78M/gxjux3q
         E4yo3tcphvT7QJLG3Yyd8FWBOGtPRNZPc0h0ru4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Kalderon <mkalderon@marvell.com>,
        Yuval Basson <ybason@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 279/464] qed: Fix ILT and XRCD bitmap memory leaks
Date:   Mon, 17 Aug 2020 17:13:52 +0200
Message-Id: <20200817143847.123172922@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuval Basson <ybason@marvell.com>

[ Upstream commit d4eae993fc45398526aed683e225d6fa713f8ddf ]

- Free ILT lines used for XRC-SRQ's contexts.
- Free XRCD bitmap

Fixes: b8204ad878ce7 ("qed: changes to ILT to support XRC")
Fixes: 7bfb399eca460 ("qed: Add XRC to RoCE")
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Yuval Basson <ybason@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_cxt.c  | 5 +++++
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index d13ec88313c38..eb70fdddddbfe 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -2355,6 +2355,11 @@ qed_cxt_free_ilt_range(struct qed_hwfn *p_hwfn,
 		elem_size = SRQ_CXT_SIZE;
 		p_blk = &p_cli->pf_blks[SRQ_BLK];
 		break;
+	case QED_ELEM_XRC_SRQ:
+		p_cli = &p_hwfn->p_cxt_mngr->clients[ILT_CLI_TSDM];
+		elem_size = XRC_SRQ_CXT_SIZE;
+		p_blk = &p_cli->pf_blks[SRQ_BLK];
+		break;
 	case QED_ELEM_TASK:
 		p_cli = &p_hwfn->p_cxt_mngr->clients[ILT_CLI_CDUT];
 		elem_size = TYPE1_TASK_CXT_SIZE(p_hwfn);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 19c0c8864da13..4ad5f21de79ea 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -404,6 +404,7 @@ static void qed_rdma_resc_free(struct qed_hwfn *p_hwfn)
 	qed_rdma_bmap_free(p_hwfn, &p_hwfn->p_rdma_info->srq_map, 1);
 	qed_rdma_bmap_free(p_hwfn, &p_hwfn->p_rdma_info->real_cid_map, 1);
 	qed_rdma_bmap_free(p_hwfn, &p_hwfn->p_rdma_info->xrc_srq_map, 1);
+	qed_rdma_bmap_free(p_hwfn, &p_hwfn->p_rdma_info->xrcd_map, 1);
 
 	kfree(p_rdma_info->port);
 	kfree(p_rdma_info->dev);
-- 
2.25.1



