Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D3D4803BA
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbhL0TFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232376AbhL0TEh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:04:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B1FC06175F;
        Mon, 27 Dec 2021 11:04:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D03C7B81142;
        Mon, 27 Dec 2021 19:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BB3C36AEE;
        Mon, 27 Dec 2021 19:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631874;
        bh=8UKBtvaq+kge4eaTjj755zrfzPSTNSNaJNMjEhe9rI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQg1m3TANjH1xhmnBm/EzFTk5Jil46MLzXrapY4NdotVulTmVEYBrkZDRMuRq9u4V
         mGAqQD35FAVV6JXlY93TnIn4AuFaJzE7Z+HxrBFP6mD6b0rvGjMWSymPVFg8uk2p07
         1ZMtovAAdMM7Ig0WrkZqJx/o/UXpqGV9F54LCjRifXv0h2nnHwGPUfqsVc0nn3lMe/
         K7GZR23sJp8Oy8efrsHC+4z1DoKr4e3lYIgDgdSKNWgskLNXO6aECecaGvAgQ7xtJz
         DhQTKZFq/hNqQ3CaFQRdTdtFrQBbgLlAGjP9C3KvvWQbTmzRuDGqiXQcjl1G1DOt3x
         cP0N1NbvBsjVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miaoqian Lin <linmq006@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        vadimp@nvidia.com, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 21/26] platform/mellanox: mlxbf-pmc: Fix an IS_ERR() vs NULL bug in mlxbf_pmc_map_counters
Date:   Mon, 27 Dec 2021 14:03:22 -0500
Message-Id: <20211227190327.1042326-21-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190327.1042326-1-sashal@kernel.org>
References: <20211227190327.1042326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 804034c4ffc502795cea9b3867acb2ec7fad99ba ]

The devm_ioremap() function returns NULL on error, it doesn't return
error pointers. Also according to doc of device_property_read_u64_array,
values in info array are properties of device or NULL.

Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20211210070753.10761-1-linmq006@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-pmc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/mellanox/mlxbf-pmc.c b/drivers/platform/mellanox/mlxbf-pmc.c
index 04bc3b50aa7a4..65b4a819f1bdf 100644
--- a/drivers/platform/mellanox/mlxbf-pmc.c
+++ b/drivers/platform/mellanox/mlxbf-pmc.c
@@ -1374,8 +1374,8 @@ static int mlxbf_pmc_map_counters(struct device *dev)
 		pmc->block[i].counters = info[2];
 		pmc->block[i].type = info[3];
 
-		if (IS_ERR(pmc->block[i].mmio_base))
-			return PTR_ERR(pmc->block[i].mmio_base);
+		if (!pmc->block[i].mmio_base)
+			return -ENOMEM;
 
 		ret = mlxbf_pmc_create_groups(dev, i);
 		if (ret)
-- 
2.34.1

