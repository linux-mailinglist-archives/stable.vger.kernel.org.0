Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC141CA9E6
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732888AbfJCRB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:01:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404061AbfJCQou (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:44:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1CEB2070B;
        Thu,  3 Oct 2019 16:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121090;
        bh=9m2JYGkvWDmA0P2yVuAEtBW885OyXdy4d9jpcGwBEes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAqVn8C3Ne5s6xgUnc8yL3qGY80EsfVyuWir2PliRd2ygD5c6wgo8XJRe4FGxo55q
         lqOACdUh8kb+G6FxdykGPoKvBmj3MgI71H7KeFxbFqrA+kZE8HozKSIcxi/SV6nhZh
         HVwQbRrOGBrTHMySFus7n+dbFiHw4BlwlLnpd4Ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 151/344] soc: renesas: Enable ARM_ERRATA_754322 for affected Cortex-A9
Date:   Thu,  3 Oct 2019 17:51:56 +0200
Message-Id: <20191003154555.146144185@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



