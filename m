Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D182E41B9
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440522AbgL1PMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:12:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:41626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438382AbgL1OHP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:07:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5204207A9;
        Mon, 28 Dec 2020 14:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164395;
        bh=CjD0mD9bvfYzAwlyCCtls/JDl9o6dwCb40VFC1u2mEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cqknYXP2jVCwY9CZMrFsT7DsPjGhRZ84hX95X6NoTw8hQ66XTwjxyYQi+kUFWtwyE
         TMql+x/+OaJXJF7qsMKMgRXHSID9rF7j/7mdOkvTWCPrtriTJ4q/rq9tufN9z7r5Zv
         /7R8hNIRN4n29+03fNpFUXxTfzWp0/qHEB57qr8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 165/717] scsi: ufs: Avoid to call REQ_CLKS_OFF to CLKS_OFF
Date:   Mon, 28 Dec 2020 13:42:43 +0100
Message-Id: <20201228125028.861970632@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit fd62de114f8c9df098dcd43b5d83c5714176dd12 ]

Once UFS is gated with CLKS_OFF, it should not call REQ_CLKS_OFF
again. This can lead to hibern8_enter failure.

Link: https://lore.kernel.org/r/20201117165839.1643377-2-jaegeuk@kernel.org
Reviewed-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0c148fcd24deb..1ad7d6c130f5b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1752,7 +1752,8 @@ static void __ufshcd_release(struct ufs_hba *hba)
 	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended ||
 	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
 	    ufshcd_any_tag_in_use(hba) || hba->outstanding_tasks ||
-	    hba->active_uic_cmd || hba->uic_async_done)
+	    hba->active_uic_cmd || hba->uic_async_done ||
+	    hba->clk_gating.state == CLKS_OFF)
 		return;
 
 	hba->clk_gating.state = REQ_CLKS_OFF;
-- 
2.27.0



