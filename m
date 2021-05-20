Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2383E38A581
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235810AbhETKRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:17:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236463AbhETKPQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:15:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7FC961990;
        Thu, 20 May 2021 09:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503930;
        bh=jXe+eICHR2kqfTF2x8QphGEPcMJeJCsAvRutRnGo/y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fMe5TllR2JsfaIo0KSWBRVGspX3L+i+aAgcDfGCDfetbK/l7JWhUMY+2ZtkaA/Fz0
         zCdfEjTgJj7pj7aDHjQMMJEia7l8W58prpu1w4H4kCZhgOHvNmdlYK0dmS1RQIff9F
         hmXKmqQJYiRd4Qb0hUiChwspB4hrtIEykrNPNBDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        George Kennedy <george.kennedy@oracle.com>
Subject: [PATCH 4.14 003/323] ACPI: x86: Call acpi_boot_table_init() after acpi_table_upgrade()
Date:   Thu, 20 May 2021 11:18:15 +0200
Message-Id: <20210520092120.243381122@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 6998a8800d73116187aad542391ce3b2dd0f9e30 upstream.

Commit 1a1c130ab757 ("ACPI: tables: x86: Reserve memory occupied by
ACPI tables") attempted to address an issue with reserving the memory
occupied by ACPI tables, but it broke the initrd-based table override
mechanism relied on by multiple users.

To restore the initrd-based ACPI table override functionality, move
the acpi_boot_table_init() invocation in setup_arch() on x86 after
the acpi_table_upgrade() one.

Fixes: 1a1c130ab757 ("ACPI: tables: x86: Reserve memory occupied by ACPI tables")
Reported-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: George Kennedy <george.kennedy@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/setup.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1129,9 +1129,6 @@ void __init setup_arch(char **cmdline_p)
 
 	cleanup_highmap();
 
-	/* Look for ACPI tables and reserve memory occupied by them. */
-	acpi_boot_table_init();
-
 	memblock_set_current_limit(ISA_END_ADDRESS);
 	e820__memblock_setup();
 
@@ -1214,6 +1211,8 @@ void __init setup_arch(char **cmdline_p)
 	reserve_initrd();
 
 	acpi_table_upgrade();
+	/* Look for ACPI tables and reserve memory occupied by them. */
+	acpi_boot_table_init();
 
 	vsmp_init();
 


