Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF2F013EC84
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393943AbgAPRnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:43:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:33672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393937AbgAPRnc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:43:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BA0F246C2;
        Thu, 16 Jan 2020 17:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196612;
        bh=QJfuTchg0AaTuZTfMfJaRqGBCF2ucnljtlclH+t/ZLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h9o5LCESY99fX13aaaZvNr075R/VIJ5E3bvslabZahrHFvsbaJkJwwEVhdw45bkZf
         hSIRzXV5U0BwyWXXQ9MnUfihpmAtlTvN46W58EV27ufB7KrdwR19oaSL51xT6JhhWg
         i1//iGLF/3nyufhy4KTUMVAHoOlx1sGcXnfTXaVM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gal Pressman <galpress@amazon.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 031/174] RDMA/ocrdma: Fix out of bounds index check in query pkey
Date:   Thu, 16 Jan 2020 12:40:28 -0500
Message-Id: <20200116174251.24326-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gal Pressman <galpress@amazon.com>

[ Upstream commit b188940796c7be31c1b8c25a9a0e0842c2e7a49e ]

The pkey table size is one element, index should be tested for > 0 instead
of > 1.

Fixes: fe2caefcdf58 ("RDMA/ocrdma: Add driver for Emulex OneConnect IBoE RDMA adapter")
Signed-off-by: Gal Pressman <galpress@amazon.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 76e96f97b3f6..6385448b22c5 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -55,7 +55,7 @@
 
 int ocrdma_query_pkey(struct ib_device *ibdev, u8 port, u16 index, u16 *pkey)
 {
-	if (index > 1)
+	if (index > 0)
 		return -EINVAL;
 
 	*pkey = 0xffff;
-- 
2.20.1

