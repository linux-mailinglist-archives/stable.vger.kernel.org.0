Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB43B499553
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392566AbiAXUvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390833AbiAXUq2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:46:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727F2C061243;
        Mon, 24 Jan 2022 11:56:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E9C9B8121C;
        Mon, 24 Jan 2022 19:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F009C340E5;
        Mon, 24 Jan 2022 19:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054167;
        bh=FpFOz55NDArr1D4SGMUr6c5B/Pd266OUahPpfqk8l5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTqQh2/eP1CLyBJvnz/LJ4hk5uuMAxeVvxeeBXwxzw6L8dQ4yLA9DiXGXERwtQEGZ
         Rs8aKlukynXCOvnxY+2JA45WHRfzzKhjogKWbblYFGvqKsFFufDW+sDfybFgF1z869
         Z3UDpSC+Oj6qRSP54xRHX+/zVX7uezc+mGcqM5Ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Khoruzhick <anarsoul@gmail.com>,
        Roman Stratiienko <r.stratiienko@gmail.com>,
        Qiang Yu <yuq825@gmail.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 301/563] drm/lima: fix warning when CONFIG_DEBUG_SG=y & CONFIG_DMA_API_DEBUG=y
Date:   Mon, 24 Jan 2022 19:41:06 +0100
Message-Id: <20220124184034.854329625@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 65fdca366e41f..36c9905894278 100644
--- a/drivers/gpu/drm/lima/lima_device.c
+++ b/drivers/gpu/drm/lima/lima_device.c
@@ -357,6 +357,7 @@ int lima_device_init(struct lima_device *ldev)
 	int err, i;
 
 	dma_set_coherent_mask(ldev->dev, DMA_BIT_MASK(32));
+	dma_set_max_seg_size(ldev->dev, UINT_MAX);
 
 	err = lima_clk_init(ldev);
 	if (err)
-- 
2.34.1



