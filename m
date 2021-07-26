Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF88C3D61DD
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233990AbhGZPdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232754AbhGZPbW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:31:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC765604AC;
        Mon, 26 Jul 2021 16:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315910;
        bh=FgK9NZuTa9AKJ+M+a+SkaDwispSR9I/vi0k5rtH8yE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+veGjOeEZy5Y8xvHqGlJtKtOPwylkLLDe01SYY0OYLy0vqdoKKkxq7TQOIGidonu
         d1ZFEnDeSZa0W3X1ccgDM7G6eVXN7TTfPkc2gsAK6XYQh2YJE9PqTju9/2cF01ZS9n
         9LjcFJ87ePYfAXnpsQvweQ4wXenBCheXCzqSNtaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Somnath Kotur <somnath.kotur@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 107/223] bnxt_en: fix error path of FW reset
Date:   Mon, 26 Jul 2021 17:38:19 +0200
Message-Id: <20210726153849.779301572@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Somnath Kotur <somnath.kotur@broadcom.com>

[ Upstream commit 3958b1da725a477b4a222183d16a14d85445d4b6 ]

When bnxt_open() fails in the firmware reset path, the driver needs to
gracefully abort, but it is executing code that should be invoked only
in the success path.  Define a function to abort FW reset and
consolidate all error paths to call this new function.

Fixes: dab62e7c2de7 ("bnxt_en: Implement faster recovery for firmware fatal error.")
Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 31 +++++++++++++++--------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 07efab5bad95..49aca3289c00 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11849,10 +11849,21 @@ static bool bnxt_fw_reset_timeout(struct bnxt *bp)
 			  (bp->fw_reset_max_dsecs * HZ / 10));
 }
 
+static void bnxt_fw_reset_abort(struct bnxt *bp, int rc)
+{
+	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+	if (bp->fw_reset_state != BNXT_FW_RESET_STATE_POLL_VF) {
+		bnxt_ulp_start(bp, rc);
+		bnxt_dl_health_status_update(bp, false);
+	}
+	bp->fw_reset_state = 0;
+	dev_close(bp->dev);
+}
+
 static void bnxt_fw_reset_task(struct work_struct *work)
 {
 	struct bnxt *bp = container_of(work, struct bnxt, fw_reset_task.work);
-	int rc;
+	int rc = 0;
 
 	if (!test_bit(BNXT_STATE_IN_FW_RESET, &bp->state)) {
 		netdev_err(bp->dev, "bnxt_fw_reset_task() called when not in fw reset mode!\n");
@@ -11883,8 +11894,9 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		bp->fw_reset_timestamp = jiffies;
 		rtnl_lock();
 		if (test_bit(BNXT_STATE_ABORT_ERR, &bp->state)) {
+			bnxt_fw_reset_abort(bp, rc);
 			rtnl_unlock();
-			goto fw_reset_abort;
+			return;
 		}
 		bnxt_fw_reset_close(bp);
 		if (bp->fw_cap & BNXT_FW_CAP_ERR_RECOVER_RELOAD) {
@@ -11933,6 +11945,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 			if (val == 0xffff) {
 				if (bnxt_fw_reset_timeout(bp)) {
 					netdev_err(bp->dev, "Firmware reset aborted, PCI config space invalid\n");
+					rc = -ETIMEDOUT;
 					goto fw_reset_abort;
 				}
 				bnxt_queue_fw_reset_work(bp, HZ / 1000);
@@ -11942,6 +11955,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		clear_bit(BNXT_STATE_FW_FATAL_COND, &bp->state);
 		if (pci_enable_device(bp->pdev)) {
 			netdev_err(bp->dev, "Cannot re-enable PCI device\n");
+			rc = -ENODEV;
 			goto fw_reset_abort;
 		}
 		pci_set_master(bp->pdev);
@@ -11968,9 +11982,10 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		}
 		rc = bnxt_open(bp->dev);
 		if (rc) {
-			netdev_err(bp->dev, "bnxt_open_nic() failed\n");
-			clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
-			dev_close(bp->dev);
+			netdev_err(bp->dev, "bnxt_open() failed during FW reset\n");
+			bnxt_fw_reset_abort(bp, rc);
+			rtnl_unlock();
+			return;
 		}
 
 		bp->fw_reset_state = 0;
@@ -11997,12 +12012,8 @@ fw_reset_abort_status:
 		netdev_err(bp->dev, "fw_health_status 0x%x\n", sts);
 	}
 fw_reset_abort:
-	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
-	if (bp->fw_reset_state != BNXT_FW_RESET_STATE_POLL_VF)
-		bnxt_dl_health_status_update(bp, false);
-	bp->fw_reset_state = 0;
 	rtnl_lock();
-	dev_close(bp->dev);
+	bnxt_fw_reset_abort(bp, rc);
 	rtnl_unlock();
 }
 
-- 
2.30.2



