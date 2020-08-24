Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB12324F853
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729716AbgHXJ3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:29:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729947AbgHXIvg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:51:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C332D207D3;
        Mon, 24 Aug 2020 08:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259095;
        bh=ib3ov4ByJ2KzNtKTgGjw5zSsvyIJbB/3U+DgfprOU6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QP2WetXphjtEAWvebVDTBZAl2LTXHaVRoEKc6phxuhRVKtgEOFn65PiHCGXNTfCJE
         mLpQ3mJhMhySRsDE7nMLpegocwrKqduqUCznTS+gg5Mq9xkC2xzOfDr2OZQ/LjRSj1
         RICFVj8U18Efn/pWkpnx9OQP0MYxEFrU6zboAGno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 18/39] scsi: ufs: Add DELAY_BEFORE_LPM quirk for Micron devices
Date:   Mon, 24 Aug 2020 10:31:17 +0200
Message-Id: <20200824082349.435003610@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082348.445866152@linuxfoundation.org>
References: <20200824082348.445866152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanley Chu <stanley.chu@mediatek.com>

[ Upstream commit c0a18ee0ce78d7957ec1a53be35b1b3beba80668 ]

It is confirmed that Micron device needs DELAY_BEFORE_LPM quirk to have a
delay before VCC is powered off. Sdd Micron vendor ID and this quirk for
Micron devices.

Link: https://lore.kernel.org/r/20200612012625.6615-2-stanley.chu@mediatek.com
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs_quirks.h | 1 +
 drivers/scsi/ufs/ufshcd.c     | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufs_quirks.h b/drivers/scsi/ufs/ufs_quirks.h
index 71f73d1d1ad1f..6c944fbefd40a 100644
--- a/drivers/scsi/ufs/ufs_quirks.h
+++ b/drivers/scsi/ufs/ufs_quirks.h
@@ -21,6 +21,7 @@
 #define UFS_ANY_VENDOR 0xFFFF
 #define UFS_ANY_MODEL  "ANY_MODEL"
 
+#define UFS_VENDOR_MICRON      0x12C
 #define UFS_VENDOR_TOSHIBA     0x198
 #define UFS_VENDOR_SAMSUNG     0x1CE
 #define UFS_VENDOR_SKHYNIX     0x1AD
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index af4b0a2021d6c..a7f520581cb0f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -178,6 +178,8 @@ ufs_get_pm_lvl_to_link_pwr_state(enum ufs_pm_level lvl)
 
 static struct ufs_dev_fix ufs_fixups[] = {
 	/* UFS cards deviations table */
+	UFS_FIX(UFS_VENDOR_MICRON, UFS_ANY_MODEL,
+		UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM),
 	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
 		UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM),
 	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL, UFS_DEVICE_NO_VCCQ),
-- 
2.25.1



