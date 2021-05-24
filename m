Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2A138EF88
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234745AbhEXP6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:58:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234853AbhEXP46 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:56:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 856636194C;
        Mon, 24 May 2021 15:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871001;
        bh=Q7N5BFJD1w+E3XQGJHFoJg4hWxx3QjNXlxWafl5zlYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h5gT2JyJTbt6dUpoKp2na/SxFxOD+l/3YLQfOuf1dwUtfholdDszKe/+R/FNgUArV
         bfHPPs/33rcP6kR4j4YZwJ05EYtYxA+CEOqTEDJ9MlINNA7nl3GDzutRxVEdJRBBMH
         bQJTeLeHTaMtlSfOEvpFaM0F0LHVxZmGSlbJqMIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, xinhui pan <xinhui.pan@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 027/127] drm/ttm: Do not add non-system domain BO into swap list
Date:   Mon, 24 May 2021 17:25:44 +0200
Message-Id: <20210524152335.763973546@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: xinhui pan <xinhui.pan@amd.com>

[ Upstream commit ad2c28bd9a4083816fa45a7e90c2486cde8a9873 ]

BO would be added into swap list if it is validated into system domain.
If BO is validated again into non-system domain, say, VRAM domain. It
actually should not be in the swap list.

Signed-off-by: xinhui pan <xinhui.pan@amd.com>
Acked-by: Guchun Chen <guchun.chen@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210224032808.150465-1-xinhui.pan@amd.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_bo.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 101a68dc615b..799ec7a7caa4 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -153,6 +153,8 @@ void ttm_bo_move_to_lru_tail(struct ttm_buffer_object *bo,
 
 		swap = &ttm_bo_glob.swap_lru[bo->priority];
 		list_move_tail(&bo->swap, swap);
+	} else {
+		list_del_init(&bo->swap);
 	}
 
 	if (bdev->driver->del_from_lru_notify)
-- 
2.30.2



