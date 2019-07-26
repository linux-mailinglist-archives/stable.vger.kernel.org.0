Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A88E76960
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbfGZNv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:51:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727686AbfGZNnx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:43:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB44F22BF5;
        Fri, 26 Jul 2019 13:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148632;
        bh=vzNNaYikDY21v23/2zO3IPUtpcgrGZDW0AIPcGzNqA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YOmDqrtj4oVBkidZnkzhNq+Y5NXnscfqIYPqN2zRixs/WcVWsqRs4Gwd8GUivU3dL
         TixBA+kcHCivm0ynX0RhNPCqVwyWNbzWbLWapHHOgYhWsXvcDYFUiEMR0pXo8ZeyIF
         GrlpdqFTWN+XJUIPdgNanC3iU5LsAqC6u7d+LsNM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.14 15/37] ACPI: blacklist: fix clang warning for unused DMI table
Date:   Fri, 26 Jul 2019 09:43:10 -0400
Message-Id: <20190726134332.12626-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726134332.12626-1-sashal@kernel.org>
References: <20190726134332.12626-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit b80d6a42bdc97bdb6139107d6034222e9843c6e2 ]

When CONFIG_DMI is disabled, we only have a tentative declaration,
which causes a warning from clang:

drivers/acpi/blacklist.c:20:35: error: tentative array definition assumed to have one element [-Werror]
static const struct dmi_system_id acpi_rev_dmi_table[] __initconst;

As the variable is not actually used here, hide it entirely
in an #ifdef to shut up the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/blacklist.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index 995c4d8922b1..761f0c19a451 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -30,7 +30,9 @@
 
 #include "internal.h"
 
+#ifdef CONFIG_DMI
 static const struct dmi_system_id acpi_rev_dmi_table[] __initconst;
+#endif
 
 /*
  * POLICY: If *anything* doesn't work, put it on the blacklist.
@@ -74,7 +76,9 @@ int __init acpi_blacklisted(void)
 	}
 
 	(void)early_acpi_osi_init();
+#ifdef CONFIG_DMI
 	dmi_check_system(acpi_rev_dmi_table);
+#endif
 
 	return blacklisted;
 }
-- 
2.20.1

