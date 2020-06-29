Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE9420DADA
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388525AbgF2UBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387546AbgF2TkP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91A2D2490E;
        Mon, 29 Jun 2020 15:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444463;
        bh=jqIGikHXbjh0fGXK+ZUVg3Q2MlISrW97Srq0yttB7jM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ADT3u4+7TWhUsLyrWQzun1/FK1aWPi8+q0l5zXDcl8Td2QieQb9tn8F7FEUsTpZCZ
         KiECeU/1Ju4mfNTOl8AguROhoO36zRIC6admjEPO8HQ/G19qIUdCj/lVeiEprSjcdj
         6W1ZFtvpbQ/2VAj/eEjjhdD0lTP4SOQz2cQWjv3U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 143/178] ACPI: configfs: Disallow loading ACPI tables when locked down
Date:   Mon, 29 Jun 2020 11:24:48 -0400
Message-Id: <20200629152523.2494198-144-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 75b0cea7bf307f362057cc778efe89af4c615354 upstream.

Like other vectors already patched, this one here allows the root
user to load ACPI tables, which enables arbitrary physical address
writes, which in turn makes it possible to disable lockdown.

Prevents this by checking the lockdown status before allowing a new
ACPI table to be installed. The link in the trailer shows a PoC of
how this might be used.

Link: https://git.zx2c4.com/american-unsigned-language/tree/american-unsigned-language-2.sh
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_configfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_configfs.c b/drivers/acpi/acpi_configfs.c
index 57d9d574d4dde..01738d8e888e3 100644
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
2.25.1

