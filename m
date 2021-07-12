Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C843C5331
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344104AbhGLHyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344981AbhGLHsk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:48:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 231CE6162B;
        Mon, 12 Jul 2021 07:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075761;
        bh=G/K3Crhd6tJ6ZgMrsEAgkpCBVgafFxlC8sWRLdF9XLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uq+DdtFbNpJa3vautgssV8V7nwiynERvn9MT+7vLWSDZih5bzjY0uPijfMEwXuPl6
         RM1K106TXko+G0e+bojqiVXRsXkWiJHgYKkEnmH/0hyKPjkVW9eLriPklSJtjmt0xU
         9C3PG3kUQtsvdtkuNkpWlXn9b0A7B3NnjfpHeF5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dafna Hirschfeld <dafna.hirschfeld@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 353/800] media: mtk-vpu: on suspend, read/write regs only if vpu is running
Date:   Mon, 12 Jul 2021 08:06:16 +0200
Message-Id: <20210712061004.652134891@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>

[ Upstream commit 11420749c6b4b237361750de3d5b5579175f8622 ]

If the vpu is not running, we should not rely on VPU_IDLE_REG
value. In this case, the suspend cb should only unprepare the
clock. This fixes a system-wide suspend to ram failure:

[  273.073363] PM: suspend entry (deep)
[  273.410502] mtk-msdc 11230000.mmc: phase: [map:ffffffff] [maxlen:32] [final:10]
[  273.455926] Filesystems sync: 0.378 seconds
[  273.589707] Freezing user space processes ... (elapsed 0.003 seconds) done.
[  273.600104] OOM killer disabled.
[  273.603409] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[  273.613361] mwifiex_sdio mmc2:0001:1: None of the WOWLAN triggers enabled
[  274.784952] mtk_vpu 10020000.vpu: vpu idle timeout
[  274.789764] PM: dpm_run_callback(): platform_pm_suspend+0x0/0x70 returns -5
[  274.796740] mtk_vpu 10020000.vpu: PM: failed to suspend: error -5
[  274.802842] PM: Some devices failed to suspend, or early wake event detected
[  275.426489] OOM killer enabled.
[  275.429718] Restarting tasks ...
[  275.435765] done.
[  275.447510] PM: suspend exit

Fixes: 1f565e263c3e ("media: mtk-vpu: VPU should be in idle state before system is suspended")
Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-vpu/mtk_vpu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/platform/mtk-vpu/mtk_vpu.c b/drivers/media/platform/mtk-vpu/mtk_vpu.c
index c8a56271b259..7c4428cf14e6 100644
--- a/drivers/media/platform/mtk-vpu/mtk_vpu.c
+++ b/drivers/media/platform/mtk-vpu/mtk_vpu.c
@@ -987,6 +987,12 @@ static int mtk_vpu_suspend(struct device *dev)
 		return ret;
 	}
 
+	if (!vpu_running(vpu)) {
+		vpu_clock_disable(vpu);
+		clk_unprepare(vpu->clk);
+		return 0;
+	}
+
 	mutex_lock(&vpu->vpu_mutex);
 	/* disable vpu timer interrupt */
 	vpu_cfg_writel(vpu, vpu_cfg_readl(vpu, VPU_INT_STATUS) | VPU_IDLE_STATE,
-- 
2.30.2



