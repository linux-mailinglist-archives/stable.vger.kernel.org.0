Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB2A3A9AF
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733127AbfFIQ7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:59:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387628AbfFIQ7M (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:59:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA569207E0;
        Sun,  9 Jun 2019 16:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099552;
        bh=w5VgwM7rZfhCRKwWQy5d3tZcoubBYlFs0mrr95QMj1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LLqIk/xwRYaQN/FcyWdl8ofBF8B1sUfXzSjyXAaaj7+6xQnrE1zYfCZFA4cAHEyOV
         Nd25nfSoudvTFHkK8HGoeeEjdftNGpX8It0zmjxi2Y+GzSjQ5InByHEn9MuRlUil2H
         jqPD75KBgotXexrJxir/VL6YNh8u4iS6LvOpO0SA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Axtens <dja@axtens.net>,
        Nayna Jain <nayna@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.4 080/241] crypto: vmx - CTR: always increment IV as quadword
Date:   Sun,  9 Jun 2019 18:40:22 +0200
Message-Id: <20190609164150.081536665@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Axtens <dja@axtens.net>

commit 009b30ac7444c17fae34c4f435ebce8e8e2b3250 upstream.

The kernel self-tests picked up an issue with CTR mode:
alg: skcipher: p8_aes_ctr encryption test failed (wrong result) on test vector 3, cfg="uneven misaligned splits, may sleep"

Test vector 3 has an IV of FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD, so
after 3 increments it should wrap around to 0.

In the aesp8-ppc code from OpenSSL, there are two paths that
increment IVs: the bulk (8 at a time) path, and the individual
path which is used when there are fewer than 8 AES blocks to
process.

In the bulk path, the IV is incremented with vadduqm: "Vector
Add Unsigned Quadword Modulo", which does 128-bit addition.

In the individual path, however, the IV is incremented with
vadduwm: "Vector Add Unsigned Word Modulo", which instead
does 4 32-bit additions. Thus the IV would instead become
FFFFFFFFFFFFFFFFFFFFFFFF00000000, throwing off the result.

Use vadduqm.

This was probably a typo originally, what with q and w being
adjacent. It is a pretty narrow edge case: I am really
impressed by the quality of the kernel self-tests!

Fixes: 5c380d623ed3 ("crypto: vmx - Add support for VMS instructions by ASM")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Axtens <dja@axtens.net>
Acked-by: Nayna Jain <nayna@linux.ibm.com>
Tested-by: Nayna Jain <nayna@linux.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/vmx/aesp8-ppc.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/vmx/aesp8-ppc.pl
+++ b/drivers/crypto/vmx/aesp8-ppc.pl
@@ -1298,7 +1298,7 @@ Loop_ctr32_enc:
 	addi		$idx,$idx,16
 	bdnz		Loop_ctr32_enc
 
-	vadduwm		$ivec,$ivec,$one
+	vadduqm		$ivec,$ivec,$one
 	 vmr		$dat,$inptail
 	 lvx		$inptail,0,$inp
 	 addi		$inp,$inp,16


