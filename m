Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D869749978F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448727AbiAXVNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:13:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58514 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447054AbiAXVJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:09:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D33061320;
        Mon, 24 Jan 2022 21:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E16CC340E5;
        Mon, 24 Jan 2022 21:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058596;
        bh=7FuChzgMaV2OYhpaYWC7LUUS8H6TQwy/LwWyEKCH3tY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O44MWlWuHV74b4juXZhE1Q7fAIsdClVH0Y+ZED6T8hPKnIVUAeg8RXnTsfUH0ob9Q
         1bs3QCX/v+t3kMx5nV81DmIQHOu7VcZiHGOqSofTZsKMnEkCMJYQPSrfmFeVeEEF81
         6XBEEAAH0dJU60E95ZyxQCmj9L0Tf/6UbTCcfaMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0297/1039] gpu: host1x: select CONFIG_DMA_SHARED_BUFFER
Date:   Mon, 24 Jan 2022 19:34:46 +0100
Message-Id: <20220124184135.279937254@linuxfoundation.org>
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



