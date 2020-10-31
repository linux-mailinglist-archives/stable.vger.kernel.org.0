Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039152A16ED
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgJaLmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:42:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727332AbgJaLmY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:42:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38153205F4;
        Sat, 31 Oct 2020 11:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144543;
        bh=lyN8fzdZVm2iK4kV+7mrPWBQYhkvGH4kdoLeQtrO2uU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OoS1tClKWSB0hbhVO62QoubylVBgx7f7O4EY3mTP+59sIO9BIPjyx4NLzx2fbdjF1
         ZUkM03pJ2/elm89Uj0oKv3rvweUtLP5qt68K5qZtrQ+C/MxYeYtphQd7XydOWk2CSi
         xgP2co5LccEnXeECpSspf1UThLvfWxhfIJGD0FUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.8 18/70] efi/arm64: libstub: Deal gracefully with EFI_RNG_PROTOCOL failure
Date:   Sat, 31 Oct 2020 12:35:50 +0100
Message-Id: <20201031113500.381102391@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
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
 


