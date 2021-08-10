Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3683F3E80BB
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236267AbhHJRvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:51:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234212AbhHJRuP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:50:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 536006125F;
        Tue, 10 Aug 2021 17:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617346;
        bh=Ytw1cLf0Lyybp1VabA0vBqJp3f9hKUPHh5H1Z7c2aaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sg+lzGf97n7uDXS3CwrP10BFyBhStWio2dGGoZGVNX3lVoDXDkNcHtBXnn37DYSfd
         asXDJFa4D/ZJGiADvu/GIWIAECOnqakTb9+/h5p8ZNvBcFafYsNb864dzDTOapFnx2
         fdo6fQT8Z4xCkZzaMVQBEhzpDhne0trHlqeGubNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 019/175] arm64: dts: armada-3720-turris-mox: fixed indices for the SDHC controllers
Date:   Tue, 10 Aug 2021 19:28:47 +0200
Message-Id: <20210810173001.582152565@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
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
index ce2bcddf396f..f2d7d6f071bc 100644
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



