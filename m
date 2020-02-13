Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0C315C375
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbgBMPl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:41:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:56152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387725AbgBMP2e (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:28:34 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE4D42168B;
        Thu, 13 Feb 2020 15:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607713;
        bh=qNVJvkLk5QY4zMFf9zWqo7r205XJykyNObIRHrwIBPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eSdhd21AsrVeBhBUaZ+REaI2tMFdnzhL7z43zMczyMMYYTx+/7hnyC7F2aH9Bx77R
         w9nYGJ9S1BQbeVWQOlbBNxOZAQrIvcEALG6e2LvVrRSRhmfAWfWXz8s1v9HLdUtk0o
         pqENeUCrUB1DNqxacNHEf8LLz1STEZ0xxhILv6FY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Clarkson <sc@lambdal.com>,
        Borislav Petkov <bp@suse.de>, linux-acpi@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 035/120] x86/boot: Handle malformed SRAT tables during early ACPI parsing
Date:   Thu, 13 Feb 2020 07:20:31 -0800
Message-Id: <20200213151913.733845018@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Clarkson <sc@lambdal.com>

[ Upstream commit 2b73ea3796242608b4ccf019ff217156c92e92fe ]

Break an infinite loop when early parsing of the SRAT table is caused
by a subtable with zero length. Known to affect the ASUS WS X299 SAGE
motherboard with firmware version 1201 which has a large block of
zeros in its SRAT table. The kernel could boot successfully on this
board/firmware prior to the introduction of early parsing this table or
after a BIOS update.

 [ bp: Fixup whitespace damage and commit message. Make it return 0 to
   denote that there are no immovable regions because who knows what
   else is broken in this BIOS. ]

Fixes: 02a3e3cdb7f1 ("x86/boot: Parse SRAT table and count immovable memory regions")
Signed-off-by: Steven Clarkson <sc@lambdal.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: linux-acpi@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206343
Link: https://lkml.kernel.org/r/CAHKq8taGzj0u1E_i=poHUam60Bko5BpiJ9jn0fAupFUYexvdUQ@mail.gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/compressed/acpi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/boot/compressed/acpi.c b/arch/x86/boot/compressed/acpi.c
index 25019d42ae937..ef2ad7253cd5e 100644
--- a/arch/x86/boot/compressed/acpi.c
+++ b/arch/x86/boot/compressed/acpi.c
@@ -393,7 +393,13 @@ int count_immovable_mem_regions(void)
 	table = table_addr + sizeof(struct acpi_table_srat);
 
 	while (table + sizeof(struct acpi_subtable_header) < table_end) {
+
 		sub_table = (struct acpi_subtable_header *)table;
+		if (!sub_table->length) {
+			debug_putstr("Invalid zero length SRAT subtable.\n");
+			return 0;
+		}
+
 		if (sub_table->type == ACPI_SRAT_TYPE_MEMORY_AFFINITY) {
 			struct acpi_srat_mem_affinity *ma;
 
-- 
2.20.1



