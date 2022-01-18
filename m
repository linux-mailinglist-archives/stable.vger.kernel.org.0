Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D377A491A8E
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352572AbiARDAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346488AbiARCtG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:49:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A9DC06175A;
        Mon, 17 Jan 2022 18:41:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB89E612E2;
        Tue, 18 Jan 2022 02:41:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2B1C36AF5;
        Tue, 18 Jan 2022 02:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473671;
        bh=bjnr579xE3xgyvjFIi7SCyvGueJvDxugpZ7TyGVGiLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKHwtSZcRq+y8f4QN4wv2ca7WzaOZQ2mfS7ASnnsvrZ5YRgRwE+J290vYEZGrocKv
         LXFQM2xrBDMGas+OGirJzKuW+DUOHLg5FXZzJgrt5V70RQBnEnwovCGGCDQbkf3Nn6
         J+7t8ASY/4GAN5kkqoBO8qPvIHst/WOKwG7S2XCy7GLnOTlMuIS7cCMa8W4btDfiWs
         EMqs4hvgRI0INQGsz67kWZdbk5tiF8uOITwvTnLKeQs4uXo8pj96vfI3sGa2FNWyu4
         gv5W/N2uEZd/nR4bBURJE37HN6LO2cn9wwscNH+pFYq1Zu5PYJFV1mQCr1WJQlhQUX
         wQCZmVdEW0jIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinh Nguyen <dinguyen@kernel.org>, Borislav Petkov <bp@suse.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>, bp@alien8.de,
        mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 020/116] EDAC/synopsys: Use the quirk for version instead of ddr version
Date:   Mon, 17 Jan 2022 21:38:31 -0500
Message-Id: <20220118024007.1950576-20-sashal@kernel.org>
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

From: Dinh Nguyen <dinguyen@kernel.org>

[ Upstream commit bd1d6da17c296bd005bfa656952710d256e77dd3 ]

Version 2.40a supports DDR_ECC_INTR_SUPPORT for a quirk, so use that
quirk to determine a call to setup_address_map().

Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lkml.kernel.org/r/20211012190709.1504152-1-dinguyen@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/synopsys_edac.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/edac/synopsys_edac.c b/drivers/edac/synopsys_edac.c
index 1a801a5d3b08b..92906b56b1a2b 100644
--- a/drivers/edac/synopsys_edac.c
+++ b/drivers/edac/synopsys_edac.c
@@ -1351,8 +1351,7 @@ static int mc_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (of_device_is_compatible(pdev->dev.of_node,
-				    "xlnx,zynqmp-ddrc-2.40a"))
+	if (priv->p_data->quirks & DDR_ECC_INTR_SUPPORT)
 		setup_address_map(priv);
 #endif
 
-- 
2.34.1

