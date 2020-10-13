Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDEE28C5AC
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 02:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgJMA22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 20:28:28 -0400
Received: from mga07.intel.com ([134.134.136.100]:8540 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726564AbgJMA22 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 20:28:28 -0400
IronPort-SDR: 2aBZ6ae/1jTjspiGyqk+dF0PAUe4z0bKkUun/uWsBJzm8ihSWUAa0AGNuOzseXi8tF4ul5cXaQ
 ehPuhBz/Z/iQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="230002298"
X-IronPort-AV: E=Sophos;i="5.77,368,1596524400"; 
   d="scan'208";a="230002298"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 17:28:27 -0700
IronPort-SDR: Bu4FvpltcYE9xk6Hvso9hT15D9oWCNGy5e/qOvb5X9q91LT1sAomgza7nohR1vgevo4eRkYxov
 QDXBDKPpD9hA==
X-IronPort-AV: E=Sophos;i="5.77,368,1596524400"; 
   d="scan'208";a="299438052"
Received: from lusin-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.53.81])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 17:28:23 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-integrity@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        stable@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Kent Yoder <key@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Safford <safford@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        keyrings@vger.kernel.org (open list:KEYS-TRUSTED),
        linux-security-module@vger.kernel.org (open list:SECURITY SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 1/3] KEYS: trusted: Fix incorrect handling of tpm_get_random()
Date:   Tue, 13 Oct 2020 03:28:13 +0300
Message-Id: <20201013002815.40256-2-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201013002815.40256-1-jarkko.sakkinen@linux.intel.com>
References: <20201013002815.40256-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When tpm_get_random() was introduced, it defined the following API for the
return value:

1. A positive value tells how many bytes of random data was generated.
2. A negative value on error.

However, in the call sites the API was used incorrectly, i.e. as it would
only return negative values and otherwise zero. Returning he positive read
counts to the user space does not make any possible sense.

Fix this by returning -EIO when tpm_get_random() returns a positive value.

Fixes: 41ab999c80f1 ("tpm: Move tpm_get_random api into the TPM device driver")
Cc: stable@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Kent Yoder <key@linux.vnet.ibm.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 security/keys/trusted-keys/trusted_tpm1.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/security/keys/trusted-keys/trusted_tpm1.c b/security/keys/trusted-keys/trusted_tpm1.c
index b9fe02e5f84f..c7b1701cdac5 100644
--- a/security/keys/trusted-keys/trusted_tpm1.c
+++ b/security/keys/trusted-keys/trusted_tpm1.c
@@ -403,9 +403,12 @@ static int osap(struct tpm_buf *tb, struct osapsess *s,
 	int ret;
 
 	ret = tpm_get_random(chip, ononce, TPM_NONCE_SIZE);
-	if (ret != TPM_NONCE_SIZE)
+	if (ret < 0)
 		return ret;
 
+	if (ret != TPM_NONCE_SIZE)
+		return -EIO;
+
 	tpm_buf_reset(tb, TPM_TAG_RQU_COMMAND, TPM_ORD_OSAP);
 	tpm_buf_append_u16(tb, type);
 	tpm_buf_append_u32(tb, handle);
@@ -496,8 +499,12 @@ static int tpm_seal(struct tpm_buf *tb, uint16_t keytype,
 		goto out;
 
 	ret = tpm_get_random(chip, td->nonceodd, TPM_NONCE_SIZE);
+	if (ret < 0)
+		return ret;
+
 	if (ret != TPM_NONCE_SIZE)
-		goto out;
+		return -EIO;
+
 	ordinal = htonl(TPM_ORD_SEAL);
 	datsize = htonl(datalen);
 	pcrsize = htonl(pcrinfosize);
@@ -601,9 +608,12 @@ static int tpm_unseal(struct tpm_buf *tb,
 
 	ordinal = htonl(TPM_ORD_UNSEAL);
 	ret = tpm_get_random(chip, nonceodd, TPM_NONCE_SIZE);
+	if (ret < 0)
+		return ret;
+
 	if (ret != TPM_NONCE_SIZE) {
 		pr_info("trusted_key: tpm_get_random failed (%d)\n", ret);
-		return ret;
+		return -EIO;
 	}
 	ret = TSS_authhmac(authdata1, keyauth, TPM_NONCE_SIZE,
 			   enonce1, nonceodd, cont, sizeof(uint32_t),
@@ -1013,8 +1023,12 @@ static int trusted_instantiate(struct key *key,
 	case Opt_new:
 		key_len = payload->key_len;
 		ret = tpm_get_random(chip, payload->key, key_len);
+		if (ret < 0)
+			goto out;
+
 		if (ret != key_len) {
 			pr_info("trusted_key: key_create failed (%d)\n", ret);
+			ret = -EIO;
 			goto out;
 		}
 		if (tpm2)
-- 
2.25.1

