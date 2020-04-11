Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8A831A5B2E
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbgDKXEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:04:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727361AbgDKXEn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:04:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75C12214D8;
        Sat, 11 Apr 2020 23:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646283;
        bh=A6KO02u9HP+jDAo+joquhsaqmcvlEcEHNFs8Fwa8mA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VLH2/BqniR7QpE6CAhmjJTH22BNSrrzpVyfxtl0Kq98XaAphI16e9P5lqyHuhw37P
         olLOtfZWrWW6QA4glKjZ4mHIwjVcNQrUwRnucDIgw6gjnmP6T6SoMmh9V3VrOnA/ox
         vroaEzB0rHE9u+VafufOf+ge69FyjS7xPzuhzGE4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rocky Liao <rjliao@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 045/149] Bluetooth: hci_qca: Not send vendor pre-shutdown command for QCA Rome
Date:   Sat, 11 Apr 2020 19:02:02 -0400
Message-Id: <20200411230347.22371-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rocky Liao <rjliao@codeaurora.org>

[ Upstream commit 4f9ed5bd63dc16d061cdeb00eeff9d56e86a6beb ]

QCA Rome doesn't support the pre-shutdown vendor hci command, this patch
will check the soc type in qca_power_off() and only send this command
for wcn399x.

Fixes: ae563183b647 ("Bluetooth: hci_qca: Enable power off/on support during hci down/up for QCA Rome")
Signed-off-by: Rocky Liao <rjliao@codeaurora.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index d6e0c99ee5eb1..7e5a097bd0ed8 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1726,9 +1726,11 @@ static int qca_power_off(struct hci_dev *hdev)
 {
 	struct hci_uart *hu = hci_get_drvdata(hdev);
 	struct qca_data *qca = hu->priv;
+	enum qca_btsoc_type soc_type = qca_soc_type(hu);
 
 	/* Stop sending shutdown command if soc crashes. */
-	if (qca->memdump_state == QCA_MEMDUMP_IDLE) {
+	if (qca_is_wcn399x(soc_type)
+		&& qca->memdump_state == QCA_MEMDUMP_IDLE) {
 		qca_send_pre_shutdown_cmd(hdev);
 		usleep_range(8000, 10000);
 	}
-- 
2.20.1

