Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFE326EC7
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730633AbfEVTvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:51:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731206AbfEVT0W (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:26:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D26121473;
        Wed, 22 May 2019 19:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553181;
        bh=JN7DAyu81eNfQKpvA28BwDa3RsDFP+X9/NVf49fRkp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s/Ajm/rlyI/BJGYwnEn5m+kG+xMBEskC/pUY72BQFHpWlM2Twcw8VReZymZFYEvnT
         Yj2VehG5NqRAhBSxalMMK5z4hTMuPjr4EIEBM1r2Xjx13fPpOQIItpnwfCuKdIkQuD
         BSLozu9gT2E7CmXHOPkD24XqlUeEA1+b/1PvK2no=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Rocky Liao <rjliao@codeaurora.org>,
        Claire Chang <tientzu@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 097/317] Bluetooth: hci_qca: Give enough time to ROME controller to bootup.
Date:   Wed, 22 May 2019 15:19:58 -0400
Message-Id: <20190522192338.23715-97-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Balakrishna Godavarthi <bgodavar@codeaurora.org>

[ Upstream commit 7f09d5a6c33be66a5ca19bf9dd1c2d90c5dfcf0d ]

This patch enables enough time to ROME controller to bootup
after we bring the enable pin out of reset.

Fixes: 05ba533c5c11 ("Bluetooth: hci_qca: Add serdev support").
Signed-off-by: Balakrishna Godavarthi <bgodavar@codeaurora.org>
Reviewed-by: Rocky Liao <rjliao@codeaurora.org>
Tested-by: Rocky Liao <rjliao@codeaurora.org>
Tested-by: Claire Chang <tientzu@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index f036c8f98ea33..97bc17670b7aa 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -508,6 +508,8 @@ static int qca_open(struct hci_uart *hu)
 		qcadev = serdev_device_get_drvdata(hu->serdev);
 		if (qcadev->btsoc_type != QCA_WCN3990) {
 			gpiod_set_value_cansleep(qcadev->bt_en, 1);
+			/* Controller needs time to bootup. */
+			msleep(150);
 		} else {
 			hu->init_speed = qcadev->init_speed;
 			hu->oper_speed = qcadev->oper_speed;
-- 
2.20.1

