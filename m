Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2460E17810E
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733231AbgCCSAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:00:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:43992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733268AbgCCSAS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:00:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23E4020870;
        Tue,  3 Mar 2020 18:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258417;
        bh=FENz68I0RaPEhZkP8bdUxUd0mUyE1lN/0TK31Bdtg44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gcwBFXee+JqX+LZSJMZUIyNPoKIipifLEbpR9ToJrWGqhmcM/0NQ/Q9nQ37LBL880
         ctDVq7oAThbw2LGS+WVpbm037hxlxFVj5OKiQPuFTIxs5eGZKLjuk4wsXbfZEnkSgC
         0vFNVLB1GFUzcFUE5ZP6clD99pYkht7P6EIA5IK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jean Delvare <jdelvare@suse.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.19 42/87] ACPI: watchdog: Fix gas->access_width usage
Date:   Tue,  3 Mar 2020 18:43:33 +0100
Message-Id: <20200303174354.147945098@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 2ba33a4e9e22ac4dda928d3e9b5978a3a2ded4e0 upstream.

ACPI Generic Address Structure (GAS) access_width field is not in bytes
as the driver seems to expect in few places so fix this by using the
newly introduced macro ACPI_ACCESS_BYTE_WIDTH().

Fixes: b1abf6fc4982 ("ACPI / watchdog: Fix off-by-one error at resource assignment")
Fixes: 058dfc767008 ("ACPI / watchdog: Add support for WDAT hardware watchdog")
Reported-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Cc: 4.16+ <stable@vger.kernel.org> # 4.16+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpi_watchdog.c |    3 +--
 drivers/watchdog/wdat_wdt.c  |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/acpi/acpi_watchdog.c
+++ b/drivers/acpi/acpi_watchdog.c
@@ -129,12 +129,11 @@ void __init acpi_watchdog_init(void)
 		gas = &entries[i].register_region;
 
 		res.start = gas->address;
+		res.end = res.start + ACPI_ACCESS_BYTE_WIDTH(gas->access_width) - 1;
 		if (gas->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY) {
 			res.flags = IORESOURCE_MEM;
-			res.end = res.start + ALIGN(gas->access_width, 4) - 1;
 		} else if (gas->space_id == ACPI_ADR_SPACE_SYSTEM_IO) {
 			res.flags = IORESOURCE_IO;
-			res.end = res.start + gas->access_width - 1;
 		} else {
 			pr_warn("Unsupported address space: %u\n",
 				gas->space_id);
--- a/drivers/watchdog/wdat_wdt.c
+++ b/drivers/watchdog/wdat_wdt.c
@@ -392,7 +392,7 @@ static int wdat_wdt_probe(struct platfor
 
 		memset(&r, 0, sizeof(r));
 		r.start = gas->address;
-		r.end = r.start + gas->access_width - 1;
+		r.end = r.start + ACPI_ACCESS_BYTE_WIDTH(gas->access_width) - 1;
 		if (gas->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY) {
 			r.flags = IORESOURCE_MEM;
 		} else if (gas->space_id == ACPI_ADR_SPACE_SYSTEM_IO) {


