Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148882A16CA
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgJaLsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:48:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728050AbgJaLnk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:43:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2042420731;
        Sat, 31 Oct 2020 11:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144620;
        bh=lyN8fzdZVm2iK4kV+7mrPWBQYhkvGH4kdoLeQtrO2uU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qf0XWdQC9FjF8TQ2VbkQVS/nEYGvD+uk1lSLIxDY9QOxfeD5VNwZD58ZMPAt/St0F
         ibpImJGYZm4s+A2xRrcn3Bqq1j1kkTN47Y/giUuidz3GovOUzAoSL0jjSbcjDTvihP
         bETj5EsgGcydN6ocN1JGxhA0NBmgSDNjqTwvsvek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.9 18/74] efi/arm64: libstub: Deal gracefully with EFI_RNG_PROTOCOL failure
Date:   Sat, 31 Oct 2020 12:36:00 +0100
Message-Id: <20201031113500.927808908@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit d32de9130f6c79533508e2c7879f18997bfbe2a0 upstream.

Currently, on arm64, we abort on any failure from efi_get_random_bytes()
other than EFI_NOT_FOUND when it comes to setting the physical seed for
KASLR, but ignore such failures when obtaining the seed for virtual
KASLR or for early seeding of the kernel's entropy pool via the config
table. This is inconsistent, and may lead to unexpected boot failures.

So let's permit any failure for the physical seed, and simply report
the error code if it does not equal EFI_NOT_FOUND.

Cc: <stable@vger.kernel.org> # v5.8+
Reported-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/libstub/arm64-stub.c |    8 +++++---
 drivers/firmware/efi/libstub/fdt.c        |    4 +---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -62,10 +62,12 @@ efi_status_t handle_kernel_image(unsigne
 			status = efi_get_random_bytes(sizeof(phys_seed),
 						      (u8 *)&phys_seed);
 			if (status == EFI_NOT_FOUND) {
-				efi_info("EFI_RNG_PROTOCOL unavailable, no randomness supplied\n");
+				efi_info("EFI_RNG_PROTOCOL unavailable, KASLR will be disabled\n");
+				efi_nokaslr = true;
 			} else if (status != EFI_SUCCESS) {
-				efi_err("efi_get_random_bytes() failed\n");
-				return status;
+				efi_err("efi_get_random_bytes() failed (0x%lx), KASLR will be disabled\n",
+					status);
+				efi_nokaslr = true;
 			}
 		} else {
 			efi_info("KASLR disabled on kernel command line\n");
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -136,7 +136,7 @@ static efi_status_t update_fdt(void *ori
 	if (status)
 		goto fdt_set_fail;
 
-	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
+	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && !efi_nokaslr) {
 		efi_status_t efi_status;
 
 		efi_status = efi_get_random_bytes(sizeof(fdt_val64),
@@ -145,8 +145,6 @@ static efi_status_t update_fdt(void *ori
 			status = fdt_setprop_var(fdt, node, "kaslr-seed", fdt_val64);
 			if (status)
 				goto fdt_set_fail;
-		} else if (efi_status != EFI_NOT_FOUND) {
-			return efi_status;
 		}
 	}
 


