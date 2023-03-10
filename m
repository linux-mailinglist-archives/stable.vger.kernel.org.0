Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2866B47E6
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbjCJO41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:56:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbjCJOy5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:54:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9E01241F0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:50:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B3E461A0A
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2713AC433D2;
        Fri, 10 Mar 2023 14:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459826;
        bh=qDI50Od0kKhb3QlAkkHlWiz99f9rmKiIY2EBGSUhRXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1kWYJvTagRq0oMDq5PmzwWW0V3ystkW7HN34XU3Hjpae7ntOyV4QrzAW0MIDM1KVV
         NKvdCG7GXayDpvgwRoLtjyUvZh+Ly79aeWQb0c0l53BZ12OHTE6H6SNaEPNscawfZ3
         qJ8Xw45d5NcsiCBchthYvVxMJk2K1zMxLoLf+Isk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 133/529] wifi: iwl4965: Add missing check for create_singlethread_workqueue()
Date:   Fri, 10 Mar 2023 14:34:36 +0100
Message-Id: <20230310133811.134197435@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 26e6775f75517ad6844fe5b79bc5f3fa8c22ee61 ]

Add the check for the return value of the create_singlethread_workqueue()
in order to avoid NULL pointer dereference.

Fixes: b481de9ca074 ("[IWLWIFI]: add iwlwifi wireless drivers")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230209010748.45454-1-jiasheng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlegacy/4965-mac.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index 28675a4ad8612..12cf22d0e9949 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -6212,10 +6212,12 @@ il4965_bg_txpower_work(struct work_struct *work)
 	mutex_unlock(&il->mutex);
 }
 
-static void
+static int
 il4965_setup_deferred_work(struct il_priv *il)
 {
 	il->workqueue = create_singlethread_workqueue(DRV_NAME);
+	if (!il->workqueue)
+		return -ENOMEM;
 
 	init_waitqueue_head(&il->wait_command_queue);
 
@@ -6234,6 +6236,8 @@ il4965_setup_deferred_work(struct il_priv *il)
 	timer_setup(&il->watchdog, il_bg_watchdog, 0);
 
 	tasklet_setup(&il->irq_tasklet, il4965_irq_tasklet);
+
+	return 0;
 }
 
 static void
@@ -6623,7 +6627,10 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_disable_msi;
 	}
 
-	il4965_setup_deferred_work(il);
+	err = il4965_setup_deferred_work(il);
+	if (err)
+		goto out_free_irq;
+
 	il4965_setup_handlers(il);
 
 	/*********************************************
@@ -6661,6 +6668,7 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 out_destroy_workqueue:
 	destroy_workqueue(il->workqueue);
 	il->workqueue = NULL;
+out_free_irq:
 	free_irq(il->pci_dev->irq, il);
 out_disable_msi:
 	pci_disable_msi(il->pci_dev);
-- 
2.39.2



