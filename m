Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8211AC46E
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729315AbgDPN7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:59:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392583AbgDPN7f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:59:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CCF920732;
        Thu, 16 Apr 2020 13:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045574;
        bh=HgRYTwaT0K3i6R4yyE0ffxtTm8sNUE/pRjIWBN7QiJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WRKkNoXM/YRn2kSv3T2KtVyacFpEg9upGfx5rQMnx70DIImUTUWtFnXSYgHyhvst+
         Ak0wdgXUMGmBxtc3S2p9unma4rTr+K2EDpNhu0HPGhnXFFQPe/BktJmUlpDxbmBvZb
         cb99vryv1snxo+jneowZIaIRP2yly3mVv6nEhkdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Valentin Ciocoi Radulescu <valentin.ciocoi@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.6 183/254] crypto: caam/qi2 - fix chacha20 data size error
Date:   Thu, 16 Apr 2020 15:24:32 +0200
Message-Id: <20200416131349.265927802@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horia Geantă <horia.geanta@nxp.com>

commit 3a5a9e1ef37b030b836d92df8264f840988f4a38 upstream.

HW generates a Data Size error for chacha20 requests that are not
a multiple of 64B, since algorithm state (AS) does not have
the FINAL bit set.

Since updating req->iv (for chaining) is not required,
modify skcipher descriptors to set the FINAL bit for chacha20.

[Note that for skcipher decryption we know that ctx1_iv_off is 0,
which allows for an optimization by not checking algorithm type,
since append_dec_op1() sets FINAL bit for all algorithms except AES.]

Also drop the descriptor operations that save the IV.
However, in order to keep code logic simple, things like
S/G tables generation etc. are not touched.

Cc: <stable@vger.kernel.org> # v5.3+
Fixes: 334d37c9e263 ("crypto: caam - update IV using HW support")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Tested-by: Valentin Ciocoi Radulescu <valentin.ciocoi@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/caam/caamalg_desc.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/crypto/caam/caamalg_desc.c
+++ b/drivers/crypto/caam/caamalg_desc.c
@@ -1379,6 +1379,9 @@ void cnstr_shdsc_skcipher_encap(u32 * co
 				const u32 ctx1_iv_off)
 {
 	u32 *key_jump_cmd;
+	u32 options = cdata->algtype | OP_ALG_AS_INIT | OP_ALG_ENCRYPT;
+	bool is_chacha20 = ((cdata->algtype & OP_ALG_ALGSEL_MASK) ==
+			    OP_ALG_ALGSEL_CHACHA20);
 
 	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
 	/* Skip if already shared */
@@ -1417,14 +1420,15 @@ void cnstr_shdsc_skcipher_encap(u32 * co
 				      LDST_OFFSET_SHIFT));
 
 	/* Load operation */
-	append_operation(desc, cdata->algtype | OP_ALG_AS_INIT |
-			 OP_ALG_ENCRYPT);
+	if (is_chacha20)
+		options |= OP_ALG_AS_FINALIZE;
+	append_operation(desc, options);
 
 	/* Perform operation */
 	skcipher_append_src_dst(desc);
 
 	/* Store IV */
-	if (ivsize)
+	if (!is_chacha20 && ivsize)
 		append_seq_store(desc, ivsize, LDST_SRCDST_BYTE_CONTEXT |
 				 LDST_CLASS_1_CCB | (ctx1_iv_off <<
 				 LDST_OFFSET_SHIFT));
@@ -1451,6 +1455,8 @@ void cnstr_shdsc_skcipher_decap(u32 * co
 				const u32 ctx1_iv_off)
 {
 	u32 *key_jump_cmd;
+	bool is_chacha20 = ((cdata->algtype & OP_ALG_ALGSEL_MASK) ==
+			    OP_ALG_ALGSEL_CHACHA20);
 
 	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
 	/* Skip if already shared */
@@ -1499,7 +1505,7 @@ void cnstr_shdsc_skcipher_decap(u32 * co
 	skcipher_append_src_dst(desc);
 
 	/* Store IV */
-	if (ivsize)
+	if (!is_chacha20 && ivsize)
 		append_seq_store(desc, ivsize, LDST_SRCDST_BYTE_CONTEXT |
 				 LDST_CLASS_1_CCB | (ctx1_iv_off <<
 				 LDST_OFFSET_SHIFT));


