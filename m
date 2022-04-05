Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B3F4F276E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbiDEIGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236264AbiDEIBw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:01:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3311549FB3;
        Tue,  5 Apr 2022 00:59:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3C41B81B16;
        Tue,  5 Apr 2022 07:59:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26811C340EE;
        Tue,  5 Apr 2022 07:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145591;
        bh=bSHnxBfTeFa9LiNJveLBByEKIzdv4qri4DryIuhPjVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVwvpLzME9eVCmY/PuDVxg1jcOv5gwJDJvlT7ouLfvQNPPVpYkf+w6xeZu0laXWYZ
         X4qE1feUBwX9/9bXH9ypwCzQ+HJzXt1GyBwbW9O/cGujuOhia8woBVX8si+P28TmOT
         7V5foR8DeHvR8QzZraV/1ahwLbpoL1nSm+DXPANI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brett Creeley <brett@pensando.io>,
        Shannon Nelson <snelson@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0458/1126] ionic: Dont send reset commands if FW isnt running
Date:   Tue,  5 Apr 2022 09:20:05 +0200
Message-Id: <20220405070421.068992989@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brett Creeley <brett@pensando.io>

[ Upstream commit b8fd0271dad00b953caaabe73474788d3d19e252 ]

It's possible the FW is already shutting down while the driver is being
removed and/or when the driver is going through reset. This can cause
unexpected/unnecessary errors to be printed:

eth0: DEV_CMD IONIC_CMD_PORT_RESET (12) error, IONIC_RC_ERROR (29) failed
eth1: DEV_CMD IONIC_CMD_RESET (3) error, IONIC_RC_ERROR (29) failed

Fix this by checking the FW status register before issuing the reset
commands.

Also, since err may not be assigned in ionic_port_reset(), assign it a
default value of 0, and remove an unnecessary log message.

Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
Signed-off-by: Brett Creeley <brett@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/pensando/ionic/ionic_dev.c    | 17 ++++++++++++-----
 .../net/ethernet/pensando/ionic/ionic_dev.h    |  1 +
 .../net/ethernet/pensando/ionic/ionic_main.c   | 18 ++++++++++--------
 3 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 4044c630f8b4..2c7ce820a1fa 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -129,6 +129,16 @@ int ionic_dev_setup(struct ionic *ionic)
 }
 
 /* Devcmd Interface */
+bool ionic_is_fw_running(struct ionic_dev *idev)
+{
+	u8 fw_status = ioread8(&idev->dev_info_regs->fw_status);
+
+	/* firmware is useful only if the running bit is set and
+	 * fw_status != 0xff (bad PCI read)
+	 */
+	return (fw_status != 0xff) && (fw_status & IONIC_FW_STS_F_RUNNING);
+}
+
 int ionic_heartbeat_check(struct ionic *ionic)
 {
 	struct ionic_dev *idev = &ionic->idev;
@@ -152,13 +162,10 @@ int ionic_heartbeat_check(struct ionic *ionic)
 		goto do_check_time;
 	}
 
-	/* firmware is useful only if the running bit is set and
-	 * fw_status != 0xff (bad PCI read)
-	 * If fw_status is not ready don't bother with the generation.
-	 */
 	fw_status = ioread8(&idev->dev_info_regs->fw_status);
 
-	if (fw_status == 0xff || !(fw_status & IONIC_FW_STS_F_RUNNING)) {
+	/* If fw_status is not ready don't bother with the generation */
+	if (!ionic_is_fw_running(idev)) {
 		fw_status_ready = false;
 	} else {
 		fw_generation = fw_status & IONIC_FW_STS_F_GENERATION;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index e5acf3bd62b2..73b950ac1272 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -353,5 +353,6 @@ void ionic_q_rewind(struct ionic_queue *q, struct ionic_desc_info *start);
 void ionic_q_service(struct ionic_queue *q, struct ionic_cq_info *cq_info,
 		     unsigned int stop_index);
 int ionic_heartbeat_check(struct ionic *ionic);
+bool ionic_is_fw_running(struct ionic_dev *idev);
 
 #endif /* _IONIC_DEV_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index a89ad768e4a0..a548f2a01806 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -540,6 +540,9 @@ int ionic_reset(struct ionic *ionic)
 	struct ionic_dev *idev = &ionic->idev;
 	int err;
 
+	if (!ionic_is_fw_running(idev))
+		return 0;
+
 	mutex_lock(&ionic->dev_cmd_lock);
 	ionic_dev_cmd_reset(idev);
 	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
@@ -612,15 +615,17 @@ int ionic_port_init(struct ionic *ionic)
 int ionic_port_reset(struct ionic *ionic)
 {
 	struct ionic_dev *idev = &ionic->idev;
-	int err;
+	int err = 0;
 
 	if (!idev->port_info)
 		return 0;
 
-	mutex_lock(&ionic->dev_cmd_lock);
-	ionic_dev_cmd_port_reset(idev);
-	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
-	mutex_unlock(&ionic->dev_cmd_lock);
+	if (ionic_is_fw_running(idev)) {
+		mutex_lock(&ionic->dev_cmd_lock);
+		ionic_dev_cmd_port_reset(idev);
+		err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+		mutex_unlock(&ionic->dev_cmd_lock);
+	}
 
 	dma_free_coherent(ionic->dev, idev->port_info_sz,
 			  idev->port_info, idev->port_info_pa);
@@ -628,9 +633,6 @@ int ionic_port_reset(struct ionic *ionic)
 	idev->port_info = NULL;
 	idev->port_info_pa = 0;
 
-	if (err)
-		dev_err(ionic->dev, "Failed to reset port\n");
-
 	return err;
 }
 
-- 
2.34.1



