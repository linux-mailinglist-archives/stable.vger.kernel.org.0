Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2689BDA168
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394805AbfJPVxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:53:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394799AbfJPVxD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:53:03 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6591521A49;
        Wed, 16 Oct 2019 21:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262782;
        bh=0TygEq0obD9yYFXBpeYVPtjciUgfWD7m0vV61+y6fIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1D17U8myz+1/o2Am/Ol4aaMCx5AvJiSBqMFtjPLZ7IdR1+WJt1oN34ja4sgjQLVw
         u4vQsJQro1LcuoLnPO170/4nHgeYXO77kRwk8Tk/adX7VzRWt77zu88xhH4xse8hPQ
         pU0EC6GO79nl81FsXhuvUMFJ3ZW+R6vrHVg9Hbr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 4.4 23/79] crypto: caam - fix concurrency issue in givencrypt descriptor
Date:   Wed, 16 Oct 2019 14:49:58 -0700
Message-Id: <20191016214752.249557377@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
References: <20191016214729.758892904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horia Geantă <horia.geanta@nxp.com>

commit 48f89d2a2920166c35b1c0b69917dbb0390ebec7 upstream.

IV transfer from ofifo to class2 (set up at [29][30]) is not guaranteed
to be scheduled before the data transfer from ofifo to external memory
(set up at [38]:

[29] 10FA0004           ld: ind-nfifo (len=4) imm
[30] 81F00010               <nfifo_entry: ofifo->class2 type=msg len=16>
[31] 14820004           ld: ccb2-datasz len=4 offs=0 imm
[32] 00000010               data:0x00000010
[33] 8210010D    operation: cls1-op aes cbc init-final enc
[34] A8080B04         math: (seqin + math0)->vseqout len=4
[35] 28000010    seqfifold: skip len=16
[36] A8080A04         math: (seqin + math0)->vseqin len=4
[37] 2F1E0000    seqfifold: both msg1->2-last2-last1 len=vseqinsz
[38] 69300000   seqfifostr: msg len=vseqoutsz
[39] 5C20000C      seqstr: ccb2 ctx len=12 offs=0

If ofifo -> external memory transfer happens first, DECO will hang
(issuing a Watchdog Timeout error, if WDOG is enabled) waiting for
data availability in ofifo for the ofifo -> c2 ififo transfer.

Make sure IV transfer happens first by waiting for all CAAM internal
transfers to end before starting payload transfer.

New descriptor with jump command inserted at [37]:

[..]
[36] A8080A04         math: (seqin + math0)->vseqin len=4
[37] A1000401         jump: jsl1 all-match[!nfifopend] offset=[01] local->[38]
[38] 2F1E0000    seqfifold: both msg1->2-last2-last1 len=vseqinsz
[39] 69300000   seqfifostr: msg len=vseqoutsz
[40] 5C20000C      seqstr: ccb2 ctx len=12 offs=0

[Note: the issue is present in the descriptor from the very beginning
(cf. Fixes tag). However I've marked it v4.19+ since it's the oldest
maintained kernel that the patch applies clean against.]

Cc: <stable@vger.kernel.org> # v4.19+
Fixes: 1acebad3d8db8 ("crypto: caam - faster aead implementation")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[Horia: backport to v4.4, v4.9]
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/caam/caamalg.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -75,7 +75,7 @@
 #define DESC_AEAD_BASE			(4 * CAAM_CMD_SZ)
 #define DESC_AEAD_ENC_LEN		(DESC_AEAD_BASE + 11 * CAAM_CMD_SZ)
 #define DESC_AEAD_DEC_LEN		(DESC_AEAD_BASE + 15 * CAAM_CMD_SZ)
-#define DESC_AEAD_GIVENC_LEN		(DESC_AEAD_ENC_LEN + 9 * CAAM_CMD_SZ)
+#define DESC_AEAD_GIVENC_LEN		(DESC_AEAD_ENC_LEN + 10 * CAAM_CMD_SZ)
 
 /* Note: Nonce is counted in enckeylen */
 #define DESC_AEAD_CTR_RFC3686_LEN	(4 * CAAM_CMD_SZ)
@@ -437,6 +437,7 @@ static int aead_set_sh_desc(struct crypt
 	u32 geniv, moveiv;
 	u32 ctx1_iv_off = 0;
 	u32 *desc;
+	u32 *wait_cmd;
 	const bool ctr_mode = ((ctx->class1_alg_type & OP_ALG_AAI_MASK) ==
 			       OP_ALG_AAI_CTR_MOD128);
 	const bool is_rfc3686 = alg->caam.rfc3686;
@@ -702,6 +703,14 @@ copy_iv:
 
 	/* Will read cryptlen */
 	append_math_add(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
+
+	/*
+	 * Wait for IV transfer (ofifo -> class2) to finish before starting
+	 * ciphertext transfer (ofifo -> external memory).
+	 */
+	wait_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL | JUMP_COND_NIFP);
+	set_jump_tgt_here(desc, wait_cmd);
+
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_BOTH | KEY_VLF |
 			     FIFOLD_TYPE_MSG1OUT2 | FIFOLD_TYPE_LASTBOTH);
 	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | KEY_VLF);


