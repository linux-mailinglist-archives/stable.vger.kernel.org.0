Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95AC84A8E49
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354270AbiBCUgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243188AbiBCUeI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:34:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB3BC06175A;
        Thu,  3 Feb 2022 12:33:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3AC561B16;
        Thu,  3 Feb 2022 20:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBB1C340E8;
        Thu,  3 Feb 2022 20:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920431;
        bh=guK3INTiect6vAz3XA7kTRmCWn7LkN7OxWWdegn2POE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LsY1DOhG2rUDfd3skkOC9MQQKwC+t5T7NfphBPzsjBrFsRH9jaLMadYtQ0hZsZ11l
         EMveI5NVSyVlHYIIOcYCf+BAdl1df5kdK9R1DIp6/7qZUCuNllxxsH2Jc5WXL29qx7
         3CX0rwHa+cG77IQl0boaEvXY0b9s+oVmL+3MNQ2mJJ0vmAoVfNNHK4n6Msgbte/zF7
         1V1Mw5QR1MSX9HOTZg0RnCiMuAVnXGKJjsbz4luT0HB+qcdYY7NVs1UumG+4F73FDr
         9Gd0sa3Q1SZ0Ggcn4M9IpjRp4drh9FZT4IEzlNIvh3xnIv6s1TWnVmVxMALal2Y1C+
         Xx1DnbZ8W8pmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        beanhuo@micron.com, avri.altman@wdc.com, daejun7.park@samsung.com,
        adrian.hunter@intel.com, cang@codeaurora.org,
        asutoshd@codeaurora.org, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 29/41] scsi: ufs: Use generic error code in ufshcd_set_dev_pwr_mode()
Date:   Thu,  3 Feb 2022 15:32:33 -0500
Message-Id: <20220203203245.3007-29-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203245.3007-1-sashal@kernel.org>
References: <20220203203245.3007-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kiwoong Kim <kwmad.kim@samsung.com>

[ Upstream commit ad6c8a426446873febc98140d81d5353f8c0825b ]

The return value of ufshcd_set_dev_pwr_mode() is passed to device PM
core. However, the function currently returns a SCSI result which the PM
core doesn't understand.  This might lead to unexpected behaviors in
userland; a platform reset was observed in Android.

Use a generic error code for SSU failures.

Link: https://lore.kernel.org/r/1642743182-54098-1-git-send-email-kwmad.kim@samsung.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ae7bdd8703198..f489954e46321 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8473,7 +8473,7 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
  * @pwr_mode: device power mode to set
  *
  * Returns 0 if requested power mode is set successfully
- * Returns non-zero if failed to set the requested power mode
+ * Returns < 0 if failed to set the requested power mode
  */
 static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 				     enum ufs_dev_pwr_mode pwr_mode)
@@ -8527,8 +8527,11 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 		sdev_printk(KERN_WARNING, sdp,
 			    "START_STOP failed for power mode: %d, result %x\n",
 			    pwr_mode, ret);
-		if (ret > 0 && scsi_sense_valid(&sshdr))
-			scsi_print_sense_hdr(sdp, NULL, &sshdr);
+		if (ret > 0) {
+			if (scsi_sense_valid(&sshdr))
+				scsi_print_sense_hdr(sdp, NULL, &sshdr);
+			ret = -EIO;
+		}
 	}
 
 	if (!ret)
-- 
2.34.1

