Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C55491C70
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356095AbiARDPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245674AbiARDJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:09:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D20C061762;
        Mon, 17 Jan 2022 18:51:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68E9C61348;
        Tue, 18 Jan 2022 02:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DDBAC36AF2;
        Tue, 18 Jan 2022 02:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474296;
        bh=8+gCBx0g7+QE7u/fTFVaw7lf8xg7PIrSLStF9YpUgcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQTectjImcdY+xY6xbzAa/W5hIRX2b8ZGQjCRvb58nG7EGf3YZsY6yLzVN42e61pJ
         14pq8Wzg5EMlKO9QlTxVm63oyWCsDg2hbgDgdZmVx1dnKZhWF6CCwvAQ0DF9XhFL/8
         6gpwdoQAksA8htETvKcYeHASCsMgygkTWWF6fYY0a/AY52uhDvFiYFBoGA20y0x5pv
         P4XndsRiuPF1PFU1nq2bXg1616TKRXRChIm4BF/RQekgOuRZGnZsLvjTx0kwJwcrQ0
         Kmjebvznx5phMVt2dw8xqvCi1yRZbKK6eAEKl5/2ivUVzeBqcTrmIXcgYZUf10EGRj
         x/HCLj6zjz9ew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengfeng Ye <cyeaa@connect.ust.hk>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, sre@kernel.org
Subject: [PATCH AUTOSEL 4.9 09/33] HSI: core: Fix return freed object in hsi_new_client
Date:   Mon, 17 Jan 2022 21:50:51 -0500
Message-Id: <20220118025116.1954375-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118025116.1954375-1-sashal@kernel.org>
References: <20220118025116.1954375-1-sashal@kernel.org>
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
index e9d63b966caff..4a9fd745b8cb4 100644
--- a/drivers/hsi/hsi_core.c
+++ b/drivers/hsi/hsi_core.c
@@ -115,6 +115,7 @@ struct hsi_client *hsi_new_client(struct hsi_port *port,
 	if (device_register(&cl->device) < 0) {
 		pr_err("hsi: failed to register client: %s\n", info->name);
 		put_device(&cl->device);
+		goto err;
 	}
 
 	return cl;
-- 
2.34.1

