Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3110713EF86
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392735AbgAPR3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:29:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:41490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392762AbgAPR3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:29:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3B1024722;
        Thu, 16 Jan 2020 17:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195774;
        bh=AJxd5Nq/0m8HyyS0sFd0JNlFDTh7G9lKgm0h3v4rbLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Ahf2VNztURjX49QOJEMm3iXyhG/Uqmo9QznelnKYFrdhObcRRVG4EjFc658qhHVD
         Qd5qH5WQFvldc7s95VJppjpXEPfbOGmaEhaWGbmdLVHD8uCeCbYl9nRWF+7ZdgJk1y
         HfEyyyWG4Ac8Mjr6E8iVlHrU6a1AqjdCvSc3oNDU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 300/371] RDMA/cma: Fix false error message
Date:   Thu, 16 Jan 2020 12:22:52 -0500
Message-Id: <20200116172403.18149-243-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Håkon Bugge <haakon.bugge@oracle.com>

[ Upstream commit a6e4d254c19b541a58caced322111084b27a7788 ]

In addr_handler(), assuming status == 0 and the device already has been
acquired (id_priv->cma_dev != NULL), we get the following incorrect
"error" message:

RDMA CM: ADDR_ERROR: failed to resolve IP. status 0

Fixes: 498683c6a7ee ("IB/cma: Add debug messages to error flows")
Link: https://lore.kernel.org/r/20190902092731.1055757-1-haakon.bugge@oracle.com
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index fc4630e4acdd..1614f6f3677c 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2789,7 +2789,7 @@ static void addr_handler(int status, struct sockaddr *src_addr,
 		if (status)
 			pr_debug_ratelimited("RDMA CM: ADDR_ERROR: failed to acquire device. status %d\n",
 					     status);
-	} else {
+	} else if (status) {
 		pr_debug_ratelimited("RDMA CM: ADDR_ERROR: failed to resolve IP. status %d\n", status);
 	}
 
-- 
2.20.1

