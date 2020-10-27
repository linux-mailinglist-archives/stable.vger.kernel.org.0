Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7614529B900
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802145AbgJ0Ppp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799204AbgJ0PaO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:30:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EF8B2225E;
        Tue, 27 Oct 2020 15:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812613;
        bh=u6tmtFzoQhNJoYX9gYV+e9lb3rVX2mHMPLxiTP6Gkv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Mm6fdysWm2MMqM9xW75T5pLW1756Ls05fSkHzVsT+hmA8yeYsCgeenKuL8zEc0KP
         SdhHvRFO36RyPopmclYYTDaWaISSXy+8pX3V/C7dyWxaWBFb2lyE+HihEA7ADhiZrx
         MIFHUjs92w5gFOXWe7xD3fr9KC2rATGCpeooenmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 243/757] scsi: ufs: ufs-mediatek: Eliminate error message for unbound mphy
Date:   Tue, 27 Oct 2020 14:48:13 +0100
Message-Id: <20201027135501.990327635@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanley Chu <stanley.chu@mediatek.com>

[ Upstream commit 30a90782c105fe498df74161392aa143796b6886 ]

Some MediaTek platforms does not have to bind MPHY so users shall not see
any unnecessary logs. Simply remove logs for this case.

Link: https://lore.kernel.org/r/20200908064507.30774-2-stanley.chu@mediatek.com
Fixes: fc4983018fea ("scsi: ufs-mediatek: Allow unbound mphy")
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-mediatek.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 1755dd6b04aec..0a50b95315f8f 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -129,7 +129,10 @@ static int ufs_mtk_bind_mphy(struct ufs_hba *hba)
 			__func__, err);
 	} else if (IS_ERR(host->mphy)) {
 		err = PTR_ERR(host->mphy);
-		dev_info(dev, "%s: PHY get failed %d\n", __func__, err);
+		if (err != -ENODEV) {
+			dev_info(dev, "%s: PHY get failed %d\n", __func__,
+				 err);
+		}
 	}
 
 	if (err)
-- 
2.25.1



