Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CDF3F6519
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239030AbhHXRK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:10:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239024AbhHXRIE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:08:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB00461A38;
        Tue, 24 Aug 2021 17:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824403;
        bh=aXang1viFh8gd2lw1E6A5ooGAb/t8CsBx7L5U6AMAxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zsa2YdP0oaJKd38/dCQ6dm5G7GZszCVivxxcBBKp6yihy7JCg5Wy78Nr7ObPgplRZ
         gxGPkuXJEW1Dkn5QZNE/Dt7XF9s4FlsBTIfLOOS8LzouL0WTv2H11c9xTXzSew+l5Y
         ItRlbJyRB5bQ+g4voF9l+8OjWOipODLsZEElmn4IdEDd/RIyvzBSpChC7sj/S4riNF
         NBxy1hwkihMD1ntwwC3gaRU6AFR7tcw3B7qTpAFqCzC73/fLi+05xUzEz5xUE8BE47
         WpMFOT/oJZ2J5/G1A+KmgrG/ZuFRBWFY02+5wOEWxVaHkB6gPT+kBQ5vrh+VyvBzdf
         3SrHKULjQYsSw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        kernel test robot <lkp@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 54/98] ptp_pch: Restore dependency on PCI
Date:   Tue, 24 Aug 2021 12:58:24 -0400
Message-Id: <20210824165908.709932-55-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 55c8fca1dae1fb0d11deaa21b65a647dedb1bc50 ]

During the swap dependency on PCH_GBE to selection PTP_1588_CLOCK_PCH
incidentally dropped the implicit dependency on the PCI. Restore it.

Fixes: 18d359ceb044 ("pch_gbe, ptp_pch: Fix the dependency direction between these drivers")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index deb429a3dff1..3e377f3c69e5 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -90,7 +90,8 @@ config PTP_1588_CLOCK_INES
 config PTP_1588_CLOCK_PCH
 	tristate "Intel PCH EG20T as PTP clock"
 	depends on X86_32 || COMPILE_TEST
-	depends on HAS_IOMEM && NET
+	depends on HAS_IOMEM && PCI
+	depends on NET
 	imply PTP_1588_CLOCK
 	help
 	  This driver adds support for using the PCH EG20T as a PTP
-- 
2.30.2

