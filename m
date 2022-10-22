Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11728608A72
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbiJVIzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235066AbiJVIyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:54:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6291B63D0A;
        Sat, 22 Oct 2022 01:13:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09A31B82E3B;
        Sat, 22 Oct 2022 08:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47030C433D7;
        Sat, 22 Oct 2022 08:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425650;
        bh=PytxVOSr5jFXPJQvawqoj1wVm66oLH6DZCYSKa7TKrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TEejyQoY9+lqSWWPoD1x6kdgalZlYzzbAk+l6H6g+EIkns4v/Xdd0U+fxo4xrsPT/
         ih4lKcKVXHCvZr9vBsFR0saiDsefLLq2sMwjFhRDfUVyNHpGEZsJ1FMeCtYb3LO7zb
         YxDs9Ls+FNGeLrZohaBqDYNkgUa7ACx7oZfsKCQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 571/717] wifi: ath11k: Register shutdown handler for WCN6750
Date:   Sat, 22 Oct 2022 09:27:30 +0200
Message-Id: <20221022072523.662784372@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manikanta Pubbisetty <quic_mpubbise@quicinc.com>

[ Upstream commit ac41c2b642b136a1e633379fcb87a9db0ee07f5b ]

When the system shuts down, SMMU driver will be stopped and
will not assist in IOVA translations. SMMU driver expects all
of its consumers to shutdown before shutting down itself.
WCN6750 being one of the consumer device should not perform any
DMA operations after the SMMU has shutdown which will otherwise
result in SMMU faults.

SMMU driver will call the shutdown() callback of all its
consumer devices and the consumers shall stop further DMA
activity after the invocation of their respective shutdown()
callbacks.

Register the shutdown() callback to the platform core for WCN6750.
Change will not impact other AHB ath11k devices.

Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.1.0.1-00887-QCAMSLSWPLZ-1

Signed-off-by: Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220720134710.15523-1-quic_mpubbise@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/ahb.c  | 58 ++++++++++++++++++++------
 drivers/net/wireless/ath/ath11k/core.c |  2 +
 2 files changed, 47 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index c47414710138..911eee9646a4 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -1088,20 +1088,10 @@ static int ath11k_ahb_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int ath11k_ahb_remove(struct platform_device *pdev)
+static void ath11k_ahb_remove_prepare(struct ath11k_base *ab)
 {
-	struct ath11k_base *ab = platform_get_drvdata(pdev);
 	unsigned long left;
 
-	if (test_bit(ATH11K_FLAG_QMI_FAIL, &ab->dev_flags)) {
-		ath11k_ahb_power_down(ab);
-		ath11k_debugfs_soc_destroy(ab);
-		ath11k_qmi_deinit_service(ab);
-		goto qmi_fail;
-	}
-
-	reinit_completion(&ab->driver_recovery);
-
 	if (test_bit(ATH11K_FLAG_RECOVERY, &ab->dev_flags)) {
 		left = wait_for_completion_timeout(&ab->driver_recovery,
 						   ATH11K_AHB_RECOVERY_TIMEOUT);
@@ -1111,19 +1101,60 @@ static int ath11k_ahb_remove(struct platform_device *pdev)
 
 	set_bit(ATH11K_FLAG_UNREGISTERING, &ab->dev_flags);
 	cancel_work_sync(&ab->restart_work);
+	cancel_work_sync(&ab->qmi.event_work);
+}
+
+static void ath11k_ahb_free_resources(struct ath11k_base *ab)
+{
+	struct platform_device *pdev = ab->pdev;
 
-	ath11k_core_deinit(ab);
-qmi_fail:
 	ath11k_ahb_free_irq(ab);
 	ath11k_hal_srng_deinit(ab);
 	ath11k_ahb_fw_resource_deinit(ab);
 	ath11k_ce_free_pipes(ab);
 	ath11k_core_free(ab);
 	platform_set_drvdata(pdev, NULL);
+}
+
+static int ath11k_ahb_remove(struct platform_device *pdev)
+{
+	struct ath11k_base *ab = platform_get_drvdata(pdev);
+
+	if (test_bit(ATH11K_FLAG_QMI_FAIL, &ab->dev_flags)) {
+		ath11k_ahb_power_down(ab);
+		ath11k_debugfs_soc_destroy(ab);
+		ath11k_qmi_deinit_service(ab);
+		goto qmi_fail;
+	}
+
+	ath11k_ahb_remove_prepare(ab);
+	ath11k_core_deinit(ab);
+
+qmi_fail:
+	ath11k_ahb_free_resources(ab);
 
 	return 0;
 }
 
+static void ath11k_ahb_shutdown(struct platform_device *pdev)
+{
+	struct ath11k_base *ab = platform_get_drvdata(pdev);
+
+	/* platform shutdown() & remove() are mutually exclusive.
+	 * remove() is invoked during rmmod & shutdown() during
+	 * system reboot/shutdown.
+	 */
+	ath11k_ahb_remove_prepare(ab);
+
+	if (!(test_bit(ATH11K_FLAG_REGISTERED, &ab->dev_flags)))
+		goto free_resources;
+
+	ath11k_core_deinit(ab);
+
+free_resources:
+	ath11k_ahb_free_resources(ab);
+}
+
 static struct platform_driver ath11k_ahb_driver = {
 	.driver         = {
 		.name   = "ath11k",
@@ -1131,6 +1162,7 @@ static struct platform_driver ath11k_ahb_driver = {
 	},
 	.probe  = ath11k_ahb_probe,
 	.remove = ath11k_ahb_remove,
+	.shutdown = ath11k_ahb_shutdown,
 };
 
 static int ath11k_ahb_init(void)
diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 6ddc698f4a2d..209345bedd09 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -1635,6 +1635,8 @@ static void ath11k_core_pre_reconfigure_recovery(struct ath11k_base *ab)
 
 	wake_up(&ab->wmi_ab.tx_credits_wq);
 	wake_up(&ab->peer_mapping_wq);
+
+	reinit_completion(&ab->driver_recovery);
 }
 
 static void ath11k_core_post_reconfigure_recovery(struct ath11k_base *ab)
-- 
2.35.1



