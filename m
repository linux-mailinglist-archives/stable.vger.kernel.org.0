Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D76F14838E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404992AbgAXLhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:37:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:57354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404989AbgAXLhI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:37:08 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A93F206F0;
        Fri, 24 Jan 2020 11:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865827;
        bh=3Pos9kAh4dGl97/R2LXThgI2MYXBDfwcfu0Py14xAd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SwsI4ZRzdvo4um8piDrp7CKki13YddCDo5sLmKQcG96PDFdm02Pxl6iEO9S07Vkmg
         4Pr8GzuBZx4jlynNkc5dOREH2EgL+d/7nT4zkSHu6cfOBFjTB2tvjdLbPVXY3M302r
         bSgQ6dANA3Y4krDCt4Ts3xqeZ6J1tBesK/SKGqp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Israel Rukshin <israelr@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 636/639] IB/iser: Fix dma_nents type definition
Date:   Fri, 24 Jan 2020 10:33:26 +0100
Message-Id: <20200124093209.316739750@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
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
index 120b408295603..a7aeaa0c6fbc9 100644
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



