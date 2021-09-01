Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0EA3FDA7A
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244522AbhIAMce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:32:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244903AbhIAMbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:31:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E93D61090;
        Wed,  1 Sep 2021 12:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499446;
        bh=KZj7r2rwRatg88XVRLTbBU6z0+dYmS7JKKEcrlFzO9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GT6eaFxTXo3UXZAYZFTfm19TUVoslg2yI0fwri2FQi89KWcVZQ0y0E5CLfHZsQaMe
         COfYSAdsjN6acZPGrxgYo7SYPvdjC9XvvhpTcfr7EhCbWLRRlY2vnl60uLIcFPZICx
         hsIBP/HYyQT7mqfcCHwfRg98MfXg6hiHyj/xqHV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Ariel Elior <aelior@marvell.com>,
        Shai Malin <smalin@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/33] qed: Fix null-pointer dereference in qed_rdma_create_qp()
Date:   Wed,  1 Sep 2021 14:28:14 +0200
Message-Id: <20210901122251.623743558@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122250.752620302@linuxfoundation.org>
References: <20210901122250.752620302@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shai Malin <smalin@marvell.com>

[ Upstream commit d33d19d313d3466abdf8b0428be7837aff767802 ]

Fix a possible null-pointer dereference in qed_rdma_create_qp().

Changes from V2:
- Revert checkpatch fixes.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 909422d93903..3392982ff374 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -1244,8 +1244,7 @@ qed_rdma_create_qp(void *rdma_cxt,
 
 	if (!rdma_cxt || !in_params || !out_params ||
 	    !p_hwfn->p_rdma_info->active) {
-		DP_ERR(p_hwfn->cdev,
-		       "qed roce create qp failed due to NULL entry (rdma_cxt=%p, in=%p, out=%p, roce_info=?\n",
+		pr_err("qed roce create qp failed due to NULL entry (rdma_cxt=%p, in=%p, out=%p, roce_info=?\n",
 		       rdma_cxt, in_params, out_params);
 		return NULL;
 	}
-- 
2.30.2



