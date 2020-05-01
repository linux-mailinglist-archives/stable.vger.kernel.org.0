Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27EBF1C16E3
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731065AbgEANyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:54:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730693AbgEANfZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:35:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF15E24953;
        Fri,  1 May 2020 13:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340124;
        bh=lVj3HBRVvftPoVTU+f2gffGmhA98BzLYOR+6QXbf+wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2WI7Wg8yLUzOx3KJvRM30yMgWtU6sGoi/rUoKclmi7AttOyMNb0Wwj5WAu0YRZyg9
         VPWHtXkIox0l8G1OIqJnlofzEFYCPMPNDUH49Eo5fMdbtOZghfQnKgwWGuYX44XHuS
         DqQFcwugOm0LQ5l3ArQ6IURfM3o3EUsEhVZILAeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Kalderon <mkalderon@marvell.com>,
        Yuval Bason <ybason@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 116/117] qed: Fix use after free in qed_chain_free
Date:   Fri,  1 May 2020 15:22:32 +0200
Message-Id: <20200501131558.652223176@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuval Basson <ybason@marvell.com>

commit 8063f761cd7c17fc1d0018728936e0c33a25388a upstream.

The qed_chain data structure was modified in
commit 1a4a69751f4d ("qed: Chain support for external PBL") to support
receiving an external pbl (due to iWARP FW requirements).
The pages pointed to by the pbl are allocated in qed_chain_alloc
and their virtual address are stored in an virtual addresses array to
enable accessing and freeing the data. The physical addresses however
weren't stored and were accessed directly from the external-pbl
during free.

Destroy-qp flow, leads to freeing the external pbl before the chain is
freed, when the chain is freed it tries accessing the already freed
external pbl, leading to a use-after-free. Therefore we need to store
the physical addresses in additional to the virtual addresses in a
new data structure.

Fixes: 1a4a69751f4d ("qed: Chain support for external PBL")
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Yuval Bason <ybason@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/qlogic/qed/qed_dev.c |   38 ++++++++++++------------------
 include/linux/qed/qed_chain.h             |   24 +++++++++++-------
 2 files changed, 31 insertions(+), 31 deletions(-)

--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -3151,26 +3151,20 @@ static void qed_chain_free_single(struct
 
 static void qed_chain_free_pbl(struct qed_dev *cdev, struct qed_chain *p_chain)
 {
-	void **pp_virt_addr_tbl = p_chain->pbl.pp_virt_addr_tbl;
+	struct addr_tbl_entry *pp_addr_tbl = p_chain->pbl.pp_addr_tbl;
 	u32 page_cnt = p_chain->page_cnt, i, pbl_size;
-	u8 *p_pbl_virt = p_chain->pbl_sp.p_virt_table;
 
-	if (!pp_virt_addr_tbl)
+	if (!pp_addr_tbl)
 		return;
 
-	if (!p_pbl_virt)
-		goto out;
-
 	for (i = 0; i < page_cnt; i++) {
-		if (!pp_virt_addr_tbl[i])
+		if (!pp_addr_tbl[i].virt_addr || !pp_addr_tbl[i].dma_map)
 			break;
 
 		dma_free_coherent(&cdev->pdev->dev,
 				  QED_CHAIN_PAGE_SIZE,
-				  pp_virt_addr_tbl[i],
-				  *(dma_addr_t *)p_pbl_virt);
-
-		p_pbl_virt += QED_CHAIN_PBL_ENTRY_SIZE;
+				  pp_addr_tbl[i].virt_addr,
+				  pp_addr_tbl[i].dma_map);
 	}
 
 	pbl_size = page_cnt * QED_CHAIN_PBL_ENTRY_SIZE;
@@ -3180,9 +3174,9 @@ static void qed_chain_free_pbl(struct qe
 				  pbl_size,
 				  p_chain->pbl_sp.p_virt_table,
 				  p_chain->pbl_sp.p_phys_table);
-out:
-	vfree(p_chain->pbl.pp_virt_addr_tbl);
-	p_chain->pbl.pp_virt_addr_tbl = NULL;
+
+	vfree(p_chain->pbl.pp_addr_tbl);
+	p_chain->pbl.pp_addr_tbl = NULL;
 }
 
 void qed_chain_free(struct qed_dev *cdev, struct qed_chain *p_chain)
