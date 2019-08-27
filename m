Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFA59DFD3
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 09:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbfH0H54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:57:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730883AbfH0H5y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:57:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25CC821883;
        Tue, 27 Aug 2019 07:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892672;
        bh=AQEVTXZQxGBQ9YFF+5HCo/xdoTw+hiPIi6RUAuY8E94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DdMZauSQYYAeVSkwKrMm1thAWDlPxFlvwJiwflAYpBpXrSYeBKRWgRKRmTcTmw9uW
         pVNnTORkh5r1PUeWi3eVbbayQlvUK/pf37Lx9PEh3vD3RRmerhyu1j+3g8lzp2lMSb
         //CFZaJWaR7CACU0JDAw04CSvW1AkzSlDIqlD8ms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH 4.19 73/98] x86/boot: Save fields explicitly, zero out everything else
Date:   Tue, 27 Aug 2019 09:50:52 +0200
Message-Id: <20190827072722.052505070@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

commit a90118c445cc7f07781de26a9684d4ec58bfcfd1 upstream.

Recent gcc compilers (gcc 9.1) generate warnings about an out of bounds
memset, if the memset goes accross several fields of a struct. This
generated a couple of warnings on x86_64 builds in sanitize_boot_params().

Fix this by explicitly saving the fields in struct boot_params
that are intended to be preserved, and zeroing all the rest.

[ tglx: Tagged for stable as it breaks the warning free build there as well ]

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Suggested-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20190731054627.5627-2-jhubbard@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/bootparam_utils.h |   60 +++++++++++++++++++++++++--------
 1 file changed, 47 insertions(+), 13 deletions(-)

--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -18,6 +18,20 @@
  * Note: efi_info is commonly left uninitialized, but that field has a
  * private magic, so it is better to leave it unchanged.
  */
+
+#define sizeof_mbr(type, member) ({ sizeof(((type *)0)->member); })
+
+#define BOOT_PARAM_PRESERVE(struct_member)				\
+	{								\
+		.start = offsetof(struct boot_params, struct_member),	\
+		.len   = sizeof_mbr(struct boot_params, struct_member),	\
+	}
+
+struct boot_params_to_save {
+	unsigned int start;
+	unsigned int len;
+};
+
 static void sanitize_boot_params(struct boot_params *boot_params)
 {
 	/* 
@@ -36,19 +50,39 @@ static void sanitize_boot_params(struct
 	 */
 	if (boot_params->sentinel) {
 		/* fields in boot_params are left uninitialized, clear them */
-		memset(&boot_params->ext_ramdisk_image, 0,
-		       (char *)&boot_params->efi_info -
-			(char *)&boot_params->ext_ramdisk_image);
-		memset(&boot_params->kbd_status, 0,
-		       (char *)&boot_params->hdr -
-		       (char *)&boot_params->kbd_status);
-		memset(&boot_params->_pad7[0], 0,
-		       (char *)&boot_params->edd_mbr_sig_buffer[0] -
-			(char *)&boot_params->_pad7[0]);
-		memset(&boot_params->_pad8[0], 0,
-		       (char *)&boot_params->eddbuf[0] -
-			(char *)&boot_params->_pad8[0]);
-		memset(&boot_params->_pad9[0], 0, sizeof(boot_params->_pad9));
+		static struct boot_params scratch;
+		char *bp_base = (char *)boot_params;
+		char *save_base = (char *)&scratch;
+		int i;
+
+		const struct boot_params_to_save to_save[] = {
+			BOOT_PARAM_PRESERVE(screen_info),
+			BOOT_PARAM_PRESERVE(apm_bios_info),
+			BOOT_PARAM_PRESERVE(tboot_addr),
+			BOOT_PARAM_PRESERVE(ist_info),
+			BOOT_PARAM_PRESERVE(hd0_info),
+			BOOT_PARAM_PRESERVE(hd1_info),
+			BOOT_PARAM_PRESERVE(sys_desc_table),
+			BOOT_PARAM_PRESERVE(olpc_ofw_header),
+			BOOT_PARAM_PRESERVE(efi_info),
+			BOOT_PARAM_PRESERVE(alt_mem_k),
+			BOOT_PARAM_PRESERVE(scratch),
+			BOOT_PARAM_PRESERVE(e820_entries),
+			BOOT_PARAM_PRESERVE(eddbuf_entries),
+			BOOT_PARAM_PRESERVE(edd_mbr_sig_buf_entries),
+			BOOT_PARAM_PRESERVE(edd_mbr_sig_buffer),
+			BOOT_PARAM_PRESERVE(e820_table),
+			BOOT_PARAM_PRESERVE(eddbuf),
+		};
+
+		memset(&scratch, 0, sizeof(scratch));
+
+		for (i = 0; i < ARRAY_SIZE(to_save); i++) {
+			memcpy(save_base + to_save[i].start,
+			       bp_base + to_save[i].start, to_save[i].len);
+		}
+
+		memcpy(boot_params, save_base, sizeof(*boot_params));
 	}
 }
 


