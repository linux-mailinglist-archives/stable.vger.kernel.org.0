Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343C34B4B27
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346616AbiBNKXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:23:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346640AbiBNKVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:21:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527037DE2B;
        Mon, 14 Feb 2022 01:55:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38773B80DCF;
        Mon, 14 Feb 2022 09:55:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7B0C340E9;
        Mon, 14 Feb 2022 09:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832544;
        bh=WoggJfzxZcsMjHbc6cnyNwotPtNHvkZ1EEsQdBd98pI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bg5n2UFVAYIJXV3sdKSkm3b1tMeiQ85EcEWk+lC3mYAzJrv/nle7x0N+Gcgd/lLoR
         nPR4JZSpix6jJ9+Vcxx4ArTe6wtmlKact5tePyIPoNwg+rCbiHJxo1FDVF8IFhwr7e
         C69fXDHBaEo5hWCzgoUsFtczLrgnXM/lVVdT7K7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 049/203] scsi: ufs: Use generic error code in ufshcd_set_dev_pwr_mode()
Date:   Mon, 14 Feb 2022 10:24:53 +0100
Message-Id: <20220214092511.882844129@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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



