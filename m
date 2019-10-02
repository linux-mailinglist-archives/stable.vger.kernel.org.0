Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1E92C9199
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729801AbfJBTKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:10:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35936 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729333AbfJBTIR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:17 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyx-00035v-Q5; Wed, 02 Oct 2019 20:08:15 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyp-0003fU-MK; Wed, 02 Oct 2019 20:08:07 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Avri Altman" <avri.altman@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Stanley Chu" <stanley.chu@mediatek.com>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.955969694@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 70/87] scsi: ufs: Avoid runtime suspend possibly
 being blocked forever
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley Chu <stanley.chu@mediatek.com>

commit 24e2e7a19f7e4b83d0d5189040d997bce3596473 upstream.

UFS runtime suspend can be triggered after pm_runtime_enable() is invoked
in ufshcd_pltfrm_init(). However if the first runtime suspend is triggered
before binding ufs_hba structure to ufs device structure via
platform_set_drvdata(), then UFS runtime suspend will be no longer
triggered in the future because its dev->power.runtime_error was set in the
first triggering and does not have any chance to be cleared.

To be more clear, dev->power.runtime_error is set if hba is NULL in
ufshcd_runtime_suspend() which returns -EINVAL to rpm_callback() where
dev->power.runtime_error is set as -EINVAL. In this case, any future
rpm_suspend() for UFS device fails because rpm_check_suspend_allowed()
fails due to non-zero
dev->power.runtime_error.

To resolve this issue, make sure the first UFS runtime suspend get valid
"hba" in ufshcd_runtime_suspend(): Enable UFS runtime PM only after hba is
successfully bound to UFS device structure.

Fixes: 62694735ca95 ([SCSI] ufs: Add runtime PM support for UFS host controller driver)
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[bwh: Backported to 3.16:
 - ufshcd_pltrfm_probe() doesn't allocate or free the host structure
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -150,22 +150,19 @@ static int ufshcd_pltfrm_probe(struct pl
 		goto out;
 	}
 
-	pm_runtime_set_active(&pdev->dev);
-	pm_runtime_enable(&pdev->dev);
-
 	err = ufshcd_init(dev, &hba, mmio_base, irq);
 	if (err) {
 		dev_err(dev, "Intialization failed\n");
-		goto out_disable_rpm;
+		goto out;
 	}
 
 	platform_set_drvdata(pdev, hba);
 
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
 	return 0;
 
-out_disable_rpm:
-	pm_runtime_disable(&pdev->dev);
-	pm_runtime_set_suspended(&pdev->dev);
 out:
 	return err;
 }

