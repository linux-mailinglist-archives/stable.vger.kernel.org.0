Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5D537CC37
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhELQn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:43:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242909AbhELQgH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:36:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3F9361C34;
        Wed, 12 May 2021 16:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835213;
        bh=XXjOdhq4OKwkEJhPMgWyfvg5oHCTz6WJQgZGMu9/Q8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UhSmdcGOMl5SgOfIRwjxDT9q+MZk+8o4FVRvyrl/HGERCdgxrocZ49J2bCc+Hlnrm
         AJHaTdtl4MQASfeP9HU45ndRtVU8LQX8WINYKqRyHHGf08UZ+GKygm484/IW7No6Pb
         6IJR19K9+9H+lu9DfOIdRrk9I3EaIpPuRFfz6t0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 252/677] driver core: platform: Declare early_platform_cleanup() prototype
Date:   Wed, 12 May 2021 16:44:58 +0200
Message-Id: <20210512144845.609877063@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 1768289b44bae847612751d418fc5c5e680b5e5c ]

Compiler is not happy:

  CC      drivers/base/platform.o
drivers/base/platform.c:1557:20: warning: no previous prototype for ‘early_platform_cleanup’ [-Wmissing-prototypes]
 1557 | void __weak __init early_platform_cleanup(void) { }
      |                    ^~~~~~~~~~~~~~~~~~~~~~

Declare early_platform_cleanup() prototype in the header to make everyone happy.

Fixes: eecd37e105f0 ("drivers: Fix boot problem on SuperH")
Cc: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210331150525.59223-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/platform_device.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 3f23f6e430bf..cd81e060863c 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -359,4 +359,7 @@ static inline int is_sh_early_platform_device(struct platform_device *pdev)
 }
 #endif /* CONFIG_SUPERH */
 
+/* For now only SuperH uses it */
+void early_platform_cleanup(void);
+
 #endif /* _PLATFORM_DEVICE_H_ */
-- 
2.30.2



