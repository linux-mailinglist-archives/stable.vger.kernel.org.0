Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0852344A222
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241294AbhKIBQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:16:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:40458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242728AbhKIBOM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:14:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F26161A09;
        Tue,  9 Nov 2021 01:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419948;
        bh=vX3XEse8BNh+6SkQZ8/Qtrl79RAZXOZ0Sx1Lyy6b0Wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDsgX7L/30EqwdAXRhhneVY5P09ra/RRKObuQWIO2PTw4kKskG+Uwgxb6FeR0D4GN
         F1rDnCcl7qsFjdR80QxiU9cLkOCM54afwnQAE7LKNPqnWZTkHDDZvuxsn/QIVsRLad
         e7x6HKGhdORmHChQ5/65OFdfd5TuOzSwwagJFVQ9n1YJ1qxcocA5xBZ0Ppf+qqIEac
         39q24qUZ+bY5BIuRrXy/nsYdpufXK5R+7vfsOCVAmLxEfLRZugtXIoGTVMPo6VIIUN
         XZQlZ/GzVk3+RQdOgrYIf7o62c5FEPqUw6B+Iv4xHHkTYrub92bEqbVunLyews4iZF
         7Uj+ljEjumW7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tuo Li <islituo@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, a.hajda@samsung.com,
        mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 18/47] media: s5p-mfc: fix possible null-pointer dereference in s5p_mfc_probe()
Date:   Mon,  8 Nov 2021 12:50:02 -0500
Message-Id: <20211108175031.1190422-18-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
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
index 4b8516c35bc20..80bb58d31c3f6 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1276,7 +1276,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	spin_lock_init(&dev->condlock);
 	dev->plat_dev = pdev;
 	if (!dev->plat_dev) {
-		dev_err(&pdev->dev, "No platform data specified\n");
+		mfc_err("No platform data specified\n");
 		return -ENODEV;
 	}
 
-- 
2.33.0

