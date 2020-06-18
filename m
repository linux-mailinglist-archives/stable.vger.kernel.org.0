Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED6381FE08F
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732991AbgFRBsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:48:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731990AbgFRB15 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:27:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6E77221F9;
        Thu, 18 Jun 2020 01:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443676;
        bh=feUd0AmCmn7I9f2TYK/0nNByOcuLcslvVtpb5rFy/IQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oh+KTtjU10NQn1zUnKRR6JlBu915yIG6dayxqH4xPo9m0OxtgsvK0OSZKFRW9lkow
         +4Hy1zj1HMM0MB9E2LY7KvhT0YcluzmHFnKHJsuULRuZCJeUNR4AJHEQcuz4npIvwQ
         p3BwyfSmwnGuDLIGFtQbkIWuifuDGPdyLrXp4h7k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 092/108] scsi: ufs: Don't update urgent bkops level when toggling auto bkops
Date:   Wed, 17 Jun 2020 21:25:44 -0400
Message-Id: <20200618012600.608744-92-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012600.608744-1-sashal@kernel.org>
References: <20200618012600.608744-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 3a98e5a1d830..1e2a97a10033 100644
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

