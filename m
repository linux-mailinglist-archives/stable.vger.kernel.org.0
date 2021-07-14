Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82BB63C8CFE
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235501AbhGNTnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:43:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230364AbhGNTmx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:42:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD6296044F;
        Wed, 14 Jul 2021 19:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291601;
        bh=IS1vLpPz6uocNDSd2Xrszaj7fRjp7DbJLKWZOOhIkb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X8obvJmzeWeiGhRv9qd2vl2WfDfo6bTUjkcxs8BxrlLz8cryaQBQNjqcrUXix3JpX
         KaAv65wu6LGx8Y98pzCCj1Iq2tFDUGXGg2zl5RQB35rdc5Eo8vJS/0yxAeZdCh98D/
         nvQl7Jj6AmmAl5C8rBmPZW7IKdDHBmPsFQT4Y39y8ytf63Z+oqIoUM5wonLRqXP4+t
         krwkpJsQqQTS951uyrea+AOiP38HuR+4JttsGLyycYyt3nK+tz4M77EKmDLxOGx1kj
         bj/QrAyQxdzJJ4RWRs+ReE4YiKvN8bPfXC6ZJLdVwxIT/MoTXWozc7OivXBrYMJp3F
         ZhTFGfzlrWIrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 083/108] firmware: tegra: bpmp: Fix Tegra234-only builds
Date:   Wed, 14 Jul 2021 15:37:35 -0400
Message-Id: <20210714193800.52097-83-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit bd778b893963d67d7eb01f49d84ffcd3eaf229dd ]

The tegra186_bpmp_ops symbol is used on Tegra234, so make sure it's
available.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/tegra/Makefile       | 1 +
 drivers/firmware/tegra/bpmp-private.h | 3 ++-
 drivers/firmware/tegra/bpmp.c         | 3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/tegra/Makefile b/drivers/firmware/tegra/Makefile
index 49c87e00fafb..620cf3fdd607 100644
--- a/drivers/firmware/tegra/Makefile
+++ b/drivers/firmware/tegra/Makefile
@@ -3,6 +3,7 @@ tegra-bpmp-y			= bpmp.o
 tegra-bpmp-$(CONFIG_ARCH_TEGRA_210_SOC)	+= bpmp-tegra210.o
 tegra-bpmp-$(CONFIG_ARCH_TEGRA_186_SOC)	+= bpmp-tegra186.o
 tegra-bpmp-$(CONFIG_ARCH_TEGRA_194_SOC)	+= bpmp-tegra186.o
+tegra-bpmp-$(CONFIG_ARCH_TEGRA_234_SOC)	+= bpmp-tegra186.o
 tegra-bpmp-$(CONFIG_DEBUG_FS)	+= bpmp-debugfs.o
 obj-$(CONFIG_TEGRA_BPMP)	+= tegra-bpmp.o
 obj-$(CONFIG_TEGRA_IVC)		+= ivc.o
diff --git a/drivers/firmware/tegra/bpmp-private.h b/drivers/firmware/tegra/bpmp-private.h
index 54d560c48398..182bfe396516 100644
--- a/drivers/firmware/tegra/bpmp-private.h
+++ b/drivers/firmware/tegra/bpmp-private.h
@@ -24,7 +24,8 @@ struct tegra_bpmp_ops {
 };
 
 #if IS_ENABLED(CONFIG_ARCH_TEGRA_186_SOC) || \
-    IS_ENABLED(CONFIG_ARCH_TEGRA_194_SOC)
+    IS_ENABLED(CONFIG_ARCH_TEGRA_194_SOC) || \
+    IS_ENABLED(CONFIG_ARCH_TEGRA_234_SOC)
 extern const struct tegra_bpmp_ops tegra186_bpmp_ops;
 #endif
 #if IS_ENABLED(CONFIG_ARCH_TEGRA_210_SOC)
diff --git a/drivers/firmware/tegra/bpmp.c b/drivers/firmware/tegra/bpmp.c
index 0742a90cb844..5654c5e9862b 100644
--- a/drivers/firmware/tegra/bpmp.c
+++ b/drivers/firmware/tegra/bpmp.c
@@ -809,7 +809,8 @@ static const struct dev_pm_ops tegra_bpmp_pm_ops = {
 };
 
 #if IS_ENABLED(CONFIG_ARCH_TEGRA_186_SOC) || \
-    IS_ENABLED(CONFIG_ARCH_TEGRA_194_SOC)
+    IS_ENABLED(CONFIG_ARCH_TEGRA_194_SOC) || \
+    IS_ENABLED(CONFIG_ARCH_TEGRA_234_SOC)
 static const struct tegra_bpmp_soc tegra186_soc = {
 	.channels = {
 		.cpu_tx = {
-- 
2.30.2

