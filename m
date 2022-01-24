Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE9149921F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238630AbiAXURb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355128AbiAXUNU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:13:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8A0C028C3E;
        Mon, 24 Jan 2022 11:34:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABACAB811F9;
        Mon, 24 Jan 2022 19:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E622DC340E5;
        Mon, 24 Jan 2022 19:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052857;
        bh=SR6/RHYzbaW8Yv7fuCZxeBV3M2Vgut2hDG7UGkgolbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tp91cejAMrxQZDK/KtBJxVu9mu9DRKVwFVYrCkgzzSYnszt9iZ19aNPSusXxbgEMX
         9DTbBIrazPmygi+2y84aXTFXXklwjwo3ReDZCwSjkHYFalSpJd/QEn/GSG4vUP5/Ib
         ZSWAIe1b5Jq1euU872/qDf9gEQli6geUJLwE73ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengfeng Ye <cyeaa@connect.ust.hk>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 169/320] HSI: core: Fix return freed object in hsi_new_client
Date:   Mon, 24 Jan 2022 19:42:33 +0100
Message-Id: <20220124183959.418536720@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



