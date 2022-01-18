Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3374C49141B
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244489AbiARCUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:20:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244361AbiARCUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:20:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61A8C061574;
        Mon, 17 Jan 2022 18:19:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63643612CF;
        Tue, 18 Jan 2022 02:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB938C36AF2;
        Tue, 18 Jan 2022 02:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472398;
        bh=KHJX1CBivhLoDwFSvdl5GVShspbncmIWqtKSQBbrEYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YlEGAf6kl2fq43DOFQJsApfFj2OcaZBizmh8xVv81gzYsfndo4pK0ieDZ7CvRPXBO
         913etGF93KD8uv4AKUtkwU4xAp4vnnaMBH+KZiVHAG+64C9/AtD4z+nqgR4FglwCSx
         EY3kBcECa5Ny0ObmgEw8ndkt0KG7rKJ/LTjERESGItTI/R+Sc0FzPeZF1uOSkytzpv
         F19e2WdDEkdPmDozf37H9bwFrPi1hxMYV3ypR/uctQAjpQPT4Tjzx1soX6owx7Ykvt
         j0D/GPf2SCSlnrfEWaamZ5X9q/4ObHaG4eu8yti74UeUp1bAYi7M77KaifsZoMPiI8
         /zRasjYXNvOCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiang Yu <yuq825@gmail.com>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Roman Stratiienko <r.stratiienko@gmail.com>,
        Sasha Levin <sashal@kernel.org>, airlied@linux.ie,
        daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        lima@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.16 011/217] drm/lima: fix warning when CONFIG_DEBUG_SG=y & CONFIG_DMA_API_DEBUG=y
Date:   Mon, 17 Jan 2022 21:16:14 -0500
Message-Id: <20220118021940.1942199-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiang Yu <yuq825@gmail.com>

[ Upstream commit 89636a06fa2ee7826a19c39c19a9bc99ab9340a9 ]

Otherwise get following warning:

DMA-API: lima 1c40000.gpu: mapping sg segment longer than device claims to support [len=4149248] [max=65536]

See: https://gitlab.freedesktop.org/mesa/mesa/-/issues/5496

Reviewed-by: Vasily Khoruzhick <anarsoul@gmail.com>
Reported-by: Roman Stratiienko <r.stratiienko@gmail.com>
Signed-off-by: Qiang Yu <yuq825@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211031041604.187216-1-yuq825@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/lima/lima_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/lima/lima_device.c b/drivers/gpu/drm/lima/lima_device.c
index f74f8048af8f2..02cef0cea6572 100644
--- a/drivers/gpu/drm/lima/lima_device.c
+++ b/drivers/gpu/drm/lima/lima_device.c
@@ -358,6 +358,7 @@ int lima_device_init(struct lima_device *ldev)
 	int err, i;
 
 	dma_set_coherent_mask(ldev->dev, DMA_BIT_MASK(32));
+	dma_set_max_seg_size(ldev->dev, UINT_MAX);
 
 	err = lima_clk_init(ldev);
 	if (err)
-- 
2.34.1

