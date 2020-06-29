Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F8D20D0BE
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgF2Sfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:35:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgF2Sf2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3CD8246BA;
        Mon, 29 Jun 2020 15:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444009;
        bh=dUZkHkgB/7ulFGjs0AMPzzCU/9UP9/5a5DGcbNsCZwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AiWn8zzCcE7HsskBi0U7/yA5WmS8yWSMWDM4UEWCtEFH34VSLU9iZJ7mKq8uG7KdV
         dTh15F/JHs67YXvwSTTBwzR/dmJMVZwowhcGxcP8XG8pdaJ92WwcqWDnw9QAOYJhDD
         Uq7iworf9UVfB0OZah9eLHCkSypW01uj+zNJ/LYE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tom Seewald <tseewald@gmail.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 115/265] RDMA/siw: Fix pointer-to-int-cast warning in siw_rx_pbl()
Date:   Mon, 29 Jun 2020 11:15:48 -0400
Message-Id: <20200629151818.2493727-116-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Seewald <tseewald@gmail.com>

[ Upstream commit 6769b275a313c76ddcd7d94c632032326db5f759 ]

The variable buf_addr is type dma_addr_t, which may not be the same size
as a pointer.  To ensure it is the correct size, cast to a uintptr_t.

Fixes: c536277e0db1 ("RDMA/siw: Fix 64/32bit pointer inconsistency")
Link: https://lore.kernel.org/r/20200610174717.15932-1-tseewald@gmail.com
Signed-off-by: Tom Seewald <tseewald@gmail.com>
Reviewed-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_qp_rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_rx.c b/drivers/infiniband/sw/siw/siw_qp_rx.c
index 650520244ed0c..7271d705f4b06 100644
--- a/drivers/infiniband/sw/siw/siw_qp_rx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_rx.c
@@ -139,7 +139,8 @@ static int siw_rx_pbl(struct siw_rx_stream *srx, int *pbl_idx,
 			break;
 
 		bytes = min(bytes, len);
-		if (siw_rx_kva(srx, (void *)buf_addr, bytes) == bytes) {
+		if (siw_rx_kva(srx, (void *)(uintptr_t)buf_addr, bytes) ==
+		    bytes) {
 			copied += bytes;
 			offset += bytes;
 			len -= bytes;
-- 
2.25.1

