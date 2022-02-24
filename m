Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B74F4C39F4
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 00:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbiBXX5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 18:57:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235531AbiBXX5L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 18:57:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C5A260B;
        Thu, 24 Feb 2022 15:56:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37FC161C5A;
        Thu, 24 Feb 2022 23:56:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847F4C340E9;
        Thu, 24 Feb 2022 23:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645746996;
        bh=Ih5JYTd0Da7Xsf2nsb9SNMND0av004oSEgWifyEjasI=;
        h=From:To:Cc:Subject:Date:From;
        b=PWh1cYEdCo157rEx2C5QP/ipoMslEVI7A3SLC5i1iaOLTTyxX8zcbnr0+HZxjS1Fu
         1t9QEK1/3uIShNzfHYSl3jMMBvwbhm0S6cGSYRj/cOCYUt1Ob7FC44AVU9wkBJiXf+
         ZFFxa1JArf2fOX4GuzDWKmyC95qqj/IKX/Un+hWBNj5HUtjE+rD77jYeLbJwglJQEQ
         b4bq0Ysr1iKbUNSZ6dkIVxgE9qoAy1n9Tt1rNGJUg3z5gf4kLGqAjqV4o1BLMbfkrz
         Un+Zi3uVFAXyexv2OYsGCjJ0VBuxrIfbGGpFBj8sAP5ct7H46liywAKXaK5VDdHRiT
         R/IJfg58ujIbw==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] scsi: ufs: move shutting_down back to ufshcd_shutdown
Date:   Thu, 24 Feb 2022 15:56:29 -0800
Message-Id: <20220224235629.3804227-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
MIME-Version: 1.0
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

The commit b294ff3e3449 ("scsi: ufs: core: Enable power management for wlun")
moved hba->shutting_down from ufshcd_shutdown to ufshcd_wl_shutdown, which
introduced regression as belows.

ufshcd_err_handler started; HBA state eh_non_fatal; powered 1; shutting down 1; saved_err = 4; saved_uic_err = 64; force_reset = 0
...
task:init            state:D stack:    0 pid:    1 ppid:     0 flags:0x04000008
Call trace:
 __switch_to+0x25c/0x5e0
 __schedule+0x68c/0xaa8
 schedule+0x12c/0x24c
 schedule_timeout+0x98/0x138
 wait_for_common_io+0x13c/0x30c
 blk_execute_rq+0xb0/0x10c
 __scsi_execute+0x100/0x27c
 ufshcd_set_dev_pwr_mode+0x1c8/0x408
 __ufshcd_wl_suspend+0x564/0x688
 ufshcd_wl_shutdown+0xa8/0xc0
 device_shutdown+0x234/0x578
 kernel_restart+0x4c/0x140
 __arm64_sys_reboot+0x3a0/0x414
 el0_svc_common+0xd0/0x1e4
 el0_svc+0x28/0x88
 el0_sync_handler+0x8c/0xf0
 el0_sync+0x1c0/0x200

The init for reboot was stuck, since ufshcd_err_hanlder was skipped when
shutting down WLUN. This patch allows to run the error handler and let
disable it during final ufshcd_shutdown only.

Cc: stable@vger.kernel.org
Fixes: b294ff3e3449 ("scsi: ufs: core: Enable power management for wlun")
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 460d2b440d2e..a37813b474d0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9178,10 +9178,6 @@ static void ufshcd_wl_shutdown(struct device *dev)
 
 	hba = shost_priv(sdev->host);
 
-	down(&hba->host_sem);
-	hba->shutting_down = true;
-	up(&hba->host_sem);
-
 	/* Turn on everything while shutting down */
 	ufshcd_rpm_get_sync(hba);
 	scsi_device_quiesce(sdev);
@@ -9387,6 +9383,10 @@ EXPORT_SYMBOL(ufshcd_runtime_resume);
  */
 int ufshcd_shutdown(struct ufs_hba *hba)
 {
+	down(&hba->host_sem);
+	hba->shutting_down = true;
+	up(&hba->host_sem);
+
 	if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba))
 		goto out;
 
-- 
2.35.1.574.g5d30c73bfb-goog

