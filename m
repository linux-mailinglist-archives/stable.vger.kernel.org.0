Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890FD328AA5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239550AbhCASUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:20:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:35644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239332AbhCASOV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:14:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F79E64DBD;
        Mon,  1 Mar 2021 17:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618635;
        bh=jlN6g22lrXypVtavH1lj1OLAcBEFVpU31LB8cTkyxIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L50reW+2f/nBgTnM8Devn2RUeens/buxuZr0BduP7nOOMLvIICVZ5x2ml0Wh2Djrf
         xDCmmzJEVp5r8P5ZVM4yJidNznScZNvW0JKOwXZJ9YFYKT0GNfLXAv69MoR/qiQnkV
         TPvKeb7ctOHDgBhBr04YVf3LEwnEC8bnhboQh7jw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 159/663] media: ipu3-cio2: Build only for x86
Date:   Mon,  1 Mar 2021 17:06:47 +0100
Message-Id: <20210301161149.638859783@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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



