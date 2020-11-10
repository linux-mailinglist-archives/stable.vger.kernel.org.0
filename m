Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999442AD18F
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 09:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgKJIpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 03:45:03 -0500
Received: from proxy25214.mail.163.com ([103.129.252.14]:41729 "EHLO
        proxy25214.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgKJIpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 03:45:03 -0500
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Nov 2020 03:45:03 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=rvhFDVIg8u7520uvWc
        E2LdvNVsYPbYyQ0e9xp3KriaA=; b=b/MGbcjKYXk6Y9YOtCLTEVVX96TkT2Ygrb
        JlAAYoosxhLJAQ5lnoKDgCud2SSagkBlyZJ0B74AAKHvHEmGmUM6tkNKndbn82ZV
        Y0hcMv8VxqLssieVbM7l2C1HHUn7V/TuqQ6Wb6HtvF3VWkZP5K6wPa5xzbUW3Hqr
        biA1KHSF4=
Received: from smtp.163.com (unknown [36.112.24.10])
        by smtp13 (Coremail) with SMTP id EcCowABnQWl4T6pf07m0Sw--.43662S2;
        Tue, 10 Nov 2020 16:29:45 +0800 (CST)
From:   yaoaili126@163.com
To:     yaoaili@kingsoft.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] ACPI, APEI, Fix error return value in apei_map_generic_address()
Date:   Tue, 10 Nov 2020 00:29:42 -0800
Message-Id: <20201110082942.456745-1-yaoaili126@163.com>
X-Mailer: git-send-email 2.9.5
X-CM-TRANSID: EcCowABnQWl4T6pf07m0Sw--.43662S2
X-Coremail-Antispam: 1Uf129KBjvJXoWrZr45Zr4UJw45Kr48ArW7XFb_yoW8JF4rpF
        W29ayjkr48tw48Kw4UAw1YvFy5u3Z3AFy7tr40ywnY9F15CF47Cryqvrs093W5XF48K3yS
        qFsrtFWY9ayDAFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jYHqcUUUUU=
X-Originating-IP: [36.112.24.10]
X-CM-SenderInfo: 51drtxdolrjli6rwjhhfrp/1tbiUBnYG1WBpNiEaQAAsP
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aili Yao <yaoaili@kingsoft.com>

From commit 6915564dc5a8 ("ACPI: OSL: Change the type of
acpi_os_map_generic_address() return value"),
acpi_os_map_generic_address() will return logical address or NULL for
error, but for ACPI_ADR_SPACE_SYSTEM_IO case, it should be also return 0,
as it's a normal case, but now it will return -ENXIO. so check it out for
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


