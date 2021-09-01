Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07D23FD401
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 08:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242361AbhIAGwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 02:52:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241096AbhIAGwh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 02:52:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 454796101A;
        Wed,  1 Sep 2021 06:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630479101;
        bh=rNmdrQvuGqWSSWlNIgo4Fv34roEI4S5C4yYkmzZYlAE=;
        h=From:To:Cc:Subject:Date:From;
        b=b5RfHnhWgYpn88oaOYpkj/xOr7qYO1RtgzwnL9ofhcbcXaNkrydW8cAgYlDumyn/M
         YiZcByGGDZzechAGLg8/x1oY9mCVIc8bAD9mskHjyQ8wvcfz44pqLxqrY8lNjOzTng
         EB+jPC1Fm0DDZS8+aoPQtIZ7C1xLjnVGp1TnPsui2T/xs3reWiq91pFfK1VStJoYX2
         J+umMbcCYkyo/jgiyipmenoNm2CL5s1mKOEHYJQqDgfdOZGseBtO7pkGnyquKs2eQm
         j0ANvp2CXIxO9pJcFXcXKYYXF1kCWEANFPxikcgR7V6veqD4RlwoKZGW5MUZ9zaQnZ
         9tyAZW5w4Qddw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     james.morse@arm.com, bp@alien8.de,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: [PATCH] efi/cper: use stack buffer for error record decoding
Date:   Wed,  1 Sep 2021 08:51:21 +0200
Message-Id: <20210901065121.642188-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 73bdbd207e7a..6ec8edec6329 100644
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
-- 
2.30.2

