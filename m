Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B6920171E
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395168AbgFSQe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:34:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388565AbgFSOuw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:50:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45C922166E;
        Fri, 19 Jun 2020 14:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578251;
        bh=Di2MMUfV9E4W+mJymjb01swf4edgnWzTp3VZ5Zc+FhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rIXAEZC8zfNC9xABERLxMl6JK1WaXZuKVWGz1E4p4A7slXQZ3VRHiUPvTTPrBssgw
         Z03Bgs6y1Tb+XLCiQ12W8EH7xLs+eAVC8JyE9iDPXW6FyVokTUWfEbOmA6+9B/7qE9
         I3bhjFEW2vhWOMapmIOuljBi14LaNADd1d9oxHwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Krzysztof Struczynski <krzysztof.struczynski@huawei.com>,
        David.Laight@aculab.com (big endian system concerns),
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 4.14 142/190] ima: Fix ima digest hash table key calculation
Date:   Fri, 19 Jun 2020 16:33:07 +0200
Message-Id: <20200619141640.753748779@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
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
@@ -40,7 +40,7 @@ enum tpm_pcrs { TPM_PCR0 = 0, TPM_PCR8 =
 #define IMA_DIGEST_SIZE		SHA1_DIGEST_SIZE
 #define IMA_EVENT_NAME_LEN_MAX	255
 
-#define IMA_HASH_BITS 9
+#define IMA_HASH_BITS 10
 #define IMA_MEASURE_HTABLE_SIZE (1 << IMA_HASH_BITS)
 
 #define IMA_TEMPLATE_FIELD_ID_MAX_LEN	16
@@ -167,9 +167,10 @@ struct ima_h_table {
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


