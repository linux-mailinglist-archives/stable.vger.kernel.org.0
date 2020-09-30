Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3533727E052
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 07:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbgI3F2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 01:28:01 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53792 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgI3F1y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 01:27:54 -0400
Date:   Wed, 30 Sep 2020 05:27:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601443671;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=dojNA2QK2p60590n3wTPwR4Rinnm1FmDqQd1jhNmpVg=;
        b=lFA+kHY2lcZmldSuowA7s/c9mrB4Y6SOcy8P+s4LAzNS2g00yBYxquK+zjhP6uSwJ/4ESA
        H38RXjU7GidaINDKYxCN/o0gd0dqS0veHCfBrjLTzNzdAwBr4YFfkCh6VSzHv1FDRh/7my
        TD/a+fJq/NotCrUd3PdVRveTR9CzjzVJgGyLi9eYo9OrtxPmYLmEFaWukbIDFfCeIrwX4e
        TEhPx0kV2kgYzaXJrGrkrPlHQOJS/h7kA+ZEemoiDwdYhE7Ou24AMl3s4xPT52Biz4e02R
        NJb+jZE59MoyEkmWjucjzh96uLNRlZ2M9hxhrenukMhm3tQfCT9PaLuE7h0Btg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601443671;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=dojNA2QK2p60590n3wTPwR4Rinnm1FmDqQd1jhNmpVg=;
        b=VdfyQ/gevnMg3p2RQeS1DP+oTMrHMbGo7sguxiezktlBO2Bt7eu67NnupC4skjOoz895xm
        pLW/3kSdzPBAGUCA==
From:   "tip-bot2 for Ard Biesheuvel" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: efi/urgent] efi/arm64: libstub: Deal gracefully with
 EFI_RNG_PROTOCOL failure
Cc:     <stable@vger.kernel.org>, Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Ard Biesheuvel <ardb@kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <160144367102.7002.15954644693943604406.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the efi/urgent branch of tip:

Commit-ID:     d32de9130f6c79533508e2c7879f18997bfbe2a0
Gitweb:        https://git.kernel.org/tip/d32de9130f6c79533508e2c7879f18997bfbe2a0
Author:        Ard Biesheuvel <ardb@kernel.org>
AuthorDate:    Sat, 26 Sep 2020 10:52:42 +02:00
Committer:     Ard Biesheuvel <ardb@kernel.org>
CommitterDate: Tue, 29 Sep 2020 15:41:52 +02:00

efi/arm64: libstub: Deal gracefully with EFI_RNG_PROTOCOL failure

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
---
 drivers/firmware/efi/libstub/arm64-stub.c | 8 +++++---
 drivers/firmware/efi/libstub/fdt.c        | 4 +---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index e5bfac7..04f5d79 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -62,10 +62,12 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
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
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index 11ecf3c..368cd60 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -136,7 +136,7 @@ static efi_status_t update_fdt(void *orig_fdt, unsigned long orig_fdt_size,
 	if (status)
 		goto fdt_set_fail;
 
-	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
+	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && !efi_nokaslr) {
 		efi_status_t efi_status;
 
 		efi_status = efi_get_random_bytes(sizeof(fdt_val64),
@@ -145,8 +145,6 @@ static efi_status_t update_fdt(void *orig_fdt, unsigned long orig_fdt_size,
 			status = fdt_setprop_var(fdt, node, "kaslr-seed", fdt_val64);
 			if (status)
 				goto fdt_set_fail;
-		} else if (efi_status != EFI_NOT_FOUND) {
-			return efi_status;
 		}
 	}
 
