Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A920177E16
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 18:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731131AbgCCRqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:46:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:52932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731129AbgCCRqY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:46:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D807C208C3;
        Tue,  3 Mar 2020 17:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257583;
        bh=UsYeohpK6s/8P45xPBN0BM1m3ZQJsw1sNlWd83+Re8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZPi9lzT+UPROzwHk9NbME/6ZKLmo0OmlkJGvI94/+uqZw3WFFF/Up7NiBqfTY5HR
         WEE8ZfpDYPEWrFR+ZcKd7l/E34/xNwJlj35qRqvhRh+pwq5LhG5YECyfWmemiRnH7q
         9BnPiY8FJQFKTMOehZlVvBpb6gdmGOaDVCcBdoGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Thierry Reding <treding@nvidia.com>,
        Olof Johansson <olof@lixom.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 051/176] soc/tegra: fuse: Fix build with Tegra194 configuration
Date:   Tue,  3 Mar 2020 18:41:55 +0100
Message-Id: <20200303174310.446994948@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
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
index b8daaf5b7291b..efd158b4607cb 100644
--- a/drivers/soc/tegra/fuse/fuse-tegra30.c
+++ b/drivers/soc/tegra/fuse/fuse-tegra30.c
@@ -36,7 +36,8 @@
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



