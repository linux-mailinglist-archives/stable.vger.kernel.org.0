Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2066D44A3FA
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243410AbhKIBcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:32:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:50180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244263AbhKIBZD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:25:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C45E61B55;
        Tue,  9 Nov 2021 01:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420180;
        bh=Uex9h7YseuhlAs0JCsyeFQpH1/CR2LdViy8pLjB+99k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/VYxR3GHFL/brTjldyEouJHIOPiuR9xBh2Emnvadzl1laDNIz1Viq3A7JI4DFkkz
         AAiSF4YCZ743ZlRsP04NaVlgUnE3iIZDwHvYrtI+O8KsAvH9+pg2cIE7ghJJ7C2AD+
         l8a9JYQOnTbsBn7oYp5pezSEZkRIxwriyYbT44ws0oN86iQjV4Z+Leb0SiuRQ54YlS
         27AXWVROGexomBiZz/jTfzQKbanHTZA4so+k8xQU6o6KI3zBS5quyr0Xh/aGV6PwGE
         6EOhtc8zoE7SJkCdZP6O3ab8zIcdYgasT/p5sCUJY+2dmi+wx1FjRvc3tWdFYyDbOH
         ewpOpkJQ3bOtA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tuo Li <islituo@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, a.hajda@samsung.com,
        mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 12/30] media: s5p-mfc: fix possible null-pointer dereference in s5p_mfc_probe()
Date:   Mon,  8 Nov 2021 20:09:00 -0500
Message-Id: <20211109010918.1192063-12-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010918.1192063-1-sashal@kernel.org>
References: <20211109010918.1192063-1-sashal@kernel.org>
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
index 7727789dbda14..daa5b4dea092c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1102,7 +1102,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	spin_lock_init(&dev->condlock);
 	dev->plat_dev = pdev;
 	if (!dev->plat_dev) {
-		dev_err(&pdev->dev, "No platform data specified\n");
+		mfc_err("No platform data specified\n");
 		return -ENODEV;
 	}
 
-- 
2.33.0

