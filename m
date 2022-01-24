Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57EDF499699
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445875AbiAXVFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:05:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391109AbiAXUq7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:46:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9271C0619C6;
        Mon, 24 Jan 2022 11:57:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71790B81239;
        Mon, 24 Jan 2022 19:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ADE4C340E5;
        Mon, 24 Jan 2022 19:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054222;
        bh=bjnr579xE3xgyvjFIi7SCyvGueJvDxugpZ7TyGVGiLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pvq1A8wafWZLLr3CMt2WeRE9aPrW1A8M9xJ6pEsU85cksZQUcfU/8lc5z8erxWh+P
         fSXf+A4yRHVU/Kmu+1ij3UHbmDync+UjcmrEfYpbpwflZ/TDV7ON5ZVSelU6rDFySE
         GV5nGCPV89KSJh4roFnnVtYEdmJa42OcDNwlwbgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 317/563] EDAC/synopsys: Use the quirk for version instead of ddr version
Date:   Mon, 24 Jan 2022 19:41:22 +0100
Message-Id: <20220124184035.393469702@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



