Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91F242ED17
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 11:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236467AbhJOJIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 05:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236176AbhJOJIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 05:08:30 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0EDC061570;
        Fri, 15 Oct 2021 02:06:23 -0700 (PDT)
Date:   Fri, 15 Oct 2021 09:06:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634288782;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=Jo4n0ypAfnMELIZ0YjsjAb0WmlzrZA09o7ISC7CjWa4=;
        b=jJzBE9OvlBpoIkCBSc50KMRdnHsyWyOuMV1wmnGsCiWfnQWduov4yEX2H92Pq6gEQ79mOp
        lhQ+QBGV8+N4pJA2pcKL8592j99HhZl8OWwnMWRnEyJ9NTka9BhefRw4ftDskuCrR30vwr
        Wf4HT8lf7vuFrLJMqHddlTlZe6bF2PVQhqD36swFVknF+RNhCiYWjruuLyITZg1628F7CD
        Y0a3GqAWC2CtqPizqb9mbgG12pCUBjmCV4OzRLxjSse7v4Np6sdj7HHQGAcihAq4AiJrqI
        GAyZG8Lo1G/PyGkXhjCyyiteM+5b8fzBvdoSz+rw+XDOf2m0YbgYj/6t4LgQtw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634288782;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=Jo4n0ypAfnMELIZ0YjsjAb0WmlzrZA09o7ISC7CjWa4=;
        b=kgfNtFh+532XRMre4snOjtBJGU65xhkcpoP9dXTWBAH1CLI5+8PQ24+wF5FZuaGsDHN8HC
        a/ES0Iz9exd4vkBg==
From:   "tip-bot2 for Ard Biesheuvel" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: efi/urgent] efi/cper: use stack buffer for error record decoding
Cc:     <stable@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Ard Biesheuvel <ardb@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <163428878128.25758.6648821221665717900.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the efi/urgent branch of tip:

Commit-ID:     b3a72ca80351917cc23f9e24c35f3c3979d3c121
Gitweb:        https://git.kernel.org/tip/b3a72ca80351917cc23f9e24c35f3c3979d3c121
Author:        Ard Biesheuvel <ardb@kernel.org>
AuthorDate:    Wed, 01 Sep 2021 08:33:19 +02:00
Committer:     Ard Biesheuvel <ardb@kernel.org>
CommitterDate: Tue, 05 Oct 2021 13:05:59 +02:00

efi/cper: use stack buffer for error record decoding

Joe reports that using a statically allocated buffer for converting CPER
error records into human readable text is probably a bad idea. Even
though we are not aware of any actual issues, a stack buffer is clearly
a better choice here anyway, so let's move the buffer into the stack
frames of the two functions that refer to it.

Cc: <stable@vger.kernel.org>
Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/cper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index 73bdbd2..6ec8ede 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -25,8 +25,6 @@
 #include <acpi/ghes.h>
 #include <ras/ras_event.h>
 
-static char rcd_decode_str[CPER_REC_LEN];
-
 /*
  * CPER record ID need to be unique even after reboot, because record
  * ID is used as index for ERST storage, while CPER records from
@@ -312,6 +310,7 @@ const char *cper_mem_err_unpack(struct trace_seq *p,
 				struct cper_mem_err_compact *cmem)
 {
 	const char *ret = trace_seq_buffer_ptr(p);
+	char rcd_decode_str[CPER_REC_LEN];
 
 	if (cper_mem_err_location(cmem, rcd_decode_str))
 		trace_seq_printf(p, "%s", rcd_decode_str);
@@ -326,6 +325,7 @@ static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem,
 	int len)
 {
 	struct cper_mem_err_compact cmem;
+	char rcd_decode_str[CPER_REC_LEN];
 
 	/* Don't trust UEFI 2.1/2.2 structure with bad validation bits */
 	if (len == sizeof(struct cper_sec_mem_err_old) &&
