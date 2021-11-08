Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59AF944A22C
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241169AbhKIBQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:16:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242040AbhKIBMm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:12:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F3B961A0B;
        Tue,  9 Nov 2021 01:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419910;
        bh=/tmpztGr5ZDjKdMHbqUB88TpMaSVSAhhg5KWft8tnNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KTMar5xDzc3NseyimIpuiGJx98HgMv1iN8MCEMZClyXMoDgZ6jSXHt7SwcHUW+b3g
         MraCCEVaSSWlgSsSAusgTsVN89nGQ6n0cr8ONwoztpIw+EZcWb0uHDYITTp19Hcs22
         MetQQQ2baramRz2hKewgB0N/vX2JgET4CvpKxi2xpYIqJgdug7ObN9e7QSuXY+2xJg
         irWpEVNJK6PN25USb0H7wm43GXQbBaixyNmVWdnFNgelUtCxFIXix6LCR/0PMABqvR
         1Hu0lJ1eNNj5l+CVurXJNJrBFsD7cGvcJlTtKUdCUxr0ZTCxM73tR9blNsqmcKLGqM
         RVXOojnUKRdlA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tuo Li <islituo@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, a.hajda@samsung.com,
        mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 25/74] media: s5p-mfc: fix possible null-pointer dereference in s5p_mfc_probe()
Date:   Mon,  8 Nov 2021 12:48:52 -0500
Message-Id: <20211108174942.1189927-25-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174942.1189927-1-sashal@kernel.org>
References: <20211108174942.1189927-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuo Li <islituo@gmail.com>

[ Upstream commit 8515965e5e33f4feb56134348c95953f3eadfb26 ]

The variable pdev is assigned to dev->plat_dev, and dev->plat_dev is
checked in:
  if (!dev->plat_dev)

This indicates both dev->plat_dev and pdev can be NULL. If so, the
function dev_err() is called to print error information.
  dev_err(&pdev->dev, "No platform data specified\n");

However, &pdev->dev is an illegal address, and it is dereferenced in
dev_err().

To fix this possible null-pointer dereference, replace dev_err() with
mfc_err().

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index b776f83e395e0..f8a5ed6bb9d7a 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1279,7 +1279,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	spin_lock_init(&dev->condlock);
 	dev->plat_dev = pdev;
 	if (!dev->plat_dev) {
-		dev_err(&pdev->dev, "No platform data specified\n");
+		mfc_err("No platform data specified\n");
 		return -ENODEV;
 	}
 
-- 
2.33.0

