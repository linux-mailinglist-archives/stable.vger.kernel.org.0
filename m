Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D988147E48
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733183AbgAXKHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:07:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:44256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389036AbgAXKHj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:07:39 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AB632087E;
        Fri, 24 Jan 2020 10:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860459;
        bh=1SRjTnV20dg5/VzTUjEQ4H/tE+oFjJK7N8fz5kY4F0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QgC6k5nJ05sloGLfDGedP0EbmPssk2b1v6oPgK06wnrxlcNcOM8dE5hMBXDdyqmbZ
         p7QN/Pxq+yKob+H/arw0aQAvKILXHhK94DCyNpwPaw8ItCypohmSdcNquyWzfHblyz
         SiSs+/iS1SyFJ1pLPUKRVTwKLByEXR0UKaPEqakw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Israel Rukshin <israelr@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 341/343] IB/iser: Fix dma_nents type definition
Date:   Fri, 24 Jan 2020 10:32:39 +0100
Message-Id: <20200124093004.613711197@linuxfoundation.org>
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

From: Max Gurtovoy <maxg@mellanox.com>

[ Upstream commit c1545f1a200f4adc4ef8dd534bf33e2f1aa22c2f ]

The retured value from ib_dma_map_sg saved in dma_nents variable. To avoid
future mismatch between types, define dma_nents as an integer instead of
unsigned.

Fixes: 57b26497fabe ("IB/iser: Pass the correct number of entries for dma mapped SGL")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Israel Rukshin <israelr@mellanox.com>
Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
Acked-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index c1ae4aeae2f90..46dfc6ae9d1c1 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -197,7 +197,7 @@ struct iser_data_buf {
 	struct scatterlist *sg;
 	int                size;
 	unsigned long      data_len;
-	unsigned int       dma_nents;
+	int                dma_nents;
 };
 
 /* fwd declarations */
-- 
2.20.1



