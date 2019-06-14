Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B202D4698A
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbfFNUaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727546AbfFNUaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:30:23 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D862621851;
        Fri, 14 Jun 2019 20:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544222;
        bh=b4B2B2FBeblgf04rcejeh3Qcw4zIHtGN/AIfvoR/y/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1iGqqqsg0i1GDTuRuAOP2vBBwKX1RwRHI8HImN7s4vRIGO/XMa10iHaYao78+0+Qp
         oWOJ+cPJMJfgoN6rghCR+80pwhtj0EMGxVdQ9+Kor5z3ZXTe3sP5+fOTgAHY73H76N
         HwZ9D55Aln02fhanix+EfNNJQSiQxwRFGUl32FZs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kamenee Arumugam <kamenee.arumugam@intel.com>,
        "Michael J . Ruhl" <michael.j.ruhl@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 09/27] IB/hfi1: Validate page aligned for a given virtual address
Date:   Fri, 14 Jun 2019 16:29:58 -0400
Message-Id: <20190614203018.27686-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614203018.27686-1-sashal@kernel.org>
References: <20190614203018.27686-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamenee Arumugam <kamenee.arumugam@intel.com>

[ Upstream commit 97736f36dbebf2cda2799db3b54717ba5b388255 ]

User applications can register memory regions for TID buffers that are not
aligned on page boundaries. Hfi1 is expected to pin those pages in memory
and cache the pages with mmu_rb. The rb tree will fail to insert pages
that are not aligned correctly.

Validate whether a given virtual address is page aligned before pinning.

Fixes: 7e7a436ecb6e ("staging/hfi1: Add TID entry program function body")
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Kamenee Arumugam <kamenee.arumugam@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/user_exp_rcv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index 6f6c14df383e..b38e3808836c 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -324,6 +324,9 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 	u32 *tidlist = NULL;
 	struct tid_user_buf *tidbuf;
 
+	if (!PAGE_ALIGNED(tinfo->vaddr))
+		return -EINVAL;
+
 	tidbuf = kzalloc(sizeof(*tidbuf), GFP_KERNEL);
 	if (!tidbuf)
 		return -ENOMEM;
-- 
2.20.1

