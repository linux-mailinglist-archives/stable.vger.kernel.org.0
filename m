Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE41D29B80C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799276AbgJ0Pak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799266AbgJ0Pai (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:30:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 466F82225E;
        Tue, 27 Oct 2020 15:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812637;
        bh=CQKTD0d148XiW1IMPDm/KF4m8s/GqQ4VL9p2bSbZns4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TT4RNNOaONzf33HiJLH8O9eCWFArJV7tk0khn12Y0iLhnT7tAvHDu8VtcURRza1e2
         snW5RDnRkDk5vEU8OIbfRrvdTmJe7z0SR+VL6FQxwy/IAaJiHr9uChSVS4FlTmFyK+
         vaZ9WMHMbBcvtflwQ5i2v9+yqm2LROdOytnu49X0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Price <steven.price@arm.com>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 248/757] drm/panfrost: Ensure GPU quirks are always initialised
Date:   Tue, 27 Oct 2020 14:48:18 +0100
Message-Id: <20201027135502.220126543@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index f2c1ddc41a9bf..689b92893e0e1 100644
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
@@ -355,7 +357,6 @@ int panfrost_gpu_init(struct panfrost_device *pfdev)
 		return err;
 	}
 
-	panfrost_gpu_init_quirks(pfdev);
 	panfrost_gpu_power_on(pfdev);
 
 	return 0;
-- 
2.25.1



