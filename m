Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40027D0207
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 22:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730737AbfJHUTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 16:19:51 -0400
Received: from inva020.nxp.com ([92.121.34.13]:49078 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727835AbfJHUTv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 16:19:51 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 5E7C31A099B;
        Tue,  8 Oct 2019 22:19:48 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 49D001A008A;
        Tue,  8 Oct 2019 22:19:48 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 1AE9B205DB;
        Tue,  8 Oct 2019 22:19:48 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.4, 4.9] crypto: caam - fix concurrency issue in givencrypt descriptor
Date:   Tue,  8 Oct 2019 23:19:41 +0300
Message-Id: <20191008201941.17526-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[Horia: backport to v4.4, v4.9]
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index f8ac768ed5d7..413e1f35773f 100644
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
@@ -474,6 +474,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	u32 geniv, moveiv;
 	u32 ctx1_iv_off = 0;
 	u32 *desc;
+	u32 *wait_cmd;
 	const bool ctr_mode = ((ctx->class1_alg_type & OP_ALG_AAI_MASK) ==
 			       OP_ALG_AAI_CTR_MOD128);
 	const bool is_rfc3686 = alg->caam.rfc3686;
@@ -736,6 +737,14 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 
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
-- 
2.17.1

