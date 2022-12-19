Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12346512EB
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbiLSTZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbiLSTYd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:24:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3A112AC3
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 11:24:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A07CB80EF6
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1DDC433F0;
        Mon, 19 Dec 2022 19:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671477857;
        bh=TkbDt47k2Q5e0PKPovq3L8nAcVZYYuzMMVoQGkvc76I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GHUoopPOeTy119OFyZ7Ikye1I1pkbGGwMCetCokf67JVFAvVpWWfqb7rKfUX85b3z
         aJ1Gv6ucp0XVkD67ApnhwVyReCrXRXaus6egWu1bKu9+3hejm6RMFI80FaWdAmqizN
         8Ud1v7VTYiicwgqYkEiI9YzT5kVMF5Yr2bduVvgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable@kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        Nikolaus Voss <nikolaus.voss@haag-streit.com>
Subject: [PATCH 6.1 24/25] KEYS: encrypted: fix key instantiation with user-provided data
Date:   Mon, 19 Dec 2022 20:23:03 +0100
Message-Id: <20221219182944.417769764@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>
References: <20221219182943.395169070@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolaus Voss <nikolaus.voss@haag-streit.com>

commit 5adedd42245af0860ebda8fe0949f24f5204c1b1 upstream.

Commit cd3bc044af48 ("KEYS: encrypted: Instantiate key with
user-provided decrypted data") added key instantiation with user
provided decrypted data.  The user data is hex-ascii-encoded but was
just memcpy'ed to the binary buffer. Fix this to use hex2bin instead.

Old keys created from user provided decrypted data saved with "keyctl
pipe" are still valid, however if the key is recreated from decrypted
data the old key must be converted to the correct format. This can be
done with a small shell script, e.g.:

BROKENKEY=abcdefABCDEF1234567890aaaaaaaaaa
NEWKEY=$(echo -ne $BROKENKEY | xxd -p -c32)
keyctl add user masterkey "$(cat masterkey.bin)" @u
keyctl add encrypted testkey "new user:masterkey 32 $NEWKEY" @u

However, NEWKEY is still broken: If for BROKENKEY 32 bytes were
specified, a brute force attacker knowing the key properties would only
need to try at most 2^(16*8) keys, as if the key was only 16 bytes long.

The security issue is a result of the combination of limiting the input
range to hex-ascii and using memcpy() instead of hex2bin(). It could
have been fixed either by allowing binary input or using hex2bin() (and
doubling the ascii input key length). This patch implements the latter.

The corresponding test for the Linux Test Project ltp has also been
fixed (see link below).

Fixes: cd3bc044af48 ("KEYS: encrypted: Instantiate key with user-provided decrypted data")
Cc: stable@kernel.org
Link: https://lore.kernel.org/ltp/20221006081709.92303897@mail.steuer-voss.de/
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Nikolaus Voss <nikolaus.voss@haag-streit.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/security/keys/trusted-encrypted.rst |    3 ++-
 security/keys/encrypted-keys/encrypted.c          |    6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/Documentation/security/keys/trusted-encrypted.rst
+++ b/Documentation/security/keys/trusted-encrypted.rst
@@ -350,7 +350,8 @@ Load an encrypted key "evm" from saved b
 
 Instantiate an encrypted key "evm" using user-provided decrypted data::
 
-    $ keyctl add encrypted evm "new default user:kmk 32 `cat evm_decrypted_data.blob`" @u
+    $ evmkey=$(dd if=/dev/urandom bs=1 count=32 | xxd -c32 -p)
+    $ keyctl add encrypted evm "new default user:kmk 32 $evmkey" @u
     794890253
 
     $ keyctl print 794890253
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -627,7 +627,7 @@ static struct encrypted_key_payload *enc
 			pr_err("encrypted key: instantiation of keys using provided decrypted data is disabled since CONFIG_USER_DECRYPTED_DATA is set to false\n");
 			return ERR_PTR(-EINVAL);
 		}
-		if (strlen(decrypted_data) != decrypted_datalen) {
+		if (strlen(decrypted_data) != decrypted_datalen * 2) {
 			pr_err("encrypted key: decrypted data provided does not match decrypted data length provided\n");
 			return ERR_PTR(-EINVAL);
 		}
@@ -791,8 +791,8 @@ static int encrypted_init(struct encrypt
 		ret = encrypted_key_decrypt(epayload, format, hex_encoded_iv);
 	} else if (decrypted_data) {
 		get_random_bytes(epayload->iv, ivsize);
-		memcpy(epayload->decrypted_data, decrypted_data,
-				   epayload->decrypted_datalen);
+		ret = hex2bin(epayload->decrypted_data, decrypted_data,
+			      epayload->decrypted_datalen);
 	} else {
 		get_random_bytes(epayload->iv, ivsize);
 		get_random_bytes(epayload->decrypted_data, epayload->decrypted_datalen);


