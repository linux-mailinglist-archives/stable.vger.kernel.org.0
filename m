Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0565D323C9F
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235199AbhBXMwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 07:52:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:50148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233834AbhBXMv6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:51:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9464464EEC;
        Wed, 24 Feb 2021 12:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171037;
        bh=qW38qW/K88E7dBMpwGtAuCpUpPX/oXWt5JFBqki4zYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LqQZsgh9DYmGfBJ1CnlGzSRil8HqDqQMjzW7esLep586fisN2imj8I8E8fym4kHNj
         PrWYc7X+JOm/R9CJJHt4HvOnHOTat2VXTVd74t258Q+IErOhb9AQwSFr53byv1vKYK
         CZdiHiVvjOqsJr4AQqOtOzlHvtV9Cqqu/mW3fZjVo+RBc3GQfpuLVitrOQAgsenXuG
         7ur/5Yq7cHsKprnSK29f5/AIwVbJe9+ZmKB6ezYhriQ6se8+zVdRuGwGRSd7xN5FvB
         xmQs0Ym1x0jj1O+YcfRA/z/Zlam1I+LTUbbyaN5NdA/055xMLdlchBzK3XKqc6Alko
         QYsZUijDtAGvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Claire Chang <tientzu@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 08/67] Bluetooth: hci_h5: Set HCI_QUIRK_SIMULTANEOUS_DISCOVERY for btrtl
Date:   Wed, 24 Feb 2021 07:49:26 -0500
Message-Id: <20210224125026.481804-8-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claire Chang <tientzu@chromium.org>

[ Upstream commit 7f9f2c3f7d99b8ae773459c74ac5e99a0dd46db9 ]

Realtek Bluetooth controllers can do both LE scan and BR/EDR inquiry
at once, need to set HCI_QUIRK_SIMULTANEOUS_DISCOVERY quirk.

Signed-off-by: Claire Chang <tientzu@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_h5.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index 7be16a7f653bd..95ecd30e6619e 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -906,6 +906,11 @@ static int h5_btrtl_setup(struct h5 *h5)
 	/* Give the device some time before the hci-core sends it a reset */
 	usleep_range(10000, 20000);
 
+	/* Enable controller to do both LE scan and BR/EDR inquiry
+	 * simultaneously.
+	 */
+	set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &h5->hu->hdev->quirks);
+
 out_free:
 	btrtl_free(btrtl_dev);
 
-- 
2.27.0

