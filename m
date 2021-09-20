Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20D08411F9A
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348995AbhITRnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:43:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348554AbhITRlP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:41:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DDB3615E4;
        Mon, 20 Sep 2021 17:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157705;
        bh=h4FneUWbuA2iMv6bh/tKjtxESfPbAx2Qv5HTuygn5fM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TdGsC1pVdXKuo9daCaZvxDKVxy8YZiqNgXAbhtZdKEn/dYXHHgWM8JCtMRLMPLxyp
         6vkMy36E9Rmg/JBPIiD4cfqtVW7Ton3w2Me5Hj2XwW9Ep/CKHULTDApE/PTCxG/C8p
         kXyuOpdR9fZF2LCTlRW131HOfOuvwXSw4ik81hzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, THOBY Simon <Simon.THOBY@viveris.fr>,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 4.19 114/293] IMA: remove the dependency on CRYPTO_MD5
Date:   Mon, 20 Sep 2021 18:41:16 +0200
Message-Id: <20210920163937.163566344@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: THOBY Simon <Simon.THOBY@viveris.fr>

commit 8510505d55e194d3f6c9644c9f9d12c4f6b0395a upstream.

MD5 is a weak digest algorithm that shouldn't be used for cryptographic
operation. It hinders the efficiency of a patch set that aims to limit
the digests allowed for the extended file attribute namely security.ima.
MD5 is no longer a requirement for IMA, nor should it be used there.

The sole place where we still use the MD5 algorithm inside IMA is setting
the ima_hash algorithm to MD5, if the user supplies 'ima_hash=md5'
parameter on the command line.  With commit ab60368ab6a4 ("ima: Fallback
to the builtin hash algorithm"), setting "ima_hash=md5" fails gracefully
when CRYPTO_MD5 is not set:
	ima: Can not allocate md5 (reason: -2)
	ima: Allocating md5 failed, going to use default hash algorithm sha256

Remove the CRYPTO_MD5 dependency for IMA.

Signed-off-by: THOBY Simon <Simon.THOBY@viveris.fr>
Reviewed-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
[zohar@linux.ibm.com: include commit number in patch description for
stable.]
Cc: stable@vger.kernel.org # 4.17
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -5,7 +5,6 @@ config IMA
 	select SECURITYFS
 	select CRYPTO
 	select CRYPTO_HMAC
-	select CRYPTO_MD5
 	select CRYPTO_SHA1
 	select CRYPTO_HASH_INFO
 	select TCG_TPM if HAS_IOMEM && !UML


