Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72C3431D71
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbhJRNv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:51:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233356AbhJRNt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:49:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C3D4617E5;
        Mon, 18 Oct 2021 13:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564252;
        bh=hCcs/XLHiAkXJzy7hvDA0gYAuxzu2AQsf724r6E2lEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jLB7KP9RQ5F0BPtFTMuUB7r5zjblcViI+4VQe4xw9aQN7QgCVIM8UmDfNyW5rQTiK
         TXz1sijM4xoPDUBwUistMjujryqEkwBC5T8nUt2PY5LSBsvqZuZLwNQ6q0AtOevq5+
         Lch5IH7Yp7oyld8VFHTBiQZiR1IE1L/XwVQj+PBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sachi King <nakato@nakato.io>,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.14 019/151] ACPI: PM: Include alternate AMDI0005 id in special behaviour
Date:   Mon, 18 Oct 2021 15:23:18 +0200
Message-Id: <20211018132341.302779676@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sachi King <nakato@nakato.io>

commit 1ea1dbf1f54c3345072c963b3acf8830e2468c1b upstream.

The Surface Laptop 4 AMD has used the AMD0005 to identify this
controller instead of using the appropriate ACPI ID AMDI0005.  The
AMD0005 needs the same special casing as AMDI0005.

Link: https://github.com/linux-surface/acpidumps/tree/master/surface_laptop_4_amd
Link: https://gist.github.com/nakato/2a1a7df1a45fe680d7a08c583e1bf863
Signed-off-by: Sachi King <nakato@nakato.io>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Cc: 5.14+ <stable@vger.kernel.org> # 5.14+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/x86/s2idle.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/acpi/x86/s2idle.c
+++ b/drivers/acpi/x86/s2idle.c
@@ -371,7 +371,7 @@ static int lps0_device_attach(struct acp
 		return 0;
 
 	if (acpi_s2idle_vendor_amd()) {
-		/* AMD0004, AMDI0005:
+		/* AMD0004, AMD0005, AMDI0005:
 		 * - Should use rev_id 0x0
 		 * - function mask > 0x3: Should use AMD method, but has off by one bug
 		 * - function mask = 0x3: Should use Microsoft method
@@ -390,6 +390,7 @@ static int lps0_device_attach(struct acp
 					ACPI_LPS0_DSM_UUID_MICROSOFT, 0,
 					&lps0_dsm_guid_microsoft);
 		if (lps0_dsm_func_mask > 0x3 && (!strcmp(hid, "AMD0004") ||
+						 !strcmp(hid, "AMD0005") ||
 						 !strcmp(hid, "AMDI0005"))) {
 			lps0_dsm_func_mask = (lps0_dsm_func_mask << 1) | 0x1;
 			acpi_handle_debug(adev->handle, "_DSM UUID %s: Adjusted function mask: 0x%x\n",


