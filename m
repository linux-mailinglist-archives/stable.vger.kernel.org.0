Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363F13F676C
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241273AbhHXRda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:33:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241890AbhHXRbW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:31:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1ABF6141B;
        Tue, 24 Aug 2021 17:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824748;
        bh=ZW2pB7bIps+bRCd1KQyDfbm042Nd6FhaOooC8zGq4L4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0w2ugeYKoPXebOh7kKQ4aMTUGWpoF/Gr57NRkGRt27IkG/TmUVISlS1LxyX8pGG2
         E/4fEY5cILIst2itKDIBCA0xFL3ZR1dunatC6y1PTot56njlD7SB/BXBcQurFiUs/+
         FhjQQRaNKYms0cuSz3sByH0W4gDeCABEaq0lALDrecG3Rkbfk7FCmrqXPzzKNg2RV9
         QsijE01RWL06HZx9oiC2nKkAJF2IEmHinKM7Qe8gMEDy9HiMeGnPyqiB5hQa+FVhMf
         F/utf96b/xah+eUwiGk1yLWbigLINc8eVwsQNss+ZxLQm+vE3nlwX1TjK5gBzsJR7k
         TmVzMsEY44O0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        kernel test robot <lkp@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 52/64] ptp_pch: Restore dependency on PCI
Date:   Tue, 24 Aug 2021 13:04:45 -0400
Message-Id: <20210824170457.710623-53-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
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
index a21ad10d613c..a8b4ca17208d 100644
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

