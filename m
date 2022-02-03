Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70394A8D9C
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354391AbiBCUby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:31:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34354 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354212AbiBCUbO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:31:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1895CB835A4;
        Thu,  3 Feb 2022 20:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7CFC340E8;
        Thu,  3 Feb 2022 20:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920271;
        bh=WoggJfzxZcsMjHbc6cnyNwotPtNHvkZ1EEsQdBd98pI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JzeXohw1OAujYRIx3j/FOaGx7WYwkKHztNReDLfCkyp8en+iWm/bvTY8xjSQr5308
         CwzG7Fz0sNWiPSB8jq2atSaILyd2isTsGNKRTkko++yb+Wsti8l4paq4U00kMgiAVB
         C3sGpn5PgN9HVXBViW2sncoAuthZsDU+HFYkiRvX9gy6JvcJi7Q584TjkMQ/kdx9pi
         NfVbxocdwRKYOzBRHM3TenhT9HSbgqS1EwbrkWtSmj4Aw/y5h/iZMynuQLZmnMx9xo
         24/d7PBZ9+K/2sFns9BG9v6JBWQvNt5vXcQBu/j4ABR8RywGk1Vit/n2fXWWn6hfhq
         l3QHhPWvAQHNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        beanhuo@micron.com, avri.altman@wdc.com, daejun7.park@samsung.com,
        adrian.hunter@intel.com, cang@codeaurora.org,
        asutoshd@codeaurora.org, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 32/52] scsi: ufs: Use generic error code in ufshcd_set_dev_pwr_mode()
Date:   Thu,  3 Feb 2022 15:29:26 -0500
Message-Id: <20220203202947.2304-32-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
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
index c94377aa82739..ec7d7e01231d7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8587,7 +8587,7 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
  * @pwr_mode: device power mode to set
  *
  * Returns 0 if requested power mode is set successfully
- * Returns non-zero if failed to set the requested power mode
+ * Returns < 0 if failed to set the requested power mode
  */
 static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 				     enum ufs_dev_pwr_mode pwr_mode)
@@ -8641,8 +8641,11 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
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

