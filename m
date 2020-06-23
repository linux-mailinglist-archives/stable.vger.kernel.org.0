Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9C82061F8
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389751AbgFWUw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:52:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:45404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403922AbgFWUrG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:47:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3AB3214DB;
        Tue, 23 Jun 2020 20:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945227;
        bh=ridycpqTE1S9wgnTO4TRgseyQs/OqkDJIyJrLdDfziQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gV5wrPjozwEeFfWBvw3occXuKwjLKVGV/4jpLm1SoB6s/YP+gh5yHp2SagkD9xkHl
         4OoUFBfDhGhNtgxZglt3O+ZQ0U8PUWfZTG6MFFk6bIRhvgKIp5v6VqePhbnYJodxVY
         6WID831kTyhZ8D62hcQX6xmhlnq/T8GzwvJyT1sg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 088/136] scsi: ufs: Dont update urgent bkops level when toggling auto bkops
Date:   Tue, 23 Jun 2020 21:59:04 +0200
Message-Id: <20200623195308.101743130@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

[ Upstream commit be32acff43800c87dc5c707f5d47cc607b76b653 ]

Urgent bkops level is used to compare against actual bkops status read from
UFS device. Urgent bkops level is set during initialization and might be
updated in exception event handler during runtime. But it should not be
updated to the actual bkops status every time when auto bkops is toggled.
Otherwise, if urgent bkops level is updated to 0, auto bkops shall always
be kept enabled.

Link: https://lore.kernel.org/r/1590632686-17866-1-git-send-email-cang@codeaurora.org
Fixes: 24366c2afbb0 ("scsi: ufs: Recheck bkops level if bkops is disabled")
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3a98e5a1d830c..1e2a97a10033b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4890,7 +4890,6 @@ static int ufshcd_bkops_ctrl(struct ufs_hba *hba,
 		err = ufshcd_enable_auto_bkops(hba);
 	else
 		err = ufshcd_disable_auto_bkops(hba);
-	hba->urgent_bkops_lvl = curr_status;
 out:
 	return err;
 }
-- 
2.25.1



