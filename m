Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12DE23F66AD
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238653AbhHXR00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:26:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:59098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241139AbhHXRYS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:24:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF50861B22;
        Tue, 24 Aug 2021 17:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824635;
        bh=Aqxd822YINiV471mu2ngp7FSFP1pr1SPy9Fgek9H/F8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NptPPzu0t0HCUkGUpusD5n4d2WiFjgUvLCQM6TlNb8jWn/UqQ9wWaLyelx5KBecKK
         408dRWrgiNYGHaE+/rcPZzHcYJlUVp4LkNITB81FJNM/xGoSqv81z/3C4PllC89E2P
         KsdD52ON2Qs8ZUkbJR3r2RiZBI77TFxFwntg2EGGBDoqFquQHweDb1uLHloNFgO9e5
         6bpG9h4HtJU9v183xGZPDm+tO8zj416dUz2L6XqmN9Erph/VG7yhcMMM/FxdJFt6Pr
         xPPYa7Xoe/x3Jm2+w/g4gnIERBkxNvYKQUoMwUssK9meZsyGXZYCWrJuAudiOk0J1o
         ck2NWv3WZ3h2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        kernel test robot <lkp@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 66/84] ptp_pch: Restore dependency on PCI
Date:   Tue, 24 Aug 2021 13:02:32 -0400
Message-Id: <20210824170250.710392-67-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
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
index d137c480db46..dd04aedd76e0 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -91,7 +91,8 @@ config DP83640_PHY
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

