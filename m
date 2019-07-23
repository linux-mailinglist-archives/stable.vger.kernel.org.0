Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC5267145F
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 10:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbfGWItk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 04:49:40 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52587 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727994AbfGWItj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 04:49:39 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id ACF3C21B03;
        Tue, 23 Jul 2019 04:49:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 04:49:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=O7lj0y
        gTmJxt/4eP9W2yCRuHKysFHEoR+iCCTQvyJjw=; b=xSNO+VY624pwl0RXk6CSeL
        CCd/a860j0tlQ/IfDJSFRXwofm00w5eYcZnen+9J5MAo8CLyfzq1tStNdpK9f8e1
        7+OceNfm7vucjMPJLxLfPNFIfwuF0mrEFLfpfug2Cf3cArY+oAvrQDBwvIH1rknr
        O+VHB+mflqQslBFh0MT/I/wRqu6IJ+EQVfAE6l7qJQNo68SvLc7GEZIXvkcXfLXq
        c9cDXXFyHiNOft+q5ThT9H2mirFlVjeixPdPp1ynrHc3dAe3kwiKlmWNfiByBgSR
        HfngsUQPYH+0NoN+nL6IGArE8JENMXTIcQXk771kJ1jq+kLr/xROCFOs4hy4yAPw
        ==
X-ME-Sender: <xms:Iso2XXnbwGIiXbGD3-ZDCBQ3-iPFjb9fS6N0ggEZSX23MFFL38iB4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeej
X-ME-Proxy: <xmx:Iso2XT4eR-zIEbmyV5hoTZUCg22gSimEb4iCQyXr-Uu7yW9NW0Y-CA>
    <xmx:Iso2XWvxBymMGCzZu3B6lQK4KexKBDJHwsz0KsadCLPeFyEd0tvDTg>
    <xmx:Iso2XbVrzhQG2ZaY2oOsqagZUYNLUkYbi0-tAYarnGdA-y2bLhgu6g>
    <xmx:Iso2XaX-pz02sJ4rXVtWyxOv4XMRMYLvE25GeX7wDyESC8oi0oSa2A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B8FCD80061;
        Tue, 23 Jul 2019 04:49:37 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: ccp - Validate the the error value used to index" failed to apply to 4.9-stable tree
To:     Gary.Hook@amd.com, cfir@google.com, gary.hook@amd.com,
        herbert@gondor.apana.org.au, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 10:49:35 +0200
Message-ID: <1563871775163255@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 52393d617af7b554f03531e6756facf2ea687d2e Mon Sep 17 00:00:00 2001
From: "Hook, Gary" <Gary.Hook@amd.com>
Date: Thu, 27 Jun 2019 16:16:23 +0000
Subject: [PATCH] crypto: ccp - Validate the the error value used to index
 error messages

The error code read from the queue status register is only 6 bits wide,
but we need to verify its value is within range before indexing the error
messages.

Fixes: 81422badb3907 ("crypto: ccp - Make syslog errors human-readable")
Cc: <stable@vger.kernel.org>
Reported-by: Cfir Cohen <cfir@google.com>
Signed-off-by: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index 1b5035d56288..9b6d8972a565 100644
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
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 6810b65c1939..7442b0422f8a 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -632,7 +632,7 @@ struct ccp5_desc {
 void ccp_add_device(struct ccp_device *ccp);
 void ccp_del_device(struct ccp_device *ccp);
 
-extern void ccp_log_error(struct ccp_device *, int);
+extern void ccp_log_error(struct ccp_device *, unsigned int);
 
 struct ccp_device *ccp_alloc_struct(struct sp_device *sp);
 bool ccp_queues_suspended(struct ccp_device *ccp);

