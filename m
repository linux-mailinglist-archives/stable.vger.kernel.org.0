Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3889937CC8D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244330AbhELQpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:45:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233909AbhELQhN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:37:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB46361106;
        Wed, 12 May 2021 16:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835361;
        bh=uaTIHit7rd4SMZpz7bs8cScimDT8ppeXht2WLsEmML4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0iMeK26xNf5deg9oP9j+goBnKQNLJK1bSwjq+OEv9v/akJRgnDxJ7W9RjLiNIaeB
         3ToVl5CmqwjKxn6ZHYuWDopSa/C83xo1PRG0zZ4HZ1Wiuh59odPXjl2HZVdAKwQyTD
         xQydpsDlfrWexvOyyDWulwzKgA+AA55NOaWNj0MM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 314/677] security: keys: trusted: fix TPM2 authorizations
Date:   Wed, 12 May 2021 16:46:00 +0200
Message-Id: <20210512144847.649823939@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>

[ Upstream commit de66514d934d70ce73c302ce0644b54970fc7196 ]

In TPM 1.2 an authorization was a 20 byte number.  The spec actually
recommended you to hash variable length passwords and use the sha1
hash as the authorization.  Because the spec doesn't require this
hashing, the current authorization for trusted keys is a 40 digit hex
number.  For TPM 2.0 the spec allows the passing in of variable length
passwords and passphrases directly, so we should allow that in trusted
keys for ease of use.  Update the 'blobauth' parameter to take this
into account, so we can now use plain text passwords for the keys.

so before

keyctl add trusted kmk "new 32 blobauth=f572d396fae9206628714fb2ce00f72e94f2258fkeyhandle=81000001" @u

after we will accept both the old hex sha1 form as well as a new
directly supplied password:

keyctl add trusted kmk "new 32 blobauth=hello keyhandle=81000001" @u

Since a sha1 hex code must be exactly 40 bytes long and a direct
password must be 20 or less, we use the length as the discriminator
for which form is input.

Note this is both and enhancement and a potential bug fix.  The TPM
2.0 spec requires us to strip leading zeros, meaning empyty
authorization is a zero length HMAC whereas we're currently passing in
20 bytes of zeros.  A lot of TPMs simply accept this as OK, but the
Microsoft TPM emulator rejects it with TPM_RC_BAD_AUTH, so this patch
makes the Microsoft TPM emulator work with trusted keys.

Fixes: 0fe5480303a1 ("keys, trusted: seal/unseal with TPM 2.0 chips")
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/keys/trusted-type.h               |  1 +
 security/keys/trusted-keys/trusted_tpm1.c | 32 ++++++++++++++++++-----
 security/keys/trusted-keys/trusted_tpm2.c | 10 ++++---
 3 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/include/keys/trusted-type.h b/include/keys/trusted-type.h
index a94c03a61d8f..b2ed3481c6a0 100644
--- a/include/keys/trusted-type.h
+++ b/include/keys/trusted-type.h
@@ -30,6 +30,7 @@ struct trusted_key_options {
 	uint16_t keytype;
 	uint32_t keyhandle;
 	unsigned char keyauth[TPM_DIGEST_SIZE];
+	uint32_t blobauth_len;
 	unsigned char blobauth[TPM_DIGEST_SIZE];
 	uint32_t pcrinfo_len;
 	unsigned char pcrinfo[MAX_PCRINFO_SIZE];
diff --git a/security/keys/trusted-keys/trusted_tpm1.c b/security/keys/trusted-keys/trusted_tpm1.c
index 493eb91ed017..1e13c9f7ea8c 100644
--- a/security/keys/trusted-keys/trusted_tpm1.c
+++ b/security/keys/trusted-keys/trusted_tpm1.c
@@ -791,13 +791,33 @@ static int getoptions(char *c, struct trusted_key_payload *pay,
 				return -EINVAL;
 			break;
 		case Opt_blobauth:
-			if (strlen(args[0].from) != 2 * SHA1_DIGEST_SIZE)
-				return -EINVAL;
-			res = hex2bin(opt->blobauth, args[0].from,
-				      SHA1_DIGEST_SIZE);
-			if (res < 0)
-				return -EINVAL;
+			/*
+			 * TPM 1.2 authorizations are sha1 hashes passed in as
+			 * hex strings.  TPM 2.0 authorizations are simple
+			 * passwords (although it can take a hash as well)
+			 */
+			opt->blobauth_len = strlen(args[0].from);
+
+			if (opt->blobauth_len == 2 * TPM_DIGEST_SIZE) {
+				res = hex2bin(opt->blobauth, args[0].from,
+					      TPM_DIGEST_SIZE);
+				if (res < 0)
+					return -EINVAL;
+
+				opt->blobauth_len = TPM_DIGEST_SIZE;
+				break;
+			}
+
+			if (tpm2 && opt->blobauth_len <= sizeof(opt->blobauth)) {
+				memcpy(opt->blobauth, args[0].from,
+				       opt->blobauth_len);
+				break;
+			}
+
+			return -EINVAL;
+
 			break;
+
 		case Opt_migratable:
 			if (*args[0].from == '0')
 				pay->migratable = 0;
diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index c87c4df8703d..4c19d3abddbe 100644
--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -97,10 +97,12 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 			     TPM_DIGEST_SIZE);
 
 	/* sensitive */
-	tpm_buf_append_u16(&buf, 4 + TPM_DIGEST_SIZE + payload->key_len + 1);
+	tpm_buf_append_u16(&buf, 4 + options->blobauth_len + payload->key_len + 1);
+
+	tpm_buf_append_u16(&buf, options->blobauth_len);
+	if (options->blobauth_len)
+		tpm_buf_append(&buf, options->blobauth, options->blobauth_len);
 
-	tpm_buf_append_u16(&buf, TPM_DIGEST_SIZE);
-	tpm_buf_append(&buf, options->blobauth, TPM_DIGEST_SIZE);
 	tpm_buf_append_u16(&buf, payload->key_len + 1);
 	tpm_buf_append(&buf, payload->key, payload->key_len);
 	tpm_buf_append_u8(&buf, payload->migratable);
@@ -265,7 +267,7 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
 			     NULL /* nonce */, 0,
 			     TPM2_SA_CONTINUE_SESSION,
 			     options->blobauth /* hmac */,
-			     TPM_DIGEST_SIZE);
+			     options->blobauth_len);
 
 	rc = tpm_transmit_cmd(chip, &buf, 6, "unsealing");
 	if (rc > 0)
-- 
2.30.2



