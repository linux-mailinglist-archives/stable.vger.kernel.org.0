Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFCF134C1C
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729669AbgAHTtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:49:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43452 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730405AbgAHTqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:01 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHB-0006nm-Eq; Wed, 08 Jan 2020 19:45:57 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHB-007dkp-1Q; Wed, 08 Jan 2020 19:45:57 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        linux-crypto@vger.kernel.org, "Eric Biggers" <ebiggers@google.com>
Date:   Wed, 08 Jan 2020 19:43:03 +0000
Message-ID: <lsq.1578512578.955748574@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 05/63] crypto: cts - fix crash on short inputs
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

In the CTS template, when the input length is <= one block cipher block
(e.g. <= 16 bytes for AES) pass the correct length to the underlying CBC
transform rather than one block.  This matches the upstream behavior and
makes the encryption/decryption operation correctly return -EINVAL when
1 <= nbytes < bsize or succeed when nbytes == 0, rather than crashing.

This was fixed upstream incidentally by a large refactoring,
commit 0605c41cc53c ("crypto: cts - Convert to skcipher").  But
syzkaller easily trips over this when running on older kernels, as it's
easily reachable via AF_ALG.  Therefore, this patch makes the minimal
fix for older kernels.

Cc: linux-crypto@vger.kernel.org
Fixes: 76cb9521795a ("[CRYPTO] cts: Add CTS mode required for Kerberos AES support")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 crypto/cts.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -137,8 +137,8 @@ static int crypto_cts_encrypt(struct blk
 	lcldesc.info = desc->info;
 	lcldesc.flags = desc->flags;
 
-	if (tot_blocks == 1) {
-		err = crypto_blkcipher_encrypt_iv(&lcldesc, dst, src, bsize);
+	if (tot_blocks <= 1) {
+		err = crypto_blkcipher_encrypt_iv(&lcldesc, dst, src, nbytes);
 	} else if (nbytes <= bsize * 2) {
 		err = cts_cbc_encrypt(ctx, desc, dst, src, 0, nbytes);
 	} else {
@@ -232,8 +232,8 @@ static int crypto_cts_decrypt(struct blk
 	lcldesc.info = desc->info;
 	lcldesc.flags = desc->flags;
 
-	if (tot_blocks == 1) {
-		err = crypto_blkcipher_decrypt_iv(&lcldesc, dst, src, bsize);
+	if (tot_blocks <= 1) {
+		err = crypto_blkcipher_decrypt_iv(&lcldesc, dst, src, nbytes);
 	} else if (nbytes <= bsize * 2) {
 		err = cts_cbc_decrypt(ctx, desc, dst, src, 0, nbytes);
 	} else {

