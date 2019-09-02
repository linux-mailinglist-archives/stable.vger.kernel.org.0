Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B24BA5131
	for <lists+stable@lfdr.de>; Mon,  2 Sep 2019 10:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbfIBIRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 04:17:24 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56402 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729462AbfIBIRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Sep 2019 04:17:24 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1i4hWQ-0008Mf-J3; Mon, 02 Sep 2019 10:17:10 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 327551C0793;
        Mon,  2 Sep 2019 10:17:10 +0200 (CEST)
Date:   Mon, 02 Sep 2019 08:17:10 -0000
From:   "tip-bot2 for John S. Gruber" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/boot: Preserve boot_params.secure_boot from sanitizing
Cc:     "John S. Gruber" <JohnSGruber@gmail.com>,
        Borislav Petkov <bp@suse.de>,
        John Hubbard <jhubbard@nvidia.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Mark Brown <broonie@kernel.org>,
        stable <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86-ml" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
In-Reply-To: <CAPotdmSPExAuQcy9iAHqX3js_fc4mMLQOTr5RBGvizyCOPcTQQ@mail.gmail.com>
References: <CAPotdmSPExAuQcy9iAHqX3js_fc4mMLQOTr5RBGvizyCOPcTQQ@mail.gmail.com>
MIME-Version: 1.0
Message-ID: <156741223005.17687.14072415887043895040.tip-bot2@tip-bot2>
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

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     29d9a0b50736768f042752070e5cdf4e4d4c00df
Gitweb:        https://git.kernel.org/tip/29d9a0b50736768f042752070e5cdf4e4d4c00df
Author:        John S. Gruber <JohnSGruber@gmail.com>
AuthorDate:    Mon, 02 Sep 2019 00:00:54 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Mon, 02 Sep 2019 09:17:45 +02:00

x86/boot: Preserve boot_params.secure_boot from sanitizing

Commit

  a90118c445cc ("x86/boot: Save fields explicitly, zero out everything else")

now zeroes the secure boot setting information (enabled/disabled/...)
passed by the boot loader or by the kernel's EFI handover mechanism.

The problem manifests itself with signed kernels using the EFI handoff
protocol with grub and the kernel loses the information whether secure
boot is enabled in the firmware, i.e., the log message "Secure boot
enabled" becomes "Secure boot could not be determined".

efi_main() arch/x86/boot/compressed/eboot.c sets this field early but it
is subsequently zeroed by the above referenced commit.

Include boot_params.secure_boot in the preserve field list.

 [ bp: restructure commit message and massage. ]

Fixes: a90118c445cc ("x86/boot: Save fields explicitly, zero out everything else")
Signed-off-by: John S. Gruber <JohnSGruber@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: stable <stable@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/CAPotdmSPExAuQcy9iAHqX3js_fc4mMLQOTr5RBGvizyCOPcTQQ@mail.gmail.com
---
 arch/x86/include/asm/bootparam_utils.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/bootparam_utils.h b/arch/x86/include/asm/bootparam_utils.h
index 9e5f3c7..981fe92 100644
--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -70,6 +70,7 @@ static void sanitize_boot_params(struct boot_params *boot_params)
 			BOOT_PARAM_PRESERVE(eddbuf_entries),
 			BOOT_PARAM_PRESERVE(edd_mbr_sig_buf_entries),
 			BOOT_PARAM_PRESERVE(edd_mbr_sig_buffer),
+			BOOT_PARAM_PRESERVE(secure_boot),
 			BOOT_PARAM_PRESERVE(hdr),
 			BOOT_PARAM_PRESERVE(e820_table),
 			BOOT_PARAM_PRESERVE(eddbuf),
