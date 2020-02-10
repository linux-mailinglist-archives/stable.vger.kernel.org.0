Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5E315767E
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgBJMxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:53:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730188AbgBJMmO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:42:14 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BE0F21739;
        Mon, 10 Feb 2020 12:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338534;
        bh=FxDB79vcx4G5QmW2++YxBtmlc+Bcn40MOvGOEo/+95Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zpDVDW3GQI4ixAyJEiizdUtrLIF5Es3K+t4+jaSbv9V6of790WqiLkWhku/wmD0eL
         fZ/lHB3+XS8EGkEvz8nkgjx+buV469nXVbUwOvk8wLYNNVlGA1Sqd1oKap4EQjopcs
         hhwqSEb//udqJi/uJ8dug9/dLIR2Vq7vq7feZx7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 361/367] IB/core: Fix build failure without hugepages
Date:   Mon, 10 Feb 2020 04:34:34 -0800
Message-Id: <20200210122455.688619849@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 74f75cda754eb69a77f910ceb5bc85f8e9ba56a5 ]

HPAGE_SHIFT is only defined on architectures that support hugepages:

drivers/infiniband/core/umem_odp.c: In function 'ib_umem_odp_get':
drivers/infiniband/core/umem_odp.c:245:26: error: 'HPAGE_SHIFT' undeclared (first use in this function); did you mean 'PAGE_SHIFT'?

Enclose this in an #ifdef.

Fixes: 9ff1b6466a29 ("IB/core: Fix ODP with IB_ACCESS_HUGETLB handling")
Link: https://lore.kernel.org/r/20200109084740.2872079-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/umem_odp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index f42fa31c24a29..b9baf7d0a5cb7 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -241,10 +241,11 @@ struct ib_umem_odp *ib_umem_odp_get(struct ib_udata *udata, unsigned long addr,
 	umem_odp->umem.owning_mm = mm = current->mm;
 	umem_odp->notifier.ops = ops;
 
+	umem_odp->page_shift = PAGE_SHIFT;
+#ifdef CONFIG_HUGETLB_PAGE
 	if (access & IB_ACCESS_HUGETLB)
 		umem_odp->page_shift = HPAGE_SHIFT;
-	else
-		umem_odp->page_shift = PAGE_SHIFT;
+#endif
 
 	umem_odp->tgid = get_task_pid(current->group_leader, PIDTYPE_PID);
 	ret = ib_init_umem_odp(umem_odp, ops);
-- 
2.20.1