@@ -3283,19 +3277,19 @@ qed_chain_alloc_pbl(struct qed_dev *cdev
 {
 	u32 page_cnt = p_chain->page_cnt, size, i;
 	dma_addr_t p_phys = 0, p_pbl_phys = 0;
-	void **pp_virt_addr_tbl = NULL;
+	struct addr_tbl_entry *pp_addr_tbl;
 	u8 *p_pbl_virt = NULL;
 	void *p_virt = NULL;
 
-	size = page_cnt * sizeof(*pp_virt_addr_tbl);
-	pp_virt_addr_tbl = vzalloc(size);
-	if (!pp_virt_addr_tbl)
+	size = page_cnt * sizeof(*pp_addr_tbl);
+	pp_addr_tbl =  vzalloc(size);
+	if (!pp_addr_tbl)
 		return -ENOMEM;
 
 	/* The allocation of the PBL table is done with its full size, since it
 	 * is expected to be successive.
 	 * qed_chain_init_pbl_mem() is called even in a case of an allocation
-	 * failure, since pp_virt_addr_tbl was previously allocated, and it
+	 * failure, since tbl was previously allocated, and it
 	 * should be saved to allow its freeing during the error flow.
 	 */
 	size = page_cnt * QED_CHAIN_PBL_ENTRY_SIZE;
@@ -3309,8 +3303,7 @@ qed_chain_alloc_pbl(struct qed_dev *cdev
 		p_chain->b_external_pbl = true;
 	}
 
-	qed_chain_init_pbl_mem(p_chain, p_pbl_virt, p_pbl_phys,
-			       pp_virt_addr_tbl);
+	qed_chain_init_pbl_mem(p_chain, p_pbl_virt, p_pbl_phys, pp_addr_tbl);
 	if (!p_pbl_virt)
 		return -ENOMEM;
 
@@ -3329,7 +3322,8 @@ qed_chain_alloc_pbl(struct qed_dev *cdev
 		/* Fill the PBL table with the physical address of the page */
 		*(dma_addr_t *)p_pbl_virt = p_phys;
 		/* Keep the virtual address of the page */
-		p_chain->pbl.pp_virt_addr_tbl[i] = p_virt;
+		p_chain->pbl.pp_addr_tbl[i].virt_addr = p_virt;
+		p_chain->pbl.pp_addr_tbl[i].dma_map = p_phys;
 
 		p_pbl_virt += QED_CHAIN_PBL_ENTRY_SIZE;
 	}
--- a/include/linux/qed/qed_chain.h
+++ b/include/linux/qed/qed_chain.h
@@ -97,6 +97,11 @@ struct qed_chain_u32 {
 	u32 cons_idx;
 };
 
+struct addr_tbl_entry {
+	void *virt_addr;
+	dma_addr_t dma_map;
+};
+
 struct qed_chain {
 	/* fastpath portion of the chain - required for commands such
 	 * as produce / consume.
@@ -107,10 +112,11 @@ struct qed_chain {
 
 	/* Fastpath portions of the PBL [if exists] */
 	struct {
-		/* Table for keeping the virtual addresses of the chain pages,
-		 * respectively to the physical addresses in the pbl table.
+		/* Table for keeping the virtual and physical addresses of the
+		 * chain pages, respectively to the physical addresses
+		 * in the pbl table.
 		 */
-		void **pp_virt_addr_tbl;
+		struct addr_tbl_entry *pp_addr_tbl;
 
 		union {
 			struct qed_chain_pbl_u16 u16;
@@ -287,7 +293,7 @@ qed_chain_advance_page(struct qed_chain
 				*(u32 *)page_to_inc = 0;
 			page_index = *(u32 *)page_to_inc;
 		}
-		*p_next_elem = p_chain->pbl.pp_virt_addr_tbl[page_index];
+		*p_next_elem = p_chain->pbl.pp_addr_tbl[page_index].virt_addr;
 	}
 }
 
@@ -537,7 +543,7 @@ static inline void qed_chain_init_params
 
 	p_chain->pbl_sp.p_phys_table = 0;
 	p_chain->pbl_sp.p_virt_table = NULL;
-	p_chain->pbl.pp_virt_addr_tbl = NULL;
+	p_chain->pbl.pp_addr_tbl = NULL;
 }
 
 /**
@@ -575,11 +581,11 @@ static inline void qed_chain_init_mem(st
 static inline void qed_chain_init_pbl_mem(struct qed_chain *p_chain,
 					  void *p_virt_pbl,
 					  dma_addr_t p_phys_pbl,
-					  void **pp_virt_addr_tbl)
+					  struct addr_tbl_entry *pp_addr_tbl)
 {
 	p_chain->pbl_sp.p_phys_table = p_phys_pbl;
 	p_chain->pbl_sp.p_virt_table = p_virt_pbl;
-	p_chain->pbl.pp_virt_addr_tbl = pp_virt_addr_tbl;
+	p_chain->pbl.pp_addr_tbl = pp_addr_tbl;
 }
 
 /**
@@ -644,7 +650,7 @@ static inline void *qed_chain_get_last_e
 		break;
 	case QED_CHAIN_MODE_PBL:
 		last_page_idx = p_chain->page_cnt - 1;
-		p_virt_addr = p_chain->pbl.pp_virt_addr_tbl[last_page_idx];
+		p_virt_addr = p_chain->pbl.pp_addr_tbl[last_page_idx].virt_addr;
 		break;
 	}
 	/* p_virt_addr points at this stage to the last page of the chain */
@@ -716,7 +722,7 @@ static inline void qed_chain_pbl_zero_me
 	page_cnt = qed_chain_get_page_cnt(p_chain);
 
 	for (i = 0; i < page_cnt; i++)
-		memset(p_chain->pbl.pp_virt_addr_tbl[i], 0,
+		memset(p_chain->pbl.pp_addr_tbl[i].virt_addr, 0,
 		       QED_CHAIN_PAGE_SIZE);
 }
 


