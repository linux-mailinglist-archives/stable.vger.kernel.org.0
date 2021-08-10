Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4708B3E7F78
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234070AbhHJRke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235293AbhHJRj3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:39:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 104C661164;
        Tue, 10 Aug 2021 17:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617027;
        bh=VHK4iE+ZouWV29FULJZcZrMDuQ9PHpmquCZJ8/3fJvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rl8DaUNYc3h5xGhrtTZ/k8J8zt2BHiAvX6uEs1MhhevKiEKpJuJzogqFwDrVO3pny
         NN3EURjP4NViRpaq6aY62cQQe2/WuDYbkoKPBHbU61Cw3CDGhccbtEyolf88ZSYOL3
         5eYgaqhEljwTuNmRQNcRJUr+xoY23Zz7PuGOsJ0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/135] arm64: dts: armada-3720-turris-mox: fixed indices for the SDHC controllers
Date:   Tue, 10 Aug 2021 19:29:07 +0200
Message-Id: <20210810172956.130850164@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 923f98929182dfd04e9149be839160b63a3db145 ]

Since drivers/mmc/host/sdhci-xenon.c declares the PROBE_PREFER_ASYNCHRONOUS
probe type, it is not guaranteed whether /dev/mmcblk0 will belong to
sdhci0 or sdhci1. In turn, this will break booting by:

root=/dev/mmcblk0p1

Fix the issue by adding aliases so that the old MMC controller indices
are preserved.

Fixes: 7320915c8861 ("mmc: Set PROBE_PREFER_ASYNCHRONOUS for drivers that existed in v4.14")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
index 389aebdb35f1..2d51c6f3915d 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -19,6 +19,8 @@
 	aliases {
 		spi0 = &spi0;
 		ethernet1 = &eth1;
+		mmc0 = &sdhci0;
+		mmc1 = &sdhci1;
 	};
 
 	chosen {
-- 
2.30.2



