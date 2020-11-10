Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE2FD2AD1C0
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 09:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbgKJIuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 03:50:13 -0500
Received: from m12-13.163.com ([220.181.12.13]:45301 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726827AbgKJIuN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 03:50:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=RlJkEVh6ttoD9PLkdU
        x/BFTSSqOzHRhkDw0D+7d2ZHM=; b=Ysuz4Kx57/RpOr0szKluDKC62bIJym/Z52
        UsH7LwHqim01saJ/Vp3ucP15FE0fF82llSU+tb4UCr4WAQOvTm3gWVTVuxOKlZ35
        bPH4gvi44LWDm5YbT6VQGXEQkJUz1KDFrplxaTsw+7qpbBH8OVcw5vklkxcJ9LYO
        gxasKILJQ=
Received: from smtp.163.com (unknown [36.112.24.10])
        by smtp9 (Coremail) with SMTP id DcCowADn5YFgUKpfa7B2Pw--.531S2;
        Tue, 10 Nov 2020 16:33:38 +0800 (CST)
From:   yaoaili126@163.com
To:     rjw@rjwysocki.net, lenb@kernel.org
Cc:     james.morse@arm.com, tony.luck@intel.com, bp@alien8.de,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org,
        yangfeng1@kingsoft.com, yaoaili@kingsoft.com
Subject: [PATCH] ACPI, APEI, Fix error return value in apei_map_generic_address()
Date:   Tue, 10 Nov 2020 00:33:34 -0800
Message-Id: <20201110083334.456893-1-yaoaili126@163.com>
X-Mailer: git-send-email 2.9.5
X-CM-TRANSID: DcCowADn5YFgUKpfa7B2Pw--.531S2
X-Coremail-Antispam: 1Uf129KBjvJXoWrZr45Zr4UJw45Kr48ArW7XFb_yoW8JF45pF
        W29ayYkr40kw48Kw4UAw1YvFy5uas3AFy2yr40kwnY9F15CF47Cryqvws093W5XF48K3yS
        qFnrtFWYyayDAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jaNtsUUUUU=
X-Originating-IP: [36.112.24.10]
X-CM-SenderInfo: 51drtxdolrjli6rwjhhfrp/1tbiKwHYG1QHWcsR6wAAsS
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aili Yao <yaoaili@kingsoft.com>

From commit 6915564dc5a8 ("ACPI: OSL: Change the type of
acpi_os_map_generic_address() return value"),
acpi_os_map_generic_address() will return logical address or NULL for
error, but for ACPI_ADR_SPACE_SYSTEM_IO case, it should be also return 0
as it's a normal case, but now it will return -ENXIO. So check it out for
such case to avoid einj module initialization fail.

Fixes: 6915564dc5a8 ("ACPI: OSL: Change the type of
acpi_os_map_generic_address() return value")
Cc: <stable@vger.kernel.org>
Reviewed-by: James Morse <james.morse@arm.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Aili Yao <yaoaili@kingsoft.com>
---
 drivers/acpi/apei/apei-base.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
index 552fd9f..3294cc8 100644
--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -633,6 +633,10 @@ int apei_map_generic_address(struct acpi_generic_address *reg)
 	if (rc)
 		return rc;
 
+	/* IO space doesn't need mapping */
+	if (reg->space_id == ACPI_ADR_SPACE_SYSTEM_IO)
+		return 0;
+
 	if (!acpi_os_map_generic_address(reg))
 		return -ENXIO;
 
-- 
2.9.5


