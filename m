Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B956EF65CC
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbfKJCoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:44:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:43868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728564AbfKJCoa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2E8C222BE;
        Sun, 10 Nov 2019 02:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353869;
        bh=xscJ7EClHwitBaxZMa5jBEldDG3fG8cJaiC13LZuq10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MfLJIDYfNRw+8U99Mpg5RLuBQb4OPIBz30RJHxU0TnFtqn7oZi4EWx9l3MBewDUqG
         55YtaOT4SYPTJ24UVsVb6tsfGLX2OaJ5HxzQeKHi+NVzdcNoL0iGxHAI7sX/IxW7wd
         i31QvPyr1W19Q/OtH7ewZWevwq5MctwbSiLRCUOI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 149/191] RDMA: Fix dependencies for rdma_user_mmap_io
Date:   Sat,  9 Nov 2019 21:39:31 -0500
Message-Id: <20191110024013.29782-149-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 46bdf777685677c1cc6b3da9220aace9da690731 ]

The mlx4 driver produces a link error when it is configured
as built-in while CONFIG_INFINIBAND_USER_ACCESS is set to =m:

drivers/infiniband/hw/mlx4/main.o: In function `mlx4_ib_mmap':
main.c:(.text+0x1af4): undefined reference to `rdma_user_mmap_io'

The same function is called from mlx5, which already has a
dependency to ensure we can call it, and from hns, which
appears to suffer from the same problem.

This adds the same dependency that mlx5 uses to the other two.

Fixes: 6745d356ab39 ("RDMA/hns: Use rdma_user_mmap_io")
Fixes: c282da4109e4 ("RDMA/mlx4: Use rdma_user_mmap_io")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/Kconfig  | 1 +
 drivers/infiniband/hw/mlx4/Kconfig | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/hns/Kconfig b/drivers/infiniband/hw/hns/Kconfig
index fddb5fdf92de8..21c2100b2ea98 100644
--- a/drivers/infiniband/hw/hns/Kconfig
+++ b/drivers/infiniband/hw/hns/Kconfig
@@ -1,6 +1,7 @@
 config INFINIBAND_HNS
 	tristate "HNS RoCE Driver"
 	depends on NET_VENDOR_HISILICON
+	depends on INFINIBAND_USER_ACCESS || !INFINIBAND_USER_ACCESS
 	depends on ARM64 || (COMPILE_TEST && 64BIT)
 	---help---
 	  This is a RoCE/RDMA driver for the Hisilicon RoCE engine. The engine
diff --git a/drivers/infiniband/hw/mlx4/Kconfig b/drivers/infiniband/hw/mlx4/Kconfig
index db4aa13ebae0c..d1de3285fd885 100644
--- a/drivers/infiniband/hw/mlx4/Kconfig
+++ b/drivers/infiniband/hw/mlx4/Kconfig
@@ -1,6 +1,7 @@
 config MLX4_INFINIBAND
 	tristate "Mellanox ConnectX HCA support"
 	depends on NETDEVICES && ETHERNET && PCI && INET
+	depends on INFINIBAND_USER_ACCESS || !INFINIBAND_USER_ACCESS
 	depends on MAY_USE_DEVLINK
 	select NET_VENDOR_MELLANOX
 	select MLX4_CORE
-- 
2.20.1

