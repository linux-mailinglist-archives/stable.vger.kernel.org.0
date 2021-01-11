Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C001B2F14E0
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730411AbhAKNcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:32:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:33156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731894AbhAKNP2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:15:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7048A22795;
        Mon, 11 Jan 2021 13:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370912;
        bh=ba5DDOCOWU2rUNvSaILRUFl/P5ERLkhqrZq6lwPUL3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIbLTBNM1wg/jzRcS48w6G3Fertj7jRyZlVS1M2kW9cKL6oElPIuQ7TLB0YdvMmkv
         TVN8qGCzqyM78TtLLIfXu7NjHwF53gQMhbojzsNDiN/EJFVRW3qey8mfLP65zPXqLb
         vpjHXh+LxXsORw5AfjU4/3mJ7gM2U+7cWoYRNGbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/145] scsi: ufs-pci: Fix recovery from hibernate exit errors for Intel controllers
Date:   Mon, 11 Jan 2021 14:01:21 +0100
Message-Id: <20210111130051.277712298@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 044d5bda7117891d6d0d56f2f807b7b11e120abd ]

Intel controllers can end up in an unrecoverable state after a hibernate
exit error unless a full reset and restore is done before anything else.
Force that to happen.

Link: https://lore.kernel.org/r/20201207083120.26732-4-adrian.hunter@intel.com
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd-pci.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 5d33c39fa82f0..888d8c9ca3a55 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -178,6 +178,23 @@ static int ufs_intel_resume(struct ufs_hba *hba, enum ufs_pm_op op)
 		      REG_UTP_TASK_REQ_LIST_BASE_L);
 	ufshcd_writel(hba, upper_32_bits(hba->utmrdl_dma_addr),
 		      REG_UTP_TASK_REQ_LIST_BASE_H);
+
+	if (ufshcd_is_link_hibern8(hba)) {
+		int ret = ufshcd_uic_hibern8_exit(hba);
+
+		if (!ret) {
+			ufshcd_set_link_active(hba);
+		} else {
+			dev_err(hba->dev, "%s: hibern8 exit failed %d\n",
+				__func__, ret);
+			/*
+			 * Force reset and restore. Any other actions can lead
+			 * to an unrecoverable state.
+			 */
+			ufshcd_set_link_off(hba);
+		}
+	}
+
 	return 0;
 }
 
-- 
2.27.0



