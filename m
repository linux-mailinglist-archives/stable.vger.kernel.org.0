Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3748444A1C4
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242209AbhKIBMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:12:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:38486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239950AbhKIBJr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:09:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFF9161360;
        Tue,  9 Nov 2021 01:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419860;
        bh=QJctPq2mvvXd9D5+REVvKRYsNwuWRooixOau3OZ0qMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9aSg9o2IeAAdPW6psRBhoIbQC8d9StU5OQ5PbYHDCl0Sefejlf69z+gwLS57LVJs
         3s3y50xwF+SxzuxhLJdLdDtL7B/Clli9XNM7UWtBswvL2GwwFQK/DEP/BrqBnfj2F3
         mg6hKKRU0r6LB30fjjblfo8L+WWkPoUGu32Z3HO5+9EIrU59nCoQ5Otg18yupjTFoT
         weMEMI8VAvU/iPJ6iiUHLIStB08o4lhKl2TROhq7i3+xZQygwRmkpV/AoAKD1KM6/b
         qH5mHYUpIEp3lQY0+Rk3giWD6Jcflh6lNRQuzEP5d2mPy78GkZtTT0h40DR7qPE+h/
         3DGClL+L8oNYw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tuo Li <islituo@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, a.hajda@samsung.com,
        mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 034/101] media: s5p-mfc: fix possible null-pointer dereference in s5p_mfc_probe()
Date:   Mon,  8 Nov 2021 12:47:24 -0500
Message-Id: <20211108174832.1189312-34-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174832.1189312-1-sashal@kernel.org>
References: <20211108174832.1189312-1-sashal@kernel.org>
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
index eba2b9f040df0..c763c0a03140c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1283,7 +1283,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	spin_lock_init(&dev->condlock);
 	dev->plat_dev = pdev;
 	if (!dev->plat_dev) {
-		dev_err(&pdev->dev, "No platform data specified\n");
+		mfc_err("No platform data specified\n");
 		return -ENODEV;
 	}
 
-- 
2.33.0

