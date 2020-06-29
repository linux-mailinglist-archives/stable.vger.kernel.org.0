Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27E220DE8E
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732607AbgF2U0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:26:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732459AbgF2TZZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D303C25316;
        Mon, 29 Jun 2020 15:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445144;
        bh=jYcTHKfl71oRSgVpLIw4fJJ7HkJD9PW7AfDpRhNHGMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OC6D1BpT8GHOSBEPlYKLQNaxhXqJ7LXWA2Spw4+HnOUITMYzFSdMm6mrIoLGu8MrQ
         wAerfY3I5Lb6lskmGdiU8bBi5F/vHJ+sqOi/znbT37g70NZ/vbCJcc8u/ruAoSYJ/q
         nz+ojxCmnID+Lw84ulsDDjXHANCK33dRAf2mugPg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 48/78] net: qed: fix excessive QM ILT lines consumption
Date:   Mon, 29 Jun 2020 11:37:36 -0400
Message-Id: <20200629153806.2494953-49-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
References: <20200629153806.2494953-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.186-rc1
X-KernelTest-Deadline: 2020-07-01T15:38+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@marvell.com>

[ Upstream commit d434d02f7e7c24c721365fd594ed781acb18e0da ]

This is likely a copy'n'paste mistake. The amount of ILT lines to
reserve for a single VF was being multiplied by the total VFs count.
This led to a huge redundancy in reservation and potential lines
drainouts.

Fixes: 1408cc1fa48c ("qed: Introduce VFs")
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_cxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index 27ba476f761d4..4fc3468f6f38b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -396,7 +396,7 @@ static void qed_cxt_qm_iids(struct qed_hwfn *p_hwfn,
 		vf_tids += segs[NUM_TASK_PF_SEGMENTS].count;
 	}
 
-	iids->vf_cids += vf_cids * p_mngr->vf_count;
+	iids->vf_cids = vf_cids;
 	iids->tids += vf_tids * p_mngr->vf_count;
 
 	DP_VERBOSE(p_hwfn, QED_MSG_ILT,
-- 
2.25.1

