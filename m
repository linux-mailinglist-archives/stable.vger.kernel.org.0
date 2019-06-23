Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5577B4FB61
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 13:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfFWLxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 07:53:30 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55853 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726483AbfFWLxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 07:53:30 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7C92221550;
        Sun, 23 Jun 2019 07:53:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 23 Jun 2019 07:53:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Qh+AFw
        TQOLM6x3yyahhT74dAofRZL0dzo2C+FK9oLc0=; b=ZVLINVyN9JoJmpvLeErQLV
        ZZKy+lhwz+gfhWsXhl5k9TWAE3AiUvlmGsGb0Xbu9Lj66nprUzvkzWn7n0cQG0hw
        vLxKrZWQ3K9g6tA61SrXPpfeFOtrzjTUInQqfWjX1KrhOjHRukBPcj8uDcRF62dT
        YZ1BIaanTyD6iUF9wIoaRGfNs03iwPS/enmyuVCNoUa6DG85/d8XKZkU7mNk35+f
        7NEYnu0koXTOZRMZ/4qhCdX6tU/ny1bJ0NwSjtPAYhftZaFBrD1Jg2l2J6jXTXmb
        6jj+/1dVHX8PE9oeq14yGNjpxDRhUZr2JyUEf7OAPEn2Pcuvw35A4d3vUNF96GwA
        ==
X-ME-Sender: <xms:OGgPXViTnHwU7YGutSxg0bLuisRDDWND9HcKFuRzTDc15HcKNzJT0A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtgdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepudejvddruddtgedrvdegkedrgeegnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:OGgPXU6BZpJV34VQLsw3SNPZe16ht44ptR2XxJZ2OGeAVUGHfBiYfA>
    <xmx:OGgPXX8-nWeTSHuNOVyYdPBjvvz_5p2nENCG636nhS69OBYwPZ0-QQ>
    <xmx:OGgPXT9rz-0yrLvR7dWgWA3rl-1h-iOsrNTxBI9ur7yQ6Vanng3jKg>
    <xmx:OWgPXQhL2ypSSkkCQuAYtlKFsH0dNJRIJOBs-eWP4RJyYEstfXpRig>
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 704BB380076;
        Sun, 23 Jun 2019 07:53:28 -0400 (EDT)
Subject: FAILED: patch "[PATCH] scsi: ufs: Avoid runtime suspend possibly being blocked" failed to apply to 4.4-stable tree
To:     stanley.chu@mediatek.com, avri.altman@wdc.com,
        martin.petersen@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jun 2019 13:53:27 +0200
Message-ID: <15612908076757@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 24e2e7a19f7e4b83d0d5189040d997bce3596473 Mon Sep 17 00:00:00 2001
From: Stanley Chu <stanley.chu@mediatek.com>
Date: Wed, 12 Jun 2019 23:19:05 +0800
Subject: [PATCH] scsi: ufs: Avoid runtime suspend possibly being blocked
 forever

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

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 8a74ec30c3d2..d7d521b394c3 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -430,24 +430,21 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
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

