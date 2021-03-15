Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6441333B887
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbhCOODs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:03:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232952AbhCOOAV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF90164F5D;
        Mon, 15 Mar 2021 14:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816805;
        bh=1LANfikIH4WX96lOTe4tjEdD+qWcOW6ze56Lfeyz/Dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1JWr7WXcYtuHfvJfwGjIsgweDcKkZd0zST+CVVGrRiq3hRKrhAFms3WBkKwASRXdq
         1A9N0m0KXqbkyN7uEdD87sxTLSM/nx/HKh27rLyRPCAwF3iuXheWXOURtqoEtdGDeY
         7eWNiIVEzkVxUU8HEkpRzAhcCRS+Iw4m/ksmYu2c=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 135/306] Platform: OLPC: Fix probe error handling
Date:   Mon, 15 Mar 2021 14:53:18 +0100
Message-Id: <20210315135512.214850549@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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



