Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C424520DA35
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388256AbgF2Tyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:54:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387668AbgF2TkZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64ACD2489A;
        Mon, 29 Jun 2020 15:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444394;
        bh=1r0f4ZnQmdR4BWSj2HlcLqxYIZwQ45jP+tBmxdtmu24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pRVVToz5NLWcYlwpxzyext4FDelD4ciXZa6R6nvCSngC35cvJMNJEQg8b2K7d61Pn
         wgT/MID7Kw1bznA6X5EjIredr+ZOpYyAHup4S5UkZhyoZvO8UcX227+fE9XRF8vVcf
         r4Xu0uJuWrWs7CtWC2SGcqEcdpwg3riJSico9H0U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tom Seewald <tseewald@gmail.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/178] RDMA/siw: Fix pointer-to-int-cast warning in siw_rx_pbl()
Date:   Mon, 29 Jun 2020 11:23:36 -0400
Message-Id: <20200629152523.2494198-72-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
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
index c0a8872403258..0520e70084f97 100644
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

