Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D81629C2A8
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1820793AbgJ0RiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:38:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760354AbgJ0Oep (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:34:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC426207BB;
        Tue, 27 Oct 2020 14:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809284;
        bh=U1/EQmUCs1K3RWAhVipzsNc8+B3ohnd64s0zlhr9toY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BgVhXoVjIwQ8dqQBbNgjKAJ4SsxM3QnhVm7712byXtCYujBYLGiPg4D/00zQ4+iCr
         RoFt8nohpxYGhWzBavS0OyaA1bNfDNSS+pzT9wpQEvNb+UP2yhdOcgulDOi+Iy45Us
         RvsBpJ14zTMzrmKu8kk+sc0JfEOcpal4fH40srhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Price <steven.price@arm.com>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 141/408] drm/panfrost: Ensure GPU quirks are always initialised
Date:   Tue, 27 Oct 2020 14:51:19 +0100
Message-Id: <20201027135501.637067196@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Price <steven.price@arm.com>

[ Upstream commit 8c3c818c23a5bbce6ff180dd2ee04415241df77c ]

The GPU 'CONFIG' registers used to work around hardware issues are
cleared on reset so need to be programmed every time the GPU is reset.
However panfrost_device_reset() failed to do this.

To avoid this in future instead move the call to
panfrost_gpu_init_quirks() to panfrost_gpu_power_on() so that the
regsiters are always programmed just before the cores are powered.

Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200909122957.51667-1-steven.price@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_gpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_gpu.c b/drivers/gpu/drm/panfrost/panfrost_gpu.c
index 8822ec13a0d61..1431db13ec788 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gpu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gpu.c
@@ -304,6 +304,8 @@ void panfrost_gpu_power_on(struct panfrost_device *pfdev)
 	int ret;
 	u32 val;
 
+	panfrost_gpu_init_quirks(pfdev);
+
 	/* Just turn on everything for now */
 	gpu_write(pfdev, L2_PWRON_LO, pfdev->features.l2_present);
 	ret = readl_relaxed_poll_timeout(pfdev->iomem + L2_READY_LO,
@@ -357,7 +359,6 @@ int panfrost_gpu_init(struct panfrost_device *pfdev)
 		return err;
 	}
 
-	panfrost_gpu_init_quirks(pfdev);
 	panfrost_gpu_power_on(pfdev);
 
 	return 0;
-- 
2.25.1



