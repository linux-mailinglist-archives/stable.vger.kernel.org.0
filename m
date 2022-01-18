Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315534914B8
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245389AbiARCXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244732AbiARCWp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:22:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D72C06176E;
        Mon, 17 Jan 2022 18:22:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9181CB8124E;
        Tue, 18 Jan 2022 02:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623B2C36AF2;
        Tue, 18 Jan 2022 02:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472562;
        bh=bLZe5OoYsGgnPbNAU3HWfa4F/i/GsLBmkpOXd9PxLn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LnlTRUXPdCH9b5R9wDXU2B3t1ZbJrMP3GDxbVjlmXu4L4prPrsnh42btRJiUqCjtD
         vbAgv/996Up7QkZ1W9x9anIZd76b3MPp9WU+QG3L2nW5dQvpNY7awYA8c8i2NSqlGd
         mRORuuFXWi2+sIY9qWLe8YI6hRxzBiUUkr8ubWurYeZoK3FBUmTdDaQdq2inHB9IY4
         /2dG8Bkd/r8jC+MeepvWExX6AhcGsLLVCxdR9UaoQif1BAukcrL6kU1a8KhYBokbsA
         zRAWxHun6prfpMQ7ge0TSaB0VVj3PuftuSjngX457sHlaqR2MY3Wr9EuX6gZxe0MAa
         GDrBNv+SkACBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinh Nguyen <dinguyen@kernel.org>, Borislav Petkov <bp@suse.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>, bp@alien8.de,
        mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 054/217] EDAC/synopsys: Use the quirk for version instead of ddr version
Date:   Mon, 17 Jan 2022 21:16:57 -0500
Message-Id: <20220118021940.1942199-54-sashal@kernel.org>
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

