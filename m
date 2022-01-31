Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A384A439C
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376888AbiAaLWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378563AbiAaLUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:20:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01EC8C06173E;
        Mon, 31 Jan 2022 03:12:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF9DCB82A65;
        Mon, 31 Jan 2022 11:12:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D6DC340E8;
        Mon, 31 Jan 2022 11:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627571;
        bh=wqzNeQcFF238y01AizBLF3zZp3vvxECIIQgISDKaW+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TxHCPPj6rovDwEq1iGm8z4BRbgwVD8fSvJzPeFYHE+YQ7HwheOm86Gk8aQC75LBFh
         zAivZbY6dGDage3KPg0sHVh/N5nBeFyZxX8urv6T4tWeC68yiLeHb7H4C+yBC+QeOI
         9Kss6CJ5FAsKGtqP00IOR1qIlnvxPC2gvKo534mA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 126/171] octeontx2-af: cn10k: Do not enable RPM loopback for LPC interfaces
Date:   Mon, 31 Jan 2022 11:56:31 +0100
Message-Id: <20220131105234.285216950@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit df66b6ebc5dcf7253e35a640b9ec4add54195c25 ]

Internal looback is not supported to low rate LPCS interface like
SGMII/QSGMII. Hence don't allow to enable for such interfaces.

Fixes: 3ad3f8f93c81 ("octeontx2-af: cn10k: MAC internal loopback support")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/rpm.c   | 27 +++++++++----------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index 07b0eafccad87..b3803577324e6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -251,22 +251,19 @@ int rpm_lmac_internal_loopback(void *rpmd, int lmac_id, bool enable)
 	if (!rpm || lmac_id >= rpm->lmac_count)
 		return -ENODEV;
 	lmac_type = rpm->mac_ops->get_lmac_type(rpm, lmac_id);
-	if (lmac_type == LMAC_MODE_100G_R) {
-		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_PCS100X_CONTROL1);
-
-		if (enable)
-			cfg |= RPMX_MTI_PCS_LBK;
-		else
-			cfg &= ~RPMX_MTI_PCS_LBK;
-		rpm_write(rpm, lmac_id, RPMX_MTI_PCS100X_CONTROL1, cfg);
-	} else {
-		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_LPCSX_CONTROL1);
-		if (enable)
-			cfg |= RPMX_MTI_PCS_LBK;
-		else
-			cfg &= ~RPMX_MTI_PCS_LBK;
-		rpm_write(rpm, lmac_id, RPMX_MTI_LPCSX_CONTROL1, cfg);
+
+	if (lmac_type == LMAC_MODE_QSGMII || lmac_type == LMAC_MODE_SGMII) {
+		dev_err(&rpm->pdev->dev, "loopback not supported for LPC mode\n");
+		return 0;
 	}
 
+	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_PCS100X_CONTROL1);
+
+	if (enable)
+		cfg |= RPMX_MTI_PCS_LBK;
+	else
+		cfg &= ~RPMX_MTI_PCS_LBK;
+	rpm_write(rpm, lmac_id, RPMX_MTI_PCS100X_CONTROL1, cfg);
+
 	return 0;
 }
-- 
2.34.1



