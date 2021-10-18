Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A96B431B1F
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbhJRNax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:30:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232321AbhJRN34 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:29:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1040361260;
        Mon, 18 Oct 2021 13:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563665;
        bh=+SRxb1X4HPldcRmw4/nJibzSkkID6PALLpf7xzb+9TQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WwGhdx4j0014kPnounkpsOpmybMlHomIEq8Gg3ViJ2LBHRFLjLEUkv0Ac4ku1NbI+
         8/Op1zn6la4kktZjEJrz96Pe3+T0RObnF2BZ73rXL8e2YootWLeSBSN6YgeQLt0/6k
         91yKWVs+9RxA1gN0EmBLxwhtk+p7VMzDmdkZCW6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Perches <joe@perches.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.19 16/50] efi/cper: use stack buffer for error record decoding
Date:   Mon, 18 Oct 2021 15:24:23 +0200
Message-Id: <20211018132327.081021783@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132326.529486647@linuxfoundation.org>
References: <20211018132326.529486647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit b3a72ca80351917cc23f9e24c35f3c3979d3c121 upstream.

Joe reports that using a statically allocated buffer for converting CPER
error records into human readable text is probably a bad idea. Even
though we are not aware of any actual issues, a stack buffer is clearly
a better choice here anyway, so let's move the buffer into the stack
frames of the two functions that refer to it.

Cc: <stable@vger.kernel.org>
Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/cper.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -37,8 +37,6 @@
 #include <acpi/ghes.h>
 #include <ras/ras_event.h>
 
-static char rcd_decode_str[CPER_REC_LEN];
-
 /*
  * CPER record ID need to be unique even after reboot, because record
  * ID is used as index for ERST storage, while CPER records from
@@ -311,6 +309,7 @@ const char *cper_mem_err_unpack(struct t
 				struct cper_mem_err_compact *cmem)
 {
 	const char *ret = trace_seq_buffer_ptr(p);
+	char rcd_decode_str[CPER_REC_LEN];
 
 	if (cper_mem_err_location(cmem, rcd_decode_str))
 		trace_seq_printf(p, "%s", rcd_decode_str);
@@ -325,6 +324,7 @@ static void cper_print_mem(const char *p
 	int len)
 {
 	struct cper_mem_err_compact cmem;
+	char rcd_decode_str[CPER_REC_LEN];
 
 	/* Don't trust UEFI 2.1/2.2 structure with bad validation bits */
 	if (len == sizeof(struct cper_sec_mem_err_old) &&


