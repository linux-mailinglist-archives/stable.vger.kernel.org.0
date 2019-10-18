Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F729DD4B8
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403834AbfJRW0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:26:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727730AbfJRWEN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F339520679;
        Fri, 18 Oct 2019 22:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436251;
        bh=Kb8JQLQR3nCqBAecn6Mu9+UCIoHVl9rSUVXcizj1rvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XlZsqaL6fnBab9PoDa7VdwDDgI5tehxEiVPOrUEQNgGKyfBU3aoRELtQdGUHKOBvs
         jFiBUeEFGxMFEbusEFIX6JjD7zxIHxWScShyR168a06vocYP65R8hYXsnGIySD0/tc
         /Aa9gFKoS4Foy/S3ASKGrgN2HMvGlcyhNLiZ61Rk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Nicolas Waisman <nico@semmle.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 35/89] RDMA/cxgb4: Do not dma memory off of the stack
Date:   Fri, 18 Oct 2019 18:02:30 -0400
Message-Id: <20191018220324.8165-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

[ Upstream commit 3840c5b78803b2b6cc1ff820100a74a092c40cbb ]

Nicolas pointed out that the cxgb4 driver is doing dma off of the stack,
which is generally considered a very bad thing.  On some architectures it
could be a security problem, but odds are none of them actually run this
driver, so it's just a "normal" bug.

Resolve this by allocating the memory for a message off of the heap
instead of the stack.  kmalloc() always will give us a proper memory
location that DMA will work correctly from.

Link: https://lore.kernel.org/r/20191001165611.GA3542072@kroah.com
Reported-by: Nicolas Waisman <nico@semmle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Tested-by: Potnuri Bharat Teja <bharat@chelsio.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/mem.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index aa772ee0706f9..35c284af574da 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -275,13 +275,17 @@ static int write_tpt_entry(struct c4iw_rdev *rdev, u32 reset_tpt_entry,
 			   struct sk_buff *skb, struct c4iw_wr_wait *wr_waitp)
 {
 	int err;
-	struct fw_ri_tpte tpt;
+	struct fw_ri_tpte *tpt;
 	u32 stag_idx;
 	static atomic_t key;
 
 	if (c4iw_fatal_error(rdev))
 		return -EIO;
 
+	tpt = kmalloc(sizeof(*tpt), GFP_KERNEL);
+	if (!tpt)
+		return -ENOMEM;
+
 	stag_state = stag_state > 0;
 	stag_idx = (*stag) >> 8;
 
@@ -291,6 +295,7 @@ static int write_tpt_entry(struct c4iw_rdev *rdev, u32 reset_tpt_entry,
 			mutex_lock(&rdev->stats.lock);
 			rdev->stats.stag.fail++;
 			mutex_unlock(&rdev->stats.lock);
+			kfree(tpt);
 			return -ENOMEM;
 		}
 		mutex_lock(&rdev->stats.lock);
@@ -305,28 +310,28 @@ static int write_tpt_entry(struct c4iw_rdev *rdev, u32 reset_tpt_entry,
 
 	/* write TPT entry */
 	if (reset_tpt_entry)
-		memset(&tpt, 0, sizeof(tpt));
+		memset(tpt, 0, sizeof(*tpt));
 	else {
-		tpt.valid_to_pdid = cpu_to_be32(FW_RI_TPTE_VALID_F |
+		tpt->valid_to_pdid = cpu_to_be32(FW_RI_TPTE_VALID_F |
 			FW_RI_TPTE_STAGKEY_V((*stag & FW_RI_TPTE_STAGKEY_M)) |
 			FW_RI_TPTE_STAGSTATE_V(stag_state) |
 			FW_RI_TPTE_STAGTYPE_V(type) | FW_RI_TPTE_PDID_V(pdid));
-		tpt.locread_to_qpid = cpu_to_be32(FW_RI_TPTE_PERM_V(perm) |
+		tpt->locread_to_qpid = cpu_to_be32(FW_RI_TPTE_PERM_V(perm) |
 			(bind_enabled ? FW_RI_TPTE_MWBINDEN_F : 0) |
 			FW_RI_TPTE_ADDRTYPE_V((zbva ? FW_RI_ZERO_BASED_TO :
 						      FW_RI_VA_BASED_TO))|
 			FW_RI_TPTE_PS_V(page_size));
-		tpt.nosnoop_pbladdr = !pbl_size ? 0 : cpu_to_be32(
+		tpt->nosnoop_pbladdr = !pbl_size ? 0 : cpu_to_be32(
 			FW_RI_TPTE_PBLADDR_V(PBL_OFF(rdev, pbl_addr)>>3));
-		tpt.len_lo = cpu_to_be32((u32)(len & 0xffffffffUL));
-		tpt.va_hi = cpu_to_be32((u32)(to >> 32));
-		tpt.va_lo_fbo = cpu_to_be32((u32)(to & 0xffffffffUL));
-		tpt.dca_mwbcnt_pstag = cpu_to_be32(0);
-		tpt.len_hi = cpu_to_be32((u32)(len >> 32));
+		tpt->len_lo = cpu_to_be32((u32)(len & 0xffffffffUL));
+		tpt->va_hi = cpu_to_be32((u32)(to >> 32));
+		tpt->va_lo_fbo = cpu_to_be32((u32)(to & 0xffffffffUL));
+		tpt->dca_mwbcnt_pstag = cpu_to_be32(0);
+		tpt->len_hi = cpu_to_be32((u32)(len >> 32));
 	}
 	err = write_adapter_mem(rdev, stag_idx +
 				(rdev->lldi.vr->stag.start >> 5),
-				sizeof(tpt), &tpt, skb, wr_waitp);
+				sizeof(*tpt), tpt, skb, wr_waitp);
 
 	if (reset_tpt_entry) {
 		c4iw_put_resource(&rdev->resource.tpt_table, stag_idx);
@@ -334,6 +339,7 @@ static int write_tpt_entry(struct c4iw_rdev *rdev, u32 reset_tpt_entry,
 		rdev->stats.stag.cur -= 32;
 		mutex_unlock(&rdev->stats.lock);
 	}
+	kfree(tpt);
 	return err;
 }
 
-- 
2.20.1

