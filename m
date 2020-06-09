Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 163CE1F45A3
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgFIRtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:49:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732580AbgFIRtv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:49:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78F7720801;
        Tue,  9 Jun 2020 17:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591724989;
        bh=PLNJeXxTBPc66RzOoR4Z0fys6oMg6bP2vmEK7g3T1FI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2VA2FMKiNaf6HFa2prwC5oJdI5Odu0qBmqsFoKUW0/yV64ysdu2GSdJoVh4J8iQZ+
         7E+q5cpgLE0Y6NO+OSF+VzrRpd31eTdym5b9e1DpnHqeLslTflAlQiqm0AQMvoQo1N
         8nNEy4CeyVE137+cDBHDnextttDclk04ipjPRvLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 08/46] ARC: [plat-eznps]: Restrict to CONFIG_ISA_ARCOMPACT
Date:   Tue,  9 Jun 2020 19:44:24 +0200
Message-Id: <20200609174023.628305829@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174022.938987501@linuxfoundation.org>
References: <20200609174022.938987501@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

[ Upstream commit 799587d5731db9dcdafaac4002463aa7d9cd6cf7 ]

Elide invalid configuration EZNPS + ARCv2, triggered by a
make allyesconfig build.

Granted the root cause is in source code (asm/barrier.h) where we check
for ARCv2 before PLAT_EZNPS, but it is better to avoid such combinations
at onset rather then baking subtle nuances into code.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/plat-eznps/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arc/plat-eznps/Kconfig b/arch/arc/plat-eznps/Kconfig
index ce908e2c5282..71378bfec8d0 100644
--- a/arch/arc/plat-eznps/Kconfig
+++ b/arch/arc/plat-eznps/Kconfig
@@ -6,6 +6,7 @@
 
 menuconfig ARC_PLAT_EZNPS
 	bool "\"EZchip\" ARC dev platform"
+	depends on ISA_ARCOMPACT
 	select CPU_BIG_ENDIAN
 	select CLKSRC_NPS if !PHYS_ADDR_T_64BIT
 	select EZNPS_GIC
-- 
2.25.1



