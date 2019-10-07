Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BADD0CE600
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 16:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbfJGOvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 10:51:36 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44366 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728436AbfJGOtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 10:49:33 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iHUJy-0005pa-Iy; Mon, 07 Oct 2019 16:49:10 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 1E9F31C0DC9;
        Mon,  7 Oct 2019 16:49:10 +0200 (CEST)
Date:   Mon, 07 Oct 2019 14:49:10 -0000
From:   "tip-bot2 for Ard Biesheuvel" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: efi/urgent] efivar/ssdt: Don't iterate over EFI vars if no SSDT
 override was specified
Cc:     Scott Talbert <swt@techie.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        <stable@vger.kernel.org>, Ben Dooks <ben.dooks@codethink.co.uk>,
        Dave Young <dyoung@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lukas Wunner <lukas@wunner.de>, Lyude Paul <lyude@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Peter Jones <pjones@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20191002165904.8819-3-ard.biesheuvel@linaro.org>
References: <20191002165904.8819-3-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Message-ID: <157045975007.9978.12389827950739449033.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the efi/urgent branch of tip:

Commit-ID:     c05f8f92b701576b615f30aac31fabdc0648649b
Gitweb:        https://git.kernel.org/tip/c05f8f92b701576b615f30aac31fabdc0648649b
Author:        Ard Biesheuvel <ard.biesheuvel@linaro.org>
AuthorDate:    Wed, 02 Oct 2019 18:58:59 +02:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Mon, 07 Oct 2019 15:24:35 +02:00

efivar/ssdt: Don't iterate over EFI vars if no SSDT override was specified

The kernel command line option efivar_ssdt= allows the name to be
specified of an EFI variable containing an ACPI SSDT table that should
be loaded into memory by the OS, and treated as if it was provided by
the firmware.

Currently, that code will always iterate over the EFI variables and
compare each name with the provided name, even if the command line
option wasn't set to begin with.

So bail early when no variable name was provided. This works around a
boot regression on the 2012 Mac Pro, as reported by Scott.

Tested-by: Scott Talbert <swt@techie.net>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: <stable@vger.kernel.org> # v4.9+
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Dave Young <dyoung@redhat.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Matthew Garrett <mjg59@google.com>
Cc: Octavian Purdila <octavian.purdila@intel.com>
Cc: Peter Jones <pjones@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Cc: linux-integrity@vger.kernel.org
Fixes: 475fb4e8b2f4 ("efi / ACPI: load SSTDs from EFI variables")
Link: https://lkml.kernel.org/r/20191002165904.8819-3-ard.biesheuvel@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/firmware/efi/efi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 8d3e778..69f00f7 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -267,6 +267,9 @@ static __init int efivar_ssdt_load(void)
 	void *data;
 	int ret;
 
+	if (!efivar_ssdt[0])
+		return 0;
+
 	ret = efivar_init(efivar_ssdt_iter, &entries, true, &entries);
 
 	list_for_each_entry_safe(entry, aux, &entries, list) {
