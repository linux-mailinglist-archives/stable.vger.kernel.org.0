Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37527439F3B
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbhJYTSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:18:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234515AbhJYTSW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:18:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11461600D3;
        Mon, 25 Oct 2021 19:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189360;
        bh=T6sqSzknxN+29LWj2D1Fygfur49sOyVzp9bbeAszR4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gm257RKYABfD0F9AGRwgRG0DoPC2NXdj+HGkG6hedWPaSu+GqSgIqCILwQ8KHYIMp
         zv6gisiOX22E9fo2+MEK9VinnnQXvl/kD3GX08vCwi2vJ7TzPWZIpLEVsK7KBn57zT
         peCucoCrusnYvqVkXB1LP4b7Jft4N32nAl/Q6TEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Perches <joe@perches.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.4 05/44] efi/cper: use stack buffer for error record decoding
Date:   Mon, 25 Oct 2021 21:13:46 +0200
Message-Id: <20211025190929.800977864@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190928.054676643@linuxfoundation.org>
References: <20211025190928.054676643@linuxfoundation.org>
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
@@ -35,8 +35,6 @@
 
 #define INDENT_SP	" "
 
-static char rcd_decode_str[CPER_REC_LEN];
-
 /*
  * CPER record ID need to be unique even after reboot, because record
  * ID is used as index for ERST storage, while CPER records from
@@ -293,6 +291,7 @@ const char *cper_mem_err_unpack(struct t
 				struct cper_mem_err_compact *cmem)
 {
 	const char *ret = trace_seq_buffer_ptr(p);
+	char rcd_decode_str[CPER_REC_LEN];
 
 	if (cper_mem_err_location(cmem, rcd_decode_str))
 		trace_seq_printf(p, "%s", rcd_decode_str);
@@ -307,6 +306,7 @@ static void cper_print_mem(const char *p
 	int len)
 {
 	struct cper_mem_err_compact cmem;
+	char rcd_decode_str[CPER_REC_LEN];
 
 	/* Don't trust UEFI 2.1/2.2 structure with bad validation bits */
 	if (len == sizeof(struct cper_sec_mem_err_old) &&


