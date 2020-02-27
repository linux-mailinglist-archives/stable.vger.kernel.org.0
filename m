Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D20AB1719C6
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730779AbgB0NsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:48:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:44534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730161AbgB0Nr5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:47:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F3E921D7E;
        Thu, 27 Feb 2020 13:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811276;
        bh=ofwbgNjBWpSvnTCV96oBhMiWdtYCquSy3RtoQ52qE2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bOvMYst/0OUlwa3yVUCkQ1o3ycP4DbX4+QECG6X4J5c6i4S0CFtjOxG5ajW8BntY0
         bM3GGnL8QXByFdDvujo+BRKKfZeeoEDBA50lThLY1urGIkyeTyR+egRGT5LyEGwoLF
         jo4rB0szJaks8Xxk7UMffhl/dbPZQBYFGqVxtBNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 070/165] soc/tegra: fuse: Correct straps address for older Tegra124 device trees
Date:   Thu, 27 Feb 2020 14:35:44 +0100
Message-Id: <20200227132241.631761356@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 2d9ea1934f8ef0dfb862d103389562cc28b4fc03 ]

Trying to read out Chip ID before APBMISC registers are mapped won't
succeed, in a result Tegra124 gets a wrong address for the HW straps
register if machine uses an old outdated device tree.

Fixes: 297c4f3dcbff ("soc/tegra: fuse: Restrict legacy code to 32-bit ARM")
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/fuse/tegra-apbmisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/tegra/fuse/tegra-apbmisc.c b/drivers/soc/tegra/fuse/tegra-apbmisc.c
index 5b18f6ffa45c7..cd61c883c19f5 100644
--- a/drivers/soc/tegra/fuse/tegra-apbmisc.c
+++ b/drivers/soc/tegra/fuse/tegra-apbmisc.c
@@ -134,7 +134,7 @@ void __init tegra_init_apbmisc(void)
 			apbmisc.flags = IORESOURCE_MEM;
 
 			/* strapping options */
-			if (tegra_get_chip_id() == TEGRA124) {
+			if (of_machine_is_compatible("nvidia,tegra124")) {
 				straps.start = 0x7000e864;
 				straps.end = 0x7000e867;
 			} else {
-- 
2.20.1



