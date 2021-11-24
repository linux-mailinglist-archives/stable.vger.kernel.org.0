Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C38E45BB2C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242901AbhKXMRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:17:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:47096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243716AbhKXMPP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:15:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0839610F9;
        Wed, 24 Nov 2021 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755811;
        bh=dTg/yNAUnvDS1H7l1tqqToSBagvSeQxGASeVqlgRDO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VokHjmlhk3dOTBfSIicQUmYsCcwdHo2dL5H6ms4con+FC+gfKPUqCYthR76oo3lwY
         5M274T7gbzYHMEkjHi+fS+yVhBvzJA/mwBPwcWNIeulFRSUGcxPlpwd7m+/WMsYz2q
         pg2hss4UEqQgMZ9MZuDYVxwvmULjcpiQi2sQVRj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Tuo Li <islituo@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 067/207] media: s5p-mfc: fix possible null-pointer dereference in s5p_mfc_probe()
Date:   Wed, 24 Nov 2021 12:55:38 +0100
Message-Id: <20211124115706.095187944@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8051c13456922..0ff972b8d9671 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1160,7 +1160,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	spin_lock_init(&dev->condlock);
 	dev->plat_dev = pdev;
 	if (!dev->plat_dev) {
-		dev_err(&pdev->dev, "No platform data specified\n");
+		mfc_err("No platform data specified\n");
 		return -ENODEV;
 	}
 
-- 
2.33.0



