Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0EB41E2C0A
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403923AbgEZTL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:11:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391950AbgEZTL0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:11:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D92F20888;
        Tue, 26 May 2020 19:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520286;
        bh=DKb0ALmsiFZedu5tthQYLY1kwwXyjwj+9xGl6d2TjXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qEVom3Gfj0pWnej9s4NEpCSJsmA5dtx4lJC4GQNc4vbU5NCiDuYNGuatcimGpjjzK
         5p5iWkoGJ5bB+jwr3tmxfDcwB72NSGHbAhhVPaBLDecdLYXgj2NO3H5Jmb809J6L0c
         3U2loUkWfVIC3AHiO8fRh2v74jKYkAQxbbmqIksc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 002/126] ARC: [plat-hsdk]: fix USB regression
Date:   Tue, 26 May 2020 20:52:19 +0200
Message-Id: <20200526183937.694190297@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>

[ Upstream commit 4c13ca86dcf80a8c705b1f3674ff43d318e970e0 ]

As of today the CONFIG_USB isn't explicitly present in HSDK defconfig
as it is implicitly forcibly enabled by UDL driver which selects CONFIG_USB
in its kconfig.
The commit 5d50bd440bc2 ("drm/udl: Make udl driver depend on CONFIG_USB")
reverse the dependencies between UDL and USB so UDL now depends on
CONFIG_USB and not selects it. This introduces regression for ARC HSDK
board as HSDK defconfig wasn't adjusted and now it misses USB support
due to lack of CONFIG_USB enabled.

Fix that.

Cc: <stable@vger.kernel.org> # 5.6.x
Fixes: 5d50bd440bc2 ("drm/udl: Make udl driver depend on CONFIG_USB")
Signed-off-by: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/configs/hsdk_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arc/configs/hsdk_defconfig b/arch/arc/configs/hsdk_defconfig
index 0974226fab55..aa000075a575 100644
--- a/arch/arc/configs/hsdk_defconfig
+++ b/arch/arc/configs/hsdk_defconfig
@@ -65,6 +65,7 @@ CONFIG_DRM_UDL=y
 CONFIG_DRM_ETNAVIV=y
 CONFIG_FB=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
+CONFIG_USB=y
 CONFIG_USB_EHCI_HCD=y
 CONFIG_USB_EHCI_HCD_PLATFORM=y
 CONFIG_USB_OHCI_HCD=y
-- 
2.25.1



