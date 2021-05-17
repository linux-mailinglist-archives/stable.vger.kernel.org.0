Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43873834CF
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239713AbhEQPMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:12:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242976AbhEQPKf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:10:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E04A26161E;
        Mon, 17 May 2021 14:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261842;
        bh=LrNG479SmsQRMUuhF8XIsslIbx4AsT9If1H9oW8g+Nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kU+wVfDNF8gnH24eEVDvQP6NIIWSE4rt38wAnuI3eB7NupL9WbRYccmOknSwuyxb4
         qTybB1v3MAi4PPur2ksxyrmwNg/n/PjT521OXpOTUBizkGrJ6gD/DttIr68tLj11Y3
         6ptZHUPjAUNOQ4LyHezxCiRc9UpLJkbSKHNeI8H8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 176/329] scsi: ufs: core: Narrow down fast path in system suspend path
Date:   Mon, 17 May 2021 16:01:27 +0200
Message-Id: <20210517140308.078221133@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

[ Upstream commit ce4f62f9dd8cf43ac044045ed598a0b80ef33890 ]

If spm_lvl is set to 0 or 1, when system suspend kicks start and HBA is
runtime active, system suspend may just bail without doing anything (the
fast path), leaving other contexts still running, e.g., clock gating and
clock scaling. When system resume kicks start, concurrency can happen
between ufshcd_resume() and these contexts, leading to various stability
issues.

Add a check against HBA's runtime state and allowing fast path only if HBA
is runtime suspended, otherwise let system suspend go ahead call
ufshcd_suspend(). This will guarantee that these contexts are stopped by
either runtime suspend or system suspend.

Link: https://lore.kernel.org/r/1619408921-30426-4-git-send-email-cang@codeaurora.org
Fixes: 0b257734344a ("scsi: ufs: optimize system suspend handling")
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d7e983e952cb..ab3a5c1b5723 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8978,6 +8978,7 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 	     hba->curr_dev_pwr_mode) &&
 	    (ufs_get_pm_lvl_to_link_pwr_state(hba->spm_lvl) ==
 	     hba->uic_link_state) &&
+	     pm_runtime_suspended(hba->dev) &&
 	     !hba->dev_info.b_rpm_dev_flush_capable)
 		goto out;
 
-- 
2.30.2



