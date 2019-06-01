Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A13E31E93
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfFANhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:37:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727688AbfFANVy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:21:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5925A27317;
        Sat,  1 Jun 2019 13:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395314;
        bh=dz7ImWkFud/FqpTDRiTLUrdEhfm7QdX4UEbVhuwS3AI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bbnEZHsNzD8db5iKogz1XLYJPB/vX7v408XuqVDDrrr8tBASAZusceluTwDXv1Oqn
         vCgKYsn63Sb5rPk4DXmWkSHU5iiYKZp0vX0bZd0anE2/nuePMBFPYkaY3agVFslNU6
         MfC5CZNRbWz3wXDobTgQNXGOtm4N3N803rVcl+rU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>, linux-watchdog@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 068/173] watchdog: Use depends instead of select for pretimeout governors
Date:   Sat,  1 Jun 2019 09:17:40 -0400
Message-Id: <20190601131934.25053-68-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131934.25053-1-sashal@kernel.org>
References: <20190601131934.25053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit f627ac0e12cd2736e60b9f5782ecec1d97251f77 ]

Watchdog pretimeout governors were enabled from the default governor
selection using "select". As a result, the default governor was always
built into the kernel, even if no watchdog driver was loaded. By using
"depends on" instead of "select", we are in better control, and the
governors can all be built as modules. At the same time, set the default
configuration option for pretimeout governors to match WATCHDOG_CORE
(meaning all pretimeout governors are by default enabled if pretimeout
support is enabled).

The practical impact of this change is minimal. Previously, selecting
a default governor automatically enabled that governor. Now, a default
governor can only be selected if that governor has been enabled.
Consequently, the order of governor selection is now reversed: The
governor selection is now first, followed by default governor selection.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/Kconfig | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 57f017d74a976..b65c907fc306a 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -2004,6 +2004,20 @@ config WATCHDOG_PRETIMEOUT_GOV
 
 if WATCHDOG_PRETIMEOUT_GOV
 
+config WATCHDOG_PRETIMEOUT_GOV_NOOP
+	tristate "Noop watchdog pretimeout governor"
+	default WATCHDOG_CORE
+	help
+	  Noop watchdog pretimeout governor, only an informational
+	  message is added to kernel log buffer.
+
+config WATCHDOG_PRETIMEOUT_GOV_PANIC
+	tristate "Panic watchdog pretimeout governor"
+	default WATCHDOG_CORE
+	help
+	  Panic watchdog pretimeout governor, on watchdog pretimeout
+	  event put the kernel into panic.
+
 choice
 	prompt "Default Watchdog Pretimeout Governor"
 	default WATCHDOG_PRETIMEOUT_DEFAULT_GOV_PANIC
@@ -2014,7 +2028,7 @@ choice
 
 config WATCHDOG_PRETIMEOUT_DEFAULT_GOV_NOOP
 	bool "noop"
-	select WATCHDOG_PRETIMEOUT_GOV_NOOP
+	depends on WATCHDOG_PRETIMEOUT_GOV_NOOP
 	help
 	  Use noop watchdog pretimeout governor by default. If noop
 	  governor is selected by a user, write a short message to
@@ -2022,7 +2036,7 @@ config WATCHDOG_PRETIMEOUT_DEFAULT_GOV_NOOP
 
 config WATCHDOG_PRETIMEOUT_DEFAULT_GOV_PANIC
 	bool "panic"
-	select WATCHDOG_PRETIMEOUT_GOV_PANIC
+	depends on WATCHDOG_PRETIMEOUT_GOV_PANIC
 	help
 	  Use panic watchdog pretimeout governor by default, if
 	  a watchdog pretimeout event happens, consider that
@@ -2030,18 +2044,6 @@ config WATCHDOG_PRETIMEOUT_DEFAULT_GOV_PANIC
 
 endchoice
 
-config WATCHDOG_PRETIMEOUT_GOV_NOOP
-	tristate "Noop watchdog pretimeout governor"
-	help
-	  Noop watchdog pretimeout governor, only an informational
-	  message is added to kernel log buffer.
-
-config WATCHDOG_PRETIMEOUT_GOV_PANIC
-	tristate "Panic watchdog pretimeout governor"
-	help
-	  Panic watchdog pretimeout governor, on watchdog pretimeout
-	  event put the kernel into panic.
-
 endif # WATCHDOG_PRETIMEOUT_GOV
 
 endif # WATCHDOG
-- 
2.20.1

