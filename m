Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88F71D3C30
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbgENSwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 14:52:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728041AbgENSwB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:52:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 385F720722;
        Thu, 14 May 2020 18:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482321;
        bh=tf2ztxkAvM8sk5YuIjcwOdoi9GJMWD9JK3628o4+K3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7zAaw7iWFoO8Wk3Vgu+//IrGN+hPpbsFt6kHtkye8EcoiyfzFI+oxInL6tr4kK27
         rqdTQCp5/UxTSOei0f7q6QtXCZigXUBIicrXdFew6rbMIdTESX9/Q08Z1hd1uwHu3H
         jIzIgM3FzVzFVK6FjnbWwbd0ElUVU05FmUjqphN8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        kbuild test robot <lkp@intel.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 09/62] phy: tegra: Select USB_COMMON for usb_get_maximum_speed()
Date:   Thu, 14 May 2020 14:50:54 -0400
Message-Id: <20200514185147.19716-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185147.19716-1-sashal@kernel.org>
References: <20200514185147.19716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 0d5c9bc7c68009af04bbadf22306467674c6fb90 ]

The usb_get_maximum_speed() function is part of the usb-common module,
so enable it by selecting the corresponding Kconfig symbol.

While at it, also make sure to depend on USB_SUPPORT because USB_PHY
requires that. This can lead to Kconfig conflicts if USB_SUPPORT is not
enabled while attempting to enable PHY_TEGRA_XUSB.

Reported-by: kbuild test robot <lkp@intel.com>
Suggested-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20200330101038.2422389-1-thierry.reding@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/tegra/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/tegra/Kconfig b/drivers/phy/tegra/Kconfig
index f9817c3ae85f0..2e66a123f5a2c 100644
--- a/drivers/phy/tegra/Kconfig
+++ b/drivers/phy/tegra/Kconfig
@@ -1,7 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config PHY_TEGRA_XUSB
 	tristate "NVIDIA Tegra XUSB pad controller driver"
-	depends on ARCH_TEGRA
+	depends on ARCH_TEGRA && USB_SUPPORT
+	select USB_COMMON
 	help
 	  Choose this option if you have an NVIDIA Tegra SoC.
 
-- 
2.20.1

