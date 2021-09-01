Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6743FDAF0
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343683AbhIAMg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:36:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343897AbhIAMei (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:34:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82DAC61027;
        Wed,  1 Sep 2021 12:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499568;
        bh=1NAE8l39Y1pohaMnXk2jdMQqlPqRWVWj5BfpOvUOJEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZwRTQJUd7Ixu+7X/cbEBakkyBU9m1O7zZgdsYwB6ithwOGkiiD1KY/hFfDKN9kUBQ
         wWqsbJrYFe0JAhkj5hjB6VwKlVCEPjntcdwO1cgCRGUwaPVUmo78HDNgRwGANUgCKK
         p7dPYKdY+RbtMFf+L9bm0WoWncsoHjpZBYMTfg9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Ariel Elior <aelior@marvell.com>,
        Shai Malin <smalin@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 33/48] qed: Fix null-pointer dereference in qed_rdma_create_qp()
Date:   Wed,  1 Sep 2021 14:28:23 +0200
Message-Id: <20210901122254.497028052@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122253.388326997@linuxfoundation.org>
References: <20210901122253.388326997@linuxfoundation.org>
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
index 38b1f402f7ed..b291971bcf92 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -1245,8 +1245,7 @@ qed_rdma_create_qp(void *rdma_cxt,
 
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



