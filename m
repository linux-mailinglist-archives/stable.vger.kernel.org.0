Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2991B147E02
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387470AbgAXKFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:05:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:41394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389167AbgAXKEz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:04:55 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0857B208C4;
        Fri, 24 Jan 2020 10:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860294;
        bh=xqLNtbNfc9jUGh3XZc/FX19RQ3JjbCStG0AEEYdUJAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZs4gl1aeWgCL4u75izHrdpEgil9Az2zJNzS2pmn6H56DnI8fkAZaQIsR1ETC2tRx
         8z1HvN/mhy9h0SuaFoMDe/Ecmnl1j2uOxQDjlJm3i7OgQ8dFk/otfHjXgVURJRHKnW
         0aSOhxh5s9F3ey2Td8irvxXS2dt8vwh/v596ZEUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 305/343] RDMA/cma: Fix false error message
Date:   Fri, 24 Jan 2020 10:32:03 +0100
Message-Id: <20200124092959.986136864@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index fc4630e4acdd6..1614f6f3677c0 100644
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



