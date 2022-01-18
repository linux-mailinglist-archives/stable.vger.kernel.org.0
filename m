Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4AF491A1D
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344528AbiARC6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:58:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36970 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346633AbiARCol (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:44:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63D7B612CF;
        Tue, 18 Jan 2022 02:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BA3C36AF4;
        Tue, 18 Jan 2022 02:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473879;
        bh=0Qm+dWNT8phmQ4tU5kIS5Fv5RyW+rZO78HIgmJ65jAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i/PZ9QjNCkm6OytoFrALAg/RDwIm6uPmVj7LbTy+OclvE8KnZ9lVFCnCpgmBYAAqf
         cV9hZ4QH3wRqzEkMWlUxnnlXmwiMun8joqC+wL2Y50xTgcQ7tYagN3wWzwdpwgGwFP
         +EQDb8QwIE7JfL4mi98d2QlYosTCOHlrXH8QSI14wa6cYTM6z9OyUkZ+RGSkr0JNWY
         mV4vPd+QS4JRLg1UE3wR7KQJM+BZhqu54hG/TQyTzWlZ2HLEU9TqDM/F8SyBeGwSkz
         9It2wJkezdg45kleipZ2U2baIQ69GM592YnIW/b6KyfYaSEWYJarduziVEcMF+hbei
         kDDjiy2SqmmGQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiang Yu <yuq825@gmail.com>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Roman Stratiienko <r.stratiienko@gmail.com>,
        Sasha Levin <sashal@kernel.org>, airlied@linux.ie,
        daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        lima@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 04/73] drm/lima: fix warning when CONFIG_DEBUG_SG=y & CONFIG_DMA_API_DEBUG=y
Date:   Mon, 17 Jan 2022 21:43:23 -0500
Message-Id: <20220118024432.1952028-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
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
index d86b8d81a483a..155971c57b2d5 100644
--- a/drivers/gpu/drm/lima/lima_device.c
+++ b/drivers/gpu/drm/lima/lima_device.c
@@ -293,6 +293,7 @@ int lima_device_init(struct lima_device *ldev)
 	struct resource *res;
 
 	dma_set_coherent_mask(ldev->dev, DMA_BIT_MASK(32));
+	dma_set_max_seg_size(ldev->dev, UINT_MAX);
 
 	err = lima_clk_init(ldev);
 	if (err)
-- 
2.34.1

