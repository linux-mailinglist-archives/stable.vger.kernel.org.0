Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE15B47AB57
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbhLTOgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:36:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44466 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233633AbhLTOgC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:36:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AB08B80EE0;
        Mon, 20 Dec 2021 14:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71218C36AE8;
        Mon, 20 Dec 2021 14:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640010960;
        bh=qeYDfgAi1cFub+Mx6J2hMCIFnHqaNdeHpJo+CUF7t/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QPyBYNxgihq+Jld7hk6DYQ3iYwnrQDRhpitjC4S+KK32dwRcVOxjJMpOGKm1UKo4A
         icpB/YHPyKy3bahlUFH1zigJ2sa2JcfD9hAqEW2wBDx/sSdEsHodarsswNJozuvkCq
         ansuniB/I+TFJPSP+7ph9+MEWVx2/COoB7xy9oyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 10/23] soc/tegra: fuse: Fix bitwise vs. logical OR warning
Date:   Mon, 20 Dec 2021 15:34:11 +0100
Message-Id: <20211220143018.181562886@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143017.842390782@linuxfoundation.org>
References: <20211220143017.842390782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit a7083763619f7485ccdade160deb81737cf2732f ]

A new warning in clang points out two instances where boolean
expressions are being used with a bitwise OR instead of logical OR:

drivers/soc/tegra/fuse/speedo-tegra20.c:72:9: warning: use of bitwise '|' with boolean operands [-Wbitwise-instead-of-logical]
                reg = tegra_fuse_read_spare(i) |
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~
                                               ||
drivers/soc/tegra/fuse/speedo-tegra20.c:72:9: note: cast one or both operands to int to silence this warning
drivers/soc/tegra/fuse/speedo-tegra20.c:87:9: warning: use of bitwise '|' with boolean operands [-Wbitwise-instead-of-logical]
                reg = tegra_fuse_read_spare(i) |
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~
                                               ||
drivers/soc/tegra/fuse/speedo-tegra20.c:87:9: note: cast one or both operands to int to silence this warning
2 warnings generated.

The motivation for the warning is that logical operations short circuit
while bitwise operations do not.

In this instance, tegra_fuse_read_spare() is not semantically returning
a boolean, it is returning a bit value. Use u32 for its return type so
that it can be used with either bitwise or boolean operators without any
warnings.

Fixes: 25cd5a391478 ("ARM: tegra: Add speedo-based process identification")
Link: https://github.com/ClangBuiltLinux/linux/issues/1488
Suggested-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/fuse/fuse-tegra.c | 2 +-
 drivers/soc/tegra/fuse/fuse.h       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/tegra/fuse/fuse-tegra.c b/drivers/soc/tegra/fuse/fuse-tegra.c
index c4f5e5bbb8dce..9397e8ba26469 100644
--- a/drivers/soc/tegra/fuse/fuse-tegra.c
+++ b/drivers/soc/tegra/fuse/fuse-tegra.c
@@ -176,7 +176,7 @@ static struct platform_driver tegra_fuse_driver = {
 };
 module_platform_driver(tegra_fuse_driver);
 
-bool __init tegra_fuse_read_spare(unsigned int spare)
+u32 __init tegra_fuse_read_spare(unsigned int spare)
 {
 	unsigned int offset = fuse->soc->info->spare + spare * 4;
 
diff --git a/drivers/soc/tegra/fuse/fuse.h b/drivers/soc/tegra/fuse/fuse.h
index 10c2076d5089a..f368bd5373088 100644
--- a/drivers/soc/tegra/fuse/fuse.h
+++ b/drivers/soc/tegra/fuse/fuse.h
@@ -62,7 +62,7 @@ struct tegra_fuse {
 void tegra_init_revision(void);
 void tegra_init_apbmisc(void);
 
-bool __init tegra_fuse_read_spare(unsigned int spare);
+u32 __init tegra_fuse_read_spare(unsigned int spare);
 u32 __init tegra_fuse_read_early(unsigned int offset);
 
 #ifdef CONFIG_ARCH_TEGRA_2x_SOC
-- 
2.33.0



