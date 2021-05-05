Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA483739D4
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbhEEMFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:05:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232999AbhEEMFo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:05:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8D9761166;
        Wed,  5 May 2021 12:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216288;
        bh=+AcHoBXEOmD7wYxgedw24K2ZGTpwkBToxsSQVXgT28o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DcjuerVLh+TCp+1a9KkVnDRek6IVzcXH1e1BdZbrqMPbYYN9kphNDqkoWGe/p+Kj2
         J6oGjHO231/euRmlDxPTk9TPSS1a3a6gMQ/DTKz/0MN5FajhU7Ou/0sTr0ZS0eGvgp
         Z2ji2uamsDVISLlDIjFRVxThR+W8jR6sXT9RIrGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        George Kennedy <george.kennedy@oracle.com>
Subject: [PATCH 5.4 03/21] ACPI: x86: Call acpi_boot_table_init() after acpi_table_upgrade()
Date:   Wed,  5 May 2021 14:04:17 +0200
Message-Id: <20210505112324.841518920@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112324.729798712@linuxfoundation.org>
References: <20210505112324.729798712@linuxfoundation.org>
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
@@ -1117,9 +1117,6 @@ void __init setup_arch(char **cmdline_p)
 
 	cleanup_highmap();
 
-	/* Look for ACPI tables and reserve memory occupied by them. */
-	acpi_boot_table_init();
-
 	memblock_set_current_limit(ISA_END_ADDRESS);
 	e820__memblock_setup();
 
@@ -1199,6 +1196,8 @@ void __init setup_arch(char **cmdline_p)
 	reserve_initrd();
 
 	acpi_table_upgrade();
+	/* Look for ACPI tables and reserve memory occupied by them. */
+	acpi_boot_table_init();
 
 	vsmp_init();
 


