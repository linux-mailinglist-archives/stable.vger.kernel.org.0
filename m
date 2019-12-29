Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3762712C935
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732764AbfL2SB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:01:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:44272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732933AbfL2Rzc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:55:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC756206A4;
        Sun, 29 Dec 2019 17:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642132;
        bh=JCaGLxuX1+7lSZZEo0VAEfdKz+ADCMd4+VgzpVhEvms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KR2cRkul356aUH8wuRv3iIPek52IeJb7H/j46rQeeKWyHZTQhtujp0/UzFJrbUccX
         i7AE7K80APtKZzNhN9RtZI4+5kRWx9HW1eeSV7/SpEneAxa00rsD2abwpAZkymYUIl
         wXZeGPM++CyrUz2KPeNUaPpOpJILluq15D/AMoMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Devesh Sharma <devesh.sharma@broadcom.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 354/434] RDMA/bnxt_re: Fix missing le16_to_cpu
Date:   Sun, 29 Dec 2019 18:26:47 +0100
Message-Id: <20191229172725.484108806@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Devesh Sharma <devesh.sharma@broadcom.com>

[ Upstream commit fca5b9dc0986aa49b3f0a7cfe24b6c82422ac1d7 ]

>From sparse:

drivers/infiniband/hw/bnxt_re/main.c:1274:18: warning: cast from restricted __le16
drivers/infiniband/hw/bnxt_re/main.c:1275:18: warning: cast from restricted __le16
drivers/infiniband/hw/bnxt_re/main.c:1276:18: warning: cast from restricted __le16
drivers/infiniband/hw/bnxt_re/main.c:1277:21: warning: restricted __le16 degrades to integer

Fixes: 2b827ea1926b ("RDMA/bnxt_re: Query HWRM Interface version from FW")
Link: https://lore.kernel.org/r/1574317343-23300-4-git-send-email-devesh.sharma@broadcom.com
Signed-off-by: Devesh Sharma <devesh.sharma@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 30a54f8aa42c..b31e21588200 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -1270,10 +1270,10 @@ static void bnxt_re_query_hwrm_intf_version(struct bnxt_re_dev *rdev)
 		return;
 	}
 	rdev->qplib_ctx.hwrm_intf_ver =
-		(u64)resp.hwrm_intf_major << 48 |
-		(u64)resp.hwrm_intf_minor << 32 |
-		(u64)resp.hwrm_intf_build << 16 |
-		resp.hwrm_intf_patch;
+		(u64)le16_to_cpu(resp.hwrm_intf_major) << 48 |
+		(u64)le16_to_cpu(resp.hwrm_intf_minor) << 32 |
+		(u64)le16_to_cpu(resp.hwrm_intf_build) << 16 |
+		le16_to_cpu(resp.hwrm_intf_patch);
 }
 
 static void bnxt_re_ib_unreg(struct bnxt_re_dev *rdev)
-- 
2.20.1



