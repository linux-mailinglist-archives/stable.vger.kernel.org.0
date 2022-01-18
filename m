Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F17491D75
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345640AbiARDgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352902AbiARDee (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:34:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5A1C061343;
        Mon, 17 Jan 2022 18:45:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2D25B81132;
        Tue, 18 Jan 2022 02:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E952DC36AE3;
        Tue, 18 Jan 2022 02:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473910;
        bh=SR6/RHYzbaW8Yv7fuCZxeBV3M2Vgut2hDG7UGkgolbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oj+HrotMFU0Izy8vgxHM3QcbWjNS5yFh4cxH8iPjPfO0TxnCUHQkVgFcjW1llrX95
         +8QkNOrPu3NLNROxlUEAcKbIfhjA5Vxuq/StNt5FBUZLoO3mEmeg6PrBw1O6vQwz1v
         tICxucivHSESycGkwxXvLaHnjc2aZ+PMWmWDJ7yhpkuXkReoq3i8COnpg2EXTsd3xe
         Ht8Meq9yCbPmx3g5+wpq79NJZrMr0IoBW3cPC/c4zEGwq3RsJS1FCgxkbJSImuEbzD
         gCAZIQYU/bCUTx0LxapsmSnsD+TKqU30hSkWajKAL7o3+spgzBb3DDlvPyh2dnM4Jz
         +RhQd8bRCEFVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengfeng Ye <cyeaa@connect.ust.hk>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, sre@kernel.org
Subject: [PATCH AUTOSEL 5.4 18/73] HSI: core: Fix return freed object in hsi_new_client
Date:   Mon, 17 Jan 2022 21:43:37 -0500
Message-Id: <20220118024432.1952028-18-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
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

