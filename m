Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003163B5FE7
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbhF1OVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232637AbhF1OVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6919C61C78;
        Mon, 28 Jun 2021 14:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889927;
        bh=c1VUlVMlSH6GP1FAhZeH2msdOmtAu6nQv1oaqvOZLNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hgkD0qnvh/TICdwB8yn1OPYCHjNz1Y69uhArzqvWPG+YdhYxjhaMKKs+KFVTLJqbn
         ZD547RjTgHovHyKetuWtj7ZeQr+CZrSAhymyJn8TvOmowdkTKRPczX90aHSSMfcvtX
         a+x1zy24FP4jTarAG8OpafGil5mDlKoAzBCy6FbmicI75p1Ceit6L5ItwrU3yTWtw/
         uM76DafWZ8VXpgKwLs3L3F3yvzfWKtqmfTtlZnv6F3lt4DGn+1mq6IEnVrWNaBZW44
         Klxmb3qcqPVukQ/8daTYD+pCBWMtVWtajZRbRWLq2FfZXpMs9zSNdSMJzaURlLvv9U
         wxdWwc84xYbZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Anitha Chrisanthus <anitha.chrisanthus@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 019/110] drm/kmb: Fix error return code in kmb_hw_init()
Date:   Mon, 28 Jun 2021 10:16:57 -0400
Message-Id: <20210628141828.31757-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 6fd8f323b3e4e5290d02174559308669507c00dd ]

When the call to platform_get_irq() to obtain the IRQ of the lcd fails, the
returned error code should be propagated. However, we currently do not
explicitly assign this error code to 'ret'. As a result, 0 was incorrectly
returned.

Fixes: 7f7b96a8a0a1 ("drm/kmb: Add support for KeemBay Display")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Anitha Chrisanthus <anitha.chrisanthus@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210513134639.6541-1-thunder.leizhen@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/kmb/kmb_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/kmb/kmb_drv.c b/drivers/gpu/drm/kmb/kmb_drv.c
index f64e06e1067d..96ea1a2c11dd 100644
--- a/drivers/gpu/drm/kmb/kmb_drv.c
+++ b/drivers/gpu/drm/kmb/kmb_drv.c
@@ -137,6 +137,7 @@ static int kmb_hw_init(struct drm_device *drm, unsigned long flags)
 	/* Allocate LCD interrupt resources */
 	irq_lcd = platform_get_irq(pdev, 0);
 	if (irq_lcd < 0) {
+		ret = irq_lcd;
 		drm_err(&kmb->drm, "irq_lcd not found");
 		goto setup_fail;
 	}
-- 
2.30.2

