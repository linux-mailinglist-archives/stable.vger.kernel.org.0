Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDB31A563C
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730929AbgDKXPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:15:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730965AbgDKXPH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:15:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F42D20757;
        Sat, 11 Apr 2020 23:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646907;
        bh=4MNDq5JIfNUOVoGypVOfJ3S7koSKgHGx/rT77mOia/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EGBqIBLKIjxLCr1uGTkkzOTVguoEbt5ITYqhBETodNHFjFkqClTF51xY1ZIJfxRVN
         H1vdUvmxx7eAbkMYYykJBb4yBR0Dt62KtGIr94eC9ei0qfgUr2tDeixxLIx2dlbuzo
         Ka2B+iiZzZObDOnYiSA45k3zozzc47LDzi6VGk/M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Can Guo <cang@codeaurora.org>, Hongwu Su <hongwus@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 4.4 16/16] scsi: ufs: Fix ufshcd_hold() caused scheduling while atomic
Date:   Sat, 11 Apr 2020 19:14:46 -0400
Message-Id: <20200411231447.27182-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231447.27182-1-sashal@kernel.org>
References: <20200411231447.27182-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

[ Upstream commit c63d6099a7959ecc919b2549dc6b71f53521f819 ]

The async version of ufshcd_hold(async == true), which is only called in
queuecommand path as for now, is expected to work in atomic context, thus
it should not sleep or schedule out. When it runs into the condition that
clocks are ON but link is still in hibern8 state, it should bail out
without flushing the clock ungate work.

Fixes: f2a785ac2312 ("scsi: ufshcd: Fix race between clk scaling and ungate work")
Link: https://lore.kernel.org/r/1581392451-28743-6-git-send-email-cang@codeaurora.org
Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 19f82069c68ac..bc7f8d634c805 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -595,6 +595,11 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 		 */
 		if (ufshcd_can_hibern8_during_gating(hba) &&
 		    ufshcd_is_link_hibern8(hba)) {
+			if (async) {
+				rc = -EAGAIN;
+				hba->clk_gating.active_reqs--;
+				break;
+			}
 			spin_unlock_irqrestore(hba->host->host_lock, flags);
 			flush_work(&hba->clk_gating.ungate_work);
 			spin_lock_irqsave(hba->host->host_lock, flags);
-- 
2.20.1

