Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA1449990A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454019AbiAXVb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:31:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38674 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451061AbiAXVWE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:22:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46B10B81142;
        Mon, 24 Jan 2022 21:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FADBC340E4;
        Mon, 24 Jan 2022 21:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059322;
        bh=bLZe5OoYsGgnPbNAU3HWfa4F/i/GsLBmkpOXd9PxLn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dnz70WMr9VeKQsqNdX0/QHrsbC7a2bXqFteAbd30/qMcooB3wMw5hMoGcEisp5I4z
         3OYrjQEbogcgoNjBdLGwp1FRa/l8Zx19lULy/2kNVKtqccrvHwNUdcFMjU9H4GZrms
         UhZRXfeIEmak48aUo08g2KUzPXIycrB/bX2LROw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0576/1039] EDAC/synopsys: Use the quirk for version instead of ddr version
Date:   Mon, 24 Jan 2022 19:39:25 +0100
Message-Id: <20220124184144.704959594@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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



