Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 880F529B016
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1757097AbgJ0OQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757091AbgJ0OQO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:16:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 414812076A;
        Tue, 27 Oct 2020 14:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808173;
        bh=bgtKm3nXHAJrgo0PPg5JzJ+PX4/ItlVoSYtZa0l4BFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WbCrpuum7AgaAVV0BIQyf1tnzlvQq7yMv9iXm1QpN05yUHL9HKp8UgTGnXWo5r4j/
         F5IiYFnuc9iWG9Vam2MGvA8XmUliD/Uv688qlC9gFgMSr8kPucfE5zjB/UKSTF7/of
         HWwWSV5gLXRPT4pW2uLicXd+Uvzoazfm9iJ0ZLVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hongwu Su <hongwus@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 184/191] scsi: ufs: ufs-qcom: Fix race conditions caused by ufs_qcom_testbus_config()
Date:   Tue, 27 Oct 2020 14:50:39 +0100
Message-Id: <20201027134918.578439550@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

[ Upstream commit 89dd87acd40a44de8ff3358138aedf8f73f4efc6 ]

If ufs_qcom_dump_dbg_regs() calls ufs_qcom_testbus_config() from
ufshcd_suspend/resume and/or clk gate/ungate context, pm_runtime_get_sync()
and ufshcd_hold() will cause a race condition. Fix this by removing the
unnecessary calls of pm_runtime_get_sync() and ufshcd_hold().

Link: https://lore.kernel.org/r/1596975355-39813-3-git-send-email-cang@codeaurora.org
Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index ee3589ac64abf..6b6b8bf2ec929 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1595,9 +1595,6 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host *host)
 	 */
 	}
 	mask <<= offset;
-
-	pm_runtime_get_sync(host->hba->dev);
-	ufshcd_hold(host->hba, false);
 	ufshcd_rmwl(host->hba, TEST_BUS_SEL,
 		    (u32)host->testbus.select_major << 19,
 		    REG_UFS_CFG1);
@@ -1610,8 +1607,6 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host *host)
 	 * committed before returning.
 	 */
 	mb();
-	ufshcd_release(host->hba);
-	pm_runtime_put_sync(host->hba->dev);
 
 	return 0;
 }
-- 
2.25.1



