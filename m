Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29F1328C5A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbhCASuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:50:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:53755 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237839AbhCASoG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:44:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F89464FC8;
        Mon,  1 Mar 2021 17:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620488;
        bh=V5AWefLF0sRCYMocX0u25yi5NC1clN+qL8PSRF8RwxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CBzjA76RXhwXz4zB06LiCBLHlGBObI3YkvUzMfJNDAFZe2vsBYXaMyy3Si+OqMfGn
         Ds8qxZv/3sBWd8/g1qkR0OBQZe4c9qSE/YJ+1+L39GFi+Zuicxn5UQldiuXRYpumQI
         hbkTIyc/johgAdT6+DCY94RdGiUgC4oRg4uh/0hk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 142/775] Bluetooth: hci_qca: Wait for SSR completion during suspend
Date:   Mon,  1 Mar 2021 17:05:10 +0100
Message-Id: <20210301161208.668513893@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>

[ Upstream commit ad3a9c0ec2d2baed936cfdd05870f9d1e1f40e0e ]

During SSR after memory dump collection,BT controller will be powered off,
powered on and then FW will be downloaded.During suspend if BT controller
is powered off due to SSR then we should wait until SSR is completed and
then suspend.

Fixes: 2be43abac5a8 ("Bluetooth: hci_qca: Wait for timeout during suspend")
Signed-off-by: Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 5dbcb7c42b805..17a3859326dc7 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -50,7 +50,8 @@
 #define IBS_HOST_TX_IDLE_TIMEOUT_MS	2000
 #define CMD_TRANS_TIMEOUT_MS		100
 #define MEMDUMP_TIMEOUT_MS		8000
-#define IBS_DISABLE_SSR_TIMEOUT_MS	(MEMDUMP_TIMEOUT_MS + 1000)
+#define IBS_DISABLE_SSR_TIMEOUT_MS \
+	(MEMDUMP_TIMEOUT_MS + FW_DOWNLOAD_TIMEOUT_MS)
 #define FW_DOWNLOAD_TIMEOUT_MS		3000
 
 /* susclk rate */
@@ -2102,7 +2103,12 @@ static int __maybe_unused qca_suspend(struct device *dev)
 
 	set_bit(QCA_SUSPENDING, &qca->flags);
 
-	if (test_bit(QCA_BT_OFF, &qca->flags))
+	/* During SSR after memory dump collection, controller will be
+	 * powered off and then powered on.If controller is powered off
+	 * during SSR then we should wait until SSR is completed.
+	 */
+	if (test_bit(QCA_BT_OFF, &qca->flags) &&
+	    !test_bit(QCA_SSR_TRIGGERED, &qca->flags))
 		return 0;
 
 	if (test_bit(QCA_IBS_DISABLED, &qca->flags)) {
@@ -2112,7 +2118,7 @@ static int __maybe_unused qca_suspend(struct device *dev)
 
 		/* QCA_IBS_DISABLED flag is set to true, During FW download
 		 * and during memory dump collection. It is reset to false,
-		 * After FW download complete and after memory dump collections.
+		 * After FW download complete.
 		 */
 		wait_on_bit_timeout(&qca->flags, QCA_IBS_DISABLED,
 			    TASK_UNINTERRUPTIBLE, msecs_to_jiffies(wait_timeout));
@@ -2124,10 +2130,6 @@ static int __maybe_unused qca_suspend(struct device *dev)
 		}
 	}
 
-	/* After memory dump collection, Controller is powered off.*/
-	if (test_bit(QCA_BT_OFF, &qca->flags))
-		return 0;
-
 	cancel_work_sync(&qca->ws_awake_device);
 	cancel_work_sync(&qca->ws_awake_rx);
 
-- 
2.27.0



