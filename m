Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE03364365
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239903AbhDSNRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:17:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240385AbhDSNP5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:15:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44A7D613D9;
        Mon, 19 Apr 2021 13:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838014;
        bh=ARfhDnRHmo4R28NHBw3BaJQTkw/Hgf6QnKt5YkXkJ/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oWvIj5Mc4y+OVy+eYq6x59J5Uj+dDdzH3BM2L/sv2xNNQwvVfub4Az1vb8O3PAVzz
         cP8LY0eUDTAjh7F4FQ0cq2mvpX8pVkoDq77k4Riyvy2Pqmpvx1zh5xkT7S3lPs9YCU
         SyF6qELjJiKSUJLprTEV+K6ND4RunM0E42w26rvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/103] ACPI: x86: Call acpi_boot_table_init() after acpi_table_upgrade()
Date:   Mon, 19 Apr 2021 15:05:24 +0200
Message-Id: <20210419130528.249666633@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 6998a8800d73116187aad542391ce3b2dd0f9e30 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/setup.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d23795057c4f..28c89fce0dab 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1051,9 +1051,6 @@ void __init setup_arch(char **cmdline_p)
 
 	cleanup_highmap();
 
-	/* Look for ACPI tables and reserve memory occupied by them. */
-	acpi_boot_table_init();
-
 	memblock_set_current_limit(ISA_END_ADDRESS);
 	e820__memblock_setup();
 
@@ -1132,6 +1129,8 @@ void __init setup_arch(char **cmdline_p)
 	reserve_initrd();
 
 	acpi_table_upgrade();
+	/* Look for ACPI tables and reserve memory occupied by them. */
+	acpi_boot_table_init();
 
 	vsmp_init();
 
-- 
2.30.2



