Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3485E49950F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392138AbiAXUuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:50:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389732AbiAXUm6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:42:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BC5C04967A;
        Mon, 24 Jan 2022 11:53:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F99460B02;
        Mon, 24 Jan 2022 19:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3F6C36AE9;
        Mon, 24 Jan 2022 19:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053981;
        bh=EdRBPmg9UuzN3RscHx/sISlmgsII/q5Oql95LbXNop0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JglY1Pcb11z48W8Ayv51vQTBUR/iXXTqciITs6xLa/Zo4IbugFZW++tVK14HT6rRf
         ilWy8svjnw6oiBfuoiHPWCyH1FELTwroq6KAgZYRf57q2NKVnjHWbKBmcOLVh2mp54
         jhwk6aq8/qSGibf/wwJkB5CGPpm/Y3hWRm0Sioi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 213/563] Bluetooth: hci_qca: Fix NULL vs IS_ERR_OR_NULL check in qca_serdev_probe
Date:   Mon, 24 Jan 2022 19:39:38 +0100
Message-Id: <20220124184031.819170738@linuxfoundation.org>
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
 drivers/bluetooth/hci_qca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 4f8a32601c1b6..dc7ee5dd2eeca 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1990,7 +1990,7 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 
 		qcadev->bt_en = devm_gpiod_get_optional(&serdev->dev, "enable",
 					       GPIOD_OUT_LOW);
-		if (!qcadev->bt_en) {
+		if (IS_ERR_OR_NULL(qcadev->bt_en)) {
 			dev_warn(&serdev->dev, "failed to acquire enable gpio\n");
 			power_ctrl_enabled = false;
 		}
-- 
2.34.1



