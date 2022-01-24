Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B171E49A05B
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1843862AbiAXXGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1841132AbiAXW5l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:57:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12822C08C5C0;
        Mon, 24 Jan 2022 13:12:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A72996131F;
        Mon, 24 Jan 2022 21:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F17C340E5;
        Mon, 24 Jan 2022 21:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058739;
        bh=4ttaYS0IPIApvX9jBxMH4S+arQVzSNj44W36l/3hhes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gp0qYonjln018BpDH5ErYiVRN7oDbW16g4Y/LYNOvN7FAFiss4F5ezQ24umFDNKpK
         ctvqlpggVlHYLSk0MnMTeiC75R/TJ2VO2/Ek0DRp+C3KB1kteQS3wnc9NZKz3e0iAa
         dTh9XDvtgQbxXbQ3AYqBkwKNwzhIsfORo73vWKUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0387/1039] Bluetooth: hci_qca: Fix NULL vs IS_ERR_OR_NULL check in qca_serdev_probe
Date:   Mon, 24 Jan 2022 19:36:16 +0100
Message-Id: <20220124184138.327483962@linuxfoundation.org>
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
index 9e99311038ae8..f6e91fb432a3b 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2059,14 +2059,14 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 
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
@@ -2088,7 +2088,7 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 
 		qcadev->bt_en = devm_gpiod_get_optional(&serdev->dev, "enable",
 					       GPIOD_OUT_LOW);
-		if (!qcadev->bt_en) {
+		if (IS_ERR_OR_NULL(qcadev->bt_en)) {
 			dev_warn(&serdev->dev, "failed to acquire enable gpio\n");
 			power_ctrl_enabled = false;
 		}
-- 
2.34.1



