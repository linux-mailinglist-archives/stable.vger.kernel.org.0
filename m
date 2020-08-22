Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22BD24E7B7
	for <lists+stable@lfdr.de>; Sat, 22 Aug 2020 15:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgHVNjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Aug 2020 09:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728086AbgHVNjC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Aug 2020 09:39:02 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2291C061574;
        Sat, 22 Aug 2020 06:39:01 -0700 (PDT)
Date:   Sat, 22 Aug 2020 13:38:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598103539;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nxClsAni8MetG2l9vr8TLwbGulfmhd4lEpWk5Z1JUTQ=;
        b=jtirZxsYI1DdtlnxSehiV4xiRa9IVm3XCEoREQZK34bEmZqM13Ql1Qc8QXLc/4YOXn38j9
        vcyfs7CWsEwQbul1NBy+fPIKx0BVaETemn7SQRRrWqAVNrEegazhjF0LjAHc8iwU+RLaMF
        L89Jq6kJsoYZFh4feOYYpwaSYTW9F5TiDuN71Be6PSE+6WJ373eycLXvWd218XUVcOuVcu
        YaX5xMxsDUOFikkQ1hBe3LtOa4Ob3XHmJKSY02OMa/Y1uUWKzfITpYY6+K21q6zfSohd41
        48fPVgjmYczQsp73OA2xHVwyB/pB+nuuQgplXSWeWe94Mn7VvazyHCHTowQ2ww==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598103539;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nxClsAni8MetG2l9vr8TLwbGulfmhd4lEpWk5Z1JUTQ=;
        b=ZTEQV6FyCpbCJS3euPNcdYUBZJbBW6LGiEh/JQOI9efZC3Z4ioMnj0J0L2zsw5mOkrwZc2
        sxJBEuXOx3JcywCw==
From:   "tip-bot2 for Arvind Sankar" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: efi/urgent] efi/libstub: Handle unterminated cmdline
Cc:     <stable@vger.kernel.org>, Arvind Sankar <nivedita@alum.mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200813185811.554051-4-nivedita@alum.mit.edu>
References: <20200813185811.554051-4-nivedita@alum.mit.edu>
MIME-Version: 1.0
Message-ID: <159810353887.3192.8959117951765134192.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the efi/urgent branch of tip:

Commit-ID:     8a8a3237a78cbc0557f0eb16a89f16d616323e99
Gitweb:        https://git.kernel.org/tip/8a8a3237a78cbc0557f0eb16a89f16d616323e99
Author:        Arvind Sankar <nivedita@alum.mit.edu>
AuthorDate:    Thu, 13 Aug 2020 14:58:11 -04:00
Committer:     Ard Biesheuvel <ardb@kernel.org>
CommitterDate: Thu, 20 Aug 2020 11:18:58 +02:00

efi/libstub: Handle unterminated cmdline

Make the command line parsing more robust, by handling the case it is
not NUL-terminated.

Use strnlen instead of strlen, and make sure that the temporary copy is
NUL-terminated before parsing.

Cc: <stable@vger.kernel.org>
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Link: https://lore.kernel.org/r/20200813185811.554051-4-nivedita@alum.mit.edu
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index f53652a..f735db5 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -194,12 +194,14 @@ efi_status_t efi_parse_options(char const *cmdline)
 	if (!cmdline)
 		return EFI_SUCCESS;
 
-	len = strlen(cmdline) + 1;
+	len = strnlen(cmdline, COMMAND_LINE_SIZE - 1) + 1;
 	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, len, (void **)&buf);
 	if (status != EFI_SUCCESS)
 		return status;
 
-	str = skip_spaces(memcpy(buf, cmdline, len));
+	memcpy(buf, cmdline, len - 1);
+	buf[len - 1] = '\0';
+	str = skip_spaces(buf);
 
 	while (*str) {
 		char *param, *val;
