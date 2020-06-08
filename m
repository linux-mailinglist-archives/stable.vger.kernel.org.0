Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2F91F20C2
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 22:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgFHUia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 16:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbgFHUi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 16:38:29 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4350C08C5C2
        for <stable@vger.kernel.org>; Mon,  8 Jun 2020 13:38:28 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e192so22553473ybf.17
        for <stable@vger.kernel.org>; Mon, 08 Jun 2020 13:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5otuoY2gGErOy9A+cbCl1OR8KmTp9iNB+S30IArJGxY=;
        b=KYzOYiQt3FGzO24Ji/cgJDS2qf8jKUBMSw0hou1XPe1iZ0NlVNuyLLK6BVkY7wpIEr
         4nju/eU6yQqj6iQg3Pj88h6aC9XpeUhO6aRvg/Z3EHx1d3uJqRlPI36O1665sP+Riv3V
         ORNQ/AVH79J0kEBSAxKrGpHIofF7rH4KVneMUC+7Lz8w5qRoCdxfnJ7Bs5IV5yMtTbtq
         +z/X8TVEvqXJL+EzAMEnLS03+TpJtP2O5tmH70OLnKM6p5Fv0DS2LhNfQRWuO3vIAsHd
         VrTGN6E7yLxjULQgMxXdaUowGrlPR4ev7g6d3XZ4mLcwIUCfXE4ic5pRxQymDSQFJ4Ja
         MnZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5otuoY2gGErOy9A+cbCl1OR8KmTp9iNB+S30IArJGxY=;
        b=HS40In4Los8bq2yKUum55HVxT1EIudLq0OU5kQBTrAvYspQqpQZAjs4GCOsR5kNJVq
         0Qp2dFxIITM/XJIzShpJz3C3DFdtg33uYXShHr8/vhLmUVTrr1NyovMsCYnSBrXoIP93
         +HsI6FeVnnuzXG0zP00Ju89XPOgEnbZe40PcSrqeHjrImX14EeQn3kQZPiNKqpemj/dI
         OQz0PTS6jJa4pqZlLGUHm+KTdCp88xubtlP2Tmk6mTZ/P+pCbNi8rog8cX0UU1GexyIr
         PkT17NTZOT5tMzDXzg+EFw29JHTnHAXkY7wACOQweuynOiA8zIYBolGh69akViECa4R4
         QAgQ==
X-Gm-Message-State: AOAM533jynkhlVkR2VHxj42L1d+fVM/e9eBXVudn+fMCWYjUV3JEjBnI
        Gx7lciqlRczMx2bp0zq5qw78S7Xk3lhUC2EiMtk=
X-Google-Smtp-Source: ABdhPJwMCfh6+j1JcOF7Ui/FzLouS0/CmQh3VYSy0Ww5vOQqYGp9/ZKrVXazWyjuLYCs7jqttRbM/Z4w4upIk0lRVbk=
X-Received: by 2002:a5b:54e:: with SMTP id r14mr956210ybp.93.1591648707480;
 Mon, 08 Jun 2020 13:38:27 -0700 (PDT)
Date:   Mon,  8 Jun 2020 13:38:17 -0700
In-Reply-To: <CAKwvOdnBhHnhUZ9MHgqEQ4nEyzHWUH+DPV-J0KoYyWNEnsDHbg@mail.gmail.com>
Message-Id: <20200608203818.189423-1-ndesaulniers@google.com>
Mime-Version: 1.0
References: <CAKwvOdnBhHnhUZ9MHgqEQ4nEyzHWUH+DPV-J0KoYyWNEnsDHbg@mail.gmail.com>
X-Mailer: git-send-email 2.27.0.278.ge193c7cf3a9-goog
Subject: [PATCH v2] arm64: acpi: fix UBSAN warning
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>, stable@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Enrico Weigelt <info@metux.net>,
        Allison Randal <allison@lohutok.net>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Link: https://lore.kernel.org/lkml/20200521100952.GA5360@willie-the-truck/
Cc: stable@vger.kernel.org
Reported-by: Will Deacon <will@kernel.org>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
Changes V1 -> V2:
* Just fix one of the two warnings, specific to arm64.
* Put warning in commit message.

 arch/arm64/include/asm/acpi.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index b263e239cb59..a45366c3909b 100644
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
-- 
2.27.0.278.ge193c7cf3a9-goog

