Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5D6C79441
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbfG2T3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:29:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728897AbfG2T3i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:29:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B38CF21655;
        Mon, 29 Jul 2019 19:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428577;
        bh=l3KunXrgj1/1PR7Nhw1HPBgQkLWACq+ht0INIonY6F0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwmS1x6mfw61d6HDb6p0F9faSxxiDHjYBScgW80a+RdvpXE36klmL38PypFklSzoi
         kGNQlwpaM4/zEys3as16DpjujVRJO859Hh9tjhHDnVR6sN88ushuvDsHCoDATA6bSE
         zhHWPPrh789y8ZnCk2+f4f1Q9aumgaGxNO5KrxDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cfir Cohen <cfir@google.com>,
        Gary R Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.14 120/293] crypto: ccp - Validate the the error value used to index error messages
Date:   Mon, 29 Jul 2019 21:20:11 +0200
Message-Id: <20190729190833.779164353@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hook, Gary <Gary.Hook@amd.com>

commit 52393d617af7b554f03531e6756facf2ea687d2e upstream.

The error code read from the queue status register is only 6 bits wide,
but we need to verify its value is within range before indexing the error
messages.

Fixes: 81422badb3907 ("crypto: ccp - Make syslog errors human-readable")
Cc: <stable@vger.kernel.org>
Reported-by: Cfir Cohen <cfir@google.com>
Signed-off-by: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccp/ccp-dev.c |   96 ++++++++++++++++++++++---------------------
 drivers/crypto/ccp/ccp-dev.h |    2 
 2 files changed, 52 insertions(+), 46 deletions(-)

--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -35,56 +35,62 @@ struct ccp_tasklet_data {
 };
 
 /* Human-readable error strings */
