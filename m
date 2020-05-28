Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090DD1E6082
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 14:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388631AbgE1ML3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 08:11:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388549AbgE1L4E (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 07:56:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F75D207D3;
        Thu, 28 May 2020 11:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590666963;
        bh=apuCjmo26NYIkrsmBlJnUuWxCVNtEFStOXDpG99cVcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/ublCAeiXrj9H/qCNPJWGXKVTICmWdOL96buihKb44On4bwj6LiR/pAEHU0x38lk
         qPQXuKRHWeNRkK0FuiYX7Vx/PVXH3B12Y9bJXJ+2oq+VNZgCIRILFNtHhjknh+R7yQ
         W9y0P2WnJUJMGZx2pF2o8P2DCEHtu1e2PLC6c3ZY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vineet Gupta <vgupta@synopsys.com>,
        kbuild test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 02/47] ARC: [plat-eznps]: Restrict to CONFIG_ISA_ARCOMPACT
Date:   Thu, 28 May 2020 07:55:15 -0400
Message-Id: <20200528115600.1405808-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115600.1405808-1-sashal@kernel.org>
References: <20200528115600.1405808-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index a931d0a256d0..a645bca5899a 100644
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

