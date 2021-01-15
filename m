Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276662F7A51
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732891AbhAOMhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:37:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:44438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387935AbhAOMhL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8A00236FB;
        Fri, 15 Jan 2021 12:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714191;
        bh=0UqOFdZ0HNO4sY8SrYBkxnjjEJNIXWNcXygoYzrav6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SlCEdfuH7+DUKHiNRb1/CuIHnCiAFzdLwP4D5AAApRMrCyjm6obB9vJC9CaBjU9QN
         8/Sm4tvXN9t3Sc7R2G9s5cUEyH58hVi7qeK3nEqcouIYrew/PbpasfO1jtNPBh6VfV
         I3zFlUbFG4J8hdIAKHM9U8+2fd6EABgILOSyA9Lg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 024/103] ptp: ptp_ines: prevent build when HAS_IOMEM is not set
Date:   Fri, 15 Jan 2021 13:27:17 +0100
Message-Id: <20210115122007.222030723@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 1f685e6adbbe3c7b1bd9053be771b898d9efa655 ]

ptp_ines.c uses devm_platform_ioremap_resource(), which is only
built/available when CONFIG_HAS_IOMEM is enabled.
CONFIG_HAS_IOMEM is not enabled for arch/s390/, so builds on S390
have a build error:

s390-linux-ld: drivers/ptp/ptp_ines.o: in function `ines_ptp_ctrl_probe':
ptp_ines.c:(.text+0x17e6): undefined reference to `devm_platform_ioremap_resource'

Prevent builds of ptp_ines.c when HAS_IOMEM is not set.

Fixes: bad1eaa6ac31 ("ptp: Add a driver for InES time stamping IP core.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Link: lore.kernel.org/r/202101031125.ZEFCUiKi-lkp@intel.com
Acked-by: Richard Cochran <richardcochran@gmail.com>
Link: https://lore.kernel.org/r/20210106042531.1351-1-rdunlap@infradead.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ptp/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -78,6 +78,7 @@ config DP83640_PHY
 config PTP_1588_CLOCK_INES
 	tristate "ZHAW InES PTP time stamping IP core"
 	depends on NETWORK_PHY_TIMESTAMPING
+	depends on HAS_IOMEM
 	depends on PHYLIB
 	depends on PTP_1588_CLOCK
 	help