+#define CCP_MAX_ERROR_CODE	64
 static char *ccp_error_codes[] = {
 	"",
-	"ERR 01: ILLEGAL_ENGINE",
-	"ERR 02: ILLEGAL_KEY_ID",
-	"ERR 03: ILLEGAL_FUNCTION_TYPE",
-	"ERR 04: ILLEGAL_FUNCTION_MODE",
-	"ERR 05: ILLEGAL_FUNCTION_ENCRYPT",
-	"ERR 06: ILLEGAL_FUNCTION_SIZE",
-	"ERR 07: Zlib_MISSING_INIT_EOM",
-	"ERR 08: ILLEGAL_FUNCTION_RSVD",
-	"ERR 09: ILLEGAL_BUFFER_LENGTH",
-	"ERR 10: VLSB_FAULT",
-	"ERR 11: ILLEGAL_MEM_ADDR",
-	"ERR 12: ILLEGAL_MEM_SEL",
-	"ERR 13: ILLEGAL_CONTEXT_ID",
-	"ERR 14: ILLEGAL_KEY_ADDR",
-	"ERR 15: 0xF Reserved",
-	"ERR 16: Zlib_ILLEGAL_MULTI_QUEUE",
-	"ERR 17: Zlib_ILLEGAL_JOBID_CHANGE",
-	"ERR 18: CMD_TIMEOUT",
-	"ERR 19: IDMA0_AXI_SLVERR",
-	"ERR 20: IDMA0_AXI_DECERR",
-	"ERR 21: 0x15 Reserved",
-	"ERR 22: IDMA1_AXI_SLAVE_FAULT",
-	"ERR 23: IDMA1_AIXI_DECERR",
-	"ERR 24: 0x18 Reserved",
-	"ERR 25: ZLIBVHB_AXI_SLVERR",
-	"ERR 26: ZLIBVHB_AXI_DECERR",
-	"ERR 27: 0x1B Reserved",
-	"ERR 27: ZLIB_UNEXPECTED_EOM",
-	"ERR 27: ZLIB_EXTRA_DATA",
-	"ERR 30: ZLIB_BTYPE",
-	"ERR 31: ZLIB_UNDEFINED_SYMBOL",
-	"ERR 32: ZLIB_UNDEFINED_DISTANCE_S",
-	"ERR 33: ZLIB_CODE_LENGTH_SYMBOL",
-	"ERR 34: ZLIB _VHB_ILLEGAL_FETCH",
-	"ERR 35: ZLIB_UNCOMPRESSED_LEN",
-	"ERR 36: ZLIB_LIMIT_REACHED",
-	"ERR 37: ZLIB_CHECKSUM_MISMATCH0",
-	"ERR 38: ODMA0_AXI_SLVERR",
-	"ERR 39: ODMA0_AXI_DECERR",
-	"ERR 40: 0x28 Reserved",
-	"ERR 41: ODMA1_AXI_SLVERR",
-	"ERR 42: ODMA1_AXI_DECERR",
-	"ERR 43: LSB_PARITY_ERR",
+	"ILLEGAL_ENGINE",
+	"ILLEGAL_KEY_ID",
+	"ILLEGAL_FUNCTION_TYPE",
+	"ILLEGAL_FUNCTION_MODE",
+	"ILLEGAL_FUNCTION_ENCRYPT",
+	"ILLEGAL_FUNCTION_SIZE",
+	"Zlib_MISSING_INIT_EOM",
+	"ILLEGAL_FUNCTION_RSVD",
+	"ILLEGAL_BUFFER_LENGTH",
+	"VLSB_FAULT",
+	"ILLEGAL_MEM_ADDR",
+	"ILLEGAL_MEM_SEL",
+	"ILLEGAL_CONTEXT_ID",
+	"ILLEGAL_KEY_ADDR",
+	"0xF Reserved",
+	"Zlib_ILLEGAL_MULTI_QUEUE",
+	"Zlib_ILLEGAL_JOBID_CHANGE",
+	"CMD_TIMEOUT",
+	"IDMA0_AXI_SLVERR",
+	"IDMA0_AXI_DECERR",
+	"0x15 Reserved",
+	"IDMA1_AXI_SLAVE_FAULT",
+	"IDMA1_AIXI_DECERR",
+	"0x18 Reserved",
+	"ZLIBVHB_AXI_SLVERR",
+	"ZLIBVHB_AXI_DECERR",
+	"0x1B Reserved",
+	"ZLIB_UNEXPECTED_EOM",
+	"ZLIB_EXTRA_DATA",
+	"ZLIB_BTYPE",
+	"ZLIB_UNDEFINED_SYMBOL",
+	"ZLIB_UNDEFINED_DISTANCE_S",
+	"ZLIB_CODE_LENGTH_SYMBOL",
+	"ZLIB _VHB_ILLEGAL_FETCH",
+	"ZLIB_UNCOMPRESSED_LEN",
+	"ZLIB_LIMIT_REACHED",
+	"ZLIB_CHECKSUM_MISMATCH0",
+	"ODMA0_AXI_SLVERR",
+	"ODMA0_AXI_DECERR",
+	"0x28 Reserved",
+	"ODMA1_AXI_SLVERR",
+	"ODMA1_AXI_DECERR",
 };
 
-void ccp_log_error(struct ccp_device *d, int e)
+void ccp_log_error(struct ccp_device *d, unsigned int e)
 {
-	dev_err(d->dev, "CCP error: %s (0x%x)\n", ccp_error_codes[e], e);
+	if (WARN_ON(e >= CCP_MAX_ERROR_CODE))
+		return;
+
+	if (e < ARRAY_SIZE(ccp_error_codes))
+		dev_err(d->dev, "CCP error %d: %s\n", e, ccp_error_codes[e]);
+	else
+		dev_err(d->dev, "CCP error %d: Unknown Error\n", e);
 }
 
 /* List of CCPs, CCP count, read-write access lock, and access functions
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -632,7 +632,7 @@ struct ccp5_desc {
 void ccp_add_device(struct ccp_device *ccp);
 void ccp_del_device(struct ccp_device *ccp);
 
-extern void ccp_log_error(struct ccp_device *, int);
+extern void ccp_log_error(struct ccp_device *, unsigned int);
 
 struct ccp_device *ccp_alloc_struct(struct sp_device *sp);
 bool ccp_queues_suspended(struct ccp_device *ccp);


