Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98345431D97
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbhJRNwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:52:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234109AbhJRNua (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:50:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEBF36187A;
        Mon, 18 Oct 2021 13:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564277;
        bh=tXOypJQAjdg1gcxHa5MGXJvnkhGmDkzFtfHi6z3g7j4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CB9FivORtQ2p6H76Piy8e7bGpXno1p/EDIm6mSguQSh1n5Aypx5chNh8kiCKnDb4G
         opDW6feqjVuO0vjMhnFDI9uQ48K2iyLcWLiXUSmfmIegNjXPb5dgNXBSahn2oZjSaN
         qV9wJk3ao6xM+1yv5/o1GJ8hbZ4b+yqbwtJ4KBrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.14 028/151] drm/msm: Do not run snapshot on non-DPU devices
Date:   Mon, 18 Oct 2021 15:23:27 +0200
Message-Id: <20211018132341.602101023@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

commit 6a7e0b0e9fb839caa7c7f25bcf91a95b1c2cbef1 upstream.

Since commit 98659487b845 ("drm/msm: add support to take dpu snapshot")
the following NULL pointer dereference is seen on i.MX53:

[ 3.275493] msm msm: bound 30000000.gpu (ops a3xx_ops)
[ 3.287174] [drm] Initialized msm 1.8.0 20130625 for msm on minor 0
[ 3.293915] 8<--- cut here ---
[ 3.297012] Unable to handle kernel NULL pointer dereference at virtual address 00000028
[ 3.305244] pgd = (ptrval)
[ 3.307989] [00000028] *pgd=00000000
[ 3.311624] Internal error: Oops: 805 [#1] SMP ARM
[ 3.316430] Modules linked in:
[ 3.319503] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.14.0+g682d702b426b #1
[ 3.326652] Hardware name: Freescale i.MX53 (Device Tree Support)
[ 3.332754] PC is at __mutex_init+0x14/0x54
[ 3.336969] LR is at msm_disp_snapshot_init+0x24/0xa0

i.MX53 does not use the DPU controller.

Fix the problem by only calling msm_disp_snapshot_init() on platforms that
use the DPU controller.

Cc: stable@vger.kernel.org
Fixes: 98659487b845 ("drm/msm: add support to take dpu snapshot")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/20210914174831.2044420-1-festevam@gmail.com
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/msm_drv.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -566,10 +566,11 @@ static int msm_drm_init(struct device *d
 	if (ret)
 		goto err_msm_uninit;
 
-	ret = msm_disp_snapshot_init(ddev);
-	if (ret)
-		DRM_DEV_ERROR(dev, "msm_disp_snapshot_init failed ret = %d\n", ret);
-
+	if (kms) {
+		ret = msm_disp_snapshot_init(ddev);
+		if (ret)
+			DRM_DEV_ERROR(dev, "msm_disp_snapshot_init failed ret = %d\n", ret);
+	}
 	drm_mode_config_reset(ddev);
 
 #ifdef CONFIG_DRM_FBDEV_EMULATION


