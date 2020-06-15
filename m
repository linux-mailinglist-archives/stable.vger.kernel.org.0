Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222F21F94CD
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 12:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgFOKoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 06:44:01 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:57179 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728815AbgFOKoB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 06:44:01 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 204a99b6;
        Mon, 15 Jun 2020 10:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=W+psDjWP34bkbGREKoNGTKiwX
        RY=; b=3jnAe/G5QpfRdhmbQNo/KC6yS+10Fj/j0sHOja4aJa6WQEKmPBksnzJPU
        4PjH2fbCASselEcm2VspxMQJsm7vJdmi5OpWBVSHAN4aOqvaHH/cuVNHi/MgvhUl
        cKoFNxP8rKxEg/tUSOW22eCKEj51G3kK1TrAJ37J1QI+Km++MIB+RTymZxgJzuJJ
        7rYJzWAjWAPz/vAWSYmgUeCIWy/m0+Kjz6KXLeNA3VZMMiOrB5ocUTK7AI3Zv8Im
        PwCQeORfydLLuqc+UA86L1DeLEkXqGS59WsJZdn6QY1mTTHbhdYzphppkbgrFHrm
        gGT5CJMUnpweZZGMpyUJPRipeZSew==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 22b6c329 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 15 Jun 2020 10:26:09 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        mjg59@srcf.ucam.org, kernel-hardening@lists.openwall.com
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH] acpi: disallow loading configfs acpi tables when locked down
Date:   Mon, 15 Jun 2020 04:43:32 -0600
Message-Id: <20200615104332.901519-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9rmAznrAmEQTOaLeMM82iMFTfCNfpxDGXw4CJjuVEF_gQ@mail.gmail.com>
References: <CAHmME9rmAznrAmEQTOaLeMM82iMFTfCNfpxDGXw4CJjuVEF_gQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Like other vectors already patched, this one here allows the root user
to load ACPI tables, which enables arbitrary physical address writes,
which in turn makes it possible to disable lockdown. This patch prevents
this by checking the lockdown status before allowing a new ACPI table to be
installed. The link in the trailer shows a PoC of how this might be
used.

Link: https://git.zx2c4.com/american-unsigned-language/tree/american-unsigned-language-2.sh
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/acpi/acpi_configfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_configfs.c b/drivers/acpi/acpi_configfs.c
index ece8c1a921cc..88c8af455ea3 100644
--- a/drivers/acpi/acpi_configfs.c
+++ b/drivers/acpi/acpi_configfs.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/configfs.h>
 #include <linux/acpi.h>
+#include <linux/security.h>
 
 #include "acpica/accommon.h"
 #include "acpica/actables.h"
@@ -28,7 +29,10 @@ static ssize_t acpi_table_aml_write(struct config_item *cfg,
 {
 	const struct acpi_table_header *header = data;
 	struct acpi_table *table;
-	int ret;
+	int ret = security_locked_down(LOCKDOWN_ACPI_TABLES);
+
+	if (ret)
+		return ret;
 
 	table = container_of(cfg, struct acpi_table, cfg);
 
-- 
2.27.0

