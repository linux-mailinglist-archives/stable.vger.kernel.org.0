Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE9F85A4890
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbiH2LMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiH2LME (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:12:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4630510FE3;
        Mon, 29 Aug 2022 04:08:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4536F611F6;
        Mon, 29 Aug 2022 11:08:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C612C433D6;
        Mon, 29 Aug 2022 11:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771311;
        bh=aLdWFR5wEm6zyaeL8KqBO/XNyw1A9J06VUNrOdhPi8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eekw0xVWw8E8vB5fyIUuufyJJ6CNlxPBmZZ2gqtZ74Y9VqDWv7YKmwFuhbHvL9HkP
         YhLuTuouvZpb7uXPCMrIW5byG9IyHoz4M/u0WUeEsjTAltEE58uh6Zy/aXgM2HKjnX
         lEJ9EAblErtEh79A9ce6sX8VvnVuVdxBcChdVA/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/136] ionic: widen queue_lock use around lif init and deinit
Date:   Mon, 29 Aug 2022 12:59:17 +0200
Message-Id: <20220829105808.351834789@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit 2624d95972dbebe5f226361bfc51a83bdb68c93b ]

Widen the coverage of the queue_lock to be sure the lif init
and lif deinit actions are protected.  This addresses a hang
seen when a Tx Timeout action was attempted at the same time
as a FW Reset was started.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 781313dbd04f2..abfb5efc52b86 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2974,11 +2974,10 @@ static void ionic_lif_handle_fw_down(struct ionic_lif *lif)
 
 	netif_device_detach(lif->netdev);
 
+	mutex_lock(&lif->queue_lock);
 	if (test_bit(IONIC_LIF_F_UP, lif->state)) {
 		dev_info(ionic->dev, "Surprise FW stop, stopping queues\n");
-		mutex_lock(&lif->queue_lock);
 		ionic_stop_queues(lif);
-		mutex_unlock(&lif->queue_lock);
 	}
 
 	if (netif_running(lif->netdev)) {
@@ -2989,6 +2988,8 @@ static void ionic_lif_handle_fw_down(struct ionic_lif *lif)
 	ionic_reset(ionic);
 	ionic_qcqs_free(lif);
 
+	mutex_unlock(&lif->queue_lock);
+
 	dev_info(ionic->dev, "FW Down: LIFs stopped\n");
 }
 
@@ -3012,9 +3013,12 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 	err = ionic_port_init(ionic);
 	if (err)
 		goto err_out;
+
+	mutex_lock(&lif->queue_lock);
+
 	err = ionic_qcqs_alloc(lif);
 	if (err)
-		goto err_out;
+		goto err_unlock;
 
 	err = ionic_lif_init(lif);
 	if (err)
@@ -3035,6 +3039,8 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 			goto err_txrx_free;
 	}
 
+	mutex_unlock(&lif->queue_lock);
+
 	clear_bit(IONIC_LIF_F_FW_RESET, lif->state);
 	ionic_link_status_check_request(lif, CAN_SLEEP);
 	netif_device_attach(lif->netdev);
@@ -3051,6 +3057,8 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 	ionic_lif_deinit(lif);
 err_qcqs_free:
 	ionic_qcqs_free(lif);
+err_unlock:
+	mutex_unlock(&lif->queue_lock);
 err_out:
 	dev_err(ionic->dev, "FW Up: LIFs restart failed - err %d\n", err);
 }
-- 
2.35.1



