Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 760C91A40AD
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 05:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgDJD5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:57:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728528AbgDJDtY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:49:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78299212CC;
        Fri, 10 Apr 2020 03:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490564;
        bh=4Z31UL/A8ueeNZlm3bpzNtRxUv08MKmOUDs5UrehlB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iIRGc1wgNjnNt9AxmeE3MCBjUvbItB3QXzpKFhexsV7QjDZ4Rr3FSnkOwAognCu9m
         h1kVr52AJo1TsZuzzcLJwxnk9dZTG7cUrIbsec/zfUQXW6SvfWWJ4fNGlqPiknjIIQ
         a2mb8sDpQoptsTMWnL/L7hOKAkJD2xThioO1ym0o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/46] ACPI: EC: Do not clear boot_ec_is_ecdt in acpi_ec_add()
Date:   Thu,  9 Apr 2020 23:48:34 -0400
Message-Id: <20200410034909.8922-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034909.8922-1-sashal@kernel.org>
References: <20200410034909.8922-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 65a691f5f8f0bb63d6a82eec7b0ffd193d8d8a5f ]

The reason for clearing boot_ec_is_ecdt in acpi_ec_add() (if a
PNP0C09 device object matching the ECDT boot EC had been found in
the namespace) was to cause acpi_ec_ecdt_start() to return early,
but since the latter does not look at boot_ec_is_ecdt any more,
acpi_ec_add() need not clear it.

Moreover, doing that may be confusing as it may cause "DSDT" to be
printed instead of "ECDT" in the EC initialization completion
message, so stop doing it.

While at it, split the EC initialization completion message into
two messages, one regarding the boot EC and another one printed
regardless of whether or not the EC at hand is the boot one.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index ca5cdb621c2a7..2dba4e7a83b76 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1573,7 +1573,6 @@ static int acpi_ec_add(struct acpi_device *device)
 
 		if (boot_ec && ec->command_addr == boot_ec->command_addr &&
 		    ec->data_addr == boot_ec->data_addr) {
-			boot_ec_is_ecdt = false;
 			/*
 			 * Trust PNP0C09 namespace location rather than
 			 * ECDT ID. But trust ECDT GPE rather than _GPE
@@ -1593,9 +1592,12 @@ static int acpi_ec_add(struct acpi_device *device)
 
 	if (ec == boot_ec)
 		acpi_handle_info(boot_ec->handle,
-				 "Boot %s EC used to handle transactions and events\n",
+				 "Boot %s EC initialization complete\n",
 				 boot_ec_is_ecdt ? "ECDT" : "DSDT");
 
+	acpi_handle_info(ec->handle,
+			 "EC: Used to handle transactions and events\n");
+
 	device->driver_data = ec;
 
 	ret = !!request_region(ec->data_addr, 1, "EC data");
-- 
2.20.1

