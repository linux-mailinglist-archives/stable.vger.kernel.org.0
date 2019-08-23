Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6DD9A4CB
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 03:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387757AbfHWBKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 21:10:52 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33530 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387656AbfHWBKw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 21:10:52 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1i0y6L-0000Me-CI; Fri, 23 Aug 2019 03:10:49 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 046261C07E4;
        Fri, 23 Aug 2019 03:10:49 +0200 (CEST)
Date:   Fri, 23 Aug 2019 01:10:47 -0000
From:   tip-bot2 for John Hubbard <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/boot: Fix boot regression caused by bootparam
 sanitizing
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Neil MacLeod <neil@nmacleod.com>
In-Reply-To: <20190821192513.20126-1-jhubbard@nvidia.com>
References: <20190821192513.20126-1-jhubbard@nvidia.com>
MIME-Version: 1.0
Message-ID: <156652264750.9533.3737031935739279123.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from
 these emails
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     7846f58fba964af7cb8cf77d4d13c33254725211
Gitweb:        https://git.kernel.org/tip/7846f58fba964af7cb8cf77d4d13c33254725211
Author:        John Hubbard <jhubbard@nvidia.com>
AuthorDate:    Wed, 21 Aug 2019 12:25:13 -07:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Wed, 21 Aug 2019 22:37:09 +02:00

x86/boot: Fix boot regression caused by bootparam sanitizing

commit a90118c445cc ("x86/boot: Save fields explicitly, zero out everything
else") had two errors:

    * It preserved boot_params.acpi_rsdp_addr, and
    * It failed to preserve boot_params.hdr

Therefore, zero out acpi_rsdp_addr, and preserve hdr.

Fixes: a90118c445cc ("x86/boot: Save fields explicitly, zero out everything else")
Reported-by: Neil MacLeod <neil@nmacleod.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Neil MacLeod <neil@nmacleod.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20190821192513.20126-1-jhubbard@nvidia.com
---
 arch/x86/include/asm/bootparam_utils.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/bootparam_utils.h b/arch/x86/include/asm/bootparam_utils.h
index 9e5f3c7..f5e90a8 100644
--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -59,6 +59,7 @@ static void sanitize_boot_params(struct boot_params *boot_params)
 			BOOT_PARAM_PRESERVE(apm_bios_info),
 			BOOT_PARAM_PRESERVE(tboot_addr),
 			BOOT_PARAM_PRESERVE(ist_info),
+			BOOT_PARAM_PRESERVE(acpi_rsdp_addr),
 			BOOT_PARAM_PRESERVE(hd0_info),
 			BOOT_PARAM_PRESERVE(hd1_info),
 			BOOT_PARAM_PRESERVE(sys_desc_table),
@@ -70,7 +71,6 @@ static void sanitize_boot_params(struct boot_params *boot_params)
 			BOOT_PARAM_PRESERVE(eddbuf_entries),
 			BOOT_PARAM_PRESERVE(edd_mbr_sig_buf_entries),
 			BOOT_PARAM_PRESERVE(edd_mbr_sig_buffer),
-			BOOT_PARAM_PRESERVE(hdr),
 			BOOT_PARAM_PRESERVE(e820_table),
 			BOOT_PARAM_PRESERVE(eddbuf),
 		};
