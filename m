Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFD53031B7
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 03:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730633AbhAYStq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:49:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:35490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730810AbhAYSsm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:48:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A565322482;
        Mon, 25 Jan 2021 18:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600505;
        bh=7HR1EgVX0mj2UGYAr+8JnEuzf1ABQgq6VSSdswUwEbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dcJy+KHqWXXEEOy7AIoKpS1/0aYM+R/cSJyWJ3cP9wfq96mrJhro5lQoEJw2/XqPz
         LShcsJkHH67rzC2iKIZ+E3xn7chaXOvMGAvLCSecLusawaEdCvArvBZ9F5VdmrlW0E
         KqjLS5tEhA/8qaGJkcrbc8SL5U0hhXFFl+d9WpO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/199] scsi: ufs: Relax the condition of UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
Date:   Mon, 25 Jan 2021 19:37:43 +0100
Message-Id: <20210125183217.981708976@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanley Chu <stanley.chu@mediatek.com>

[ Upstream commit 21acf4601cc63cf564c6fc1a74d81b191313c929 ]

UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL is intended to skip enabling
fWriteBoosterBufferFlushEn while WriteBooster is initializing.  Therefore
it is better to apply the checking during WriteBooster initialization only.

Link: https://lore.kernel.org/r/20201222072905.32221-3-stanley.chu@mediatek.com
Reviewed-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7b9a9a771b11b..66430cb086245 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -283,7 +283,8 @@ static inline void ufshcd_wb_config(struct ufs_hba *hba)
 	if (ret)
 		dev_err(hba->dev, "%s: En WB flush during H8: failed: %d\n",
 			__func__, ret);
-	ufshcd_wb_toggle_flush(hba, true);
+	if (!(hba->quirks & UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL))
+		ufshcd_wb_toggle_flush(hba, true);
 }
 
 static void ufshcd_scsi_unblock_requests(struct ufs_hba *hba)
@@ -5353,9 +5354,6 @@ static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set)
 
 static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable)
 {
-	if (hba->quirks & UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL)
-		return;
-
 	if (enable)
 		ufshcd_wb_buf_flush_enable(hba);
 	else
-- 
2.27.0



