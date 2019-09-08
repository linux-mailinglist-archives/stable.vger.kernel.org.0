Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 750C6ACDD1
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733298AbfIHMxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:53:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387448AbfIHMxI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:53:08 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C617E218AC;
        Sun,  8 Sep 2019 12:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947188;
        bh=sMY8CX+ke/0X1cozkbi0shNM3husLo0be0Fv4RKdw+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WuwVJPWELoSMcaN/5ZROyvgF3ZZElyCQV7Ki8O8pvPMh8F8r+wEmZtn+mCMVow5Ei
         /mxs2wVrfs3zqM07vzvUZ9GAJFo/GjMCuJgV9XSft1hRcvo28xYTAlTko5sWNPWJuK
         3T8i2I8K6LjmivC8o9t1T1e3AF8xWW434nr85X1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "John S. Gruber" <JohnSGruber@gmail.com>,
        Borislav Petkov <bp@suse.de>,
        John Hubbard <jhubbard@nvidia.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Mark Brown <broonie@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>
Subject: [PATCH 5.2 93/94] x86/boot: Preserve boot_params.secure_boot from sanitizing
Date:   Sun,  8 Sep 2019 13:42:29 +0100
Message-Id: <20190908121153.089539744@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John S. Gruber <JohnSGruber@gmail.com>

commit 29d9a0b50736768f042752070e5cdf4e4d4c00df upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/bootparam_utils.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -70,6 +70,7 @@ static void sanitize_boot_params(struct
 			BOOT_PARAM_PRESERVE(eddbuf_entries),
 			BOOT_PARAM_PRESERVE(edd_mbr_sig_buf_entries),
 			BOOT_PARAM_PRESERVE(edd_mbr_sig_buffer),
+			BOOT_PARAM_PRESERVE(secure_boot),
 			BOOT_PARAM_PRESERVE(hdr),
 			BOOT_PARAM_PRESERVE(e820_table),
 			BOOT_PARAM_PRESERVE(eddbuf),


