Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D23912C70C
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732011AbfL2RxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:53:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732167AbfL2RxU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:53:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E143206A4;
        Sun, 29 Dec 2019 17:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642000;
        bh=q6zEIwie9rdXxldDaGNMf4+uXkOVStGIjIVv2ZHoWX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1AcGmaR0jM3F3epTQkZW5eD5mIt2ofV6YSdNfOzPSnQQ4bJ6cCE+fuhnCltCzexM6
         gyergfb+BoHJkEd7KfjQLnrIf071ZK2CquoWMoF/raN6/oEecmsqHUKnV+JRsQe6wj
         N1LmsMwGjvlm6VsSXnlSWq/qh27P6700/ZC+0b1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 300/434] qtnfmac: fix debugfs support for multiple cards
Date:   Sun, 29 Dec 2019 18:25:53 +0100
Message-Id: <20191229172721.878757153@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

[ Upstream commit dd4c2260dab04f5ae7bdb79b9470e7da56f48145 ]

Fix merge artifact for commit 0b68fe10b8e8 ("qtnfmac: modify debugfs
to support multiple cards") and finally add debugfs support
for multiple qtnfmac wireless cards.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
index 8ae318b5fe54..4824be0c6231 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
@@ -130,6 +130,8 @@ static int qtnf_dbg_shm_stats(struct seq_file *s, void *data)
 
 int qtnf_pcie_fw_boot_done(struct qtnf_bus *bus)
 {
+	struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
+	char card_id[64];
 	int ret;
 
 	bus->fw_state = QTNF_FW_STATE_BOOT_DONE;
@@ -137,7 +139,9 @@ int qtnf_pcie_fw_boot_done(struct qtnf_bus *bus)
 	if (ret) {
 		pr_err("failed to attach core\n");
 	} else {
-		qtnf_debugfs_init(bus, DRV_NAME);
+		snprintf(card_id, sizeof(card_id), "%s:%s",
+			 DRV_NAME, pci_name(priv->pdev));
+		qtnf_debugfs_init(bus, card_id);
 		qtnf_debugfs_add_entry(bus, "mps", qtnf_dbg_mps_show);
 		qtnf_debugfs_add_entry(bus, "msi_enabled", qtnf_dbg_msi_show);
 		qtnf_debugfs_add_entry(bus, "shm_stats", qtnf_dbg_shm_stats);
-- 
2.20.1



