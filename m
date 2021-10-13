Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7655542B121
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbhJMA4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233371AbhJMA4v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:56:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDF8B60EBB;
        Wed, 13 Oct 2021 00:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086488;
        bh=nHZAeFdwpNuJ6DivqYQ0TyEZD3g3Sxln+fUcFX1J5io=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwF2+qJb6ZlL/GDg+yZTtcEZj26SwGY8+x4VReCVPwktGxZArINtTSK7NvhFQTkiY
         4KxE5YjzvZnkgaCusb552E+/vsFg2holEV/2kUTj4Qt37cupiULy2D83zmHH7Boj8M
         ZqLBFQMxXQgmn3NjnHXAT3cS8bIIm7sxUSSuAn3qLW14ZjdkgW8tcejjF43nTYdZNl
         hpxiL2K3Ih5dDD+qZrdKDyN0uv1iBs2/106Ccbr4sPmVMCvEv2nl8X6NkP/wX23j1b
         nibbiJt8OZHNzLuRr7vClMSuLhRtl66l8NbHN70PrRpxxsIyAXfGKDIQapw5IYUI+I
         VyA3YQjASz+KQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joel Stanley <joel@jms.id.au>, Arnd Bergmann <arnd@arndb.de>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        krzysztof.kozlowski@canonical.com, alexandre.torgue@foss.st.com,
        treding@nvidia.com, digetx@gmail.com, olivier.moysan@st.com,
        m.szyprowski@samsung.com, mani@kernel.org,
        grygorii.strashko@ti.com, f.fainelli@gmail.com,
        lionel.debieve@st.com, stefan.wahren@i2se.com,
        alexandre.belloni@bootlin.com, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 02/17] ARM: config: multi v7: Enable dependancies
Date:   Tue, 12 Oct 2021 20:54:26 -0400
Message-Id: <20211013005441.699846-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013005441.699846-1-sashal@kernel.org>
References: <20211013005441.699846-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit cf8dd57bd0d62133e4ed9e1ad83af994fac34da5 ]

Some drivers have not been built as they gained dependencies in kconfig but those
dependencies were not added to the defconfig.

The MSM pinctrl drivers fell out of the defconfig as of commit be117ca32261
("pinctrl: qcom: Kconfig: Rework PINCTRL_MSM to be a depenency rather then a
selected config"). Add PINCTRL_MSM so these stay enabled.

EDAC depends on RAS, so enable it to ensure the EDAC drivers stay
enabled.

Signed-off-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/configs/multi_v7_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index d9abaae118dd..bd5775184c03 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -454,6 +454,7 @@ CONFIG_PINCTRL_STMFX=y
 CONFIG_PINCTRL_PALMAS=y
 CONFIG_PINCTRL_OWL=y
 CONFIG_PINCTRL_S500=y
+CONFIG_PINCTRL_MSM=y
 CONFIG_PINCTRL_APQ8064=y
 CONFIG_PINCTRL_APQ8084=y
 CONFIG_PINCTRL_IPQ8064=y
@@ -1114,6 +1115,7 @@ CONFIG_PHY_DM816X_USB=m
 CONFIG_OMAP_USB2=y
 CONFIG_TI_PIPE3=y
 CONFIG_TWL4030_USB=m
+CONFIG_RAS=y
 CONFIG_NVMEM_IMX_OCOTP=y
 CONFIG_ROCKCHIP_EFUSE=m
 CONFIG_NVMEM_SUNXI_SID=y
-- 
2.33.0

