Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373724914EC
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbiARCZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:25:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37908 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245321AbiARCXh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:23:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A207B81238;
        Tue, 18 Jan 2022 02:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660C1C36AEB;
        Tue, 18 Jan 2022 02:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472615;
        bh=hEOXtMUwE/45Nh6ai1hbQxYP2KFHIOMKiavrEhac3jM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P8eYJUbd/jEF0mO1uZJ7rgl+TTrEq53jm9MGkJXqkF752OY2LyHu6RsNNar8Lq73l
         BVX405gG02xN2WB0C8IStRI7ys2uyhfP43Zv1gpQHBhDV7gQXVE+fJodtwfLovRNQY
         EfAGYF1M/ASmv+wN+rCNaBdvrS4Rtz1UY5Uh++wEEhlKI5W2K0bMCKT9YKEph4L/5n
         KYRDMIMBRQv7EaAxo67bFfXMhevc6bOpVcbDJ2u9Zihyqw2zXrAi2LZ6FVuSn2ZHcY
         rq2T/I3D745HDPqn5OM9r2ZSwbBDfCBj1DtRwi1pl7h4cM8grtA72juiMe31DnaYV5
         SHqCJ86LYmGYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengfeng Ye <cyeaa@connect.ust.hk>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, sre@kernel.org
Subject: [PATCH AUTOSEL 5.16 072/217] HSI: core: Fix return freed object in hsi_new_client
Date:   Mon, 17 Jan 2022 21:17:15 -0500
Message-Id: <20220118021940.1942199-72-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index ec90713564e32..884066109699c 100644
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

