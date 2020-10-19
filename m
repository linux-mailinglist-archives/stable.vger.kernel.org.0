Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2975292C16
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 19:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730892AbgJSRCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 13:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730657AbgJSRCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 13:02:43 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8615CC0613CE;
        Mon, 19 Oct 2020 10:02:43 -0700 (PDT)
Date:   Mon, 19 Oct 2020 17:02:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603126961;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=F9x02KxlrD1qoGO+VwTb6oVocoE14TXHnjN1lLSWp1c=;
        b=tZODMVVaTHU1pbK7t6Q7vRjiN4Xos/RO8raLRDS5t9yGwNxs5HIFJpu5L3es5p+/El+nvU
        hO21HLnHu6vcxxZ6bhQLQj0HWpIAOaH6iSUwpunMfU4yPdhReIpSRcCDXaw42SYLF6au3U
        p4SzFCPpYMimehG5aoJaouLsa8b5CBAKUuzvdSHJfdOXGIy+DE6AtkEbbbrDbpXYk6YrvX
        eiCxX+OJiERcfCrEOdeuCraY5E1UGl+ioyB1T57/6qhnNbfOhIwE1OS37qNZURZSlT5WPW
        M+fQYKeis1aS/H1XGxwwxzU3lsdbDLNoFtpePjpFv7cFVheb0VXSYywOW0vbHA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603126961;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=F9x02KxlrD1qoGO+VwTb6oVocoE14TXHnjN1lLSWp1c=;
        b=8Hsbux32bXi2DEondQsZAHrawwTEscv3524B+9M4En99P5QJmHGPGUjDBmUWrTzbL3iAIh
        re7wyhxPu7UwoIBQ==
From:   "tip-bot2 for Herbert Xu" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] crypto: bcm - Verify GCM/CCM key length in setkey
Cc:     <stable@vger.kernel.org>, kiyin@tencent.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <160312696050.7002.7315809954786207518.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     a745dda98d8a4e9946f2aca751a5b0a3cc71f474
Gitweb:        https://git.kernel.org/tip/a745dda98d8a4e9946f2aca751a5b0a3cc7=
1f474
Author:        Herbert Xu <herbert@gondor.apana.org.au>
AuthorDate:    Fri, 02 Oct 2020 17:55:22 +10:00
Committer:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CommitterDate: Sat, 17 Oct 2020 08:31:22 +02:00

crypto: bcm - Verify GCM/CCM key length in setkey

commit 10a2f0b311094ffd45463a529a410a51ca025f27 upstream.

The setkey function for GCM/CCM algorithms didn't verify the key
length before copying the key and subtracting the salt length.

This patch delays the copying of the key til after the verification
has been done.  It also adds checks on the key length to ensure
that it's at least as long as the salt.

Fixes: 9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")
Cc: <stable@vger.kernel.org>
Reported-by: kiyin(=E5=B0=B9=E4=BA=AE) <kiyin@tencent.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/bcm/cipher.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 8a7fa1a..ba25d26 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -2930,7 +2930,6 @@ static int aead_gcm_ccm_setkey(struct crypto_aead *ciph=
er,
=20
 	ctx->enckeylen =3D keylen;
 	ctx->authkeylen =3D 0;
-	memcpy(ctx->enckey, key, ctx->enckeylen);
=20
 	switch (ctx->enckeylen) {
 	case AES_KEYSIZE_128:
@@ -2946,6 +2945,8 @@ static int aead_gcm_ccm_setkey(struct crypto_aead *ciph=
er,
 		goto badkey;
 	}
=20
+	memcpy(ctx->enckey, key, ctx->enckeylen);
+
 	flow_log("  enckeylen:%u authkeylen:%u\n", ctx->enckeylen,
 		 ctx->authkeylen);
 	flow_dump("  enc: ", ctx->enckey, ctx->enckeylen);
@@ -3000,6 +3001,10 @@ static int aead_gcm_esp_setkey(struct crypto_aead *cip=
her,
 	struct iproc_ctx_s *ctx =3D crypto_aead_ctx(cipher);
=20
 	flow_log("%s\n", __func__);
+
+	if (keylen < GCM_ESP_SALT_SIZE)
+		return -EINVAL;
+
 	ctx->salt_len =3D GCM_ESP_SALT_SIZE;
 	ctx->salt_offset =3D GCM_ESP_SALT_OFFSET;
 	memcpy(ctx->salt, key + keylen - GCM_ESP_SALT_SIZE, GCM_ESP_SALT_SIZE);
@@ -3028,6 +3033,10 @@ static int rfc4543_gcm_esp_setkey(struct crypto_aead *=
cipher,
 	struct iproc_ctx_s *ctx =3D crypto_aead_ctx(cipher);
=20
 	flow_log("%s\n", __func__);
+
+	if (keylen < GCM_ESP_SALT_SIZE)
+		return -EINVAL;
+
 	ctx->salt_len =3D GCM_ESP_SALT_SIZE;
 	ctx->salt_offset =3D GCM_ESP_SALT_OFFSET;
 	memcpy(ctx->salt, key + keylen - GCM_ESP_SALT_SIZE, GCM_ESP_SALT_SIZE);
@@ -3057,6 +3066,10 @@ static int aead_ccm_esp_setkey(struct crypto_aead *cip=
her,
 	struct iproc_ctx_s *ctx =3D crypto_aead_ctx(cipher);
=20
 	flow_log("%s\n", __func__);
+
+	if (keylen < CCM_ESP_SALT_SIZE)
+		return -EINVAL;
+
 	ctx->salt_len =3D CCM_ESP_SALT_SIZE;
 	ctx->salt_offset =3D CCM_ESP_SALT_OFFSET;
 	memcpy(ctx->salt, key + keylen - CCM_ESP_SALT_SIZE, CCM_ESP_SALT_SIZE);
