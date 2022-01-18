Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4FE4917D6
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245432AbiARCnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346387AbiARChv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:37:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87199C0619CD;
        Mon, 17 Jan 2022 18:34:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AC79B8123D;
        Tue, 18 Jan 2022 02:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB31C36AE3;
        Tue, 18 Jan 2022 02:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473268;
        bh=bLZe5OoYsGgnPbNAU3HWfa4F/i/GsLBmkpOXd9PxLn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLJlgU5eY2YHrerQyqMdEGfaXfFdTXZNYZcVRdoXBGSZ5r5xXZI5vooo5zawQaXfd
         vTN+dad7c4XIIO9izAwxwJAPu/Uqj1sr1j0QB6LQq3iD5mCsgEHdaF/R3VHN+IRsW5
         hBLx/KqMc3LIfKNxAjZgB3H7cqp5wN/NojOpxha6pHHKbihoQwwX8BexPXPR7BNBBq
         bg+2GqiYdmCDmbIbH3MJc4nGpkUsHq2gAE+XNOY6TJmJjwZnGExH0xQMwcUKs0Ohh9
         FKDDb4IX5e7Aohqu6rOGxcFZCLHEGDACsO0aLqBvKOZyGk54/d2vvBtmM3W6EySIIz
         XccPf19QXYI/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinh Nguyen <dinguyen@kernel.org>, Borislav Petkov <bp@suse.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>, bp@alien8.de,
        mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 048/188] EDAC/synopsys: Use the quirk for version instead of ddr version
Date:   Mon, 17 Jan 2022 21:29:32 -0500
Message-Id: <20220118023152.1948105-48-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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
index 7d08627e738b3..a5486d86fdd2f 100644
--- a/drivers/edac/synopsys_edac.c
+++ b/drivers/edac/synopsys_edac.c
@@ -1352,8 +1352,7 @@ static int mc_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (of_device_is_compatible(pdev->dev.of_node,
-				    "xlnx,zynqmp-ddrc-2.40a"))
+	if (priv->p_data->quirks & DDR_ECC_INTR_SUPPORT)
 		setup_address_map(priv);
 #endif
 
-- 
2.34.1

