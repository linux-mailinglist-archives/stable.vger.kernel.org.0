Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCAC4D9EFC
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438425AbfJPV7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:59:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391472AbfJPV7M (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:12 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DACD21A4C;
        Wed, 16 Oct 2019 21:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263151;
        bh=O8OYVUjvIYMQTnJDCWIIrkclgQg7z0kTSL1toBZGUww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QA8jDgC44XYEVy0+dHDAJ51Va8tw5Jed+++0KatFYHTqVR+NKzFfXAF9uQrphU1mD
         6Pps/m7PO1dfzNjYWTvVJzI67is081pmbw7iywr5GCD5yeLoEbwbrJvluLUNRxpb8G
         NH1mg+Q7r5yMBdCEjYX2xkQoJjkz0WWF4Bs5BuDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mohamad Heib <mohamadh@mellanox.com>,
        Erez Alfasi <ereza@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.3 079/112] IB/core: Fix wrong iterating on ports
Date:   Wed, 16 Oct 2019 14:51:11 -0700
Message-Id: <20191016214904.411039483@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mohamad Heib <mohamadh@mellanox.com>

commit 1cbe866cbcb53338de33cf67262e73f9315a9725 upstream.

rdma_for_each_port is already incrementing the iterator's value it
receives therefore, after the first iteration the iterator is increased by
2 which eventually causing wrong queries and possible traces.

Fix the above by removing the old redundant incrementation that was used
before rdma_for_each_port() macro.

Cc: <stable@vger.kernel.org>
Fixes: ea1075edcbab ("RDMA: Add and use rdma_for_each_port")
Link: https://lore.kernel.org/r/20191002122127.17571-1-leon@kernel.org
Signed-off-by: Mohamad Heib <mohamadh@mellanox.com>
Reviewed-by: Erez Alfasi <ereza@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/security.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/core/security.c
+++ b/drivers/infiniband/core/security.c
@@ -426,7 +426,7 @@ int ib_create_qp_security(struct ib_qp *
 	int ret;
 
 	rdma_for_each_port (dev, i) {
-		is_ib = rdma_protocol_ib(dev, i++);
+		is_ib = rdma_protocol_ib(dev, i);
 		if (is_ib)
 			break;
 	}


