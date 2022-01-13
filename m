Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFCA48DE9A
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 21:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbiAMUFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 15:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbiAMUFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 15:05:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0A4C061574;
        Thu, 13 Jan 2022 12:05:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30C93B8232B;
        Thu, 13 Jan 2022 20:05:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AF4C36AE9;
        Thu, 13 Jan 2022 20:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642104306;
        bh=8Vf+iIeeZu4MFaBzEEPCVogN6kju/taexe/y383Lzqc=;
        h=From:To:Cc:Subject:Date:From;
        b=ViDsrCDb0oYI5aEJ6DYiprjTzNy43HcOHkdbg30hDiw8i+LyLwQNCpe8FgSxxpGR7
         pzy21WBZvl/1S5LhVn4nbUuFcdyd0aKNXy2mZq1v26qMLd4aMI37JOEL6hEv37d+f3
         21lr7umz3KffdTdLvLeEukEWeJsMieNdNb/CPE2ubViocudiYbOHQfOoEMad9CLeQQ
         EfIai0V8Tf9U+0P1C3ff+B3q3oFbRN83LxJ5/euhRKbiLlPxsO/5pEWmu9IwiJZZUh
         Fjj2ZkYAsXJNrMmi67hkL+8kWBqpwwqjfh8qie0y6Fo/5LXNSNCJB9QRcYQrji0pCu
         B1Z8PW+qPSAKg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Denis Kenzior <denkenz@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] KEYS: fix length validation in keyctl_pkey_params_get_2()
Date:   Thu, 13 Jan 2022 12:04:54 -0800
Message-Id: <20220113200454.72609-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In many cases, keyctl_pkey_params_get_2() is validating the user buffer
lengths against the wrong algorithm properties.  Fix it to check against
the correct properties.

Probably this wasn't noticed before because for all asymmetric keys of
the "public_key" subtype, max_data_size == max_sig_size == max_enc_size
== max_dec_size.  However, this isn't necessarily true for the
"asym_tpm" subtype (it should be, but it's not strictly validated).  Of
course, future key types could have different values as well.

Fixes: 00d60fd3b932 ("KEYS: Provide keyctls to drive the new key type ops for asymmetric keys [ver #2]")
Cc: <stable@vger.kernel.org> # v4.20+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 security/keys/keyctl_pkey.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/security/keys/keyctl_pkey.c b/security/keys/keyctl_pkey.c
index 5de0d599a274..97bc27bbf079 100644
--- a/security/keys/keyctl_pkey.c
+++ b/security/keys/keyctl_pkey.c
@@ -135,15 +135,23 @@ static int keyctl_pkey_params_get_2(const struct keyctl_pkey_params __user *_par
 
 	switch (op) {
 	case KEYCTL_PKEY_ENCRYPT:
+		if (uparams.in_len  > info.max_dec_size ||
+		    uparams.out_len > info.max_enc_size)
+			return -EINVAL;
+		break;
 	case KEYCTL_PKEY_DECRYPT:
 		if (uparams.in_len  > info.max_enc_size ||
 		    uparams.out_len > info.max_dec_size)
 			return -EINVAL;
 		break;
 	case KEYCTL_PKEY_SIGN:
+		if (uparams.in_len  > info.max_data_size ||
+		    uparams.out_len > info.max_sig_size)
+			return -EINVAL;
+		break;
 	case KEYCTL_PKEY_VERIFY:
-		if (uparams.in_len  > info.max_sig_size ||
-		    uparams.out_len > info.max_data_size)
+		if (uparams.in_len  > info.max_data_size ||
+		    uparams.in2_len > info.max_sig_size)
 			return -EINVAL;
 		break;
 	default:
@@ -151,7 +159,7 @@ static int keyctl_pkey_params_get_2(const struct keyctl_pkey_params __user *_par
 	}
 
 	params->in_len  = uparams.in_len;
-	params->out_len = uparams.out_len;
+	params->out_len = uparams.out_len; /* Note: same as in2_len */
 	return 0;
 }
 

base-commit: feb7a43de5ef625ad74097d8fd3481d5dbc06a59
-- 
2.34.1

