Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E32491AC8
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245694AbiARDCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245595AbiARC5U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:57:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C20DC0613BD;
        Mon, 17 Jan 2022 18:45:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EDFC61311;
        Tue, 18 Jan 2022 02:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A080CC36AE3;
        Tue, 18 Jan 2022 02:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473899;
        bh=VKtWU7N1EdLQFZ82cUPjVOMgCStG3PuUh+WUdBvaBIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EGE4TJMj5NEemiwBrP6UEWDmr6I1nS9QJnbCqbGof97d9R3ddKJnwGQHyEL5JRDfo
         yHmnC8Q+q5LEYsCVBTkmf7g0mVtYncaWJMFm1RWJylK5105JOd2z/8+ylg+Ocv+owL
         JayNcrT+XnHSjU0k3pxTvbfLiORBXLeiJ99OLsy0iBEqbTQI5FSxyHRI9C1M2raOan
         7jjJfFaynAG+umW9W+o8D/kBZ6pYXITCV6BHRyVbV/1keCSzuXVrtG4duKFfeP+s6i
         vsEOTVTDUhpR/60uIolXwuek/5QAHyZ8jNsBJ8sh+iOetiaCNc1SGoCmpZ3DuFAwbi
         G3WbzAvQp+X1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinh Nguyen <dinguyen@kernel.org>, Borislav Petkov <bp@suse.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>, bp@alien8.de,
        mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/73] EDAC/synopsys: Use the quirk for version instead of ddr version
Date:   Mon, 17 Jan 2022 21:43:32 -0500
Message-Id: <20220118024432.1952028-13-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
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
index 6becf3363ad57..d23a0782fb49c 100644
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

