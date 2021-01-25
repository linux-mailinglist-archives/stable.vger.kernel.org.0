Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F5C30332E
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbhAZEri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:47:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:58902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729059AbhAYSn6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:43:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79B0820E65;
        Mon, 25 Jan 2021 18:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600209;
        bh=piuu7ybTe8fIn9o/bDN8sMGlo1L4Bapy4rOIgbqgoQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eoo0+4ky8c8OjXVIKh/mnZWC6PJbNU29REHxnV7hm9KAiP6Te5gYLU2E++HyGDjKM
         sdxLBvN69uU96nl87O7MFEdvyFzZhYXtKCMc2uABBcexidxyCQg0TsqJJdBTI2OHI3
         w5FYsWjPVKXbC0Q2bwGEy0pe7L6mcE0pOB0rrHTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>
Subject: [PATCH 5.4 06/86] ACPI: scan: Make acpi_bus_get_device() clear return pointer on error
Date:   Mon, 25 Jan 2021 19:38:48 +0100
Message-Id: <20210125183201.310908759@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 78a18fec5258c8df9435399a1ea022d73d3eceb9 upstream.

Set the acpi_device pointer which acpi_bus_get_device() returns-by-
reference to NULL on errors.

We've recently had 2 cases where callers of acpi_bus_get_device()
did not properly error check the return value, so set the returned-
by-reference acpi_device pointer to NULL, because at least some
callers of acpi_bus_get_device() expect that to be done on errors.

[ rjw: This issue was exposed by commit 71da201f38df ("ACPI: scan:
  Defer enumeration of devices with _DEP lists") which caused it to
  be much more likely to occur on some systems, but the real defect
  had been introduced by an earlier commit. ]

Fixes: 40e7fcb19293 ("ACPI: Add _DEP support to fix battery issue on Asus T100TA")
Fixes: bcfcd409d4db ("usb: split code locating ACPI companion into port and device")
Reported-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Tested-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Diagnosed-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: All applicable <stable@vger.kernel.org>
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/scan.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -587,6 +587,8 @@ static int acpi_get_device_data(acpi_han
 	if (!device)
 		return -EINVAL;
 
+	*device = NULL;
+
 	status = acpi_get_data_full(handle, acpi_scan_drop_device,
 				    (void **)device, callback);
 	if (ACPI_FAILURE(status) || !*device) {


