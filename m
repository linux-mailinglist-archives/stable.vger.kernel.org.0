Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D55D37C6C8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235125AbhELPyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:54:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237468AbhELPuh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:50:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 678BC61624;
        Wed, 12 May 2021 15:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833154;
        bh=+NdNz8yZ6luZC7ix4vIyfUjoQQUXG9wfbBAPGIf3rEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gO0IMrYiSO4R9Xe/DUpjfWbHjnNrOU8+OkwXhb/kSvbbs/gLsvDSFbfv1WbSj7Qbh
         HQtCiKjcBCW73TI++q0v4O1WufYYOXkKPEBduBlAibbL+1nclwxNLBVwwvio2Dumai
         UEAAj4Qtf09akAlq+zraUMPdYDfuWpes5Ijwj4KE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.11 040/601] phy: cadence: Sierra: Fix PHY power_on sequence
Date:   Wed, 12 May 2021 16:41:57 +0200
Message-Id: <20210512144829.140195170@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

commit 5b4f5757f83be34d1428a1ffbb68d4a1966e9aae upstream.

Commit 44d30d622821d ("phy: cadence: Add driver for Sierra PHY")
de-asserts PHY_RESET even before the configurations are loaded in
phy_init(). However PHY_RESET should be de-asserted only after
all the configurations has been initialized, instead of de-asserting
in probe. Fix it here.

Fixes: 44d30d622821d ("phy: cadence: Add driver for Sierra PHY")
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Cc: <stable@vger.kernel.org> # v5.4+
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://lore.kernel.org/r/20210319124128.13308-2-kishon@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/cadence/phy-cadence-sierra.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/phy/cadence/phy-cadence-sierra.c
+++ b/drivers/phy/cadence/phy-cadence-sierra.c
@@ -319,6 +319,12 @@ static int cdns_sierra_phy_on(struct phy
 	u32 val;
 	int ret;
 
+	ret = reset_control_deassert(sp->phy_rst);
+	if (ret) {
+		dev_err(dev, "Failed to take the PHY out of reset\n");
+		return ret;
+	}
+
 	/* Take the PHY lane group out of reset */
 	ret = reset_control_deassert(ins->lnk_rst);
 	if (ret) {
@@ -616,7 +622,6 @@ static int cdns_sierra_phy_probe(struct
 
 	pm_runtime_enable(dev);
 	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
-	reset_control_deassert(sp->phy_rst);
 	return PTR_ERR_OR_ZERO(phy_provider);
 
 put_child:


