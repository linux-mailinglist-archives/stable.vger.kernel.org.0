Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84137BA60C
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390687AbfIVSrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:47:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390674AbfIVSrS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:47:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9FAC214D9;
        Sun, 22 Sep 2019 18:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178037;
        bh=9m2JYGkvWDmA0P2yVuAEtBW885OyXdy4d9jpcGwBEes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ArSizjlrmrp3YjwwHKIwV+LTEmMxhUWF2ZRPjWo7fM23t7RsIfgPWyfuxHvglxl8l
         mUxXeKfk0+WQqZOV1ZKPwaTcjpKWXqF5uzv8MO69HtrOilXFCkeVnISiFqswZ79lYb
         UdsuL9BQV/5koQAvGpwiXcgao6bBPLa/1cmAw6LQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 118/203] soc: renesas: Enable ARM_ERRATA_754322 for affected Cortex-A9
Date:   Sun, 22 Sep 2019 14:42:24 -0400
Message-Id: <20190922184350.30563-118-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 2eced4607a1e6f51f928ae3e521fe02be5cb7d23 ]

ARM Erratum 754322 affects Cortex-A9 revisions r2p* and r3p*.

Automatically enable support code to mitigate the erratum when compiling
a kernel for any of the affected Renesas SoCs:
  - RZ/A1: r3p0,
  - R-Mobile A1: r2p4,
  - R-Car M1A: r2p2-00rel0,
  - R-Car H1: r3p0,
  - SH-Mobile AG5: r2p2.

EMMA Mobile EV2 (r1p3) and RZ/A2 (r4p1) are not affected.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/renesas/Kconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/soc/renesas/Kconfig b/drivers/soc/renesas/Kconfig
index 2bbf49e5d4418..9583c542c47f7 100644
--- a/drivers/soc/renesas/Kconfig
+++ b/drivers/soc/renesas/Kconfig
@@ -55,6 +55,7 @@ config ARCH_EMEV2
 
 config ARCH_R7S72100
 	bool "RZ/A1H (R7S72100)"
+	select ARM_ERRATA_754322
 	select PM
 	select PM_GENERIC_DOMAINS
 	select RENESAS_OSTM
@@ -78,6 +79,7 @@ config ARCH_R8A73A4
 config ARCH_R8A7740
 	bool "R-Mobile A1 (R8A77400)"
 	select ARCH_RMOBILE
+	select ARM_ERRATA_754322
 	select RENESAS_INTC_IRQPIN
 
 config ARCH_R8A7743
@@ -105,10 +107,12 @@ config ARCH_R8A77470
 config ARCH_R8A7778
 	bool "R-Car M1A (R8A77781)"
 	select ARCH_RCAR_GEN1
+	select ARM_ERRATA_754322
 
 config ARCH_R8A7779
 	bool "R-Car H1 (R8A77790)"
 	select ARCH_RCAR_GEN1
+	select ARM_ERRATA_754322
 	select HAVE_ARM_SCU if SMP
 	select HAVE_ARM_TWD if SMP
 	select SYSC_R8A7779
@@ -152,6 +156,7 @@ config ARCH_R9A06G032
 config ARCH_SH73A0
 	bool "SH-Mobile AG5 (R8A73A00)"
 	select ARCH_RMOBILE
+	select ARM_ERRATA_754322
 	select HAVE_ARM_SCU if SMP
 	select HAVE_ARM_TWD if SMP
 	select RENESAS_INTC_IRQPIN
-- 
2.20.1

