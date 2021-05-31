Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94780395EE4
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbhEaOFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:05:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232210AbhEaOCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:02:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7F7361396;
        Mon, 31 May 2021 13:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468246;
        bh=7+3A1Pukmv3Q1p12fd4IG939MkFyNpZf9mJ1LLh8o5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DpSuzJ0SPStRaJ75tQCw8dQ3NcYbu36gzfGRbzdCXgQAPxsWrIhSCdDj05N97f5sL
         4GDnsB9UyV9nGZcZ/K2DUHbK0GMaosJEWlrNo0R6G92xsT747fxF412vIHYqecmFM8
         vFwjFEbQaQUzxCzc04wJC3WIpxW/1h7niRwYad5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Peter Wang <peter.wang@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 171/252] scsi: ufs: ufs-mediatek: Fix power down spec violation
Date:   Mon, 31 May 2021 15:13:56 +0200
Message-Id: <20210531130703.818410766@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit c625b80b9d00f3546722cd77527f9697c8c4c911 ]

As per spec, e.g. JESD220E chapter 7.2, while powering off the UFS device,
RST_N signal should be between VSS(Ground) and VCCQ/VCCQ2. The power down
sequence after fixing:

Power down:

 1. Assert RST_N low

 2. Turn-off VCC

 3. Turn-off VCCQ/VCCQ2

Link: https://lore.kernel.org/r/1620813706-25331-1-git-send-email-peter.wang@mediatek.com
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-mediatek.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 09d2ac20508b..aace13399a7f 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -824,6 +824,7 @@ static void ufs_mtk_vreg_set_lpm(struct ufs_hba *hba, bool lpm)
 static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 {
 	int err;
+	struct arm_smccc_res res;
 
 	if (ufshcd_is_link_hibern8(hba)) {
 		err = ufs_mtk_link_set_lpm(hba);
@@ -844,6 +845,9 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		ufs_mtk_vreg_set_lpm(hba, true);
 	}
 
+	if (ufshcd_is_link_off(hba))
+		ufs_mtk_device_reset_ctrl(0, res);
+
 	return 0;
 }
 
-- 
2.30.2



