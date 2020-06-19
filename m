Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36C62011A6
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404565AbgFSP2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:28:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404550AbgFSP2X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:28:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B38F921924;
        Fri, 19 Jun 2020 15:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580503;
        bh=MDzcFnPU6/OGUZX8eSnSRt/nxMi9RAZ+guKmqLWOiNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G4bO7GQL6mL7lItICSeDqfyJYlnbcHqLn+Qy98P8bb7bOjB68GlvKx5HaUtgvpt+k
         Daql7FzxJZwOn9NR9w6kyTXmAa37Jn1VOK+YjHlsNeTEiDnGNojuVgVriUvxVMGNWz
         IrrX0XAQ9nHj99FG8in5O6F86NVW56p1/EAHw6fE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Krzysztof Struczynski <krzysztof.struczynski@huawei.com>,
        David.Laight@aculab.com (big endian system concerns),
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.7 273/376] ima: Fix ima digest hash table key calculation
Date:   Fri, 19 Jun 2020 16:33:11 +0200
Message-Id: <20200619141723.254045965@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Struczynski <krzysztof.struczynski@huawei.com>

commit 1129d31b55d509f15e72dc68e4b5c3a4d7b4da8d upstream.

Function hash_long() accepts unsigned long, while currently only one byte
is passed from ima_hash_key(), which calculates a key for ima_htable.

Given that hashing the digest does not give clear benefits compared to
using the digest itself, remove hash_long() and return the modulus
calculated on the first two bytes of the digest with the number of slots.
Also reduce the depth of the hash table by doubling the number of slots.

Cc: stable@vger.kernel.org
Fixes: 3323eec921ef ("integrity: IMA as an integrity service provider")
Co-developed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
Acked-by: David.Laight@aculab.com (big endian system concerns)
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/integrity/ima/ima.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -36,7 +36,7 @@ enum tpm_pcrs { TPM_PCR0 = 0, TPM_PCR8 =
 #define IMA_DIGEST_SIZE		SHA1_DIGEST_SIZE
 #define IMA_EVENT_NAME_LEN_MAX	255
 
-#define IMA_HASH_BITS 9
+#define IMA_HASH_BITS 10
 #define IMA_MEASURE_HTABLE_SIZE (1 << IMA_HASH_BITS)
 
 #define IMA_TEMPLATE_FIELD_ID_MAX_LEN	16
@@ -175,9 +175,10 @@ struct ima_h_table {
 };
 extern struct ima_h_table ima_htable;
 
-static inline unsigned long ima_hash_key(u8 *digest)
+static inline unsigned int ima_hash_key(u8 *digest)
 {
-	return hash_long(*digest, IMA_HASH_BITS);
+	/* there is no point in taking a hash of part of a digest */
+	return (digest[0] | digest[1] << 8) % IMA_MEASURE_HTABLE_SIZE;
 }
 
 #define __ima_hooks(hook)		\


