Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7A7463733
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242521AbhK3OwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:52:02 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56842 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242526AbhK3Ovf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:51:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4E899CE1A3F;
        Tue, 30 Nov 2021 14:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C48BC53FCD;
        Tue, 30 Nov 2021 14:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283692;
        bh=7Z19BL2g0lP+roN8+RTxjyJLe80jPcP105NpvnikaqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u38U7bC7YlJEDT55u7Zjj39Lo+2cpFAjMGhYB7/v37PoOKL98lP0q99WNzJHWzAFM
         kk7gZsfbSquYRhmsW68Kz2Au9xTVqbrv60YWS1cuqQge/vO1fmi8PsBD5QiQvEcSxn
         jmALjNvm4iRqBkXfSPktSsbfHWqSZW039ojuQZNz/gU31KH6O2b5WCOcX9NaObjAXj
         r38HGf0sgcx0qI0fTv6C1ML/mupSsEznm88ySbPo708hWcFdmlRILpP9lofm44ZZhH
         zrzsLjRrrIvpOxNxtYh4tEq95SdufcDyvY2ANQKAmWYVYQlShRkjhYoCkaxfR4LEl5
         JedQsWLNBBNSA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Guojin <ye.guojin@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        Peter Wang <peter.wang@mediatek.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, stanley.chu@mediatek.com,
        jejb@linux.ibm.com, matthias.bgg@gmail.com,
        linux-scsi@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 20/68] scsi: ufs: ufs-mediatek: Add put_device() after of_find_device_by_node()
Date:   Tue, 30 Nov 2021 09:46:16 -0500
Message-Id: <20211130144707.944580-20-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Guojin <ye.guojin@zte.com.cn>

[ Upstream commit cc03facb1c4248997592fc683518c00cc257db1a ]

This was found by coccicheck:

./drivers/scsi/ufs/ufs-mediatek.c, 211, 1-7, ERROR missing put_device;
call of_find_device_by_node on line 1185, but without a corresponding
object release within this function.

Link: https://lore.kernel.org/r/20211110105133.150171-1-ye.guojin@zte.com.cn
Reported-by: Zeal Robot <zealci@zte.com.cn>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Ye Guojin <ye.guojin@zte.com.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-mediatek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 80b3545dd17d6..ecc503171db6b 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -1102,6 +1102,7 @@ static int ufs_mtk_probe(struct platform_device *pdev)
 	}
 	link = device_link_add(dev, &reset_pdev->dev,
 		DL_FLAG_AUTOPROBE_CONSUMER);
+	put_device(&reset_pdev->dev);
 	if (!link) {
 		dev_notice(dev, "add reset device_link fail\n");
 		goto skip_reset;
-- 
2.33.0

