Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFDBD1780D6
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387528AbgCCR7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:59:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:42120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733082AbgCCR7F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:59:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AA68206D5;
        Tue,  3 Mar 2020 17:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258345;
        bh=trmqcw4mum0jAgYjGfrbgcFg0HUsASEtcGK5hr0g88M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Op4EO1Ulif6vGJ2ndMJ2mlWz3co/IbjB72TF3p9vAd1GXJunZMOxMaVEs2ilNGk6j
         AkIINNIWcERthUxV3iDzJf86fNElDpvSC4A9P/ZUwc/NltPYU+wXyiTVU7XU3g914z
         uIZ37qEbvmWqobkqPwOIohZ8PgcWNX26sMslqNK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Thierry Reding <treding@nvidia.com>,
        Olof Johansson <olof@lixom.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/87] soc/tegra: fuse: Fix build with Tegra194 configuration
Date:   Tue,  3 Mar 2020 18:43:05 +0100
Message-Id: <20200303174350.419174638@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 6f4ecbe284df5f22e386a640d9a4b32cede62030 ]

If only Tegra194 support is enabled, the tegra30_fuse_read() and
tegra30_fuse_init() function are not declared and cause a build failure.
Add Tegra194 to the preprocessor guard to make sure these functions are
available for Tegra194-only builds as well.

Link: https://lore.kernel.org/r/20200203143114.3967295-1-thierry.reding@gmail.com
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/fuse/fuse-tegra30.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/tegra/fuse/fuse-tegra30.c b/drivers/soc/tegra/fuse/fuse-tegra30.c
index 257e254c6137f..0ec6385eb15e6 100644
--- a/drivers/soc/tegra/fuse/fuse-tegra30.c
+++ b/drivers/soc/tegra/fuse/fuse-tegra30.c
@@ -47,7 +47,8 @@
     defined(CONFIG_ARCH_TEGRA_124_SOC) || \
     defined(CONFIG_ARCH_TEGRA_132_SOC) || \
     defined(CONFIG_ARCH_TEGRA_210_SOC) || \
-    defined(CONFIG_ARCH_TEGRA_186_SOC)
+    defined(CONFIG_ARCH_TEGRA_186_SOC) || \
+    defined(CONFIG_ARCH_TEGRA_194_SOC)
 static u32 tegra30_fuse_read_early(struct tegra_fuse *fuse, unsigned int offset)
 {
 	if (WARN_ON(!fuse->base))
-- 
2.20.1



