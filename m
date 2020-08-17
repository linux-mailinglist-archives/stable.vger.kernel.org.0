Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED7A247641
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732147AbgHQTfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:35:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730056AbgHQP3S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:29:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3402923BCA;
        Mon, 17 Aug 2020 15:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678156;
        bh=Iroj//ok0sYdykOMbb8YRqc18apoV8M5/XXPiKlsvpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nPyWv+yormBQhO2bi8RR7FIoiqWjwJcIZ8bluV4BTSWcJLEKNkLS5Kb9x3wdyxOUJ
         XtwFsY+bSydLNPvC+k9DoxHl/dfgaIEFCGLaBRUIOKlnWxQl5jjep9QrYp9r9AMfVx
         m/hOJLJe8EQYk6b3y6A8jisewEJUmRRampmWKOIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ariel Elior <ariel.elior@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 237/464] RDMA/qedr: Add EDPM max size to alloc ucontext response
Date:   Mon, 17 Aug 2020 17:13:10 +0200
Message-Id: <20200817143845.151375509@linuxfoundation.org>
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

From: Michal Kalderon <michal.kalderon@marvell.com>

[ Upstream commit eb7f84e379daad69b4c92538baeaf93bbf493c14 ]

User space should receive the maximum edpm size from kernel driver,
similar to other edpm/ldpm related limits.  Add an additional parameter to
the alloc_ucontext_resp structure for the edpm maximum size.

In addition, pass an indication from user-space to kernel
(and not just kernel to user) that the DPM sizes are supported.

This is for supporting backward-forward compatibility between driver and
lib for everything related to DPM transaction and limit sizes.

This should have been part of commit mentioned in Fixes tag.

Link: https://lore.kernel.org/r/20200707063100.3811-3-michal.kalderon@marvell.com
Fixes: 93a3d05f9d68 ("RDMA/qedr: Add kernel capability flags for dpm enabled mode")
Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 9 ++++++---
 include/uapi/rdma/qedr-abi.h       | 6 +++++-
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index bddd85e1c8c77..1a7f1f805be3e 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -320,9 +320,12 @@ int qedr_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata *udata)
 				  QEDR_DPM_TYPE_ROCE_LEGACY |
 				  QEDR_DPM_TYPE_ROCE_EDPM_MODE;
 
-	uresp.dpm_flags |= QEDR_DPM_SIZES_SET;
-	uresp.ldpm_limit_size = QEDR_LDPM_MAX_SIZE;
-	uresp.edpm_trans_size = QEDR_EDPM_TRANS_SIZE;
+	if (ureq.context_flags & QEDR_SUPPORT_DPM_SIZES) {
+		uresp.dpm_flags |= QEDR_DPM_SIZES_SET;
+		uresp.ldpm_limit_size = QEDR_LDPM_MAX_SIZE;
+		uresp.edpm_trans_size = QEDR_EDPM_TRANS_SIZE;
+		uresp.edpm_limit_size = QEDR_EDPM_MAX_SIZE;
+	}
 
 	uresp.wids_enabled = 1;
 	uresp.wid_count = oparams.wid_count;
diff --git a/include/uapi/rdma/qedr-abi.h b/include/uapi/rdma/qedr-abi.h
index b261c9fca07bb..bf7333b2b5d71 100644
--- a/include/uapi/rdma/qedr-abi.h
+++ b/include/uapi/rdma/qedr-abi.h
@@ -40,7 +40,8 @@
 /* user kernel communication data structures. */
 enum qedr_alloc_ucontext_flags {
 	QEDR_ALLOC_UCTX_EDPM_MODE	= 1 << 0,
-	QEDR_ALLOC_UCTX_DB_REC		= 1 << 1
+	QEDR_ALLOC_UCTX_DB_REC		= 1 << 1,
+	QEDR_SUPPORT_DPM_SIZES		= 1 << 2,
 };
 
 struct qedr_alloc_ucontext_req {
@@ -50,6 +51,7 @@ struct qedr_alloc_ucontext_req {
 
 #define QEDR_LDPM_MAX_SIZE	(8192)
 #define QEDR_EDPM_TRANS_SIZE	(64)
+#define QEDR_EDPM_MAX_SIZE	(ROCE_REQ_MAX_INLINE_DATA_SIZE)
 
 enum qedr_rdma_dpm_type {
 	QEDR_DPM_TYPE_NONE		= 0,
@@ -77,6 +79,8 @@ struct qedr_alloc_ucontext_resp {
 	__u16 ldpm_limit_size;
 	__u8 edpm_trans_size;
 	__u8 reserved;
+	__u16 edpm_limit_size;
+	__u8 padding[6];
 };
 
 struct qedr_alloc_pd_ureq {
-- 
2.25.1



