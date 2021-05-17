Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0EB382FF0
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239214AbhEQOWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239495AbhEQOUY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:20:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7B9E6143F;
        Mon, 17 May 2021 14:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260671;
        bh=q+NDYdM015FzMXxKuIKBHYMq0mKyVVw0IJE+QUekTBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQnwoL1FMhRdrjjrTILC8PbNplQoFRM6Nxzm5OgSLK8gQ5jG2eNp1cBdWQkABdL9u
         gaYjiTaDAapXF7helnKmTyqMstYHDCbfLIdxqimeZxyvefx2LSMmPnDY4l9oKg/zfZ
         /5KT3OUGeO55jDHgwiosSiKX6wMCGMCUANSP8Kr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 188/363] scsi: ufs: core: Do not put UFS power into LPM if link is broken
Date:   Mon, 17 May 2021 16:00:54 +0200
Message-Id: <20210517140308.952776134@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

[ Upstream commit 23043dd87b153d02eaf676e752d32429be5e5126 ]

During resume, if link is broken due to AH8 failure, make sure
ufshcd_resume() does not put UFS power back into LPM.

Link: https://lore.kernel.org/r/1619408921-30426-2-git-send-email-cang@codeaurora.org
Fixes: 4db7a2360597 ("scsi: ufs: Fix concurrency of error handler and other error recovery paths")
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d3d05e997c13..fed32517d7d1 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8599,7 +8599,7 @@ static void ufshcd_vreg_set_lpm(struct ufs_hba *hba)
 	} else if (!ufshcd_is_ufs_dev_active(hba)) {
 		ufshcd_toggle_vreg(hba->dev, hba->vreg_info.vcc, false);
 		vcc_off = true;
-		if (!ufshcd_is_link_active(hba)) {
+		if (ufshcd_is_link_hibern8(hba) || ufshcd_is_link_off(hba)) {
 			ufshcd_config_vreg_lpm(hba, hba->vreg_info.vccq);
 			ufshcd_config_vreg_lpm(hba, hba->vreg_info.vccq2);
 		}
@@ -8621,7 +8621,7 @@ static int ufshcd_vreg_set_hpm(struct ufs_hba *hba)
 	    !hba->dev_info.is_lu_power_on_wp) {
 		ret = ufshcd_setup_vreg(hba, true);
 	} else if (!ufshcd_is_ufs_dev_active(hba)) {
-		if (!ret && !ufshcd_is_link_active(hba)) {
+		if (!ufshcd_is_link_active(hba)) {
 			ret = ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq);
 			if (ret)
 				goto vcc_disable;
-- 
2.30.2



