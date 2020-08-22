Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F292824E7B6
	for <lists+stable@lfdr.de>; Sat, 22 Aug 2020 15:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgHVNjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Aug 2020 09:39:33 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33766 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728020AbgHVNjC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Aug 2020 09:39:02 -0400
Date:   Sat, 22 Aug 2020 13:38:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598103540;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IUQOPfPaZw+v546zYZ+p2NR+F6fR0aAKcP7aUZHFN0M=;
        b=2eSH1QNSHjTvXb6/BJOC7su8XiTDNCDCQnfL8SNiUD4KZTvAgQve60SjDukTSFCv781RCn
        m67jdwAvhOLa/RCEKJHB3Fad0WkvwBfeqUxCJoBiPLJAPhp3/GTR54od/t1QJbwk/7EWYt
        FDDFddAL6RocqSzb+/xNsTcNHx6AtRsfTDC6/BWOB0pQThxyURhuQtnVTVwBd5nK1BQrsT
        AxL32ItHxSgl2yh5q/xKhdqOExNVcO55nTUo5Aw2ItISOpV0Xf56DGIOjhzNvz/tpekcCc
        i6dM9xm/gtnG41blNMdGM5MSBnPhsZnhFAyndYV0vYfmp2/rOT2pQ/t3G70H/g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598103540;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IUQOPfPaZw+v546zYZ+p2NR+F6fR0aAKcP7aUZHFN0M=;
        b=zSCdOY02ouaNT922InM6dMdYC0dh0NQX09UtZwVwGg4a+ja0ss7GGv3cNr6uyGjjLv09GX
        HySLNiot3Jvg3sAw==
From:   "tip-bot2 for Arvind Sankar" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: efi/urgent] efi/libstub: Handle NULL cmdline
Cc:     <stable@vger.kernel.org>, Arvind Sankar <nivedita@alum.mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200729193300.598448-1-nivedita@alum.mit.edu>
References: <20200729193300.598448-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Message-ID: <159810353950.3192.16752038526498291779.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the efi/urgent branch of tip:

Commit-ID:     a37ca6a2af9df2972372b918f09390c9303acfbd
Gitweb:        https://git.kernel.org/tip/a37ca6a2af9df2972372b918f09390c9303acfbd
Author:        Arvind Sankar <nivedita@alum.mit.edu>
AuthorDate:    Wed, 29 Jul 2020 15:33:00 -04:00
Committer:     Ard Biesheuvel <ardb@kernel.org>
CommitterDate: Thu, 20 Aug 2020 11:18:55 +02:00

efi/libstub: Handle NULL cmdline

Treat a NULL cmdline the same as empty. Although this is unlikely to
happen in practice, the x86 kernel entry does check for NULL cmdline and
handles it, so do it here as well.

Cc: <stable@vger.kernel.org>
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Link: https://lore.kernel.org/r/20200729193300.598448-1-nivedita@alum.mit.edu
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 37ff34e..f53652a 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -187,10 +187,14 @@ int efi_printk(const char *fmt, ...)
  */
 efi_status_t efi_parse_options(char const *cmdline)
 {
-	size_t len = strlen(cmdline) + 1;
+	size_t len;
 	efi_status_t status;
 	char *str, *buf;
 
+	if (!cmdline)
+		return EFI_SUCCESS;
+
+	len = strlen(cmdline) + 1;
 	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, len, (void **)&buf);
 	if (status != EFI_SUCCESS)
 		return status;
