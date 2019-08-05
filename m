Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F27081C3D
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730521AbfHENVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:21:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730541AbfHENVd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:21:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B3C62075B;
        Mon,  5 Aug 2019 13:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011292;
        bh=ICOJDce8di+TqFqDFUsxRkdd3fauK9lm6SMItONodX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQILJmKIj+N1BZh2rqsQivPmQdc7BVYgyHBL5g/rEHZ2p8vSBptBDCkG1X29F3QBG
         2yxJ4flF2o/wozQZCDtMMmrpa6kGc0OUUycw1fCvbBFQHdUq2Ki6MCpYnpkQyv5CM8
         j1caQTDmVpyd8ys6M0/Z9yZEHoMVDOa430r8foVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 036/131] ACPI: blacklist: fix clang warning for unused DMI table
Date:   Mon,  5 Aug 2019 15:02:03 +0200
Message-Id: <20190805124953.854648328@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index ad2c565f5cbe0..a86a770c9b798 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -17,7 +17,9 @@
 
 #include "internal.h"
 
+#ifdef CONFIG_DMI
 static const struct dmi_system_id acpi_rev_dmi_table[] __initconst;
+#endif
 
 /*
  * POLICY: If *anything* doesn't work, put it on the blacklist.
@@ -61,7 +63,9 @@ int __init acpi_blacklisted(void)
 	}
 
 	(void)early_acpi_osi_init();
+#ifdef CONFIG_DMI
 	dmi_check_system(acpi_rev_dmi_table);
+#endif
 
 	return blacklisted;
 }
-- 
2.20.1



