Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A1649990B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454007AbiAXVbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:31:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44548 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451030AbiAXVWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:22:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1F2161320;
        Mon, 24 Jan 2022 21:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EE5C340E4;
        Mon, 24 Jan 2022 21:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059319;
        bh=KHJX1CBivhLoDwFSvdl5GVShspbncmIWqtKSQBbrEYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=00lfQvDFvd+Agb0mASjxRy5W5dK+LY/yPqLi7yMiSPXjjIqb3vc/Bn9rmyuqm68O7
         9Imj+xv+jozJi/l7j9paAQjHA1wt+ooC8sONB+Kn/LqD+JWAOs22fadgXMuGFjK8r9
         Cp9OERoo7iLPowzfYkle4j2b3cliM67zgBjJ/Y3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Khoruzhick <anarsoul@gmail.com>,
        Roman Stratiienko <r.stratiienko@gmail.com>,
        Qiang Yu <yuq825@gmail.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0549/1039] drm/lima: fix warning when CONFIG_DEBUG_SG=y & CONFIG_DMA_API_DEBUG=y
Date:   Mon, 24 Jan 2022 19:38:58 +0100
Message-Id: <20220124184143.737026613@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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



