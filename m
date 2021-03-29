Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23CA834C9CB
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbhC2Idu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:33:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233758AbhC2IbH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:31:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DDE3614A7;
        Mon, 29 Mar 2021 08:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006666;
        bh=Yeveyd6K8wPDqF/jDYmnasW/ztGVc7aRaNgrufzhjag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Awp0pcMicLGMKUgAhSo3O9beN1kxqbN+KPyAZsQzRgzrZkDwW4ufPIb88tAgSwToh
         psOhmqCCoIFtXj7MHqWfteLNTq6HWXyeBiUQu/ftzKZj+oKb+kBTQGoE/8kXcu6JgU
         MAxJrkGPuZFViLNiNisiXPTYAlLH+5192npuTsNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 011/254] scsi: ufs: ufs-qcom: Disable interrupt in reset path
Date:   Mon, 29 Mar 2021 09:55:27 +0200
Message-Id: <20210329075633.516999162@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
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
index 2206b1e4b774..e55201f64c10 100644
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



