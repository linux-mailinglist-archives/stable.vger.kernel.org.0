Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD871FB807
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732755AbgFPPwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:52:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732754AbgFPPwI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:52:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5507321534;
        Tue, 16 Jun 2020 15:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322727;
        bh=qPXtMOTdflutZMIJ3Kxe+EfHyqUsxZqyhk7CaUbd0Do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XmKHDL6qNNsELrXIC1SUIYi639P6tcGLaWejb8f8J3NRwLwMdeLoWyOGnnZjtE74o
         J5JwYorXyGtmf1q2sxcnkPAOfmFTOScen9mEJ5MZ5mLWnJmjBy+s9yBk3KVxt5nQGf
         H7mLfha/n4s/VayBotdpWQElT3ytIInMlmXboo50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.6 081/161] arm64: acpi: fix UBSAN warning
Date:   Tue, 16 Jun 2020 17:34:31 +0200
Message-Id: <20200616153110.235892960@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit a194c33f45f83068ef13bf1d16e26d4ca3ecc098 upstream.

Will reported a UBSAN warning:

UBSAN: null-ptr-deref in arch/arm64/kernel/smp.c:596:6
member access within null pointer of type 'struct acpi_madt_generic_interrupt'
CPU: 0 PID: 0 Comm: swapper Not tainted 5.7.0-rc6-00124-g96bc42ff0a82 #1
Call trace:
 dump_backtrace+0x0/0x384
 show_stack+0x28/0x38
 dump_stack+0xec/0x174
 handle_null_ptr_deref+0x134/0x174
 __ubsan_handle_type_mismatch_v1+0x84/0xa4
 acpi_parse_gic_cpu_interface+0x60/0xe8
 acpi_parse_entries_array+0x288/0x498
 acpi_table_parse_entries_array+0x178/0x1b4
 acpi_table_parse_madt+0xa4/0x110
 acpi_parse_and_init_cpus+0x38/0x100
 smp_init_cpus+0x74/0x258
 setup_arch+0x350/0x3ec
 start_kernel+0x98/0x6f4

This is from the use of the ACPI_OFFSET in
arch/arm64/include/asm/acpi.h. Replace its use with offsetof from
include/linux/stddef.h which should implement the same logic using
__builtin_offsetof, so that UBSAN wont warn.

Reported-by: Will Deacon <will@kernel.org>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Jeremy Linton <jeremy.linton@arm.com>
Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/20200521100952.GA5360@willie-the-truck/
Link: https://lore.kernel.org/r/20200608203818.189423-1-ndesaulniers@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/acpi.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -12,6 +12,7 @@
 #include <linux/efi.h>
 #include <linux/memblock.h>
 #include <linux/psci.h>
+#include <linux/stddef.h>
 
 #include <asm/cputype.h>
 #include <asm/io.h>
@@ -31,14 +32,14 @@
  * is therefore used to delimit the MADT GICC structure minimum length
  * appropriately.
  */
-#define ACPI_MADT_GICC_MIN_LENGTH   ACPI_OFFSET(  \
+#define ACPI_MADT_GICC_MIN_LENGTH   offsetof(  \
 	struct acpi_madt_generic_interrupt, efficiency_class)
 
 #define BAD_MADT_GICC_ENTRY(entry, end)					\
 	(!(entry) || (entry)->header.length < ACPI_MADT_GICC_MIN_LENGTH || \
 	(unsigned long)(entry) + (entry)->header.length > (end))
 
-#define ACPI_MADT_GICC_SPE  (ACPI_OFFSET(struct acpi_madt_generic_interrupt, \
+#define ACPI_MADT_GICC_SPE  (offsetof(struct acpi_madt_generic_interrupt, \
 	spe_interrupt) + sizeof(u16))
 
 /* Basic configuration for ACPI */


