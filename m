Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD47491833
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348046AbiARCon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:44:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50482 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237239AbiARClk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:41:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78EDAB81255;
        Tue, 18 Jan 2022 02:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA40C36AF2;
        Tue, 18 Jan 2022 02:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473698;
        bh=SR6/RHYzbaW8Yv7fuCZxeBV3M2Vgut2hDG7UGkgolbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bfQtMj+v2vWLxmV6TIML9jGTf5xa6+0SELTH4UurZlJ3YP1Dt2QGfOAt5rR6g2DbC
         jbcMXN1SKb2wrZLcRul4wV17ohQJvSGK36Jse2iFoL4k2c4TrMOrQYstaZI6uDXBIC
         m2IOTUKZgSHNjg3oYDuX9jfrQfRzOXhpIMZL6tdwWIAQKInor+Fz9ObUMVOP95UK6E
         ADIL2T9sUklWHXwlHVPOvkphX2rYNSTIjd5JWlLz2z7QXsohy3s1wih4Bs9PygLCwO
         ryX/L6w+Xb3TdNO3b9iU42ffVZ0r9xPCVPDgCvMBPCJUpPPnHIQL5VLHx5AzcBAFh6
         E6O/dV8Zx6gjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengfeng Ye <cyeaa@connect.ust.hk>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, sre@kernel.org
Subject: [PATCH AUTOSEL 5.10 029/116] HSI: core: Fix return freed object in hsi_new_client
Date:   Mon, 17 Jan 2022 21:38:40 -0500
Message-Id: <20220118024007.1950576-29-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengfeng Ye <cyeaa@connect.ust.hk>

[ Upstream commit a1ee1c08fcd5af03187dcd41dcab12fd5b379555 ]

cl is freed on error of calling device_register, but this
object is return later, which will cause uaf issue. Fix it
by return NULL on error.

Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hsi/hsi_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hsi/hsi_core.c b/drivers/hsi/hsi_core.c
index a5f92e2889cb8..a330f58d45fc6 100644
--- a/drivers/hsi/hsi_core.c
+++ b/drivers/hsi/hsi_core.c
@@ -102,6 +102,7 @@ struct hsi_client *hsi_new_client(struct hsi_port *port,
 	if (device_register(&cl->device) < 0) {
 		pr_err("hsi: failed to register client: %s\n", info->name);
 		put_device(&cl->device);
+		goto err;
 	}
 
 	return cl;
-- 
2.34.1

