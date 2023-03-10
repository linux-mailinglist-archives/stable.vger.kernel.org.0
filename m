Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5BA6B454C
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbjCJOcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232354AbjCJOcf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:32:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179A8B1A46
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:31:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0260B822AD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BC6C433EF;
        Fri, 10 Mar 2023 14:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458693;
        bh=CxPYn+Gu463fG4AiFmfINjbxKhWNW3i8tuywiiCZ5YA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9TdKqVDcrc1SauRY+ZVFmKQvylWYmvSVP5OhkZTXZ5dRbLALVP4PhHpMt9CbC0w6
         6wO5PJ44NlvHWBrXhPKkEDU6/8HgoAk0DYM6m2+uOSLvM9SsAN+XwWw0F1NHBcSXNt
         qJnV9+pOKfuaA45qfW+0C6BOtZB7Up8bGz7QvPfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/357] wifi: iwl4965: Add missing check for create_singlethread_workqueue()
Date:   Fri, 10 Mar 2023 14:36:15 +0100
Message-Id: <20230310133737.790606374@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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
index 5fe17039a3375..feeb57cadc1ca 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -6217,10 +6217,12 @@ il4965_bg_txpower_work(struct work_struct *work)
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
 
@@ -6241,6 +6243,8 @@ il4965_setup_deferred_work(struct il_priv *il)
 	tasklet_init(&il->irq_tasklet,
 		     il4965_irq_tasklet,
 		     (unsigned long)il);
+
+	return 0;
 }
 
 static void
@@ -6630,7 +6634,10 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_disable_msi;
 	}
 
-	il4965_setup_deferred_work(il);
+	err = il4965_setup_deferred_work(il);
+	if (err)
+		goto out_free_irq;
+
 	il4965_setup_handlers(il);
 
 	/*********************************************
@@ -6668,6 +6675,7 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 out_destroy_workqueue:
 	destroy_workqueue(il->workqueue);
 	il->workqueue = NULL;
+out_free_irq:
 	free_irq(il->pci_dev->irq, il);
 out_disable_msi:
 	pci_disable_msi(il->pci_dev);
-- 
2.39.2



