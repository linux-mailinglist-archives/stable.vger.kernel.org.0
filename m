Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5328328D9B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241031AbhCATOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:14:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:39782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235226AbhCATJf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:09:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 684DE650C1;
        Mon,  1 Mar 2021 17:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620550;
        bh=jlN6g22lrXypVtavH1lj1OLAcBEFVpU31LB8cTkyxIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTglxcjLAKa18OAaq3Mci5QOdjTiD5UXsw+EmFkkuu7G5xdDmP8kIlyVeIg9kRxgK
         VfWtPTcT8Sgr15T5eQGlZnpXY5A924sLIJEBZHsDakt09YTXmtuhOY9B+yrGEm60rg
         8kqLZSvj8Vlh8wG5IUL2b8IXwBbN7Z4VBwjdZ5VQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 193/775] media: ipu3-cio2: Build only for x86
Date:   Mon,  1 Mar 2021 17:06:01 +0100
Message-Id: <20210301161211.173696012@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 3ef5e42d281ea108f4ccdca186de4ce20a346326 ]

According to the original code in the driver it was never assumed to work
with big page sizes: unsigned short type followed by PAGE_SHIFT and
PAGE_MASK which may be different on non-x86 architectures.

Recently LKP found an issue on non-x86 architectures due to above
mentioned limitations. Since Sakari acknowledges that it's not really
useful to be able to compile this elsewhere, mark it x86 only.

Fixes: a31d19f88932 ("media: ipu3: allow building it with COMPILE_TEST on non-x86 archs")
Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu3/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/intel/ipu3/Kconfig b/drivers/media/pci/intel/ipu3/Kconfig
index 82d7f17e6a024..7a805201034b7 100644
--- a/drivers/media/pci/intel/ipu3/Kconfig
+++ b/drivers/media/pci/intel/ipu3/Kconfig
@@ -2,7 +2,8 @@
 config VIDEO_IPU3_CIO2
 	tristate "Intel ipu3-cio2 driver"
 	depends on VIDEO_V4L2 && PCI
-	depends on (X86 && ACPI) || COMPILE_TEST
+	depends on ACPI || COMPILE_TEST
+	depends on X86
 	select MEDIA_CONTROLLER
 	select VIDEO_V4L2_SUBDEV_API
 	select V4L2_FWNODE
-- 
2.27.0



