Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EADE1D24B5
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389205AbfJJIuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:50:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389426AbfJJIuH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:50:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62AA921A4C;
        Thu, 10 Oct 2019 08:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697405;
        bh=9On+Gu6ZEr5b3Li89PPgEiHsxO9sWN16AGhIzJ06nkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/WDcRM/+G/FgnWVNctdJ26ziE709+tael+t+L5ll+VKcl+hpGjFIlR6lMpsSGpG5
         ihQv/Qx5cswtZPvXUeFTTtgh65gsb2SjekQhRgv8LA1O3IhiVEqafcH4FwkX1YRK9L
         TkTgbMDdf0hSpEiZrKLetbnEGI4NdrDHfbAvpoFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.14 16/61] crypto: caam - fix concurrency issue in givencrypt descriptor
Date:   Thu, 10 Oct 2019 10:36:41 +0200
Message-Id: <20191010083458.828032360@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083449.500442342@linuxfoundation.org>
References: <20191010083449.500442342@linuxfoundation.org>
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
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/caam/caamalg_desc.c |    9 +++++++++
 drivers/crypto/caam/caamalg_desc.h |    2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/crypto/caam/caamalg_desc.c
+++ b/drivers/crypto/caam/caamalg_desc.c
@@ -476,6 +476,7 @@ void cnstr_shdsc_aead_givencap(u32 * con
 			       const bool is_qi)
 {
 	u32 geniv, moveiv;
+	u32 *wait_cmd;
 
 	/* Note: Context registers are saved. */
 	init_sh_desc_key_aead(desc, cdata, adata, is_rfc3686, nonce);
@@ -566,6 +567,14 @@ copy_iv:
 
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
--- a/drivers/crypto/caam/caamalg_desc.h
+++ b/drivers/crypto/caam/caamalg_desc.h
@@ -12,7 +12,7 @@
 #define DESC_AEAD_BASE			(4 * CAAM_CMD_SZ)
 #define DESC_AEAD_ENC_LEN		(DESC_AEAD_BASE + 11 * CAAM_CMD_SZ)
 #define DESC_AEAD_DEC_LEN		(DESC_AEAD_BASE + 15 * CAAM_CMD_SZ)
-#define DESC_AEAD_GIVENC_LEN		(DESC_AEAD_ENC_LEN + 7 * CAAM_CMD_SZ)
+#define DESC_AEAD_GIVENC_LEN		(DESC_AEAD_ENC_LEN + 8 * CAAM_CMD_SZ)
 #define DESC_QI_AEAD_ENC_LEN		(DESC_AEAD_ENC_LEN + 3 * CAAM_CMD_SZ)
 #define DESC_QI_AEAD_DEC_LEN		(DESC_AEAD_DEC_LEN + 3 * CAAM_CMD_SZ)
 #define DESC_QI_AEAD_GIVENC_LEN		(DESC_AEAD_GIVENC_LEN + 3 * CAAM_CMD_SZ)


