Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C28251481BD
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390948AbgAXLWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:22:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:33684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391195AbgAXLWW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:22:22 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6767E20718;
        Fri, 24 Jan 2020 11:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864941;
        bh=t1fMeQ0Q+Zpo5xEOHE1aoeS1msL+zwYOGpA9Q9eaKdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pC6wD87ZQB72p2YU3xWRiN1yYpTVdwuBS85eusgS/fSWClDKYCIAntZMgghV1GWU+
         aHz5bnmW2P3C/kH49rxDH5jLi6E0vUQGV4DZzfYjgw14P1fJ4sv38c0Y5k4PS7aOH4
         UPElyvs6Hs+Ts7XjhK/AigARDC5gtFEepMarBNdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 408/639] phy: qcom-qusb2: fix missing assignment of ret when calling clk_prepare_enable
Date:   Fri, 24 Jan 2020 10:29:38 +0100
Message-Id: <20200124093138.168501901@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit d98010817a26eba8d4d1e8a639e0b7d7f042308a ]

The error return from the call to clk_prepare_enable is not being assigned
to variable ret even though ret is being used to check if the call failed.
Fix this by adding in the missing assignment.

Addresses-Coverity: ("Logically dead code")
Fixes: 891a96f65ac3 ("phy: qcom-qusb2: Add support for runtime PM")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qusb2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qusb2.c b/drivers/phy/qualcomm/phy-qcom-qusb2.c
index 69c92843eb3b2..9b7ae93e9df1e 100644
--- a/drivers/phy/qualcomm/phy-qcom-qusb2.c
+++ b/drivers/phy/qualcomm/phy-qcom-qusb2.c
@@ -526,7 +526,7 @@ static int __maybe_unused qusb2_phy_runtime_resume(struct device *dev)
 	}
 
 	if (!qphy->has_se_clk_scheme) {
-		clk_prepare_enable(qphy->ref_clk);
+		ret = clk_prepare_enable(qphy->ref_clk);
 		if (ret) {
 			dev_err(dev, "failed to enable ref clk, %d\n", ret);
 			goto disable_ahb_clk;
-- 
2.20.1



