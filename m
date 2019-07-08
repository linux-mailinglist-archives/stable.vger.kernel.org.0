Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6412D621D3
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733274AbfGHPTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:19:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733273AbfGHPTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:19:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C4112171F;
        Mon,  8 Jul 2019 15:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599176;
        bh=1+Q+n2T36vHFqICV6VSuCkyGccLJr15Eui94FJpfp80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OhXT67/vIYtJqbEnVYWGFdPb0bKSJgKGMVH0nt1O4AgGChwLU5KNjRWFFTr/JdigK
         ZtxsDpUo440j5makm4FXsIaOcXx4AvXGEV5ueFQria1K34IGI0JACRw7LZbTJuPRub
         jlxdFWjmN1qXX0+kwZ97JUw3lXdCTb5OJz53HGKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.9 003/102] scsi: ufs: Avoid runtime suspend possibly being blocked forever
Date:   Mon,  8 Jul 2019 17:11:56 +0200
Message-Id: <20190708150526.157448476@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/ufs/ufshcd-pltfrm.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -342,24 +342,21 @@ int ufshcd_pltfrm_init(struct platform_d
 		goto dealloc_host;
 	}
 
-	pm_runtime_set_active(&pdev->dev);
-	pm_runtime_enable(&pdev->dev);
-
 	ufshcd_init_lanes_per_dir(hba);
 
 	err = ufshcd_init(hba, mmio_base, irq);
 	if (err) {
 		dev_err(dev, "Initialization failed\n");
-		goto out_disable_rpm;
+		goto dealloc_host;
 	}
 
 	platform_set_drvdata(pdev, hba);
 
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
 	return 0;
 
-out_disable_rpm:
-	pm_runtime_disable(&pdev->dev);
-	pm_runtime_set_suspended(&pdev->dev);
 dealloc_host:
 	ufshcd_dealloc_host(hba);
 out:


