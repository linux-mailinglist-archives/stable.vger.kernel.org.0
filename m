Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4FA2475C1
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbgHQT2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:28:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729543AbgHQPcv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:32:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88733207DA;
        Mon, 17 Aug 2020 15:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678370;
        bh=9HeIzrmHQq+22kiEWxMHq/fH8O2AEp9O0/1ippdIg+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YwdszYhJ5MH5KoFQLpCBkmJEWJrkeKSLfZUqu+dEOGS1fcQLL33AnDgEMo5hMzf6e
         8Vtni+4L1XepS85cErqNa/Oks0DPFkwxOqJSQg0ris4fswos/vw7YGembCzu+90EMa
         GqfhwmSVR1/aoSwzjv6PlBFel970En4Q6fKHckLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 310/464] Bluetooth: hci_qca: Stop collecting memdump again for command timeout during SSR
Date:   Mon, 17 Aug 2020 17:14:23 +0200
Message-Id: <20200817143848.645835804@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>

[ Upstream commit 58789a1990c1a849a461ac912e72a698a771951a ]

Setting memdump state to idle prior to setting of callback function
pointer for command timeout to NULL,causing the issue.Now moved the
initialisation of memdump state to qca_setup().

Fixes: d841502c79e3 ("Bluetooth: hci_qca: Collect controller memory dump during SSR")
Signed-off-by: Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 483766b745178..9150b0c3f302a 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1676,6 +1676,8 @@ static int qca_setup(struct hci_uart *hu)
 	bt_dev_info(hdev, "setting up %s",
 		qca_is_wcn399x(soc_type) ? "wcn399x" : "ROME/QCA6390");
 
+	qca->memdump_state = QCA_MEMDUMP_IDLE;
+
 retry:
 	ret = qca_power_on(hdev);
 	if (ret)
@@ -1825,9 +1827,6 @@ static void qca_power_shutdown(struct hci_uart *hu)
 	qca_flush(hu);
 	spin_unlock_irqrestore(&qca->hci_ibs_lock, flags);
 
-	hu->hdev->hw_error = NULL;
-	hu->hdev->cmd_timeout = NULL;
-
 	/* Non-serdev device usually is powered by external power
 	 * and don't need additional action in driver for power down
 	 */
@@ -1849,6 +1848,9 @@ static int qca_power_off(struct hci_dev *hdev)
 	struct qca_data *qca = hu->priv;
 	enum qca_btsoc_type soc_type = qca_soc_type(hu);
 
+	hu->hdev->hw_error = NULL;
+	hu->hdev->cmd_timeout = NULL;
+
 	/* Stop sending shutdown command if soc crashes. */
 	if (soc_type != QCA_ROME
 		&& qca->memdump_state == QCA_MEMDUMP_IDLE) {
@@ -1856,7 +1858,6 @@ static int qca_power_off(struct hci_dev *hdev)
 		usleep_range(8000, 10000);
 	}
 
-	qca->memdump_state = QCA_MEMDUMP_IDLE;
 	qca_power_shutdown(hu);
 	return 0;
 }
-- 
2.25.1



