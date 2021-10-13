Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1708D42B15C
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbhJMA6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:58:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237065AbhJMA5k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:57:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E78760EDF;
        Wed, 13 Oct 2021 00:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086538;
        bh=MdLNO9oBBNvO/nGTl8dOihtzp2DDDLxEW8a2nWW3+SY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V8gxzEGBMhvN3yzSvMP8rL/XlxyB2zzaMIurJXuTcQa/uLXbHXRL7Y0ET9mqShXM0
         igSyjHAog7ABtgxTGZMH3s2lo7OLLm9PbaliptPuJpqwRNNuDMC8gZHedbW56MOrCE
         jG5a9Cq+Zq1IxYRicApmDEZFUTTbgzE0kqM3c33oIoKwwWz8Bb9XsULuw+8Y5QsOj2
         KE0ys4rwfAI90GKFbZ7JiXH7bCwynTD4klHtXDjYesHJsCzl6mJbXTRKTc2TyoUXst
         op9uLB0wE2tEgfxPFzGZXOFTTmJjmFUm7v69Q71slCNSSB0mlgGKq6kzsUQGpw/M4A
         t4bgAU2bmPKwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joel Stanley <joel@jms.id.au>, Arnd Bergmann <arnd@arndb.de>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        krzysztof.kozlowski@canonical.com, alexandre.torgue@foss.st.com,
        digetx@gmail.com, treding@nvidia.com, m.szyprowski@samsung.com,
        olivier.moysan@st.com, mani@kernel.org, grygorii.strashko@ti.com,
        f.fainelli@gmail.com, lionel.debieve@st.com,
        alexandre.belloni@bootlin.com, stefan.wahren@i2se.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 02/11] ARM: config: mutli v7: Reenable FB dependency
Date:   Tue, 12 Oct 2021 20:55:22 -0400
Message-Id: <20211013005532.700190-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013005532.700190-1-sashal@kernel.org>
References: <20211013005532.700190-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit 8c1768967e2733d55abf449d8abd6f1915ba3539 ]

DRM_FBDEV_EMULATION previously selected FB and was default y as long as DRM
was enabled. In commit f611b1e7624c ("drm: Avoid circular dependencies for
CONFIG_FB") the select was replaced with a depends on FB, disabling the
drivers that depended on it.

Renable FB so we get back FB_EFI, FB_WM8505, FB_SH_MOBILE_LCDC, FB_SIMPLE and
VIDEO_VIVID.

It must be set to y and not a module as the test driver VIDEO_VIVID
requires it to be built in.

Link: https://lore.kernel.org/r/CAK8P3a18EdBKQdGDOZc9cPKsf=hY8==v2cO0DBE_tyd82Uq-Ng@mail.gmail.com
Signed-off-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index a611b0c1e540..b1073fb3a132 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -701,6 +701,7 @@ CONFIG_DRM_PL111=m
 CONFIG_DRM_LIMA=m
 CONFIG_DRM_PANFROST=m
 CONFIG_DRM_ASPEED_GFX=m
+CONFIG_FB=y
 CONFIG_FB_EFI=y
 CONFIG_FB_WM8505=y
 CONFIG_FB_SH_MOBILE_LCDC=y
-- 
2.33.0

