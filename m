Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6BFE47ACB8
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236663AbhLTOqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:46:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37098 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235430AbhLTOnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:43:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 477D7611BC;
        Mon, 20 Dec 2021 14:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CAE0C36AE8;
        Mon, 20 Dec 2021 14:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011420;
        bh=nCcllGnloMbPxDxi9tnGf1r+X75h46np8ZxojuJNSlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kGR9zfhzrBr3Hfw5ypfcdfDGLuIcCvcCCZ29ez0uqTiytQ9pWXJ5u5ZAcVbPvW5vu
         df7VR67sA09fj7HC20144pcttPiGVa39jpuSuSf39VK0cRqDN5IoEjTGwQ17r3LkXx
         tFPmFle5+N4UfWp0ke4tR51RsL56BdeY2okH1YHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        Michael Kelley <mikelley@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 15/71] hv: utils: add PTP_1588_CLOCK to Kconfig to fix build
Date:   Mon, 20 Dec 2021 15:34:04 +0100
Message-Id: <20211220143026.201418732@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 1dc2f2b81a6a9895da59f3915760f6c0c3074492 ]

The hyperv utilities use PTP clock interfaces and should depend a
a kconfig symbol such that they will be built as a loadable module or
builtin so that linker errors do not happen.

Prevents these build errors:

ld: drivers/hv/hv_util.o: in function `hv_timesync_deinit':
hv_util.c:(.text+0x37d): undefined reference to `ptp_clock_unregister'
ld: drivers/hv/hv_util.o: in function `hv_timesync_init':
hv_util.c:(.text+0x738): undefined reference to `ptp_clock_register'

Fixes: 3716a49a81ba ("hv_utils: implement Hyper-V PTP source")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: linux-hyperv@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20211126023316.25184-1-rdunlap@infradead.org
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
index 79e5356a737a2..210e532ac277f 100644
--- a/drivers/hv/Kconfig
+++ b/drivers/hv/Kconfig
@@ -17,6 +17,7 @@ config HYPERV_TIMER
 config HYPERV_UTILS
 	tristate "Microsoft Hyper-V Utilities driver"
 	depends on HYPERV && CONNECTOR && NLS
+	depends on PTP_1588_CLOCK_OPTIONAL
 	help
 	  Select this option to enable the Hyper-V Utilities.
 
-- 
2.33.0



