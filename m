Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9802C15EA2E
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392207AbgBNRMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:12:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:41254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392118AbgBNQNK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:13:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8378246BD;
        Fri, 14 Feb 2020 16:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696789;
        bh=TC/KpPcIPU52VDqpKV9ZMspVLevk1JgSEAKgRSDF0mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rt8uOFdVw2/L1dNK0banADnCL/rwZYFIzSEKnp2Ov2NwbaF3EbcAUK1rCczLwHtuA
         sIbRKGty1djNNLzcZrVo7n3AXbVJNojI67aDkz++MPnHmUOlsPnZ/zpNEbTMJFlec9
         aAF/2IppR5ZvdXn5cqOLu/7FlCji1Lr7d1672X+Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhengbin <zhengbin13@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 064/252] drm/gma500: remove set but not used variable 'error'
Date:   Fri, 14 Feb 2020 11:08:39 -0500
Message-Id: <20200214161147.15842-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>

[ Upstream commit a5eb29a9d2fc03d07af7d02f6c2e7ae1e6d985f9 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/gpu/drm/gma500/psb_irq.c: In function psb_sgx_interrupt:
drivers/gpu/drm/gma500/psb_irq.c:210:6: warning: variable error set but not used [-Wunused-but-set-variable]

It is introduced by commit 64a4aff283ac ("drm/gma500:
Add support for SGX interrupts"), but never used, so remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/1573828027-122323-3-git-send-email-zhengbin13@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/gma500/psb_irq.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/gma500/psb_irq.c b/drivers/gpu/drm/gma500/psb_irq.c
index 78eb109028091..f75f199c84311 100644
--- a/drivers/gpu/drm/gma500/psb_irq.c
+++ b/drivers/gpu/drm/gma500/psb_irq.c
@@ -207,7 +207,6 @@ static void psb_sgx_interrupt(struct drm_device *dev, u32 stat_1, u32 stat_2)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	u32 val, addr;
-	int error = false;
 
 	if (stat_1 & _PSB_CE_TWOD_COMPLETE)
 		val = PSB_RSGX32(PSB_CR_2D_BLIT_STATUS);
@@ -242,7 +241,6 @@ static void psb_sgx_interrupt(struct drm_device *dev, u32 stat_1, u32 stat_2)
 
 			DRM_ERROR("\tMMU failing address is 0x%08x.\n",
 				  (unsigned int)addr);
-			error = true;
 		}
 	}
 
-- 
2.20.1

