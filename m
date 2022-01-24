Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2FF499356
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384491AbiAXUdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:33:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49444 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381767AbiAXUXe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:23:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F13E861008;
        Mon, 24 Jan 2022 20:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED69C340E8;
        Mon, 24 Jan 2022 20:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055808;
        bh=7FuChzgMaV2OYhpaYWC7LUUS8H6TQwy/LwWyEKCH3tY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2aBGdLHyrHETFtjmpXFlAnlIaWS3704E7VxUL1+TTlwsrZn8TSXJeFXMT04c7GsoD
         98vlGn2Ei/50hRvPzJl9kYTJWUl/tAihu7+/b2FZOOmq8WrjVQiITeYNDMQHOB+OpP
         b2HpFkrovSY1SefeG2gcXfX5PmqcrTQv/kXffVVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 255/846] gpu: host1x: select CONFIG_DMA_SHARED_BUFFER
Date:   Mon, 24 Jan 2022 19:36:12 +0100
Message-Id: <20220124184109.739731686@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 6c7a388b62366f0de9936db3c1921d7f4e0011bc ]

Linking fails when dma-buf is disabled:

ld.lld: error: undefined symbol: dma_fence_release
>>> referenced by fence.c
>>>               gpu/host1x/fence.o:(host1x_syncpt_fence_enable_signaling) in archive drivers/built-in.a
>>> referenced by fence.c
>>>               gpu/host1x/fence.o:(host1x_fence_signal) in archive drivers/built-in.a
>>> referenced by fence.c
>>>               gpu/host1x/fence.o:(do_fence_timeout) in archive drivers/built-in.a

Fixes: 687db2207b1b ("gpu: host1x: Add DMA fence implementation")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/host1x/Kconfig b/drivers/gpu/host1x/Kconfig
index 6dab94adf25e5..6815b4db17c1b 100644
--- a/drivers/gpu/host1x/Kconfig
+++ b/drivers/gpu/host1x/Kconfig
@@ -2,6 +2,7 @@
 config TEGRA_HOST1X
 	tristate "NVIDIA Tegra host1x driver"
 	depends on ARCH_TEGRA || (ARM && COMPILE_TEST)
+	select DMA_SHARED_BUFFER
 	select IOMMU_IOVA
 	help
 	  Driver for the NVIDIA Tegra host1x hardware.
-- 
2.34.1



