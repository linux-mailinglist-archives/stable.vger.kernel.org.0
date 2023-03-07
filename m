Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0CF6AEE04
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbjCGSJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjCGSIu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:08:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3109220D3C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:03:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98FAB61524
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9602C433D2;
        Tue,  7 Mar 2023 18:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212179;
        bh=/CiLiZ4ZhIUoIABFC7/F5Aq1DKQhCCrH8EVglSmFoNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OYcGNtOnyivTtmGU3Fad/OOqiPfGYTfExlCNQKlR9C/RjvNxlpqcZYgtsYW9ABn70
         Pu6w018eDfPKMK9nacLgADSktjTeb6BmzsqAvgAqHrOHbewDQyyx60vHytnKwmZOT+
         2FEiswen2SsFWPzQcdWHtnVapGkYAw+DgmXU/tnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Denis Kenzior <denkenz@gmail.com>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/885] KEYS: asymmetric: Fix ECDSA use via keyctl uapi
Date:   Tue,  7 Mar 2023 17:50:36 +0100
Message-Id: <20230307170006.298506011@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Kenzior <denkenz@gmail.com>

[ Upstream commit 10de7b54293995368c52d9aa153f3e7a359f04a1 ]

When support for ECDSA keys was added, constraints for data & signature
sizes were never updated.  This makes it impossible to use such keys via
keyctl API from userspace.

Update constraint on max_data_size to 64 bytes in order to support
SHA512-based signatures. Also update the signature length constraints
per ECDSA signature encoding described in RFC 5480.

Fixes: 299f561a6693 ("x509: Add support for parsing x509 certs with ECDSA keys")
Signed-off-by: Denis Kenzior <denkenz@gmail.com>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/asymmetric_keys/public_key.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 2f8352e888602..eca5671ad3f22 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -186,8 +186,28 @@ static int software_key_query(const struct kernel_pkey_params *params,
 
 	len = crypto_akcipher_maxsize(tfm);
 	info->key_size = len * 8;
-	info->max_data_size = len;
-	info->max_sig_size = len;
+
+	if (strncmp(pkey->pkey_algo, "ecdsa", 5) == 0) {
+		/*
+		 * ECDSA key sizes are much smaller than RSA, and thus could
+		 * operate on (hashed) inputs that are larger than key size.
+		 * For example SHA384-hashed input used with secp256r1
+		 * based keys.  Set max_data_size to be at least as large as
+		 * the largest supported hash size (SHA512)
+		 */
+		info->max_data_size = 64;
+
+		/*
+		 * Verify takes ECDSA-Sig (described in RFC 5480) as input,
+		 * which is actually 2 'key_size'-bit integers encoded in
+		 * ASN.1.  Account for the ASN.1 encoding overhead here.
+		 */
+		info->max_sig_size = 2 * (len + 3) + 2;
+	} else {
+		info->max_data_size = len;
+		info->max_sig_size = len;
+	}
+
 	info->max_enc_size = len;
 	info->max_dec_size = len;
 	info->supported_ops = (KEYCTL_SUPPORTS_ENCRYPT |
-- 
2.39.2



