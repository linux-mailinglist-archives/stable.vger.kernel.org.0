Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1714B3A63B4
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbhFNLQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235467AbhFNLOO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:14:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BB7661242;
        Mon, 14 Jun 2021 10:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667749;
        bh=SFAV6JONZscqsQay6VWZtgYL8AY1KB8MG4hRcvLumLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RWUw9riKXzBkZDbeHM9v7aCr/1/KXsb9g/EfQFJSKitRo0vGAnb3CURJyC7Kccbix
         lcCy2EM00TK5cQHn5wA6RwI59hLR5KYZWIFKlrxWVgR7/5cyl6oYTHcuPcmPnCSIrm
         NojABw5++ux1cYCX6v4bccgChPtlCk6qsFcuCgxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.12 058/173] ACPI: Pass the same capabilities to the _OSC regardless of the query flag
Date:   Mon, 14 Jun 2021 12:26:30 +0200
Message-Id: <20210614102700.095347454@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 159d8c274fd92438ca6d7068d7a5eeda157227f4 upstream.

Commit 719e1f561afb ("ACPI: Execute platform _OSC also with query bit
clear") makes acpi_bus_osc_negotiate_platform_control() not only query
the platforms capabilities but it also commits the result back to the
firmware to report which capabilities are supported by the OS back to
the firmware

On certain systems the BIOS loads SSDT tables dynamically based on the
capabilities the OS claims to support. However, on these systems the
_OSC actually clears some of the bits (under certain conditions) so what
happens is that now when we call the _OSC twice the second time we pass
the cleared values and that results errors like below to appear on the
system log:

  ACPI BIOS Error (bug): Could not resolve symbol [\_PR.PR00._CPC], AE_NOT_FOUND (20210105/psargs-330)
  ACPI Error: Aborting method \_PR.PR01._CPC due to previous error (AE_NOT_FOUND) (20210105/psparse-529)

In addition the ACPI 6.4 spec says following [1]:

  If the OS declares support of a feature in the Support Field in one
  call to _OSC, then it must preserve the set state of that bit
  (declaring support for that feature) in all subsequent calls.

Based on the above we can fix the issue by passing the same set of
capabilities to the platform wide _OSC in both calls regardless of the
query flag.

While there drop the context.ret.length checks which were wrong to begin
with (as the length is number of bytes not elements). This is already
checked in acpi_run_osc() that also returns an error in that case.

Includes fixes by Hans de Goede.

[1] https://uefi.org/specs/ACPI/6.4/06_Device_Configuration/Device_Configuration.html#sequence-of-osc-calls

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=213023
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1963717
Fixes: 719e1f561afb ("ACPI: Execute platform _OSC also with query bit clear")
Cc: 5.12+ <stable@vger.kernel.org> # 5.12+
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/bus.c |   27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -330,32 +330,21 @@ static void acpi_bus_osc_negotiate_platf
 	if (ACPI_FAILURE(acpi_run_osc(handle, &context)))
 		return;
 
-	capbuf_ret = context.ret.pointer;
-	if (context.ret.length <= OSC_SUPPORT_DWORD) {
-		kfree(context.ret.pointer);
-		return;
-	}
+	kfree(context.ret.pointer);
 
-	/*
-	 * Now run _OSC again with query flag clear and with the caps
-	 * supported by both the OS and the platform.
-	 */
+	/* Now run _OSC again with query flag clear */
 	capbuf[OSC_QUERY_DWORD] = 0;
-	capbuf[OSC_SUPPORT_DWORD] = capbuf_ret[OSC_SUPPORT_DWORD];
-	kfree(context.ret.pointer);
 
 	if (ACPI_FAILURE(acpi_run_osc(handle, &context)))
 		return;
 
 	capbuf_ret = context.ret.pointer;
-	if (context.ret.length > OSC_SUPPORT_DWORD) {
-		osc_sb_apei_support_acked =
-			capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_APEI_SUPPORT;
-		osc_pc_lpi_support_confirmed =
-			capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_PCLPI_SUPPORT;
-		osc_sb_native_usb4_support_confirmed =
-			capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_NATIVE_USB4_SUPPORT;
-	}
+	osc_sb_apei_support_acked =
+		capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_APEI_SUPPORT;
+	osc_pc_lpi_support_confirmed =
+		capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_PCLPI_SUPPORT;
+	osc_sb_native_usb4_support_confirmed =
+		capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_NATIVE_USB4_SUPPORT;
 
 	kfree(context.ret.pointer);
 }


