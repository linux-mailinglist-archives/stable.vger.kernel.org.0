Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88AEECA9C0
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392996AbfJCQrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:47:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391908AbfJCQrN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:47:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 036EC2070B;
        Thu,  3 Oct 2019 16:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121232;
        bh=Qr/VRfoHX7sntmUIqwqsVChvtHI6zIMCrPB6fm/zYdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LzVRgAtT6D0Djkr0kN/ydtSEgr2WMe72apBfFPNG9F5kbG1xDDZUBdoT3rHPfehMx
         kKofiM+HxlspJlaD1e0niAmVWufzJwot7PWATwWgy6PTs7djpelMg+95EJMEmBEXCU
         WzNUyct9LPTf126QLyNmYWUhFPtvDyJcr32jCJuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "M. Vefa Bicakci" <m.v.b@runbox.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 203/344] platform/x86: intel_pmc_core_pltdrv: Module removal warning fix
Date:   Thu,  3 Oct 2019 17:52:48 +0200
Message-Id: <20191003154600.286807055@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: M. Vefa Bicakci <m.v.b@runbox.com>

[ Upstream commit 0b43e41e93815ecd9616759cf5d64d3a7be8e6fb ]

Prior to this commit, removing the intel_pmc_core_pltdrv module
would cause the following warning:

  Device 'intel_pmc_core.0' does not have a release() function, it is broken and must be fixed. See Documentation/kobject.txt.
  WARNING: CPU: 0 PID: 2202 at drivers/base/core.c:1238 device_release+0x6f/0x80

This commit hence adds an empty release function for the driver.

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_pmc_core_pltdrv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/x86/intel_pmc_core_pltdrv.c b/drivers/platform/x86/intel_pmc_core_pltdrv.c
index a8754a6db1b8b..186540014c480 100644
--- a/drivers/platform/x86/intel_pmc_core_pltdrv.c
+++ b/drivers/platform/x86/intel_pmc_core_pltdrv.c
@@ -18,8 +18,16 @@
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 
+static void intel_pmc_core_release(struct device *dev)
+{
+	/* Nothing to do. */
+}
+
 static struct platform_device pmc_core_device = {
 	.name = "intel_pmc_core",
+	.dev  = {
+		.release = intel_pmc_core_release,
+	},
 };
 
 /*
-- 
2.20.1



