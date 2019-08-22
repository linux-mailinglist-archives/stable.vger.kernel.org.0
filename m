Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF4E99ACD
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388086AbfHVRPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:15:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390417AbfHVRIh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:37 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D767723405;
        Thu, 22 Aug 2019 17:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493717;
        bh=fc+CB2Ssrn59WPr6z/hOAw7WWXrO2WuzYj3CQEMvPIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fdg2oED7s9ErkhuGLE8mj/5sue9BAuNrtGIBKpc946feHbvhoBJDavsvc3bzvKQmm
         c1xsvfDOlaUxkGlsZkbujwcvXpRBX+e0pIrZSo6YPGi2oUa3wORPH9bFlrc8wgwubB
         Fchdz9iDBoUpXuee6c4nybkIOY5gwwiAL4oAO/Nw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jean Delvare <jdelvare@suse.de>,
        "Enrico Weigelt, metux IT consult" <info@metux.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 043/135] platform/x86: pcengines-apuv2: Fix softdep statement
Date:   Thu, 22 Aug 2019 13:06:39 -0400
Message-Id: <20190822170811.13303-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean Delvare <jdelvare@suse.de>

[ Upstream commit edbfe83def34153a05439ecb3352ae0bb65024de ]

Only first MODULE_SOFTDEP statement is handled per module.
Multiple dependencies must be expressed in a single statement.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Andy Shevchenko <andy@infradead.org>
[andy: massaged commit message]
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/pcengines-apuv2.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/platform/x86/pcengines-apuv2.c b/drivers/platform/x86/pcengines-apuv2.c
index c1ca931e1fab8..7a8cbfb5d2135 100644
--- a/drivers/platform/x86/pcengines-apuv2.c
+++ b/drivers/platform/x86/pcengines-apuv2.c
@@ -255,6 +255,4 @@ MODULE_DESCRIPTION("PC Engines APUv2/APUv3 board GPIO/LED/keys driver");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(dmi, apu_gpio_dmi_table);
 MODULE_ALIAS("platform:pcengines-apuv2");
-MODULE_SOFTDEP("pre: platform:" AMD_FCH_GPIO_DRIVER_NAME);
-MODULE_SOFTDEP("pre: platform:leds-gpio");
-MODULE_SOFTDEP("pre: platform:gpio_keys_polled");
+MODULE_SOFTDEP("pre: platform:" AMD_FCH_GPIO_DRIVER_NAME " platform:leds-gpio platform:gpio_keys_polled");
-- 
2.20.1

