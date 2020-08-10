Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF8F240FA5
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbgHJTM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:12:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729540AbgHJTM2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:12:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A978622BEB;
        Mon, 10 Aug 2020 19:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086747;
        bh=JWAfkfYeNpyvQQn7ChNaZq+27MlhnSQL1lGDK0L33lA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2OfpuA7NmEcRyguChjnyxac5e5FkyjJ8wc3S2/0v5O7eCeBipMRzTm1Nq4GYNuojk
         NpWVRcnBLKeWPfkl8Ti1AJVqHuAn5HbrDXd6I0Y3XZFi4bc/x1woHeWDqgNtLomBZB
         l712GNrqUkLKprYTw+WesY3ubQprHL+S1TlUz8Eo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 24/45] drm/radeon: disable AGP by default
Date:   Mon, 10 Aug 2020 15:11:32 -0400
Message-Id: <20200810191153.3794446-24-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191153.3794446-1-sashal@kernel.org>
References: <20200810191153.3794446-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

[ Upstream commit ba806f98f868ce107aa9c453fef751de9980e4af ]

Always use the PCI GART instead. We just have to many cases
where AGP still causes problems. This means a performance
regression for some GPUs, but also a bug fix for some others.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_drv.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index 7d417b9a52501..c2573096d43c0 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -174,12 +174,7 @@ int radeon_no_wb;
 int radeon_modeset = -1;
 int radeon_dynclks = -1;
 int radeon_r4xx_atom = 0;
-#ifdef __powerpc__
-/* Default to PCI on PowerPC (fdo #95017) */
 int radeon_agpmode = -1;
-#else
-int radeon_agpmode = 0;
-#endif
 int radeon_vram_limit = 0;
 int radeon_gart_size = -1; /* auto */
 int radeon_benchmarking = 0;
-- 
2.25.1

