Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E418201467
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392643AbgFSQJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:09:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391058AbgFSPGy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:06:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AE3B21835;
        Fri, 19 Jun 2020 15:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579213;
        bh=vRp6B92yGsvVsoLIK4jYcAB3SaiF9BPcAde1IxtLjbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VApTaeyPhCxpdDxVFy+u3LHgljx+7zH5wynE6t5uBwVcYvo/uSMTlZrAfCxiQmaBz
         nNfUhLnzjRKoAlRDsC9tKwM1wXlrtejDhsgqwjtIz63Rok6iHvPZqQcSv0rME/Qvlh
         4hw72bRjD/AXFs3yi6CeS+RsEeemuScqjQAWhRZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Surabhi Boob <surabhi.boob@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 050/261] ice: Fix for memory leaks and modify ICE_FREE_CQ_BUFS
Date:   Fri, 19 Jun 2020 16:31:01 +0200
Message-Id: <20200619141652.329063051@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Surabhi Boob <surabhi.boob@intel.com>

[ Upstream commit 68d270783742783f96e89ef92ac24ab3c7fb1d31 ]

Handle memory leaks during control queue initialization and
buffer allocation failures. The macro ICE_FREE_CQ_BUFS is modified to
re-use for this fix.

Signed-off-by: Surabhi Boob <surabhi.boob@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_controlq.c | 49 +++++++++++--------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c b/drivers/net/ethernet/intel/ice/ice_controlq.c
index c68709c7ef81..2e9c97bad3c3 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.c
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
@@ -199,7 +199,9 @@ unwind_alloc_rq_bufs:
 		cq->rq.r.rq_bi[i].pa = 0;
 		cq->rq.r.rq_bi[i].size = 0;
 	}
+	cq->rq.r.rq_bi = NULL;
 	devm_kfree(ice_hw_to_dev(hw), cq->rq.dma_head);
+	cq->rq.dma_head = NULL;
 
 	return ICE_ERR_NO_MEMORY;
 }
@@ -245,7 +247,9 @@ unwind_alloc_sq_bufs:
 		cq->sq.r.sq_bi[i].pa = 0;
 		cq->sq.r.sq_bi[i].size = 0;
 	}
+	cq->sq.r.sq_bi = NULL;
 	devm_kfree(ice_hw_to_dev(hw), cq->sq.dma_head);
+	cq->sq.dma_head = NULL;
 
 	return ICE_ERR_NO_MEMORY;
 }
@@ -304,6 +308,28 @@ ice_cfg_rq_regs(struct ice_hw *hw, struct ice_ctl_q_info *cq)
 	return 0;
 }
 
+#define ICE_FREE_CQ_BUFS(hw, qi, ring)					\
+do {									\
+	int i;								\
+	/* free descriptors */						\
+	if ((qi)->ring.r.ring##_bi)					\
+		for (i = 0; i < (qi)->num_##ring##_entries; i++)	\
+			if ((qi)->ring.r.ring##_bi[i].pa) {		\
+				dmam_free_coherent(ice_hw_to_dev(hw),	\
+					(qi)->ring.r.ring##_bi[i].size,	\
+					(qi)->ring.r.ring##_bi[i].va,	\
+					(qi)->ring.r.ring##_bi[i].pa);	\
+					(qi)->ring.r.ring##_bi[i].va = NULL;\
+					(qi)->ring.r.ring##_bi[i].pa = 0;\
+					(qi)->ring.r.ring##_bi[i].size = 0;\
+		}							\
+	/* free the buffer info list */					\
+	if ((qi)->ring.cmd_buf)						\
+		devm_kfree(ice_hw_to_dev(hw), (qi)->ring.cmd_buf);	\
+	/* free DMA head */						\
+	devm_kfree(ice_hw_to_dev(hw), (qi)->ring.dma_head);		\
+} while (0)
+
 /**
  * ice_init_sq - main initialization routine for Control ATQ
  * @hw: pointer to the hardware structure
@@ -357,6 +383,7 @@ static enum ice_status ice_init_sq(struct ice_hw *hw, struct ice_ctl_q_info *cq)
 	goto init_ctrlq_exit;
 
 init_ctrlq_free_rings:
+	ICE_FREE_CQ_BUFS(hw, cq, sq);
 	ice_free_cq_ring(hw, &cq->sq);
 
 init_ctrlq_exit:
@@ -416,33 +443,13 @@ static enum ice_status ice_init_rq(struct ice_hw *hw, struct ice_ctl_q_info *cq)
 	goto init_ctrlq_exit;
 
 init_ctrlq_free_rings:
+	ICE_FREE_CQ_BUFS(hw, cq, rq);
 	ice_free_cq_ring(hw, &cq->rq);
 
 init_ctrlq_exit:
 	return ret_code;
 }
 
-#define ICE_FREE_CQ_BUFS(hw, qi, ring)					\
-do {									\
-	int i;								\
-	/* free descriptors */						\
-	for (i = 0; i < (qi)->num_##ring##_entries; i++)		\
-		if ((qi)->ring.r.ring##_bi[i].pa) {			\
-			dmam_free_coherent(ice_hw_to_dev(hw),		\
-					   (qi)->ring.r.ring##_bi[i].size,\
-					   (qi)->ring.r.ring##_bi[i].va,\
-					   (qi)->ring.r.ring##_bi[i].pa);\
-			(qi)->ring.r.ring##_bi[i].va = NULL;		\
-			(qi)->ring.r.ring##_bi[i].pa = 0;		\
-			(qi)->ring.r.ring##_bi[i].size = 0;		\
-		}							\
-	/* free the buffer info list */					\
-	if ((qi)->ring.cmd_buf)						\
-		devm_kfree(ice_hw_to_dev(hw), (qi)->ring.cmd_buf);	\
-	/* free DMA head */						\
-	devm_kfree(ice_hw_to_dev(hw), (qi)->ring.dma_head);		\
-} while (0)
-
 /**
  * ice_shutdown_sq - shutdown the Control ATQ
  * @hw: pointer to the hardware structure
-- 
2.25.1



