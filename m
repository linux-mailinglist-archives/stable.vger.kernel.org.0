Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23FB32AF2B
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233565AbhCCAPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:15:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383820AbhCBMLa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:11:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B12A164F57;
        Tue,  2 Mar 2021 11:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686222;
        bh=6c15F5Uhi6U8dgs+Iy1Mr9IC+YG/q6nRShgMK4C9KO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iGSwpBGUJWO/5Ain7heo7mz2kVO2tWQD0fVFACRxIQ2WvoWY0xcdT6D+COai4etVm
         70sxFqaDOO4hgH5w+4WTK5Pl+endx4cLhmLLpfDS5+d+hb0quOI/UQfLiTjr2plhPG
         1tWeu61jxx2HCzF/WEyup5J6sFTQ+4jC2FaBjTHy3RGtV1aOWYO0MdIN69uLPcl+MV
         kg5XZ3T3lg3kCIzTXD9q/zEiMgXFZwn/U9MHp/dzO0pLpvZb5sY78IO+oqZd16fiwg
         dVgPMyYvv4n7Zn/b6EfCW/t08YIKC87jocdGaDg5hiZrmhboQeZzMK3Ho583a1VWPV
         wQDrDoPjGF/aA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lubomir Rintel <lkundrak@v3.sk>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 12/47] Platform: OLPC: Fix probe error handling
Date:   Tue,  2 Mar 2021 06:56:11 -0500
Message-Id: <20210302115646.62291-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115646.62291-1-sashal@kernel.org>
References: <20210302115646.62291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lubomir Rintel <lkundrak@v3.sk>

[ Upstream commit cec551ea0d41c679ed11d758e1a386e20285b29d ]

Reset ec_priv if probe ends unsuccessfully.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Link: https://lore.kernel.org/r/20210126073740.10232-2-lkundrak@v3.sk
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/olpc/olpc-ec.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/olpc/olpc-ec.c b/drivers/platform/olpc/olpc-ec.c
index f64b82824db2..2db7113383fd 100644
--- a/drivers/platform/olpc/olpc-ec.c
+++ b/drivers/platform/olpc/olpc-ec.c
@@ -426,11 +426,8 @@ static int olpc_ec_probe(struct platform_device *pdev)
 
 	/* get the EC revision */
 	err = olpc_ec_cmd(EC_FIRMWARE_REV, NULL, 0, &ec->version, 1);
-	if (err) {
-		ec_priv = NULL;
-		kfree(ec);
-		return err;
-	}
+	if (err)
+		goto error;
 
 	config.dev = pdev->dev.parent;
 	config.driver_data = ec;
@@ -440,12 +437,16 @@ static int olpc_ec_probe(struct platform_device *pdev)
 	if (IS_ERR(ec->dcon_rdev)) {
 		dev_err(&pdev->dev, "failed to register DCON regulator\n");
 		err = PTR_ERR(ec->dcon_rdev);
-		kfree(ec);
-		return err;
+		goto error;
 	}
 
 	ec->dbgfs_dir = olpc_ec_setup_debugfs();
 
+	return 0;
+
+error:
+	ec_priv = NULL;
+	kfree(ec);
 	return err;
 }
 
-- 
2.30.1

