Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D268499B13
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355372AbiAXVt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456653AbiAXVjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:39:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63ED4C0419C2;
        Mon, 24 Jan 2022 12:26:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0215B614ED;
        Mon, 24 Jan 2022 20:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0B7C340E7;
        Mon, 24 Jan 2022 20:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055960;
        bh=AUggMRAI+OEjWQOKaYYLxIrciToOUvNb+58T72dqe1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JpYJyCdIYil8o3r1jUjX6E0OAF22pHYHP0aOTLAMintQ2MS8AEDgm38Lbx2POX/fo
         QM7SPy4EAM/m7VwxWCDxvF2RZ7CuYW5GC8Fobbpl9+9dpsO95veUH8AFeKELDhP+GR
         bauh/SNM316UrQ+Ke9SB00tTxwNq3h+gm4GSEbdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 322/846] Bluetooth: hci_qca: Fix NULL vs IS_ERR_OR_NULL check in qca_serdev_probe
Date:   Mon, 24 Jan 2022 19:37:19 +0100
Message-Id: <20220124184112.008828740@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 6845667146a28c09b5dfc401c1ad112374087944 ]

The function devm_gpiod_get_index() return error pointers on error.
Thus devm_gpiod_get_index_optional() could return NULL and error pointers.
The same as devm_gpiod_get_optional() function. Using IS_ERR_OR_NULL()
check to catch error pointers.

Fixes: 77131dfe ("Bluetooth: hci_qca: Replace devm_gpiod_get() with devm_gpiod_get_optional()")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 3c26fc8463923..8eb7fddfb9300 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2058,14 +2058,14 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 
 		qcadev->bt_en = devm_gpiod_get_optional(&serdev->dev, "enable",
 					       GPIOD_OUT_LOW);
-		if (!qcadev->bt_en && data->soc_type == QCA_WCN6750) {
+		if (IS_ERR_OR_NULL(qcadev->bt_en) && data->soc_type == QCA_WCN6750) {
 			dev_err(&serdev->dev, "failed to acquire BT_EN gpio\n");
 			power_ctrl_enabled = false;
 		}
 
 		qcadev->sw_ctrl = devm_gpiod_get_optional(&serdev->dev, "swctrl",
 					       GPIOD_IN);
-		if (!qcadev->sw_ctrl && data->soc_type == QCA_WCN6750)
+		if (IS_ERR_OR_NULL(qcadev->sw_ctrl) && data->soc_type == QCA_WCN6750)
 			dev_warn(&serdev->dev, "failed to acquire SW_CTRL gpio\n");
 
 		qcadev->susclk = devm_clk_get_optional(&serdev->dev, NULL);
@@ -2087,7 +2087,7 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 
 		qcadev->bt_en = devm_gpiod_get_optional(&serdev->dev, "enable",
 					       GPIOD_OUT_LOW);
-		if (!qcadev->bt_en) {
+		if (IS_ERR_OR_NULL(qcadev->bt_en)) {
 			dev_warn(&serdev->dev, "failed to acquire enable gpio\n");
 			power_ctrl_enabled = false;
 		}
-- 
2.34.1



