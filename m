Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472E0408DA9
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241057AbhIMN2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:28:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241892AbhIMN0L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:26:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6708D6113E;
        Mon, 13 Sep 2021 13:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539360;
        bh=cBFE0kbMHQvo+MHLoQ0TDQ+UZS2bCFIFjzgl/uXkESg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ealQwggA5vBxbGPmocsl/Krwj7VZQE4khzdalmoHNR5MrFlW/9korWJ3bcBaI0KbB
         uNhQMXZk8yNyiq8Af3WKXJMsxx6ZSee0/HdLOFhRduimifczPi8qDx8jIdUWaaJ2AP
         06wk4O7OJmuhfh60defDqQkCN/1kW9vsr42Ju6tY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, THOBY Simon <Simon.THOBY@viveris.fr>,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.4 141/144] IMA: remove the dependency on CRYPTO_MD5
Date:   Mon, 13 Sep 2021 15:15:22 +0200
Message-Id: <20210913131052.645459517@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
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
@@ -6,7 +6,6 @@ config IMA
 	select SECURITYFS
 	select CRYPTO
 	select CRYPTO_HMAC
-	select CRYPTO_MD5
 	select CRYPTO_SHA1
 	select CRYPTO_HASH_INFO
 	select TCG_TPM if HAS_IOMEM && !UML


