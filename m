Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F8C3F65C2
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240009AbhHXRQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:16:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240181AbhHXRO0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:14:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3AB761A81;
        Tue, 24 Aug 2021 17:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824501;
        bh=K7ppNRLPs2h9yFubF0KjgOLuqmlM13d4yKCmvqK1S+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m4rawQQKg9pKJpAcVjehYxzMrnq0o+nVO2Hol+Hidymwb5xdOxriHCr8rZCciivqO
         DXMNT4iZp7cjGYs18rvc6+zynVgfgHao/8ie3g6ZDyBxn3JtzGFMRi/V0Gvh4I1vDp
         AsG5Xzpo199UeXAmkSVQDUtvQR7ao5ESC0m7bkLl34kP9nrFRtM3RL+Vo+gdICMLoi
         hysMoPD3GuXDk+XJ/zMJUvAcYfu803/AEnpWoK4n79AqUyXcSYgUuBLwM5GVVMa0UO
         gujj7YNt7hV0FKP9N+Mi7rGZpc9UUf466IUjKbt0LHBHsLjotSYev0UDE4GFR3cuer
         CgyRVo7fbYNFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        kernel test robot <lkp@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 34/61] ptp_pch: Restore dependency on PCI
Date:   Tue, 24 Aug 2021 13:00:39 -0400
Message-Id: <20210824170106.710221-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.143-rc1
X-KernelTest-Deadline: 2021-08-26T17:01+00:00
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
index 0517272a268e..9fb6f7643ea9 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -92,7 +92,8 @@ config DP83640_PHY
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

