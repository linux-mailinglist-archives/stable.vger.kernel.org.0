Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3344342B17F
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237579AbhJMA6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:58:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237459AbhJMA6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:58:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FC1360EDF;
        Wed, 13 Oct 2021 00:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086567;
        bh=1JCWJM5h9l5MnhFtkxyHxXoaEYnnSNwNurlbdVs2bKo=;
        h=From:To:Cc:Subject:Date:From;
        b=RbQ2PaecOshL35nrOII+b/7SN/b/vx6URPcZ1sF8H47bNCMSCWgCeDBWzNgK+ZN8F
         eh4QRhSFlHZhOJuR8iLt1UuABS+OBt3SoLxad4yX+/EOknWFiZf3fDZiLznihJfKrK
         K7VGUapSCxBtsF/62yWmvuRMo6hU3GqzrASSRYWGQlMBmD/JYyIcDvDM79tGNWcL6l
         /bbHhQ17IwYQcCMG86TQ3IsnVl8e5uR7iSNKy+Yl2DRFkvKWLJN/k1NQxBO10BIEab
         1efBzCdhMslPnnZv02jEfGjNs/9Ks1vm45DSukgBZg8E/Ol5Gv8Z0OciXyBGdOnaq9
         372UiYrHf6xNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joel Stanley <joel@jms.id.au>, Arnd Bergmann <arnd@arndb.de>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        krzysztof.kozlowski@canonical.com, alexandre.torgue@foss.st.com,
        treding@nvidia.com, digetx@gmail.com, m.szyprowski@samsung.com,
        olivier.moysan@st.com, mani@kernel.org, grygorii.strashko@ti.com,
        f.fainelli@gmail.com, stefan.wahren@i2se.com,
        alexandre.belloni@bootlin.com, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 1/6] ARM: config: mutli v7: Reenable FB dependency
Date:   Tue, 12 Oct 2021 20:55:57 -0400
Message-Id: <20211013005603.700363-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
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
index e4c8def9a0a5..32dfc736a4b1 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -677,6 +677,7 @@ CONFIG_DRM_PL111=m
 CONFIG_DRM_LIMA=m
 CONFIG_DRM_PANFROST=m
 CONFIG_DRM_ASPEED_GFX=m
+CONFIG_FB=y
 CONFIG_FB_EFI=y
 CONFIG_FB_WM8505=y
 CONFIG_FB_SH_MOBILE_LCDC=y
-- 
2.33.0

