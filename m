Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA3934C7D3
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbhC2IST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:18:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233206AbhC2IRJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:17:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78620619C8;
        Mon, 29 Mar 2021 08:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005805;
        bh=F2Am5AgcwvHFfovPrzkmneKKrUDiOXkJDhQ6FIxVmD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fdIUCICdO1oEQhpKQMoto0Ot2U251PL2HaLIoyvHUHIXQZLD0fEgKpGjGsv1M0HTl
         nAXsXFDCQYbRuGe0s2iCXpQzKGrmt55idrGHv8VhChyoyNfylFspz9rqvCxEQtXFWt
         cnfhghxgNPNtpl7DwaBJYySPWl5WGOm9EpCWkab0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/221] scsi: ufs: ufs-qcom: Disable interrupt in reset path
Date:   Mon, 29 Mar 2021 09:55:43 +0200
Message-Id: <20210329075629.589757404@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nitin Rawat <nitirawa@codeaurora.org>

[ Upstream commit 4a791574a0ccf36eb3a0a46fbd71d2768df3eef9 ]

Disable interrupt in reset path to flush pending IRQ handler in order to
avoid possible NoC issues.

Link: https://lore.kernel.org/r/1614145010-36079-3-git-send-email-cang@codeaurora.org
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Nitin Rawat <nitirawa@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index a244c8ae1b4e..20182e39cb28 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -253,12 +253,17 @@ static int ufs_qcom_host_reset(struct ufs_hba *hba)
 {
 	int ret = 0;
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+	bool reenable_intr = false;
 
 	if (!host->core_reset) {
 		dev_warn(hba->dev, "%s: reset control not set\n", __func__);
 		goto out;
 	}
 
+	reenable_intr = hba->is_irq_enabled;
+	disable_irq(hba->irq);
+	hba->is_irq_enabled = false;
+
 	ret = reset_control_assert(host->core_reset);
 	if (ret) {
 		dev_err(hba->dev, "%s: core_reset assert failed, err = %d\n",
@@ -280,6 +285,11 @@ static int ufs_qcom_host_reset(struct ufs_hba *hba)
 
 	usleep_range(1000, 1100);
 
+	if (reenable_intr) {
+		enable_irq(hba->irq);
+		hba->is_irq_enabled = true;
+	}
+
 out:
 	return ret;
 }
-- 
2.30.1



