Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B120268110B
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237165AbjA3OJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237153AbjA3OJo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:09:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FF53B0F8
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:09:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 860CD61025
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B6DC433D2;
        Mon, 30 Jan 2023 14:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087783;
        bh=a7KD4ki5lwxHIzlbYNkq6xlcjjZivuF+6S8zdlPJHRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B1Ch3HQ0N09CvMOP6oMhJYlCVjgoYFf+Q/UUz41lL6RgkhGnTW6yMFY69WVdeS9Tv
         LgA8i/Xj/widmOTSfCz7d2aTXJMsIIVxQUjbgfN6wU3kzRDhG5Irlr0dpQ1lF58RTM
         I027fbJTxGc/7tGRe6d3rTwIIY3Btyj8sw4QNRMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ashish Mhetre <amhetre@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 001/204] memory: tegra: Remove clients SID override programming
Date:   Mon, 30 Jan 2023 14:49:26 +0100
Message-Id: <20230130134316.398126959@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ashish Mhetre <amhetre@nvidia.com>

[ Upstream commit ef86b2c2807f41c045e5534d8513a8b83f63bc39 ]

On newer Tegra releases, early boot SID override programming and SID
override programming during resume is handled by bootloader.
In the function tegra186_mc_program_sid() which is getting removed, SID
override register of all clients is written without checking if secure
firmware has allowed write on it or not. If write is disabled by secure
firmware then it can lead to errors coming from secure firmware and hang
in kernel boot.
Also, SID override is programmed on-demand during probe_finalize() call
of IOMMU which is done in tegra186_mc_client_sid_override() in this same
file. This function does it correctly by checking if write is permitted
on SID override register. It also checks if SID override register is
already written with correct value and skips re-writing it in that case.

Fixes: 393d66fd2cac ("memory: tegra: Implement SID override programming")
Signed-off-by: Ashish Mhetre <amhetre@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20221125040752.12627-1-amhetre@nvidia.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/tegra/tegra186.c | 36 ---------------------------------
 1 file changed, 36 deletions(-)

diff --git a/drivers/memory/tegra/tegra186.c b/drivers/memory/tegra/tegra186.c
index 3d153881abc1..4bed0e54fd45 100644
--- a/drivers/memory/tegra/tegra186.c
+++ b/drivers/memory/tegra/tegra186.c
@@ -20,32 +20,6 @@
 #define MC_SID_STREAMID_SECURITY_WRITE_ACCESS_DISABLED BIT(16)
 #define MC_SID_STREAMID_SECURITY_OVERRIDE BIT(8)
 
-static void tegra186_mc_program_sid(struct tegra_mc *mc)
-{
-	unsigned int i;
-
-	for (i = 0; i < mc->soc->num_clients; i++) {
-		const struct tegra_mc_client *client = &mc->soc->clients[i];
-		u32 override, security;
-
-		override = readl(mc->regs + client->regs.sid.override);
-		security = readl(mc->regs + client->regs.sid.security);
-
-		dev_dbg(mc->dev, "client %s: override: %x security: %x\n",
-			client->name, override, security);
-
-		dev_dbg(mc->dev, "setting SID %u for %s\n", client->sid,
-			client->name);
-		writel(client->sid, mc->regs + client->regs.sid.override);
-
-		override = readl(mc->regs + client->regs.sid.override);
-		security = readl(mc->regs + client->regs.sid.security);
-
-		dev_dbg(mc->dev, "client %s: override: %x security: %x\n",
-			client->name, override, security);
-	}
-}
-
 static int tegra186_mc_probe(struct tegra_mc *mc)
 {
 	int err;
@@ -54,8 +28,6 @@ static int tegra186_mc_probe(struct tegra_mc *mc)
 	if (err < 0)
 		return err;
 
-	tegra186_mc_program_sid(mc);
-
 	return 0;
 }
 
@@ -64,13 +36,6 @@ static void tegra186_mc_remove(struct tegra_mc *mc)
 	of_platform_depopulate(mc->dev);
 }
 
-static int tegra186_mc_resume(struct tegra_mc *mc)
-{
-	tegra186_mc_program_sid(mc);
-
-	return 0;
-}
-
 #if IS_ENABLED(CONFIG_IOMMU_API)
 static void tegra186_mc_client_sid_override(struct tegra_mc *mc,
 					    const struct tegra_mc_client *client,
@@ -142,7 +107,6 @@ static int tegra186_mc_probe_device(struct tegra_mc *mc, struct device *dev)
 const struct tegra_mc_ops tegra186_mc_ops = {
 	.probe = tegra186_mc_probe,
 	.remove = tegra186_mc_remove,
-	.resume = tegra186_mc_resume,
 	.probe_device = tegra186_mc_probe_device,
 };
 
-- 
2.39.0



